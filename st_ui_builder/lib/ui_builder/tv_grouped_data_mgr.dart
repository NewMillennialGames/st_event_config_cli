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
    GroupedListView<RowPropertyInterface, GroupKeyTuple>

  TODO:  all the getters below must be completed to return real methods
  */

  final List<TableviewDataRowTuple> _assetRows;
  final TableviewConfigPayload _cfg;
  final SlotOrAreaRuleCfg _filterBarCfg;
  GroupedListOrder order = GroupedListOrder.ASC;
  List<TableviewDataRowTuple> _filteredAssetRows = [];

  GroupedTableDataMgr(
    this._assetRows,
    this._cfg,
    this._filterBarCfg, {
    bool ascending = true,
  }) : this.order = ascending ? GroupedListOrder.ASC : GroupedListOrder.DESC;

  GetGroupKeyFromRow get groupBy {
    return GroupHeaderData.keyConstructorFromCfg(_cfg.groupByRules);
  }

  // groupHeaderBuilder is function to return header widget
  // defining groupHeaderBuilder will cause groupSeparatorBuilder to be ignored
  GroupHeaderBuilder? get groupHeaderBuilder =>
      (AssetRowPropertyIfc _) => TvGroupHeader(GroupHeaderData.mockRow);

  // indexedItemBuilder is function to return a Tv-Row for this screen
  IndexedItemRowBuilder get indexedItemBuilder => (
        BuildContext ctx,
        TableviewDataRowTuple assets,
        int i,
      ) {
        return _cfg.rowConstructor(assets);
      };
  // for sorting sections
  SectionSortComparator get itemComparator => (i1, i2) => 0;

  FilterRules? get _filterRules => _filterBarCfg.filterRules;

  bool get hasFilterBar {
    return _filterRules == null ? false : true;
  }

  Widget filterBarRow() {
    // dont call this without first checking this.hasFilterBar
    FilterRules fltrRules = this._filterRules!;

    return Row(
      children: [
        _dropMenuList(fltrRules.item1),
        if (fltrRules.item2 != null) _dropMenuList(fltrRules.item2!),
        if (fltrRules.item3 != null) _dropMenuList(fltrRules.item3!),
      ],
    );
  }

  DropdownButton<String> _dropMenuList(TvFilterCfg fCfg) {
    // return DropdownButton menu for slot
    List<String> listItems = _filterListItems(fCfg);
    return DropdownButton<String>(
      items: listItems
          .map((e) => DropdownMenuItem<String>(child: Text(e)))
          .toList(),
      onChanged: (String? selectedVal) {
        if (selectedVal == null) {
          clearFilters();
          return;
        }
        _doFilteringFor(fCfg.colName, selectedVal);
      },
    );
  }

  List<String> _filterListItems(TvFilterCfg fCfg) {
    Iterable<String> l = _assetRows.map(
      (e) => e.item1.valueExtractor(fCfg.colName),
    );
    return l.toList();
  }

  void _doFilteringFor(DbTableFieldName colName, String selectedVal) {
    // void filterDataBy(DbTableFieldName fld, String value) {
    //
    FilterRules fltrRules = this._filterRules!;
    TvFilterCfg filterCfg;
    if (fltrRules.item1.colName == colName) {
      filterCfg = fltrRules.item1;
    } else if (fltrRules.item2!.colName == colName) {
      filterCfg = fltrRules.item1;
    } else if (fltrRules.item3!.colName == colName) {
      filterCfg = fltrRules.item1;
    }
    this._filteredAssetRows = this
        ._assetRows
        .where((TableviewDataRowTuple dr) =>
            dr.item1.valueExtractor(colName) == selectedVal)
        .toList();

    print('you must reload your list after calling this');
  }

  void clearFilters() {
    this._filteredAssetRows = _assetRows;
    print('you must reload your list after calling this');
  }

  // NIU
  // GroupSepRowBuilder get groupSeparatorBuilder {
  //   // defining groupHeaderBuilder will cause groupSeparatorBuilder to be ignored
  //   return (GroupHeaderData _) => TvGroupHeaderSep(GroupHeaderData.mockRow);
  // }
}
