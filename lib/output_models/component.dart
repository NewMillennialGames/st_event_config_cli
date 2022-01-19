part of OutputModels;

class ComponentCfg {
  // ComponentRules
  SectionUiArea sectionComponent;
  Map<VisualRuleType, UiCfg> uiCfgByApplicableRules;

  ComponentCfg(this.sectionComponent, this.uiCfgByApplicableRules);
}
