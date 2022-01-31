part of StUiController;

/*

*/

class TableConfigPayload {
  /* needs to provide data for 
      grouping options
      sorting options
      row-style
  */

  final TvAreaRowStyle rowStyle;
  // final DbTableFieldName

  TableConfigPayload._(this.rowStyle);

  factory TableConfigPayload(CfgForAreaAndNestedSlots tableAreaCfg) {
    //
    SlotOrAreaRuleCfg tableRules = tableAreaCfg
        .visRulesForArea[VisRuleQuestType.selectVisualComponentOrStyle]!;

    StyleOrFormatRule rule = tableRules.ruleByType(VisualRuleType.styleOrFormat)
        as StyleOrFormatRule;
    return TableConfigPayload._(rule.rrw.selectedRowStyle);
  }
}
