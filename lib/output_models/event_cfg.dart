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
  EvGameAgeOffRule evGameAgeOffRule;
  bool applySameRowStyleToAllScreens = true;

  TopEventCfg(
    this.evTemplateName,
    this.evTemplateDescription,
    this.evType, {
    this.evCompetitorType = EvCompetitorType.team,
    this.evOpponentType = EvOpponentType.sameAsCompetitorType,
    this.evDuration = EvDuration.oneGame,
    this.evEliminationType = EvEliminationStrategy.roundRobin,
    this.evGameAgeOffRule = EvGameAgeOffRule.byEvEliminationStrategy,
    this.applySameRowStyleToAllScreens = true,
  });

  bool skipGroupingOnScreen(AppScreen screen) {
    assert(
      screen == AppScreen.marketView,
      'currently only works for marketview',
    );
    return evCompetitorType.skipGroupingOnMarketView;
  }

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

  factory EventCfgTree.fromEventLevelConfig(
      Iterable<EventLevelCfgQuest> evCfgResponses) {
    //
    EventLevelCfgQuest evTemplateQuest = evCfgResponses
        .firstWhere((q) => q.questId == QuestionIdStrings.eventName);

    // if (evTemplateQuest == null)
    //   throw UnimplementedError('top level question missing');

    String evTemplateName =
        (evTemplateQuest.mainAnswer ?? '_eventNameMissing') as String;

    // declare Event level vals to be captured
    String evTemplateDescription = '';
    EvType evType = EvType.standard;
    EvCompetitorType evCompetitorType = EvCompetitorType.team;
    EvOpponentType evOpponentType = EvOpponentType.sameAsCompetitorType;
    EvDuration evDuration = EvDuration.oneGame;
    EvEliminationStrategy evEliminationType = EvEliminationStrategy.singleGame;
    EvGameAgeOffRule evGameAgeOffRule =
        EvGameAgeOffRule.byEvEliminationStrategy;
    bool applySameRowStyleToAllScreens = true;
    // use try to catch errs and allow easy debugging
    try {
      evTemplateDescription = (evCfgResponses
              .firstWhere((q) => q.questId == QuestionIdStrings.eventDescrip)
              .mainAnswer ??
          '') as String;

      evType = evCfgResponses
          .firstWhere((q) => q.mainAnswer is EvType)
          .mainAnswer as EvType;
      //
      evCompetitorType = evCfgResponses
          .firstWhere((q) => q.mainAnswer is EvCompetitorType)
          .mainAnswer as EvCompetitorType;
      evOpponentType = evCfgResponses
          .firstWhere((q) => q.mainAnswer is EvOpponentType)
          .mainAnswer as EvOpponentType;
      evDuration = evCfgResponses
          .firstWhere((q) => q.mainAnswer is EvDuration)
          .mainAnswer as EvDuration;
      evEliminationType = evCfgResponses
          .firstWhere((q) => q.mainAnswer is EvEliminationStrategy)
          .mainAnswer as EvEliminationStrategy;
      // tells app how to age-off finished games
      evGameAgeOffRule = evCfgResponses
          .firstWhere((q) => q.mainAnswer is EvGameAgeOffRule)
          .mainAnswer as EvGameAgeOffRule;
      applySameRowStyleToAllScreens = evCfgResponses
          .firstWhere((q) => q.questId == QuestionIdStrings.globalRowStyle)
          .mainAnswer as bool;
    } catch (e) {
      print(
        'Warnnig:  key Event level quests/fields missing.  Hope you are debugging testing',
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
      evGameAgeOffRule: evGameAgeOffRule,
      applySameRowStyleToAllScreens: applySameRowStyleToAllScreens,
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
    Iterable<VisualRuleDetailQuest> answeredQuestions,
  ) {
    /*  part of instance construction
      receive all vis-rule-Quest2s, and fill
        out the tree of configuration data
        that will customize the client UI
    */
    // print(
    //   'fillFromVisualRuleAnswers got ${answeredQuestions.length} answeredQuestions',
    // );
    for (VisualRuleDetailQuest vrQuest in answeredQuestions) {
      // look up or create config for this screen;  top of tree
      ScreenCfgByArea screenCfg = this.screenConfigMap[vrQuest.appScreen] ??
          ScreenCfgByArea(vrQuest.appScreen, {});
      screenCfg.appendVisRule(vrQuest);
      // store when newly created above
      this.screenConfigMap[vrQuest.appScreen] = screenCfg;
    }
  }

  void dumpCfgToFile(String? filename) {
    // write data out to file
    var fn = filename ?? eventCfg.evTemplateName;
    var outFile = File('st_ui_builder/assets/$fn.json');

    // set default vals before passing to encoder
    this._fillMissingWithDefaults();

    // try {
    String jsonData = json.encode(this);
    outFile.writeAsStringSync(jsonData, mode: FileMode.write, flush: true);
    print('Config written (in JSON fmt) to ${outFile.path}');
    // } catch (e) {
    //   print(e.toString());
    // }
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

  void printSummary() {
    print('EventCfgTree for: ${eventCfg.evTemplateName}\n');
    for (MapEntry<AppScreen, ScreenCfgByArea> screenCfg
        in screenConfigMap.entries) {
      //
      print('\tScreen: ${screenCfg.key.name}:');
      for (MapEntry<ScreenWidgetArea, CfgForAreaAndNestedSlots> areaCfg
          in screenCfg.value.areaConfig.entries) {
        //
        print('\t\tArea: ${areaCfg.key.name}\n');
        for (MapEntry<VisualRuleType, SlotOrAreaRuleCfg> ruleCfg
            in areaCfg.value.visCfgForArea.entries) {
          // print('\t\t\tVRT: ${ruleCfg.key.name}\n');
          ruleCfg.value.printSummary(areaCfg.key);
          print('\t\tSlots under Area: ${areaCfg.key.name}');
          _printSlotsInAreaWithRuleCfg(areaCfg);
        }
      }
    }
  }

  void _printSlotsInAreaWithRuleCfg(
    MapEntry<ScreenWidgetArea, CfgForAreaAndNestedSlots> areaCfg,
  ) {
    for (MapEntry<VisualRuleType,
            Map<ScreenAreaWidgetSlot, SlotOrAreaRuleCfg>> vrtWithSlotCfg
        in areaCfg.value.visCfgForSlotsByRuleType.entries) {
      // print('\n\t\t\tSlot VRT:  ${vrtWithSlotCfg.key.name}');
      for (MapEntry<ScreenAreaWidgetSlot, SlotOrAreaRuleCfg> bySlotCfg
          in vrtWithSlotCfg.value.entries) {
        print(
          '\t\tSlot: ${bySlotCfg.key.name} under VRT ${vrtWithSlotCfg.key.name}',
        );
        for (RuleResponseBase rrb in bySlotCfg.value.visRuleList) {
          print('\t\t\t' + rrb.toString());
        }
      }
    }
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

  GroupingRules? tvGroupingRules(AppScreen screen) {
    //
    return screenAreaCfg(screen, ScreenWidgetArea.tableview).groupingRules;
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
