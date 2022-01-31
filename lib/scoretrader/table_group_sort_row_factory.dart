part of StUiController;

class TableStyleFactory {
  //
  final AppScreen screen;
  final CfgForAreaAndNestedSlots _tblAreaConfig;

  TableStyleFactory(
    this.screen,
    this._tblAreaConfig,
  );

  GroupedTableDataMgr tableDataConfig(List<AssetRowPropertyIfc> rows) {
    TableConfigPayload cfg = TableConfigPayload(_tblAreaConfig);
    return GroupedTableDataMgr(rows, cfg);
  }

  // Widget rowForAsset(List<AssetRowPropertyIfc> competitors) {
  //   //
  //   TvRowStyleCfg formatRuleCfg = _eConfig.formatRuleCfg(screen);
  //   // String userResponse = formatRuleCfg
  //   //     .configForQuestType(VisRuleQuestType.selectVisualComponentOrStyle);
  //   // switch (appRule.ruleType) {
  //   //   case
  //   // }
  //   return Widget();
  // }
}
