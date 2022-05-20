part of ConfigDialogRunner;

/*  Questions about ListView area (aka TableView)
  sorting, grouping or filtering pose a new requirement
  we need to know HOW MANY (from 0-3) fields they want to specify
  under that respective rule

  for example, under grouping, if they say 2, then we should add 2 Quest2s
  to let them specify the grouping-key (some asset field/property)

*/

// top level function to add new Questions or implicit answers
void appendNewQuestsOrInsertImplicitAnswers(QuestListMgr questListMgr) {
  //
  QuestBase questJustAnswered = questListMgr._currentOrLastQuestion;
  print(
    'comparing "${questJustAnswered.questId}" to ${_matcherList.length} matchers for new quests',
  );
  for (QuestMatcher matchTest in _matcherList) {
    if (matchTest.doesMatch(questJustAnswered)) {
      print(
        '*** it does match!!  addsPendingQuestions: ${matchTest.addsPendingQuestions}  createsImplicitAnswers: ${matchTest.createsImplicitAnswers}',
      );
      if (matchTest.addsPendingQuestions) {
        List<QuestBase> newQuests =
            matchTest.generatedQuestionsFor(questJustAnswered);
        questListMgr.appendNewQuestions(newQuests);
      }
      if (matchTest.createsImplicitAnswers) {
        questListMgr.addImplicitAnswers(
          matchTest.generatedQuestionsFor(questJustAnswered),
        );
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
  // cascadeType indicates whether we add new Quest2s, auto-answers or both
  final QRespCascadePatternEm? cascadeType;
  // pattern matching values;  leave null to not match on them
  final AppScreen? appScreen;
  final ScreenWidgetArea? screenWidgetArea;
  final ScreenAreaWidgetSlot? slotInArea;
  final VisualRuleType? visRuleTypeForAreaOrSlot;
  final BehaviorRuleType? behRuleTypeForAreaOrSlot;
  final bool isRuleQuest2;
  final String questId;
  final DerivedQuestGenerator derQuestGen;
  late Type? typ = CaptureAndCast<AnsType>;
  final String matcherDescrip;
  //
  QuestMatcher(
    this.matcherDescrip,
    this.matcherMatchBehavior,
    this.derQuestGen, {
    required this.validateUserAnswerAfterPatternMatchIsTrueCallback,
    this.cascadeType,
    this.questId = '-na',
    this.appScreen,
    this.screenWidgetArea,
    this.slotInArea,
    this.visRuleTypeForAreaOrSlot,
    this.behRuleTypeForAreaOrSlot,
    this.isRuleQuest2 = false,
  });

  // getters
  bool get addsPendingQuestions => matcherMatchBehavior.addsPendingQuestions;
  bool get createsImplicitAnswers =>
      matcherMatchBehavior.createsImplicitAnswers;

  // public methods
  List<QuestBase> generatedQuestionsFor(QuestBase quest) =>
      derQuestGen.generatedQuestions(quest, this);

  bool doesMatch(QuestBase quest) {
    bool isAPatternMatch =
        quest.questId == this.questId || _doDeeperMatch(quest);
    // pattern doesnt match so exit early
    if (!isAPatternMatch) return false;

    // pattern match succeeded, so now validate user answer
    bool userRespValueIsAMatch =
        validateUserAnswerAfterPatternMatchIsTrueCallback(quest.mainAnswer);
    isAPatternMatch = isAPatternMatch && userRespValueIsAMatch;
    return isAPatternMatch;
  }

  bool _doDeeperMatch(QuestBase quest) {
    // compare all properties instead of only Quest2Id
    bool dMatch = true;
    dMatch = dMatch &&
        (this.cascadeType == null ||
            this.cascadeType == quest.qTargetIntent.cascadeType);
    print('Cascade matches: $dMatch');
    dMatch =
        dMatch && (this.appScreen == null || this.appScreen == quest.appScreen);
    print('appScreen matches: $dMatch');

    dMatch = dMatch &&
        (this.screenWidgetArea == null ||
            this.screenWidgetArea == quest.screenWidgetArea);
    print('screenWidgetArea matches: $dMatch');

    dMatch = dMatch &&
        (this.slotInArea == null || this.slotInArea == quest.slotInArea);
    print('slotInArea matches: $dMatch');

    dMatch = dMatch &&
        (this.visRuleTypeForAreaOrSlot == null ||
            this.visRuleTypeForAreaOrSlot == quest.visRuleTypeForAreaOrSlot);
    print('visRuleTypeForAreaOrSlot matches: $dMatch');

    // dMatch = dMatch &&
    //     (this.behRuleTypeForAreaOrSlot == null ||
    //         this.behRuleTypeForAreaOrSlot == quest.behRuleTypeForAreaOrSlot);
    // print('behRuleTypeForAreaOrSlot matches: $dMatch');

    dMatch = dMatch &&
        (this.isRuleQuest2 == false || quest.appliesToClientConfiguration);
    print('isRuleQuest2 matches: $dMatch');

    // dMatch =
    //     dMatch && (this.typ == null || quest.response.runtimeType == this.typ);
    return dMatch;
  }
}

List<QuestMatcher> _matcherList = [
  // defines rules for adding new Questions or implicit answers
  // based on answers to prior Questions

  QuestMatcher<int>(
    'if user wants to perform grouping on a ListView, ask how many grouping cols are required & add a Questions for each',
    MatcherBehaviorEnum.addPendingQuestions,
    DerivedQuestGenerator(
      'Select field #{0} to use for row-grouping on {1} screen',
      newQuestCountCalculator: (q) => (q.mainAnswer) as int,
      newQuestArgGen: (quest, idx) =>
          <String>['${idx + 1}', quest.appScreen.name],
      perQuestGenOptions: [
        PerQuestGenOptions(
          answerChoices: DbTableFieldName.values.map((e) => e.name),
          castFunc: (ansr) => DbTableFieldName
              .values[int.tryParse(ansr) ?? CfgConst.cancelSortIndex],
          qTargetIntentUpdaterArg: (qq, _) =>
              qq.copyWith(visRuleTypeForAreaOrSlot: VisualRuleType.groupCfg),
          ruleType: VisualRuleType.groupCfg,
          ruleQuestType: VisRuleQuestType.selectDataFieldName,
        ),
      ],
    ),

    cascadeType: QRespCascadePatternEm.addsRuleDetailQuestsForSlotOrArea,
    screenWidgetArea: ScreenWidgetArea.tableview,
    visRuleTypeForAreaOrSlot: VisualRuleType.groupCfg,
    // if existing Quest2 is for grouping on ListView
    // make sure user said YES (they want grouping)
    validateUserAnswerAfterPatternMatchIsTrueCallback: (ans) => (ans ?? 0) > 0,
    isRuleQuest2: false,
  ),
];
