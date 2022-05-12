part of ConfigDialogRunner;

/*  Quest2s about ListView area (aka TableView)
  sorting, grouping or filtering pose a new requirement
  we need to know HOW MANY (from 0-3) fields they want to specify
  under that respective rule

  for example, under grouping, if they say 2, then we should add 2 Quest2s
  to let them specify the grouping-key (some asset field/property)

*/

// top level function to add new Quest2s or implicit answers
void appendNewQuestsOrInsertImplicitAnswers(QuestListMgr questListMgr) {
  //
  Quest2 questJustAnswered = questListMgr._currentOrLastQuest2;
  print(
    'comparing "${questJustAnswered.questId}" to ${_matcherList.length} matchers for new quests',
  );
  for (QuestMatcher matchTest in _matcherList) {
    if (matchTest.doesMatch(questJustAnswered)) {
      print(
        '*** it does match!!  addsPendingQuest2s: ${matchTest.addsPendingQuest2s}  createsImplicitAnswers: ${matchTest.createsImplicitAnswers}',
      );
      if (matchTest.addsPendingQuest2s) {
        questListMgr
            .appendNewQuest2s(matchTest.generatedQuest2sFor(questJustAnswered));
      }
      if (matchTest.createsImplicitAnswers) {
        questListMgr.addImplicitAnswers(
            matchTest.generatedQuest2sFor(questJustAnswered));
      }
    }
  }
}

enum MatcherBehaviorEnum {
  addPendingQuest2s,
  addImplicitAnswers,
  addQuestsAndAnswers, // aka BOTH
}

extension MatcherBehaviorEnumExt1 on MatcherBehaviorEnum {
  //
  bool get addsPendingQuest2s => [
        MatcherBehaviorEnum.addPendingQuest2s,
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
  late Type? typ = UserResponse<AnsType>;
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
  bool get addsPendingQuest2s => matcherMatchBehavior.addsPendingQuest2s;
  bool get createsImplicitAnswers =>
      matcherMatchBehavior.createsImplicitAnswers;

  // public methods
  List<Quest2> generatedQuest2sFor(Quest2 quest) =>
      derQuestGen.generatedQuest2s(quest, this);

  bool doesMatch(Quest2 quest) {
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

  bool _doDeeperMatch(Quest2 quest) {
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
  // defines rules for adding new Quest2s or implicit answers
  // based on answers to prior Quest2s

  QuestMatcher<int>(
    'if user wants to perform grouping on a ListView, ask how many grouping cols are required & add a Quest2 for each',
    MatcherBehaviorEnum.addPendingQuest2s,
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
          qQuantRev: (qq) =>
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
