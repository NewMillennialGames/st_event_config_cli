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
  print(
    'comparing "${questJustAnswered.questStr}" to ${_matcherList.length} matchers for new quests',
  );
  for (QuestMatcher matchTest in _matcherList) {
    if (matchTest.doesMatch(questJustAnswered)) {
      print(
        '*** it does match!!  addsPendingQuestions: ${matchTest.addsPendingQuestions}  createsImplicitAnswers: ${matchTest.createsImplicitAnswers}',
      );
      if (matchTest.addsPendingQuestions) {
        questListMgr.appendNewQuestions(
            matchTest.generatedQuestionsFor(questJustAnswered));
      }
      if (matchTest.createsImplicitAnswers) {
        questListMgr.addImplicitAnswers(
            matchTest.generatedQuestionsFor(questJustAnswered));
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
  final AddQuestChkCallbk validateUserAnswerAfterPatternMatchIsTrueCallback;
  // cascadeType indicates whether we add new questions, auto-answers or both
  final UserResponseCascadePatternEm? cascadeType;
  // pattern matching values;  leave null to not match on them
  final AppScreen? appScreen;
  final ScreenWidgetArea? screenWidgetArea;
  final ScreenAreaWidgetSlot? slotInArea;
  final VisualRuleType? visRuleTypeForAreaOrSlot;
  final BehaviorRuleType? behRuleTypeForAreaOrSlot;
  final bool isRuleQuestion;
  final String questionId;
  final DerivedQuestGenerator derQuestGen;
  late Type? typ = UserResponse<AnsType>;
  final String matcherDescrip;
  //
  QuestMatcher(
    this.matcherDescrip,
    this.matcherMatchBehavior,
    this.derQuestGen, {
    required this.validateUserAnswerAfterPatternMatchIsTrueCallback,
    this.cascadeType,
    this.questionId = '-na',
    this.appScreen,
    this.screenWidgetArea,
    this.slotInArea,
    this.visRuleTypeForAreaOrSlot,
    this.behRuleTypeForAreaOrSlot,
    this.isRuleQuestion = false,
  });

  // getters
  bool get addsPendingQuestions => matcherMatchBehavior.addsPendingQuestions;
  bool get createsImplicitAnswers =>
      matcherMatchBehavior.createsImplicitAnswers;

  // public methods
  List<Question> generatedQuestionsFor(Question quest) =>
      derQuestGen.generatedQuestions(quest, this);

  bool doesMatch(Question quest) {
    bool isAPatternMatch =
        quest.questionId == this.questionId || _doDeeperMatch(quest);
    // pattern doesnt match so exit early
    if (!isAPatternMatch) return false;

    // pattern match succeeded, so now validate user answer
    bool userRespValueIsAMatch =
        validateUserAnswerAfterPatternMatchIsTrueCallback(
            quest.response!.answers!);
    isAPatternMatch = isAPatternMatch && userRespValueIsAMatch;
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
  // based on answers to prior questions

  QuestMatcher<int>(
    'if user wants to perform grouping on a ListView, ask how many grouping cols are required & add a question for each',
    MatcherBehaviorEnum.addPendingQuestions,
    DerivedQuestGenerator(
      'Select field #{0} to use for row-grouping on {1} screen',
      newQuestCountCalculator: (q) => (q.response?.answers ?? 0) as int,
      newQuestArgGen: (quest, idx) =>
          <String>['${idx + 1}', quest.appScreen.name],
      perQuestGenOptions: [
        PerQuestGenOptions(
          answerChoices: DbTableFieldName.values.map((e) => e.name),
          castFunc: (ansr) => DbTableFieldName
              .values[int.tryParse(ansr) ?? CfgConst.cancelSortIndex],
          qQuantRev: (qq) => qq.copyWith(),
        ),
      ],
    ),

    cascadeType: UserResponseCascadePatternEm.addsRuleDetailQuestsForSlotOrArea,
    screenWidgetArea: ScreenWidgetArea.tableview,
    visRuleTypeForAreaOrSlot: VisualRuleType.groupCfg,
    // if existing question is for grouping on ListView
    // make sure user said YES (they want grouping)
    validateUserAnswerAfterPatternMatchIsTrueCallback: (ans) =>
        (int.tryParse(ans as String) ?? 0) > 0,
    isRuleQuestion: false,
  ),
];
