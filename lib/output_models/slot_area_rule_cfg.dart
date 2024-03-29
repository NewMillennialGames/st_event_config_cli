part of OutputModels;

@JsonSerializable()
class SlotOrAreaRuleCfg {
  /*
    this class holds rule definitions
    defined at the area or slot level
    these recs are always grouped by rule-type
    and area/slot to which they apply

    parent container (collection of these instances)
    is how you know scope (area or slot) for "this"
  */
  List<RuleResponseBase> visRuleList;
  //
  SlotOrAreaRuleCfg(
    this.visRuleList,
  );

  List<RuleResponseBase> rulesOfVRType(VisualRuleType rt) =>
      visRuleList.where((rr) => rr.ruleType == rt).toList();

  RuleResponseBase? ruleForObjType(Type objTyp) {
    // not tested
    // bool isTp = isSubtype<objTyp.runtimeType, RuleResponseBase>();
    // assert(objTyp is RuleResponseBase, 'invalid arg');

    Iterable<RuleResponseBase> matchLst =
        visRuleList.where((rr) => rr.runtimeType == objTyp);
    return matchLst.length < 1 ? null : matchLst.first;
  }

  Iterable<VisualRuleType> get existingAnsweredRuleTypes =>
      visRuleList.map((e) => e.ruleType);

  void appendQuestion(VisualRuleDetailQuest rQuest) {
    // ConfigLogger.log(Level.FINER,'adding QuestVisualRule abt ${rQuest.firstPrompt.userPrompt} to SlotOrAreaRuleCfg on ${rQuest.appScreen.name}');
    if (visRuleList.length > 0) {
      // assert(
      //     rQuest.screenWidgetArea == visRuleList.first.requiredQuestions.first.,
      //     '');
    }
    this.visRuleList.add(rQuest.asVisRuleResponse);
  }

  void fillMissingWithDefaults(
    AppScreen appScreen,
    ScreenWidgetArea screenArea,
    ScreenAreaWidgetSlot? optSlot,
  ) {
    /* walk through existing responses for this VisualRuleType
        and add any that are missing

        TODO:  fixme
    */

    List<VisualRuleType> _rulesForWhichWeWantAnswers = [];
    if (optSlot != null) {
      // this is a slot container
      _rulesForWhichWeWantAnswers = optSlot.possibleConfigRules(screenArea);
    } else {
      // this is an area container
      _rulesForWhichWeWantAnswers = screenArea.applicableRuleTypes(appScreen);
    }
    List<VisRuleQuestType> _questsForWhichWeWantAnswers = [];
    for (VisualRuleType rt in _rulesForWhichWeWantAnswers) {
      _questsForWhichWeWantAnswers.addAll(rt.requRuleDetailCfgQuests);
    }

    var expectedResponses = Set<VisRuleQuestType>();
    existingAnsweredRuleTypes.forEach((e) {
      // get list of all needed VisRuleQuestType
      expectedResponses.addAll(e.requRuleDetailCfgQuests);
    });

    Iterable<List<VisRuleQuestType>> answerTypesSoFar =
        visRuleList.map((e) => e.requiredQuestions);
    List<VisRuleQuestType> lstVrqt = [];
    if (answerTypesSoFar.length > 0) {
      lstVrqt = answerTypesSoFar
          .reduce((finalLst, lsVals) => finalLst..addAll(lsVals));
    }
    var _answeredQuestsAsSet = Set<VisRuleQuestType>.from(lstVrqt);
    // make sure we have at least 1 answer for every expected answer
    assert(
      expectedResponses.difference(_answeredQuestsAsSet).length < 1,
      'wtf',
    );

    Set<VisRuleQuestType> existingResponses = Set<VisRuleQuestType>()
      ..addAll(lstVrqt);

    Set<VisRuleQuestType> missingResponses =
        expectedResponses.difference(existingResponses);
    if (missingResponses.length < 1) return;

    var answerBuilder = DefaultAnswerBuilder.forMissingAreaOrSlot(
      appScreen,
      screenArea,
      optSlot,
      missingResponses,
    );
    visRuleList.addAll(answerBuilder.defaultAnswers);
  }

  void printSummary(dynamic slotOrArea, {String padding = '  '}) {
    //
    bool isAreaRule = slotOrArea is ScreenWidgetArea;
    String targetScope = isAreaRule ? 'AREA' : 'SLOT';
    String targetName = isAreaRule
        ? (slotOrArea as ScreenWidgetArea).name.toUpperCase()
        : (slotOrArea as ScreenAreaWidgetSlot).name.toUpperCase();

    ConfigLogger.log(Level.INFO, padding + '$targetName $targetScope RuleCfg:');
    for (RuleResponseBase rrb in visRuleList) {
      //
      // String cfgRuleTypeName = rrb.runtimeType.toString();
      // ConfigLogger.log(Level.FINER,'\t$cfgRuleTypeName has:');
      ConfigLogger.log(Level.INFO, padding + padding + '$rrb');
    }
  }

  // JsonSerializable
  factory SlotOrAreaRuleCfg.fromJson(Map<String, dynamic> json) =>
      _$SlotOrAreaRuleCfgFromJson(json);

  Map<String, dynamic> toJson() => _$SlotOrAreaRuleCfgToJson(this);
}
