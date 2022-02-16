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
  GroupedListOrder order = GroupedListOrder.ASC;
  // rows actually rendered from _filteredAssetRows
  List<TableviewDataRowTuple> _filteredAssetRows = [];
  // regions no longer matter when you get to final 4
  bool disableGroupingBeyondDate = false;

  GroupedTableDataMgr(
    this._allAssetRows,
    this._tableViewCfg, {
    bool ascending = true,
  })  : this.order = ascending ? GroupedListOrder.ASC : GroupedListOrder.DESC,
        this._filteredAssetRows = _allAssetRows.toList();

  List<TableviewDataRowTuple> get listData => _filteredAssetRows;
  // GroupingRules get groupRules => _tableViewCfg.groupByRules;
  SortingRules get sortingRules => _tableViewCfg.sortRules;
  FilterRules get filterRules => _tableViewCfg.filterRules;

  GetGroupKeyFromRow get groupBy {
    return GroupHeaderData.keyConstructorFromCfg(_tableViewCfg.sortRules);
  }

  // groupHeaderBuilder is function to return header widget
  // defining groupHeaderBuilder will cause groupSeparatorBuilder to be ignored
  GroupHeaderBuilder get groupHeaderBuilder {
    // copy groupBy getter to save a lookup
    final gbFunc = groupBy;
    return (TableviewDataRowTuple rowData) => TvGroupHeader(gbFunc(rowData));
  }

  // natural sorting will use my Comparator; dont need this
  // GroupComparatorCallback get groupComparator =>
  //     (hd1, hd2) => hd1.compareTo(hd2);

  // indexedItemBuilder is function to return a Tv-Row for this screen
  IndexedItemRowBuilder get indexedItemBuilder => (
        BuildContext ctx,
        TableviewDataRowTuple assets,
        int i,
      ) {
        return _tableViewCfg.rowConstructor(assets);
      };

  // for sorting sections
  SectionSortComparator get itemComparator => (
        TableviewDataRowTuple i1,
        TableviewDataRowTuple i2,
      ) {
        // TODO: base it on configured sort fields
        // or we could add Comparable to TableviewDataRowTuple
        return i1.item1.topName.compareTo(i2.item1.topName);
      };

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
    List<String> listItems = _getListItemsByCfgField(fCfg);
    String headerName = fCfg.colName.labelName;
    return DropdownButton<String>(
      items: listItems
          .map((e) => DropdownMenuItem<String>(child: Text(e)))
          .toList(),
      onChanged: (String? selectedVal) {
        if (selectedVal == null || selectedVal == headerName) {
          clearFilters();
          return;
        }
        _doFilteringFor(fCfg.colName, selectedVal);
      },
      value: headerName,
      style: const TextStyle(color: Colors.grey, fontSize: 22),
    );
  }

  List<String> _getListItemsByCfgField(TvFilterCfg fCfg) {
    // build list of unique values from selected field
    // elim dups and sort
    return _allAssetRows
        .map(
          (e) => e.item1.valueExtractor(fCfg.colName),
        )
        .toSet()
        .toList()
      ..sort((v1, v2) => v1.compareTo(v2));
  }

  void _doFilteringFor(DbTableFieldName colName, String selectedVal) {
    //
    _filteredAssetRows = _allAssetRows
        .where((TableviewDataRowTuple dr) =>
            dr.item1.valueExtractor(colName) == selectedVal)
        .toList();

    print('you must reload your list after calling this');
  }

  void clearFilters() {
    this._filteredAssetRows = _allAssetRows;
    print('you must reload your list after calling this');
  }

  // NIU
  // GroupSepRowBuilder get groupSeparatorBuilder {
  //   // defining groupHeaderBuilder will cause groupSeparatorBuilder to be ignored
  //   return (GroupHeaderData _) => TvGroupHeaderSep(GroupHeaderData.mockRow);
  // }
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