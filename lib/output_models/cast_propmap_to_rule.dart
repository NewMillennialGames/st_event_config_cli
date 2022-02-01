part of OutputModels;

extension VisualRuleTypeExt2 on VisualRuleType {
  AppVisualRuleBase castPropertyMapToRule(RuleResponseBase pm) {
    switch (this) {
      case VisualRuleType.sortCfg:
        return AppVisualRuleBase.sort(pm);
      case VisualRuleType.groupCfg:
        return AppVisualRuleBase.group(pm);
      case VisualRuleType.filterCfg:
        return AppVisualRuleBase.filter(pm);
      case VisualRuleType.styleOrFormat:
        return AppVisualRuleBase.format(pm as TvRowStyleCfg);
      case VisualRuleType.showOrHide:
        return AppVisualRuleBase.show(pm);
    }
  }
}
