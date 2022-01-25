part of OutputModels;

@JsonSerializable()
class ScreenCfg {
  //
  AppScreen appScreen;
  Map<ScreenWidgetArea, ScreenAreaCfg> areaConfig = {};

  ScreenCfg(
    this.appScreen,
  );

  void appendRules(VisualRuleQuestion<dynamic, RuleResponseWrapper> rQuest) {
    //
    RuleResponseWrapper? answer = rQuest.response?.answers;
    ScreenWidgetArea? swa = rQuest.screenWidgetArea;
    if (answer == null || swa == null) return;

    if (answer is Iterable) {
      throw UnimplementedError('todo');
    } else {
      var sac = areaConfig[swa] ?? ScreenAreaCfg(swa);
      sac.appendAreaOrSlotRule(rQuest);
      areaConfig[swa] = sac;
    }
  }

  factory ScreenCfg.fromJson(Map<String, dynamic> json) =>
      _$ScreenCfgFromJson(json);

  Map<String, dynamic> toJson() => _$ScreenCfgToJson(this);
}
