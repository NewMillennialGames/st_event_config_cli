part of CfgOutputModels;

class UiCfg {
  //
  VisualRuleType ruleType;
  List<AppConfigRule> rulesForType;
  //
  UiCfg(this.ruleType, this.rulesForType);
}
