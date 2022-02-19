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

  // getters
  bool get marketViewIsGameCentricAndTwoPerRow =>
      _eConfig!.marketViewIsGameCentricAndTwoPerRow;
  bool get marketViewRowsAreSingleAssetOnly =>
      !marketViewIsGameCentricAndTwoPerRow;

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
    CfgForAreaAndNestedSlots tableAreaAndSlotCfg =
        _eConfig!.screenAreaCfg(screen, ScreenWidgetArea.tableview);

    CfgForAreaAndNestedSlots filterBarAndSlotCfg =
        _eConfig!.screenAreaCfg(screen, ScreenWidgetArea.filterBar);

    return GroupedTableDataMgr(
      rows,
      TableviewConfigPayload(screen, tableAreaAndSlotCfg, filterBarAndSlotCfg),
    );
  }

  FilterRules filterBarConfigForScreen(AppScreen screen) {
    // this data also embedded in the GroupedTableDataMgr
    // this is NIU I believe
    CfgForAreaAndNestedSlots filterBarAndSlotCfg =
        _eConfig!.screenAreaCfg(screen, ScreenWidgetArea.filterBar);
    return filterBarAndSlotCfg.filterRules!;
  }

  SlotOrAreaRuleCfg headerConfigForScreen(AppScreen screen) {
    //
    CfgForAreaAndNestedSlots tableCfg =
        _eConfig!.screenAreaCfg(screen, ScreenWidgetArea.header);
    return tableCfg.areaRulesByRuleType(VisualRuleType.styleOrFormat);
  }

  SlotOrAreaRuleCfg footerConfigForScreen(AppScreen screen) {
    //
    CfgForAreaAndNestedSlots tableCfg =
        _eConfig!.screenAreaCfg(screen, ScreenWidgetArea.footer);
    return tableCfg.areaRulesByRuleType(VisualRuleType.styleOrFormat);
  }
}
