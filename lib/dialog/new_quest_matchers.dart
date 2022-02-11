part of ConfigDialogRunner;

void appendNewQuestsOrInsertImplicitAnswers(
  QuestListMgr questListMgr,
  Question questJustAnswered,
) {
  //
  // Question questJustAnswered = questListMgr._currentOrLastQuestion;

  for (QuestMatcher matchTest in _matcherList) {
    if (matchTest.doesMatch(questJustAnswered)) {
      if (matchTest.addsPendingQuestions) {
        questListMgr.appendNewQuestions(matchTest._pendingQuests);
      }
      if (matchTest.createsImplicitAnswers) {
        questListMgr.addImplicitAnswers(matchTest._answeredQuests);
      }
    }
  }
}

enum MatcherBehavior {
  addPendingQuestions,
  addImplicitAnswers,
  addQuestsAndAnswers, // aka BOTH
}

class QuestMatcher<AnsType> {
  //
  final MatcherBehavior matcherBehavior;
  final AddQuestChkCallbk addQuestChkCallbk;
  final QuestCascadeTyp? cascadeType;
  final AppScreen? appScreen;
  final ScreenWidgetArea? screenWidgetArea;
  final ScreenAreaWidgetSlot? slotInArea;
  final VisualRuleType? visRuleTypeForAreaOrSlot;
  final BehaviorRuleType? behRuleTypeForAreaOrSlot;
  final bool isRuleQuestion;
  Type? typ = UserResponse<String>;
  //
  List<VisualRuleQuestion> _pendingQuests = [];
  List<VisualRuleQuestion> _answeredQuests = [];

  QuestMatcher(
    this.matcherBehavior,
    this.addQuestChkCallbk,
    this.cascadeType, {
    this.appScreen,
    this.screenWidgetArea,
    this.slotInArea,
    this.visRuleTypeForAreaOrSlot,
    this.behRuleTypeForAreaOrSlot,
    this.isRuleQuestion = false,
    this.typ,
    // this.quests,
  });

  // getters
  bool get addsPendingQuestions => [
        MatcherBehavior.addPendingQuestions,
        MatcherBehavior.addQuestsAndAnswers
      ].contains(matcherBehavior);
  bool get createsImplicitAnswers => [
        MatcherBehavior.addImplicitAnswers,
        MatcherBehavior.addQuestsAndAnswers
      ].contains(matcherBehavior);

  bool doesMatch(Question quest) {
    bool dMatch = true;
    dMatch = dMatch &&
        (this.cascadeType == null ||
            this.cascadeType == quest.qQuantify.cascadeType);

    dMatch =
        dMatch && (this.appScreen == null || this.appScreen == quest.appScreen);

    dMatch = dMatch &&
        (this.screenWidgetArea == null ||
            this.screenWidgetArea == quest.screenWidgetArea);

    dMatch = dMatch &&
        (this.slotInArea == null || this.slotInArea == quest.slotInArea);

    dMatch = dMatch &&
        (this.visRuleTypeForAreaOrSlot == null ||
            this.visRuleTypeForAreaOrSlot == quest.visRuleTypeForAreaOrSlot);

    dMatch = dMatch &&
        (this.behRuleTypeForAreaOrSlot == null ||
            this.behRuleTypeForAreaOrSlot == quest.behRuleTypeForAreaOrSlot);

    dMatch = dMatch &&
        (this.isRuleQuestion == false || quest.isRuleQuestion == true);

    dMatch =
        dMatch && (this.typ == null || quest.response.runtimeType == this.typ);

    if (dMatch && addQuestChkCallbk(quest.response!.answers!)) {
      // it was a mach and answer value indicates that
      // new questions /answers SHOULD be created
      if (this.addsPendingQuestions) {
        _createNewQuestAfterDoesMatch(quest);
      }
      if (this.createsImplicitAnswers) {
        _createImplicitAnswersAfterDoesMatch(quest);
      }
    }
    return dMatch;
  }

  List<VisualRuleType> _subRuleQuests(Question quest) {
    //
    // List<VisualRuleType> lstVr = [];
    // return lstVr;
    return quest.qQuantify.relatedSubVisualRules(quest);
  }

  void _createNewQuestAfterDoesMatch(Question quest) {
    //
    // int qId = quest.questionId;

    for (VisualRuleType rt in _subRuleQuests(quest)) {
      var q = VisualRuleQuestion<String, RuleResponseWrapperIfc>(
        quest.appScreen,
        quest.screenWidgetArea!,
        rt,
        quest.slotInArea,
      );
      _pendingQuests.add(q);
    }
  }

  void _createImplicitAnswersAfterDoesMatch(Question quest) {
    //
    for (VisualRuleType rt in _subRuleQuests(quest)) {
      var q = VisualRuleQuestion<String, RuleResponseWrapperIfc>(
        quest.appScreen,
        quest.screenWidgetArea!,
        rt,
        quest.slotInArea,
      );
      _answeredQuests.add(q);
    }
  }
}

List<QuestMatcher> _matcherList = [
  // defines rules for adding new questions or implicit answers
  QuestMatcher<bool>(
    // question asking about 1st selected row-style being global
    MatcherBehavior.addImplicitAnswers,
    (_) => true,
    QuestCascadeTyp.noCascade,
    appScreen: AppScreen.eventConfiguration,
  ),
  QuestMatcher<bool>(
    // question asking about 1st selected row-style being global
    MatcherBehavior.addImplicitAnswers,
    (_) => true,
    QuestCascadeTyp.noCascade,
    appScreen: AppScreen.eventConfiguration,
    screenWidgetArea: ScreenWidgetArea.tableview,
    visRuleTypeForAreaOrSlot: VisualRuleType.sortCfg,
  ),
];
