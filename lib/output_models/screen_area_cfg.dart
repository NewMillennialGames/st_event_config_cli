part of OutputModels;

@JsonSerializable()
class ScreenAreaCfg {
  // ComponentRules
  ScreenWidgetArea sectionComponent;
  Map<VisualRuleType, SlotOrAreaRuleCfg> uiCfgByApplicableRules;

  ScreenAreaCfg(this.sectionComponent, this.uiCfgByApplicableRules);

  factory ScreenAreaCfg.fromJson(Map<String, dynamic> json) =>
      _$ScreenAreaCfgFromJson(json);

  Map<String, dynamic> toJson() => _$ScreenAreaCfgToJson(this);
}
