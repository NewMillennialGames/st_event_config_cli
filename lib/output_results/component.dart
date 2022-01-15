part of EvTemplateOutput;

class ComponentCfg {
  // ComponentRules
  UiComponent sectionComponent;
  Map<RuleType, UiCfg> uiCfgByApplicableRules;

  ComponentCfg(this.sectionComponent, this.uiCfgByApplicableRules);
}
