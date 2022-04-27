part of StUiController;

class StUiBuilderFactory {
  /* top level config API

    this object will be global
    and served by a riverpod provider

    it will be refreshed every time the user changes selected Event

    when each screen inits, they will request
    the configuration objs they need from the methods below
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
    try {
      _eConfig = EventCfgTree.fromJson(eCfgJsonMap);
    } catch (e) {
      // will fall to the catch block in calling method
      throw UnimplementedError(
        'UI Config JSON failed to parse!! server sent invalid payload ${e.toString()}',
      );
    }
    //
    if (_eConfig!.eventCfg.applySameRowStyleToAllScreens) {
      _readRowStyleFromMarketViewAndClone();
    }
  }

  void _readRowStyleFromMarketViewAndClone() {
    //
    CfgForAreaAndNestedSlots mktViewTableAreaAndSlotCfg =
        _eConfig!.screenAreaCfg(
      AppScreen.marketView,
      ScreenWidgetArea.tableview,
    );
    TvAreaRowStyle rowStyle =
        mktViewTableAreaAndSlotCfg.rowStyleCfg.selectedRowStyle;
    for (AppScreen scr in AppScreen.values) {
      if (scr == AppScreen.marketView) continue;

      _eConfig?.setConfigFor(scr, ScreenWidgetArea.tableview, rowStyle);
    }
  }

  TvBasisForRow tvRowStyleForScreen(AppScreen screen) {
    CfgForAreaAndNestedSlots tableAreaAndSlotCfg =
        _eConfig!.screenAreaCfg(screen, ScreenWidgetArea.tableview);
    return tableAreaAndSlotCfg.rowStyleCfg.selectedRowStyle.rowFormatStyle;
  }

  GroupedTableDataMgr groupedTvConfigForScreen(
    AppScreen screen,
    List<TableviewDataRowTuple> rows,
    RedrawTvCallback redrawTvCallback,
  ) {
    /* build object that wraps all data and display rules
    */
    CfgForAreaAndNestedSlots tableAreaAndSlotCfg =
        _eConfig!.screenAreaCfg(screen, ScreenWidgetArea.tableview);

    CfgForAreaAndNestedSlots filterBarAndSlotCfg =
        _eConfig!.screenAreaCfg(screen, ScreenWidgetArea.filterBar);

    // hack for Nascar b4 configurator is updated
    bool disableAllGrouping = _eConfig!.eventCfg.skipGroupingOnScreen(screen) ||
        _eConfig!.eventCfg.skipGroupingForName('nascar');

    return GroupedTableDataMgr(
      screen,
      rows,
      TableviewConfigPayload(screen, tableAreaAndSlotCfg, filterBarAndSlotCfg),
      redrawCallback: redrawTvCallback,
      disableAllGrouping: disableAllGrouping,
    );
  }

  TableRowDataMgr listTvConfigForScreen(
    AppScreen screen,
    List<TableviewDataRowTuple> rows,
    RedrawTvCallback redrawTvCallback,
  ) {
    CfgForAreaAndNestedSlots tableAreaAndSlotCfg = _eConfig!.screenAreaCfg(
      screen,
      ScreenWidgetArea.tableview,
    );

    return TableRowDataMgr(
      screen,
      rows,
      TableviewConfigPayload(
        screen,
        tableAreaAndSlotCfg,
        null,
      ),
      redrawCallback: redrawTvCallback,
    );
  }

  // FilterRules filterBarConfigForScreen(AppScreen screen) {
  //   // this data also embedded in the GroupedTableDataMgr
  //   // this is NIU I believe
  //   CfgForAreaAndNestedSlots filterBarAndSlotCfg =
  //       _eConfig!.screenAreaCfg(screen, ScreenWidgetArea.filterBar);
  //   return filterBarAndSlotCfg.filterRules!;
  // }

  // SlotOrAreaRuleCfg headerConfigForScreen(AppScreen screen) {
  //   //
  //   CfgForAreaAndNestedSlots tableCfg =
  //       _eConfig!.screenAreaCfg(screen, ScreenWidgetArea.header);
  //   return tableCfg.areaRulesByRuleType(VisualRuleType.styleOrFormat);
  // }

  // SlotOrAreaRuleCfg footerConfigForScreen(AppScreen screen) {
  //   //
  //   CfgForAreaAndNestedSlots tableCfg =
  //       _eConfig!.screenAreaCfg(screen, ScreenWidgetArea.footer);
  //   return tableCfg.areaRulesByRuleType(VisualRuleType.styleOrFormat);
  // }
}
