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

  void filterDataBy(DbTableFieldName fld, String value) {
    //
    TvFilterCfg filterCfg = _filterBarCfg.filterRules!.item1;

    this._filteredAssetRows =
        this._assetRows.where((TableviewDataRowTuple dr) => true).toList();

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
