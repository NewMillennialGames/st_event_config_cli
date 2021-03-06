part of OutputModels;

/*
  this is the top level object
  to export as the complete
  Event configuration tree
*/

@JsonSerializable()
class TopEventCfg {
  /* */
  String evTemplateName;
  String evTemplateDescription;
  EvType evType;
  EvCompetitorType evCompetitorType;
  EvOpponentType evOpponentType;
  EvDuration evDuration;
  EvEliminationStrategy evEliminationType;
  // TODO  below not connected to Constructor or JSON
  bool applySameRowStyleToAllScreens = true;
  // bool groupOnlyByDate = false;

  TopEventCfg(
    this.evTemplateName,
    this.evTemplateDescription,
    this.evType, {
    this.evCompetitorType = EvCompetitorType.team,
    this.evOpponentType = EvOpponentType.sameAsCompetitorType,
    this.evDuration = EvDuration.oneGame,
    this.evEliminationType = EvEliminationStrategy.roundRobin,
  });

  bool skipGroupingOnScreen(AppScreen screen) =>
      evCompetitorType.skipGroupingOnMarketView;

  bool skipGroupingForName(String evNameSubStr) {
    return evTemplateName.toLowerCase().contains(evNameSubStr.toLowerCase()) ||
        evTemplateDescription
            .toLowerCase()
            .contains(evNameSubStr.toLowerCase());
  }

  // impl for JsonSerializable above
  factory TopEventCfg.fromJson(Map<String, dynamic> json) =>
      _$TopEventCfgFromJson(json);

  Map<String, dynamic> toJson() {
    return _$TopEventCfgToJson(this);
  }
}

@JsonSerializable()
class EventCfgTree {
  //
  TopEventCfg eventCfg;
  // area and slot level data filled below in fillFromVisualRuleAnswers
  Map<AppScreen, ScreenCfgByArea> screenConfigMap;

  EventCfgTree(
    this.eventCfg,
    this.screenConfigMap,
  );

  factory EventCfgTree.fromEventLevelConfig(Iterable<Question> responses) {
    //
    String evTemplateName = (responses
            .where((q) => q.questionId == QuestionIds.eventName)
            .first
            .response
            ?.answers ??
        '_eventNameMissing') as String;

    // declare Event level vals to be captured
    String evTemplateDescription = '';
    EvType evType = EvType.standard;
    EvCompetitorType evCompetitorType = EvCompetitorType.team;
    EvOpponentType evOpponentType = EvOpponentType.sameAsCompetitorType;
    EvDuration evDuration = EvDuration.oneGame;
    EvEliminationStrategy evEliminationType = EvEliminationStrategy.singleGame;
    bool applySameRowStyleToAllScreens = true;
    // use try to catch errs and allow easy debugging
    try {
      evTemplateDescription = (responses
              .where((q) => q.questionId == QuestionIds.eventDescrip)
              .first
              .response
              ?.answers ??
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

    final eventCfg = TopEventCfg(
      evTemplateName,
      evTemplateDescription,
      evType,
      evCompetitorType: evCompetitorType,
      evOpponentType: evOpponentType,
      evDuration: evDuration,
      evEliminationType: evEliminationType,
      // applySameRowStyleToAllScreens,
    );

    return EventCfgTree(eventCfg, {});
  }

  void setConfigFor(
    AppScreen scr,
    ScreenWidgetArea area,
    TvAreaRowStyle rowStyle,
  ) {
    //
    ScreenCfgByArea? screenCfg = screenConfigMap[scr];
    if (screenCfg == null) {
      screenCfg = ScreenCfgByArea(scr, {});
    }
    CfgForAreaAndNestedSlots? areaCfg = screenCfg.areaConfig[area];
    if (areaCfg == null) {
      areaCfg = CfgForAreaAndNestedSlots(area, {}, {});
      screenCfg.areaConfig[area] = areaCfg;
    }
    areaCfg.visCfgForArea[VisualRuleType.styleOrFormat] = SlotOrAreaRuleCfg(
      [TvRowStyleCfg.explicit(rowStyle)],
    );
  }

  void fillFromVisualRuleAnswers(
    Iterable<VisRuleStyleQuest> answeredQuestions,
  ) {
    /*  part of instance construction
      receive all vis-rule-questions, and fill
        out the tree of configuration data
        that will customize the client UI
    */
    print(
      'fillFromVisualRuleAnswers got ${answeredQuestions.length} answeredQuestions',
    );
    for (VisRuleStyleQuest rQuest in answeredQuestions) {
      // look up or create it
      ScreenCfgByArea screenCfg = this.screenConfigMap[rQuest.appScreen] ??
          ScreenCfgByArea(rQuest.appScreen, {});
      screenCfg.appendRule(rQuest);
      this.screenConfigMap[rQuest.appScreen] = screenCfg;
    }
  }

  void dumpCfgToFile(String? filename) {
    // write data out to file
    var fn = filename ?? eventCfg.evTemplateName;
    var outFile = File('st_ui_builder/assets/$fn.json');

    // set default vals before passing to encoder
    this._fillMissingWithDefaults();
    var jsonData = json.encode(this);
    outFile.writeAsStringSync(jsonData, mode: FileMode.write, flush: true);
    print('Config written (in JSON fmt) to ${outFile.path}');
    // outFile.close();
  }

  void _fillMissingWithDefaults() {
    // called automatically before conversion to JSON
    // fill out any missing rules with defaults
    // because its called on the create-json side
    // we dont need this on the load json side
    for (AppScreen as in AppScreen.eventConfiguration.topConfigurableScreens) {
      if (screenConfigMap.containsKey(as)) continue;
      screenConfigMap[as] = ScreenCfgByArea(as, {});
    }
    this.screenConfigMap.values.forEach((sc) => sc.fillMissingWithDefaults());
  }

  // impl for JsonSerializable above
  factory EventCfgTree.fromJson(Map<String, dynamic> json) =>
      _$EventCfgTreeFromJson(json);

  Map<String, dynamic> toJson() {
    // dont set defaults here
    return _$EventCfgTreeToJson(this);
  }
}

extension EventCfgTreeExt1 on EventCfgTree {
  // return the config data needed to provision the ST UI builder logic
  ScreenCfgByArea _fullScreenCfg(AppScreen screen) =>
      this.screenConfigMap[screen]!;

  bool get marketViewIsGameCentricAndTwoPerRow =>
      [EvCompetitorType.team, EvCompetitorType.teamPlayer]
          .contains(eventCfg.evCompetitorType) &&
      eventCfg.evOpponentType == EvOpponentType.sameAsCompetitorType;

  CfgForAreaAndNestedSlots screenAreaCfg(
    AppScreen screen,
    ScreenWidgetArea area,
  ) =>
      _fullScreenCfg(screen).configForArea(area);

  SortingRules? tvSortingRules(AppScreen screen) {
    //
    return screenAreaCfg(screen, ScreenWidgetArea.tableview).sortingRules;
  }

  FilterRules? tvFilteringRules(AppScreen screen) {
    //
    return screenAreaCfg(screen, ScreenWidgetArea.tableview).filterRules;
  }

  TvAreaRowStyle tableRowStyleFor(AppScreen screen) {
    //
    var xx = screenAreaCfg(screen, ScreenWidgetArea.tableview)
        .visCfgForArea[VisualRuleType.styleOrFormat]!;
    return xx.visRuleList
        .where((e) => e.ruleType == VisualRuleType.styleOrFormat)
        .first as TvAreaRowStyle;
  }
}
