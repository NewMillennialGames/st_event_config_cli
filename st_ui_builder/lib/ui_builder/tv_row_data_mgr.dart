part of StUiController;

/*  
*/

class TableRowDataMgr {
  /*
    this is the object returned when you want to build
    a table-view WITHOUT groupings or group headers
  */

  final AppScreen appScreen;
  final TableviewConfigPayload _tableViewCfg;
  List<TvRowDataContainer> _allAssetRows;
  RedrawTvCallback? redrawCallback;
  GroupedListOrder sortOrder = GroupedListOrder.ASC;

  // rows actually rendered from _filteredAssetRows
  // List<TableviewDataRowTuple> _filteredAssetRows = [];

  TableRowDataMgr(
    this.appScreen,
    this._allAssetRows,
    this._tableViewCfg, {
    this.redrawCallback,
    bool ascending = true,
  }) : sortOrder = ascending ? GroupedListOrder.ASC : GroupedListOrder.DESC;

  // _filteredAssetRows = _allAssetRows.toList();

  // List<TableviewDataRowTuple> get listData => _filteredAssetRows;
  TvSortCfg get sortingRules => _tableViewCfg.sortRules;
  TvGroupCfg? get groupingRules => _tableViewCfg.groupByRules;
  TvFilterCfg? get filterRules => _tableViewCfg.filterRules;

  // rowBuilder is function to return a Tv-Row for this screen
  NoAssetsIndexedItemRowBuilder get rowBuilder => (
        BuildContext ctx,
        int idx, {
        Function(TvRowDataContainer)? onTap,
      }) {
        var asset = _allAssetRows[idx];
        return _tableViewCfg.rowConstructor(asset, onTap: onTap);
      };

  TvAreaRowStyle get rowStyle => _tableViewCfg.rowStyle;

  void setLiveData(
    Iterable<TvRowDataContainer> _assetRows, {
    bool redraw = false,
  }) {
    /* 
    */

    _allAssetRows = _assetRows.toList();
    if (redraw && redrawCallback != null) {
      redrawCallback!();
    }
  }

  void endGeographicGrouping() {
    // games now happening between/across regions
    // so it not longer makes sense to group or sort geographically

    _tableViewCfg.endGeographicGrouping();
  }
}
