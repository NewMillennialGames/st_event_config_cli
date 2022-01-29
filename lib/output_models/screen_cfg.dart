part of OutputModels;

@JsonSerializable()
class ScreenCfg {
  //
  final AppScreen appScreen;
  final Map<ScreenWidgetArea, ScreenAreaCfg> areaConfig = {};

  ScreenCfg(
    this.appScreen,
  );

  ScreenAreaCfg configForArea(ScreenWidgetArea area) => areaConfig[area]!;

  void appendRule(
    VisualRuleQuestion<dynamic, RuleResponseWrapper> rQuest,
  ) {
    //
    RuleResponseWrapper? answer = rQuest.response?.answers;
    ScreenWidgetArea? swa = rQuest.screenWidgetArea;
    if (answer == null || swa == null) {
      print(
        'Err: ${rQuest.questionId} ${rQuest.questDef.questStr} was missing key data',
      );
      return;
    }

    if (answer is Iterable) {
      throw UnimplementedError('todo');
    } else {
      var sac = areaConfig[swa] ?? ScreenAreaCfg(swa);
      sac.appendAreaOrSlotRule(rQuest);
      areaConfig[swa] = sac;
    }
  }

  void _addDefaultRulesWhereMissing() {
    //  TODO
    for (ScreenWidgetArea a in ScreenWidgetArea.values) {
      if (!areaConfig.containsKey(a)) {
        areaConfig[a] = ScreenAreaCfg(a)..buildDefaults();
      }
    }
  }

  // JsonSerializable
  factory ScreenCfg.fromJson(Map<String, dynamic> json) =>
      _$ScreenCfgFromJson(json);

  Map<String, dynamic> toJson() {
    //
    _addDefaultRulesWhereMissing();

    return _$ScreenCfgToJson(this);
  }
}
