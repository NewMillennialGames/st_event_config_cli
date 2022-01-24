part of OutputModels;

class ScreenAreaCfg {
  // ComponentRules
  ScreenWidgetArea sectionComponent;
  Map<VisualRuleType, SlotOrAreaRuleCfg> uiCfgByApplicableRules;

  ScreenAreaCfg(this.sectionComponent, this.uiCfgByApplicableRules);
}
