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
  final List<GroupRule> groupByRules;
  final List<SortRule> sortRules;

  TableConfigPayload._(
    this.rowStyle,
    this.groupByRules,
    this.sortRules,
  );

  factory TableConfigPayload(CfgForAreaAndNestedSlots tableAreaCfg) {
    //
    SlotOrAreaRuleCfg tableRules =
        tableAreaCfg.areaRuleByRuleType(VisualRuleType.styleOrFormat);

    StyleOrFormatRule styleRule = tableRules
        .ruleByType(VisualRuleType.styleOrFormat) as StyleOrFormatRule;

    List<GroupRule> groupRules = [];

    /// tableRules.rulesForType;
    List<SortRule> sortRules = [];

    return TableConfigPayload._(
      styleRule.rrw.selectedRowStyle,
      groupRules,
      sortRules,
    );
  }
}
