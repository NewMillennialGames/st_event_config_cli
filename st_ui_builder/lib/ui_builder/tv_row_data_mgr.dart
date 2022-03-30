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
  List<TableviewDataRowTuple> _allAssetRows;
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
  // GroupingRules get groupRules => _tableViewCfg.groupByRules;
  SortingRules get sortingRules => _tableViewCfg.sortRules;
  // FilterRules get filterRules => _tableViewCfg.filterRules;

  // rowBuilder is function to return a Tv-Row for this screen
  IndexedWidgetBuilder get rowBuilder => (BuildContext ctx, int i) {
        var asset = _allAssetRows[i];
        return _tableViewCfg.rowConstructor(asset);
      };

  void setLiveData(
    Iterable<TableviewDataRowTuple> _assetRows, {
    bool redraw = false,
  }) {
    /* 
    */
    _allAssetRows = _assetRows.toList();
    if (redraw && redrawCallback != null) {
      redrawCallback!();
    }
  }
}
