part of StUiController;

class AbstractUiFactory {
  /* top level config API

    this object will be global
    and served by a riverpod provider

    it will be refreshed every time the user changes events

    when each screen inits, they will request
    the configuration objs they need fromt the methods below
  */
  EventCfgTree? _eConfig;
  //
  AbstractUiFactory();

  void setConfigForCurrentEvent(Map<String, dynamic> eCfgJsonMap) {
    /* call this every time user switches events
      send api payload (upon event switching) here
      to reconfigure the factory
    */
    this._eConfig = EventCfgTree.fromJson(eCfgJsonMap);
  }

  GroupedTableDataMgr tableviewConfigForScreen(
    AppScreen screen,
    List<StdRowData> rows,
  ) {
    //
    final cfg = _eConfig!
        .screenConfigMap[screen]!.areaConfig[ScreenWidgetArea.tableview];
    TableviewConfigPayload tvsp = TableviewConfigPayload(cfg!);
    return GroupedTableDataMgr(rows, tvsp);
  }

  // FIXME
  void filterBarConfigForScreen(AppScreen screen) {
    //
  }

  void headerConfigForScreen(AppScreen screen) {
    //
  }

  void footerConfigForScreen(AppScreen screen) {
    //
  }
}


  // TableStyleFactory tableUiConfigForScreen(AppScreen screen) {
  //   final cfg = _eConfig!
  //       .screenConfigMap[screen]!.areaConfig[ScreenWidgetArea.tableview];
  //   return TableStyleFactory(screen, cfg!);
  // }