part of CfgOutputModels;

class ComponentCfg {
  // ComponentRules
  UiComponent sectionComponent;
  Map<VisualRuleType, UiCfg> uiCfgByApplicableRules;

  ComponentCfg(this.sectionComponent, this.uiCfgByApplicableRules);
}
