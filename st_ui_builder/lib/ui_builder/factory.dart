part of StUiController;

class StUiBuilderFactory {
  /* top level config API

    this object will be global
    and served by a riverpod provider

    it will be refreshed every time the user changes events

    when each screen inits, they will request
    the configuration objs they need fromt the methods below
  */
  EventCfgTree? _eConfig;
  //
  StUiBuilderFactory();

  void setConfigForCurrentEvent(Map<String, dynamic> eCfgJsonMap) {
    /* call this every time user switches events
      send api payload (upon event switching) here
      to reconfigure the factory

      TODO:  add versioning
    */
    this._eConfig = EventCfgTree.fromJson(eCfgJsonMap);
  }

  GroupedTableDataMgr tableviewConfigForScreen(
    AppScreen screen,
    List<TableviewDataRowTuple> rows,
  ) {
    /* build object that wraps all data and display rules
    */
    CfgForAreaAndNestedSlots tableCfg =
        _eConfig!.screenAreaCfg(screen, ScreenWidgetArea.tableview);

    SlotOrAreaRuleCfg filterBarCfg = _filterBarConfigForScreen(screen);
    return GroupedTableDataMgr(
        rows, TableviewConfigPayload(tableCfg), filterBarCfg);
  }

  SlotOrAreaRuleCfg _filterBarConfigForScreen(AppScreen screen) {
    //
    CfgForAreaAndNestedSlots tableCfg =
        _eConfig!.screenAreaCfg(screen, ScreenWidgetArea.filterBar);
    return tableCfg.areaRuleByRuleType(VisualRuleType.filterCfg);
  }

  SlotOrAreaRuleCfg headerConfigForScreen(AppScreen screen) {
    //
    CfgForAreaAndNestedSlots tableCfg =
        _eConfig!.screenAreaCfg(screen, ScreenWidgetArea.header);
    return tableCfg.areaRuleByRuleType(VisualRuleType.styleOrFormat);
  }

  SlotOrAreaRuleCfg footerConfigForScreen(AppScreen screen) {
    //
    CfgForAreaAndNestedSlots tableCfg =
        _eConfig!.screenAreaCfg(screen, ScreenWidgetArea.footer);
    return tableCfg.areaRuleByRuleType(VisualRuleType.styleOrFormat);
  }
}
