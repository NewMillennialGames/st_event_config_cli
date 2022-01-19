part of OutputModels;

extension VisualRuleTypeExt2 on VisualRuleType {
  //

  AppConfigRule castPropertyMapToRule(RuleResponseWrapper pm) {
    switch (this) {
      case VisualRuleType.sort:
        return AppConfigRule.sort(pm);
      case VisualRuleType.group:
        return AppConfigRule.group(pm);
      case VisualRuleType.filter:
        return AppConfigRule.filter(pm);
      case VisualRuleType.format:
        return AppConfigRule.format(pm);
      case VisualRuleType.show:
        return AppConfigRule.show(pm);
    }
  }
}
