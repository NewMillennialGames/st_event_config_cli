part of OutputModels;

class SlotOrAreaRuleCfg {
  //
  VisualRuleType ruleType;
  List<AppConfigRule> rulesForType;
  //
  SlotOrAreaRuleCfg(this.ruleType, this.rulesForType);
}
