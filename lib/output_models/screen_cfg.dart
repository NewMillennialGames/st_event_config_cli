part of OutputModels;

@JsonSerializable()
class ScreenCfg {
  //
  AppScreen appScreen;
  Map<ScreenWidgetArea, ScreenAreaCfg> areaConfig = {};
  Map<ScreenWidgetArea, SlotOrAreaRuleCfg> slotConfig = {};

  ScreenCfg(
    this.appScreen,
  );

  void appendRules(VisualRuleQuestion rQuest) {
    //
    RuleResponseWrapper? answer = rQuest.response?.answers;
    if (answer == null) return;

    if (answer is Iterable) {
    } else {
      _handleAreaRules(answer);
      _handleSlotRules(answer);
    }
  }

  void _handleAreaRules(RuleResponseWrapper answer) {
    //
  }

  void _handleSlotRules(RuleResponseWrapper answer) {
    //
  }

  factory ScreenCfg.fromJson(Map<String, dynamic> json) =>
      _$ScreenCfgFromJson(json);

  Map<String, dynamic> toJson() => _$ScreenCfgToJson(this);
}
