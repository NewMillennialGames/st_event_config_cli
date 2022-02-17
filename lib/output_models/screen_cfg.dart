part of OutputModels;

@JsonSerializable()
class ScreenCfgByArea {
  //
  final AppScreen appScreen;
  final Map<ScreenWidgetArea, CfgForAreaAndNestedSlots> areaConfig = {};

  ScreenCfgByArea(
    this.appScreen,
  );

  void _confirmAreaIsApplicableToThisScreen(
    ScreenWidgetArea area, [
    bool checkExists = false,
  ]) {
    // just to make error handling a bit more visible
    if (!appScreen.configurableScreenAreas.contains(area))
      throw UnimplementedError(
        'area ${area.name} is invalid for screen ${appScreen.name}',
      );
    if (!checkExists) return;

    if (!areaConfig.containsKey(area))
      throw UnimplementedError(
        'config for area ${area.name} is missing on screen ${appScreen.name}',
      );
  }

  CfgForAreaAndNestedSlots configForArea(ScreenWidgetArea area) {
    _confirmAreaIsApplicableToThisScreen(area, true);
    return areaConfig[area]!;
  }

  void appendRule(
    VisRuleStyleQuest rQuest,
  ) {
    //
    var swa = rQuest.screenWidgetArea;
    assert(swa != null, 'area is required at this level');
    _confirmAreaIsApplicableToThisScreen(swa!, false);
    //
    RuleResponseBase? answer = rQuest.response?.answers;
    if (answer == null) {
      var msg =
          'Err: ${rQuest.questionId} ${rQuest.questDef.questStr} was missing key data';
      print(
        msg,
      );
      throw UnimplementedError(msg);
    }

    if (answer is Iterable) {
      throw UnimplementedError('todo');
    } else {
      var areaCfg = this.areaConfig[swa] ?? CfgForAreaAndNestedSlots(swa);
      areaCfg.appendAreaOrSlotRule(rQuest);
      areaConfig[swa] = areaCfg;
    }
  }

  void fillMissingWithDefaults() {
    // make sure all rules exist before creating
    // the json output file
    // called automatically when top obj () tries to convert to JSON
    for (ScreenWidgetArea a in appScreen.configurableScreenAreas) {
      if (areaConfig.containsKey(a)) continue;
      areaConfig[a] = CfgForAreaAndNestedSlots(a)
        ..fillMissingWithDefaults(appScreen);
    }
  }

  // JsonSerializable
  factory ScreenCfgByArea.fromJson(Map<String, dynamic> json) =>
      _$ScreenCfgByAreaFromJson(json);

  Map<String, dynamic> toJson() {
    return _$ScreenCfgByAreaToJson(this);
  }
}
