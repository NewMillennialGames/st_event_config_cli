part of OutputModels;

class ComponentCfg {
  // ComponentRules
  ScreenWidgetArea sectionComponent;
  Map<VisualRuleType, UiCfg> uiCfgByApplicableRules;

  ComponentCfg(this.sectionComponent, this.uiCfgByApplicableRules);
}
