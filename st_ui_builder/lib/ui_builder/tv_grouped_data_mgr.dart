part of StUiController;

/*  GroupHeaderData is an important struct
    it's used for unique ID, sort-order
    and arguments needed to build the Widget UI

    todo: replace Tuple3 with a reall class
*/

class GroupedTableDataMgr {
  /*
    this is the object returned when you want to build
    a table-view with custom grouping, sorting and row-styles

    produces the arguments needed to use the "GroupedListView" package

  designed specifically to work with:
    GroupedListView<TableviewDataRowTuple, GroupHeaderData>

  TODO:  all the getters below must be completed to return real methods
  */

  final AppScreen appScreen;
  final List<TableviewDataRowTuple> _allAssetRows;
  final TableviewConfigPayload _tableViewCfg;
  RedrawTvCallback? redrawCallback;
  GroupedListOrder order = GroupedListOrder.ASC;
  // rows actually rendered from _filteredAssetRows
  List<TableviewDataRowTuple> _filteredAssetRows = [];
  // regions no longer matter when you get to final 4
  bool disableGroupingBeyondDate = false;

  GroupedTableDataMgr(
    this.appScreen,
    this._allAssetRows,
    this._tableViewCfg, {
    this.redrawCallback,
    bool ascending = true,
  })  : order = ascending ? GroupedListOrder.ASC : GroupedListOrder.DESC,
        _filteredAssetRows = _allAssetRows.toList();

  List<TableviewDataRowTuple> get listData => _filteredAssetRows;
  // GroupingRules get groupRules => _tableViewCfg.groupByRules;
  SortingRules get sortingRules => _tableViewCfg.sortRules;
  FilterRules get filterRules => _tableViewCfg.filterRules;

  GetGroupKeyFromRow get groupBy {
    return GroupHeaderData.groupKeyDataConstructorFromCfg(
        _tableViewCfg.sortRules);
  }

  // groupHeaderBuilder is function to return header widget
  // defining groupHeaderBuilder will cause groupSeparatorBuilder to be ignored
  GroupHeaderBuilder get groupHeaderBuilder {
    // copy groupBy getter to save a lookup
    final TvAreaRowStyle rowStyle = _tableViewCfg.rowStyle;
    final GetGroupKeyFromRow gbFunc = groupBy;
    return (TableviewDataRowTuple rowData) =>
        TvGroupHeader(rowStyle, appScreen, gbFunc(rowData));
  }

  // natural sorting will use my Comparator; dont need this
  GroupComparatorCallback? get groupComparator => null;
  // (GroupHeaderData hdVal1, GroupHeaderData hdVal2) => hdVal1.compareTo(hdVal2);

  // indexedItemBuilder is function to return a Tv-Row for this screen
  IndexedItemRowBuilder get indexedItemBuilder => (
        BuildContext ctx,
        TableviewDataRowTuple assets,
        int i,
      ) {
        return _tableViewCfg.rowConstructor(assets);
      };

  // for sorting recs into order WITHIN groups/sections
  SectionSortComparator get itemComparator =>
      GroupHeaderData.sortComparator(sortingRules);

  bool get hasFilterBar {
    // set imageUrl as first filter field to hide/disable the whole filter bar
    return filterRules.item1.colName == DbTableFieldName.imageUrl
        ? false
        : true;
  }

  String? _filter1Selection;
  String? _filter2Selection;
  String? _filter3Selection;

  Widget filterBarRow({double totAvailWidth = 380}) {
    // dont call this without first checking this.hasFilterBar
    TvFilterCfg i1 = filterRules.item1;
    TvFilterCfg? i2 = filterRules.item2;
    TvFilterCfg? i3 = filterRules.item3;
    int dlCount = 1 + (i2 == null ? 0 : 1) + (i3 == null ? 0 : 1);
    // allocated button width
    double allocBtnWidth = totAvailWidth / dlCount;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      // mainAxisSize: MainAxisSize.min,
      children: [
        _dropMenuList(
          i1,
          _filter1Selection,
          (s) {
            _filter1Selection = s;
          },
          allocBtnWidth,
        ),
        if (i2 != null && i2.colName != i1.colName)
          _dropMenuList(
            i2,
            _filter2Selection,
            (s) {
              _filter2Selection = s;
            },
            allocBtnWidth,
          ),
        if (i3 != null && i3.colName != i2!.colName)
          _dropMenuList(
            i3,
            _filter3Selection,
            (s) {
              _filter3Selection = s;
            },
            allocBtnWidth,
          ),
      ],
    );
  }

  Widget _dropMenuList(
    TvFilterCfg fCfg,
    String? curSelection,
    SelectedFilterSetter valSetter,
    double width,
  ) {
    // return DropdownButton menu for filter bar slot
    Set<String> listItems = _getListItemsByCfgField(fCfg);
    // print('Filter items for ${fCfg.colName.labelName}');
    // print(listItems);
    return Container(
      height: 46,
      // width: width,
      child: DropdownButton<String>(
        value: curSelection ?? listItems.first,
        items: listItems
            .map((String val) => DropdownMenuItem<String>(
                  child: Text(val),
                  value: val,
                ))
            .toList(),
        onChanged: (String? selectedVal) {
          // store selected value for state mgmt
          valSetter(selectedVal);
          if (selectedVal == null ||
              selectedVal.startsWith(CLEAR_FILTER_LABEL)) {
            clearFilters();
            return;
          }
          _doFilteringFor(fCfg.colName, selectedVal);
        },
        // focusColor: Colors.green,
        dropdownColor: Colors.black38,
        iconEnabledColor: Colors.lightBlueAccent,
        style: const TextStyle(
          color: Colors.lightBlueAccent,
          fontSize: 20,
        ),
      ),
    );
  }

  Set<String> _getListItemsByCfgField(TvFilterCfg fCfg) {
    // build list of unique values from selected field
    // elim dups and sort
    var l = _allAssetRows
        .map(
          (e) => e.item1.valueExtractor(fCfg.colName),
        )
        .toSet()
        .toList()
      ..sort((v1, v2) => v1.compareTo(v2));
    l.insert(0, CLEAR_FILTER_LABEL + ' ' + fCfg.colName.labelName);
    return l.toSet();
  }

  void _doFilteringFor(DbTableFieldName colName, String selectedVal) {
    //
    _filteredAssetRows = _allAssetRows
        .where((TableviewDataRowTuple dr) =>
            dr.item1.valueExtractor(colName) == selectedVal)
        .toList();

    // print('you must reload your list after calling this');
    if (redrawCallback != null) redrawCallback!();
  }

  void clearFilters() {
    this._filteredAssetRows = _allAssetRows;
    // print('you must reload your list after calling this');
    if (redrawCallback != null) redrawCallback!();
  }

  void replaceGameStatusForRowRebuildTest(String round) {
    //
    TableviewDataRowTuple drt = _allAssetRows[2];
    ActiveGameDetails agd = drt.item3;
    var ci = CompetitionInfo(
      key: agd.competitionKey,
      competitionStatus: null,
      currentRoundName: round,
    );
    agd = agd.cloneWithUpdates(ci);

    _allAssetRows[2] = TableviewDataRowTuple(drt.item1, drt.item2, agd);
    print('ActiveGameDetails replaced on 2 with $round  (did row repaint?)');
  }
}

// void filterDataBy(DbTableFieldName fld, String value) {
//
// FilterRules fltrRules = this._filterRules!;
// // TvFilterCfg? filterCfg;
// SortOrGroupIdxOrder order = SortOrGroupIdxOrder.first;

// if (fltrRules.item1.colName == colName) {
//   // filterCfg = fltrRules.item1;
//   order = SortOrGroupIdxOrder.first;
// } else if (fltrRules.item2?.colName == colName) {
//   // filterCfg = fltrRules.item1;
//   order = SortOrGroupIdxOrder.first;
// } else if (fltrRules.item3?.colName == colName) {
//   // filterCfg = fltrRules.item1;
//   order = SortOrGroupIdxOrder.first;
// }
// // if (filterCfg == null) return;

// var filterFunc = (TableviewDataRowTuple dr) {
//   switch (order) {
//     case SortOrGroupIdxOrder.first:
//       return dr.item1.valueExtractor(colName) == selectedVal;
//     case SortOrGroupIdxOrder.first:
//       return dr.item1.valueExtractor(colName) == selectedVal;
//   }
// };

// NIU
// GroupSepRowBuilder get groupSeparatorBuilder {
//   // defining groupHeaderBuilder will cause groupSeparatorBuilder to be ignored
//   return (GroupHeaderData _) => TvGroupHeaderSep(GroupHeaderData.mockRow);
// }
