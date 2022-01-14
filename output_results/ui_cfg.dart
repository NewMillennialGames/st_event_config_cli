part of EventOutput;

class UiCfg {
  //
  SectionComponent sectionComponent;
  Map<RuleType, List<BaseRule>> rulesByType;
  //
  UiCfg(this.sectionComponent, this.rulesByType);
}
