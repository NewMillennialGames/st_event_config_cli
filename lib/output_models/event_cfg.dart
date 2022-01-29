part of OutputModels;

/*
  this is the top level object
  to export as the complete
  Event configuration tree
*/

@JsonSerializable()
class EventCfgTree {
  //
  String evTemplateName;
  String evTemplateDescription;
  EvType evType;
  EvCompetitorType evCompetitorType;
  EvOpponentType evOpponentType;
  EvDuration evDuration;
  EvEliminationStrategy evEliminationType;
  // area and slot level data filled below in fillFromRuleAnswers
  Map<AppScreen, ScreenCfgByArea> screenConfigMap = {};

  EventCfgTree(
    this.evTemplateName,
    this.evTemplateDescription,
    this.evType, {
    this.evCompetitorType = EvCompetitorType.team,
    this.evOpponentType = EvOpponentType.sameAsCompetitorType,
    this.evDuration = EvDuration.oneGame,
    this.evEliminationType = EvEliminationStrategy.roundRobin,
  });

  factory EventCfgTree.fromEventLevelConfig(Iterable<Question> responses) {
    //
    String evTemplateName =
        (responses.where((q) => q.questionId == 1).first.response?.answers ??
            '') as String;

    // declare Event level vals to be captured
    String evTemplateDescription = '';
    EvType evType = EvType.standard;
    EvCompetitorType evCompetitorType = EvCompetitorType.team;
    EvOpponentType evOpponentType = EvOpponentType.sameAsCompetitorType;
    EvDuration evDuration = EvDuration.oneGame;
    EvEliminationStrategy evEliminationType = EvEliminationStrategy.singleGame;
    // use try to catch errs and allow easy debugging
    try {
      evTemplateDescription =
          (responses.where((q) => q.questionId == 2).first.response?.answers ??
              '') as String;

      evType = responses
          .where((q) => q.response?.answers is EvType)
          .first
          .response!
          .answers as EvType;
      //
      evCompetitorType = responses
          .where((q) => q.response?.answers is EvCompetitorType)
          .first
          .response!
          .answers as EvCompetitorType;
      evOpponentType = responses
          .where((q) => q.response?.answers is EvOpponentType)
          .first
          .response!
          .answers as EvOpponentType;
      evDuration = responses
          .where((q) => q.response?.answers is EvDuration)
          .first
          .response!
          .answers as EvDuration;
      evEliminationType = responses
          .where((q) => q.response?.answers is EvEliminationStrategy)
          .first
          .response!
          .answers as EvEliminationStrategy;
    } catch (e) {
      print(
        'Warnnig:  key Event level quests/fields missing.  Hope you are debugging',
      );
    }

    return EventCfgTree(
      evTemplateName,
      evTemplateDescription,
      evType,
      evCompetitorType: evCompetitorType,
      evOpponentType: evOpponentType,
      evDuration: evDuration,
      evEliminationType: evEliminationType,
    );
  }

  void fillFromVisualRuleAnswers(
      Iterable<VisualRuleQuestion> answeredQuestions) {
    //
    for (VisualRuleQuestion rQuest in answeredQuestions) {
      //
      var screenCfg = this.screenConfigMap[rQuest.appScreen] ??
          ScreenCfgByArea(rQuest.appScreen);
      screenCfg.appendRule(rQuest);
      this.screenConfigMap[rQuest.appScreen] = screenCfg;
    }
  }

  void dumpCfgToFile(String? filename) {
    // write data out to file
    var fn = filename ?? evTemplateName;
    var outFile = File('$fn.json');
    var jsonData = this.toJson();
    outFile.writeAsStringSync(jsonEncode(jsonData));
    // outFile.close();
  }

  void fillMissingWithDefaults() {
    // called automatically before conversion to JSON
    // fill out any missing rules with defaults
    for (AppScreen as in AppScreen.eventConfiguration.topConfigurableScreens) {
      if (screenConfigMap.containsKey(as)) continue;
      screenConfigMap[as] = ScreenCfgByArea(as);
    }
    this.screenConfigMap.values.forEach((sc) => sc.fillMissingWithDefaults());
  }

  // impl for JsonSerializable above
  factory EventCfgTree.fromJson(Map<String, dynamic> json) =>
      _$EventCfgTreeFromJson(json);

  Map<String, dynamic> toJson() {
    fillMissingWithDefaults();
    return _$EventCfgTreeToJson(this);
  }
}

extension EventCfgTreeExt1 on EventCfgTree {
  //
  ScreenCfgByArea screenCfg(AppScreen screen) => this.screenConfigMap[screen]!;

  CfgForAreaAndNestedSlots screenArea(
    AppScreen screen,
    ScreenWidgetArea area,
  ) =>
      screenCfg(screen).areaConfig[area]!;

  Map<VisualRuleType, SlotOrAreaRuleCfg> areaCfgVisual(
    AppScreen screen,
    ScreenWidgetArea area,
  ) =>
      screenArea(screen, area).visRulesForArea;

  SlotOrAreaRuleCfg areaTableRules(AppScreen screen) => areaCfgVisual(
      screen, ScreenWidgetArea.tableview)[VisualRuleType.styleOrFormat]!;

  AppVisualRule tableFormatRule(AppScreen screen) {
    return areaTableRules(screen).ruleByType(VisualRuleType.styleOrFormat);
  }

  RuleResponseWrapper formatRuleCfg(AppScreen screen) =>
      (tableFormatRule as FormatRule).rrw;
}
