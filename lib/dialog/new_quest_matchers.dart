part of ConfigDialogRunner;

// top level function to add new questions or implicit answers
void appendNewQuestsOrInsertImplicitAnswers(QuestListMgr questListMgr) {
  //
  Question questJustAnswered = questListMgr._currentOrLastQuestion;

  for (QuestMatcher matchTest in _matcherList) {
    if (matchTest.doesMatch(questJustAnswered)) {
      if (matchTest.addsPendingQuestions) {
        questListMgr.appendNewQuestions(matchTest.pendingQuests);
      }
      if (matchTest.createsImplicitAnswers) {
        questListMgr.addImplicitAnswers(matchTest._answeredQuests);
      }
    }
  }
}

enum MatcherBehaviorEnum {
  addPendingQuestions,
  addImplicitAnswers,
  addQuestsAndAnswers, // aka BOTH
}

extension MatcherBehaviorEnumExt1 on MatcherBehaviorEnum {
  //
  bool get addsPendingQuestions => [
        MatcherBehaviorEnum.addPendingQuestions,
        MatcherBehaviorEnum.addQuestsAndAnswers
      ].contains(this);

  bool get createsImplicitAnswers => [
        MatcherBehaviorEnum.addImplicitAnswers,
        MatcherBehaviorEnum.addQuestsAndAnswers
      ].contains(this);
}

class QuestMatcher<AnsType> {
  /*
  define all properties a matcher may need to eval
  in order to verify it's a match

  */
  final MatcherBehaviorEnum matcherBehavior;
  // AddQuestChkCallbk is for doing more advanced analysis to verify a match
  final AddQuestChkCallbk addQuestChkCallbk;
  final QuestCascadeTypEnum? cascadeType;
  final AppScreen? appScreen;
  final ScreenWidgetArea? screenWidgetArea;
  final ScreenAreaWidgetSlot? slotInArea;
  final VisualRuleType? visRuleTypeForAreaOrSlot;
  final BehaviorRuleType? behRuleTypeForAreaOrSlot;
  final bool isRuleQuestion;
  final String questionId;
  Type? typ = UserResponse<AnsType>;
  //
  List<Question> pendingQuests = [];
  List<Question> _answeredQuests = [];

  QuestMatcher(
    this.matcherBehavior,
    this.addQuestChkCallbk, {
    this.cascadeType,
    this.questionId = '-na',
    this.appScreen,
    this.screenWidgetArea,
    this.slotInArea,
    this.visRuleTypeForAreaOrSlot,
    this.behRuleTypeForAreaOrSlot,
    this.isRuleQuestion = false,
    this.pendingQuests = const [],
  });

  // getters
  bool get addsPendingQuestions => matcherBehavior.addsPendingQuestions;
  bool get createsImplicitAnswers => matcherBehavior.createsImplicitAnswers;

  bool doesMatch(Question quest) {
    bool dMatch = quest.questionId == this.questionId || _doDeeperMatch(quest);

    if (dMatch && addQuestChkCallbk(quest.response!.answers!)) {
      // it was a mach and answer value indicates that
      // new questions /answers SHOULD be created
      if (this.addsPendingQuestions) {
        pendingQuests.addAll(
          DerivedQuestions.pendingQuestsFromAnswer(
            quest,
          ),
        );
      }
      if (this.createsImplicitAnswers) {
        _answeredQuests.addAll(
          DerivedQuestions.impliedAnswersFromAnswer(
            quest,
          ),
        );
      }
    }
    return dMatch;
  }

  bool _doDeeperMatch(Question quest) {
    // compare all properties instead of only questionId
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

    // dMatch =
    //     dMatch && (this.typ == null || quest.response.runtimeType == this.typ);
    return dMatch;
  }
}

List<QuestMatcher> _matcherList = [
  // defines rules for adding new questions or implicit answers
  QuestMatcher<int>(
    // question asking about 1st selected row-style being global
    MatcherBehaviorEnum.addPendingQuestions,
    (ans) => true,
    questionId: QuestionIds.globalRowStyle,
  ),
  QuestMatcher<bool>(
    // question asking about 1st selected row-style being global
    MatcherBehaviorEnum.addImplicitAnswers,
    (_) => true,
    cascadeType: QuestCascadeTypEnum.addsRuleDetailQuestsForSlotOrArea,
    visRuleTypeForAreaOrSlot: VisualRuleType.groupCfg,
    screenWidgetArea: ScreenWidgetArea.tableview,
  ),
];
