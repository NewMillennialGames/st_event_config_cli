part of StUiController;

class StUiBuilderFactory {
  /* top level config API

    this object will be global
    and served by a riverpod provider

    it will be refreshed every time the user changes selected Event

    when each screen inits, they will request
    the configuration objs they need from the methods below
  */
  late EventCfgTree? _eConfig;
  //
  StUiBuilderFactory();

  // getters
  bool get marketViewIsGameCentricAndTwoPerRow =>
      _eConfig!.marketViewIsGameCentricAndTwoPerRow;
  bool get marketViewRowsAreSingleAssetOnly =>
      !marketViewIsGameCentricAndTwoPerRow;

  TopEventCfg get eventCfg => _eConfig!.eventCfg;

  void setConfigForCurrentEvent(Map<String, dynamic> eCfgJsonMap) {
    /* call this every time user switches events
      send api payload (upon event switching) here
      to reconfigure the factory

      TODO:  add versioning to json so we can improve it over time
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
    if (_eConfig!.eventCfg.applyMktViewRowStyleToAllScreens) {
      _readRowStyleFromMarketViewAndClone();
    }
  }

  void _readRowStyleFromMarketViewAndClone() {
    // apply row style from market-view (first selected row-style)
    // to all screens, based on config this pref setting:
    bool applyMktViewRowStyleToAllScreens =
        _eConfig?.eventCfg.applyMktViewRowStyleToAllScreens ?? false;

    assert(
      applyMktViewRowStyleToAllScreens,
      'err: _readRowStyleFromMarketViewAndClone called when pref not set?',
    );

    CfgForAreaAndNestedSlots mktViewTableAreaAndSlotCfg =
        _eConfig!.screenAreaCfg(
      AppScreen.marketView,
      ScreenWidgetArea.tableview,
    );
    TvAreaRowStyle appWideRowStyle =
        mktViewTableAreaAndSlotCfg.rowStyleCfg.selectedRowStyle;

    for (AppScreen appScreen in AppScreen.marketView.configurableAppScreens) {
      if (appScreen == AppScreen.marketView) continue;

      _eConfig?.setConfigFor(
        appScreen,
        ScreenWidgetArea.tableview,
        appWideRowStyle,
      );
    }
  }

  TvBasisForRow tvRowStyleForScreen(AppScreen screen) {
    CfgForAreaAndNestedSlots tableAreaAndSlotCfg =
        _eConfig!.screenAreaCfg(screen, ScreenWidgetArea.tableview);
    return tableAreaAndSlotCfg.rowStyleCfg.selectedRowStyle.rowFormatStyle;
  }

  DynamicRowBuilder rowBuilderForScreen(
    AppScreen scr, {
    bool forSingleAssetOnly = true,
  }) {
    // return a function that gives you the right row style
    // constructor for a given screen

    CfgForAreaAndNestedSlots tableAreaAndSlotCfg;
    if (_eConfig?.eventCfg.applyMktViewRowStyleToAllScreens ?? false) {
      tableAreaAndSlotCfg = _eConfig!
          .screenAreaCfg(AppScreen.marketView, ScreenWidgetArea.tableview);
    } else {
      tableAreaAndSlotCfg =
          _eConfig!.screenAreaCfg(scr, ScreenWidgetArea.tableview);
    }
    TableviewConfigPayload tableViewCfg =
        TableviewConfigPayload.orig(scr, tableAreaAndSlotCfg, null);

    // this is important to force substitute row-style
    // when only showing one tradable
    tableViewCfg.alwaysReturnSingleTradableRowBuilder = forSingleAssetOnly;
    return (
      BuildContext ctx,
      TableviewDataRowTuple assets,
    ) {
      return tableViewCfg.rowConstructor(assets);
    };
  }

  GroupedTableDataMgr groupedTvConfigForScreen(
    AppScreen screen,
    List<TableviewDataRowTuple> rows,
    RedrawTvCallback redrawTvCallback,
  ) {
    /* build object that wraps all data and display rules
    */

    bool disableAllGrouping = _eConfig!.eventCfg.skipGroupingOnScreen(screen);

    CfgForAreaAndNestedSlots tableAreaAndSlotCfg =
        _eConfig!.screenAreaCfg(screen, ScreenWidgetArea.tableview);

    // old method
    // CfgForAreaAndNestedSlots filterBarAndSlotCfg =
    //     _eConfig!.screenAreaCfg(screen, ScreenWidgetArea.filterBar);

    // return GroupedTableDataMgr(
    //   screen,
    //   rows,
    //   TableviewConfigPayload.orig(
    //       screen, tableAreaAndSlotCfg, filterBarAndSlotCfg),
    //   redrawCallback: redrawTvCallback,
    //   disableAllGrouping: disableAllGrouping,
    // );

    // new updated method!
    TvSortCfg sortCfg = _eConfig!.tvSortingRules(screen) ?? TvSortCfg.noop();
    TvGroupCfg? group = _eConfig!.tvGroupingRules(screen);
    TvFilterCfg? filter = _eConfig!.tvFilteringRules(screen);

    TableviewConfigPayload tvcp = TableviewConfigPayload(
      screen,
      tableAreaAndSlotCfg.rowStyleCfg.selectedRowStyle,
      sortCfg,
      filter,
      group,
    );

    return GroupedTableDataMgr(
      screen,
      rows,
      tvcp,
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

    CfgForAreaAndNestedSlots? filterAreaCfg;

    try {
      filterAreaCfg = _eConfig!.screenAreaCfg(
        screen,
        ScreenWidgetArea.filterBar,
      );
    } catch (e) {}

    return TableRowDataMgr(
      screen,
      rows,
      TableviewConfigPayload.orig(
        screen,
        tableAreaAndSlotCfg,
        filterAreaCfg,
      ),
      redrawCallback: redrawTvCallback,
    );
  }

  void printSummary() {
    _eConfig?.printSummary();
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
