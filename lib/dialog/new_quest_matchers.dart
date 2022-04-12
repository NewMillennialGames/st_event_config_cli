part of ConfigDialogRunner;

/*  questions about ListView area (aka TableView)
  sorting, grouping or filtering pose a new requirement
  we need to know HOW MANY (from 0-3) fields they want to specify
  under that respective rule

  for example, under grouping, if they say 2, then we should add 2 questions
  to let them specify the grouping-key (some asset field/property)
  
*/

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
        questListMgr.addImplicitAnswers(matchTest.answeredQuests);
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
  final MatcherBehaviorEnum matcherMatchBehavior;
  // AddQuestChkCallbk is for doing more advanced analysis to verify a match
  final AddQuestChkCallbk chkAnswAfterMatchTrueCallback;
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
  List<Question> answeredQuests = [];

  QuestMatcher(
    this.matcherMatchBehavior,
    this.chkAnswAfterMatchTrueCallback, {
    this.cascadeType,
    this.questionId = '-na',
    this.appScreen,
    this.screenWidgetArea,
    this.slotInArea,
    this.visRuleTypeForAreaOrSlot,
    this.behRuleTypeForAreaOrSlot,
    this.isRuleQuestion = false,
    List<Question>? pendingQuests,
    List<Question>? answeredQuests,
  })  : this.pendingQuests = pendingQuests ?? [],
        this.answeredQuests = answeredQuests ?? [];

  // getters
  bool get addsPendingQuestions => matcherMatchBehavior.addsPendingQuestions;
  bool get createsImplicitAnswers =>
      matcherMatchBehavior.createsImplicitAnswers;

  bool doesMatch(Question quest) {
    bool isAPatternMatch =
        quest.questionId == this.questionId || _doDeeperMatch(quest);
    // doesnt match so exit early
    if (!isAPatternMatch) return isAPatternMatch;

    // bool userResponseIsAMatch = true;
    // if (quest.response!.answers! is RuleResponseWrapperIfc) {
    //   userResponseIsAMatch = addQuestChkCallbk(quest.response!.answers!);
    // } else {
    //   userResponseIsAMatch = addQuestChkCallbk(quest.response!.answers!);
    // }
    bool userRespValueIsAMatch =
        chkAnswAfterMatchTrueCallback(quest.response!.answers!);
    isAPatternMatch = isAPatternMatch && userRespValueIsAMatch;
    // if (isAPatternMatch && userRespValueIsAMatch) {
    //   // it was a mach and answer value indicates that
    //   // new questions /answers SHOULD be created
    //   if (this.addsPendingQuestions) {
    //     pendingQuests.addAll(
    //       DerivedQuestions.pendingQuestsFromAnswer(
    //         quest,
    //       ),
    //     );
    //   }
    //   if (this.createsImplicitAnswers) {
    //     answeredQuests.addAll(
    //       DerivedQuestions.impliedAnswersFromAnswer(
    //         quest,
    //       ),
    //     );
    //   }
    // }
    return isAPatternMatch;
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

  QuestMatcher<bool>(
    // if user wants to perform grouping on a ListView
    // lets ask how many grouping positions are reqired
    MatcherBehaviorEnum.addPendingQuestions,
    (ans) => (int.tryParse(ans as String) ?? 0) > 0,
    cascadeType: QuestCascadeTypEnum.addsRuleDetailQuestsForSlotOrArea,
    screenWidgetArea: ScreenWidgetArea.tableview,
    visRuleTypeForAreaOrSlot: VisualRuleType.groupCfg,
    pendingQuests: [],
  ),
];
