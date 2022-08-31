part of StUiController;

/*  GroupHeaderData is an important struct
    it's used for unique ID, sort-order
    and arguments needed to build the Widget UI

    todo: replace Tuple3 with a reall class
*/

// final _gameStateProvider = StreamProvider<ActiveGameDetails>(
//   (ref) => throw UnimplementedError(''),
// );

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
  // _allAssetRows will need to be updated as Event-rounds change
  final List<TableviewDataRowTuple> _allAssetRows;
  final TableviewConfigPayload _tableViewCfg;
  RedrawTvCallback? redrawCallback;
  GroupedListOrder sortOrder = GroupedListOrder.ASC;
  // rows actually rendered from _filteredAssetRows
  List<TableviewDataRowTuple> _filteredAssetRows = [];
  bool disableAllGrouping = false;
  // disableGroupingBeyondDate: regions no longer matter when you get to final 4
  bool disableGroupingBeyondDate = false;

  GroupedTableDataMgr(
    this.appScreen,
    this._allAssetRows,
    this._tableViewCfg, {
    this.redrawCallback,
    this.disableAllGrouping = false,
    bool ascending = true,
  })  : sortOrder = ascending ? GroupedListOrder.ASC : GroupedListOrder.DESC,
        _filteredAssetRows = _allAssetRows.toList();

  List<TableviewDataRowTuple> get listData => _filteredAssetRows;
  TvGroupCfg? get groupRules => _tableViewCfg.groupByRules;
  TvSortCfg get sortingRules => _tableViewCfg.sortRules;
  TvFilterCfg? get filterRules => _tableViewCfg.filterRules;

  GetGroupHeaderLblsFromCompetitionRow get groupBy {
    return GroupHeaderData.groupHeaderPayloadConstructor(
      _tableViewCfg.sortRules,
    );
  }

  // groupHeaderBuilder is function to return header widget
  // defining groupHeaderBuilder will cause groupSeparatorBuilder to be ignored
  GroupHeaderBuilder get groupHeaderBuilder {
    if (disableAllGrouping) return (_) => const SizedBox.shrink();

    // copy groupBy getter to save a lookup
    final TvAreaRowStyle rowStyle = _tableViewCfg.rowStyle;
    final GetGroupHeaderLblsFromCompetitionRow gbFunc = groupBy;
    return (TableviewDataRowTuple rowData) =>
        TvGroupHeader(rowStyle, appScreen, gbFunc(rowData));
  }

  // natural sorting will use my Comparator; dont need this
  // GroupComparatorCallback? get groupComparator => null;
  GroupComparatorCallback? get groupComparator {
    // GroupHeaderData implements comparable
    if (disableAllGrouping) return null;

    if (sortOrder == GroupedListOrder.DESC) {
      return (GroupHeaderData hd1Val, GroupHeaderData hd2Val) =>
          hd2Val.compareTo(hd1Val);
    } else {
      return (GroupHeaderData hdVal1, GroupHeaderData hdVal2) =>
          hdVal1.compareTo(hdVal2);
    }
  }

  // indexedItemBuilder is function to return a Tv-Row for this screen
  IndexedItemRowBuilder get indexedItemBuilder => (
        BuildContext ctx,
        TableviewDataRowTuple assets,
        int i,
      ) {
        return _tableViewCfg.rowConstructor(assets);
      };

  // IndexedItemRowBuilder wrappedIndexedItemBuilder(
  //   IndexedItemRowBuilder wrapper,
  // ) =>
  //     (
  //       BuildContext ctx,
  //       TableviewDataRowTuple assets,
  //       int i,
  //     ) {
  //       return wrapper(ctx, assets, i);
  //     };

  // for sorting recs into order WITHIN groups/sections
  SectionSortComparator get itemComparator => GroupHeaderData.sortComparator(
      sortingRules, sortOrder == GroupedListOrder.ASC);

  bool get hasColumnFilters {
    // set imageUrl as first filter field to hide/disable the whole filter bar
    return filterRules?.item1.colName != DbTableFieldName.imageUrl &&
        !disableAllGrouping;
  }

  void endGeographicGrouping() {
    // games now happening between/across regions
    // so it not longer makes sense to group or sort geographically
    _tableViewCfg.endGeographicGrouping();
  }

  String? _filter1Selection;
  String? _filter2Selection;
  String? _filter3Selection;

  Widget columnFilterBarWidget({
    double totAvailWidth = 360,
    double barHeight = 46,
    Color backColor = Colors.transparent,
  }) {
    // dont call this method without first checking this.hasColumnFilters
    if (filterRules == null || disableAllGrouping) {
      return const SizedBox.shrink();
    }

    SortGroupFilterEntry i1 = filterRules!.item1;
    SortGroupFilterEntry? i2 = filterRules!.item2;
    SortGroupFilterEntry? i3 = filterRules!.item3;

    Set<String> listItems1 = _getListItemsByCfgField(i1);
    Set<String> listItems2 = i2 == null ? {} : _getListItemsByCfgField(i2);
    Set<String> listItems3 = i3 == null ? {} : _getListItemsByCfgField(i3);

    const _kLstMin = 2;

    bool has2ndList =
        i2 != null && listItems2.length > _kLstMin && i2.colName != i1.colName;
    bool has3rdList =
        i3 != null && listItems3.length > _kLstMin && i3.colName != i2!.colName;

    int dropLstCount = 1 + (has2ndList ? 1 : 0) + (has3rdList ? 1 : 0);
    // allocate dropdown button width
    double allocBtnWidth = (totAvailWidth / dropLstCount) * .96;
    // one list can take 86% of space
    allocBtnWidth = dropLstCount < 2 ? totAvailWidth * 0.86 : allocBtnWidth;

    return Container(
      height: barHeight,
      width: totAvailWidth,
      color: backColor,
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        // mainAxisSize: MainAxisSize.min,
        children: [
          _dropMenuList(
            listItems1,
            i1.colName,
            _filter1Selection,
            (s) => _filter1Selection = s,
            allocBtnWidth,
          ),
          if (has2ndList)
            _dropMenuList(
              listItems2,
              i2.colName,
              _filter2Selection,
              (s) => _filter2Selection = s,
              allocBtnWidth,
            ),
          if (has3rdList)
            _dropMenuList(
              listItems3,
              i3.colName,
              _filter3Selection,
              (s) => _filter3Selection = s,
              allocBtnWidth,
            ),
        ],
      ),
    );
  }

  Widget _dropMenuList(
    Set<String> listItems,
    DbTableFieldName colName,
    String? curSelection,
    SelectedFilterSetter valSetter,
    double width,
  ) {
    // return DropdownButton menu for filter bar slot
    // Set<String> listItems = _getListItemsByCfgField(fCfg);
    // print('Filter items for ${fCfg.colName.labelName}');
    // print(listItems);
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(
          color: StColors.lightGray,
          width: 0.8,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(6.w),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: curSelection ?? listItems.first,
          items: listItems
              .map(
                (String val) => DropdownMenuItem<String>(
                  value: val,
                  alignment: AlignmentDirectional.centerStart,
                  child: Container(
                    color: curSelection == val
                        ? StColors.primaryDarkGray
                        : StColors.black,
                    child: Text(val.toUpperCase()),
                  ),
                ),
              )
              .toList(),
          selectedItemBuilder: (BuildContext context) {
            return listItems.map((String value) {
              return ConstrainedBox(
                constraints: BoxConstraints(maxWidth: width * .75),
                child: Text(
                  value.toUpperCase(),
                ),
              );
            }).toList();
          },
          onChanged: (String? selectedVal) {
            // store selected value for state mgmt
            valSetter(selectedVal);
            if (selectedVal == null ||
                selectedVal == colName.labelName.toUpperCase() ||
                selectedVal.startsWith(CLEAR_FILTER_LABEL)) {
              clearFilters();
              return;
            }
            _doFilteringFor(colName, selectedVal);
          },
          dropdownColor: StColors.black,
          iconEnabledColor: StColors.gray,
          style: TextStyle(
            color: StColors.lightGray,
            fontSize: 16.sp,
          ),
        ),
      ),
    );
  }

  void setFilteredData(
    Iterable<TableviewDataRowTuple> _assetRows, {
    bool redraw = false,
  }) {
    /* external filtering
    used by search (watched or owned) feature
    */
    _filteredAssetRows = _assetRows.toList();
    if (redraw && redrawCallback != null) {
      redrawCallback!();
    }
  }

  Set<String> _getListItemsByCfgField(SortGroupFilterEntry filterItem) {
    // build list of unique values from selected field
    // elim dups and sort
    var l = _allAssetRows
        .map(
          (e) => e.item1.labelExtractor(filterItem.colName),
        )
        .toSet()
        .toList()
      ..sort((v1, v2) => v1.compareTo(v2));
    l.insert(0, filterItem.colName.labelName); // CLEAR_FILTER_LABEL + ' ' +
    return l.toSet();
  }

  void _doFilteringFor(DbTableFieldName colName, String selectedVal) {
    //
    if (selectedVal.toUpperCase() == colName.labelName.toUpperCase()) {
      clearFilters();
      return;
    }
    _filteredAssetRows = _allAssetRows
        .where((TableviewDataRowTuple dr) =>
            dr.item1.labelExtractor(colName) == selectedVal)
        .toList();

    // print('you must reload your list after calling this');
    if (redrawCallback != null) redrawCallback!();
  }

  void clearFilters() {
    _filteredAssetRows = _allAssetRows;
    // print('you must reload your list after calling this');
    if (redrawCallback != null) redrawCallback!();
  }

  void replaceGameStatusForRowRebuildTest(String round) {
    //
    // TableviewDataRowTuple drt = _allAssetRows[2];
    // ActiveGameDetails agd = drt.item3;
    // var ci = CompetitionInfo(
    //   key: agd.competitionKey,
    //   competitionStatus: null,
    //   currentRoundName: round,
    // );
    // agd = agd.cloneWithUpdates(ci);

    // _allAssetRows[2] = TableviewDataRowTuple(drt.item1, drt.item2, agd);
    print('ActiveGameDetails replaced on 2 with $round  (did row repaint?)');
  }
}
