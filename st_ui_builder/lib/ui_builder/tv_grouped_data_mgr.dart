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

  final List<TableviewDataRowTuple> _allAssetRows;
  final TableviewConfigPayload _tableViewCfg;
  RedrawTvCallback? redrawCallback;
  GroupedListOrder order = GroupedListOrder.ASC;
  // rows actually rendered from _filteredAssetRows
  List<TableviewDataRowTuple> _filteredAssetRows = [];
  // regions no longer matter when you get to final 4
  bool disableGroupingBeyondDate = false;

  GroupedTableDataMgr(
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
        TvGroupHeader(rowStyle, gbFunc(rowData));
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

  Widget filterBarRow() {
    // dont call this without first checking this.hasFilterBar
    TvFilterCfg i1 = filterRules.item1;
    TvFilterCfg? i2 = filterRules.item2;
    TvFilterCfg? i3 = filterRules.item3;
    return Row(
      children: [
        _dropMenuList(i1),
        if (i2 != null && i2.colName != i1.colName) _dropMenuList(i2),
        if (i3 != null && i3.colName != i2!.colName) _dropMenuList(i3),
      ],
    );
  }

  DropdownButton<String> _dropMenuList(TvFilterCfg fCfg) {
    // return DropdownButton menu for filter bar slot
    Set<String> listItems = _getListItemsByCfgField(fCfg);
    print('Filter items for ${fCfg.colName.labelName}');
    print(listItems);
    String headerName = fCfg.colName.labelName;
    return DropdownButton<String>(
      value: listItems.first,
      items: listItems
          .map((String val) => DropdownMenuItem<String>(
                child: Text(val),
                value: val,
              ))
          .toList(),
      onChanged: (String? selectedVal) {
        if (selectedVal == null || selectedVal == CLEAR_FILTER_LABEL) {
          clearFilters();
          return;
        }
        _doFilteringFor(fCfg.colName, selectedVal);
      },
      style: const TextStyle(
        color: Colors.grey,
        fontSize: 22,
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
    l.insert(0, CLEAR_FILTER_LABEL);
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