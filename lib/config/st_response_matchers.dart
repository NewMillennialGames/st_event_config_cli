part of EvCfgConfig;

/*  this file contains the matcher definitions to produce:
      1. further questions
      2. implicit answers
    from the intial configurator questions

this config should drive the whole dynamic
dialog
*/

List<QuestMatcher> stDfltMatcherList = [
  // defines rules for adding new Questions or implicit answers
  // based on answers to prior Questions

  QuestMatcher<List<ScreenWidgetArea>>(
    'build ?`s to specify configured areas on selected screens',
    MatcherBehaviorEnum.addPendingQuestions,
    DerivedQuestGenerator(
      'Select areas to configure on screen {0}',
      newQuestCountCalculator: (QuestBase priorAnsweredQuest) {
        return (priorAnsweredQuest.mainAnswer as List<AppScreen>).length;
      },
      newQuestPromptArgGen: (QuestBase priorAnsweredQuest, int idx) {
        return [(priorAnsweredQuest.mainAnswer as List<AppScreen>)[idx].name];
      },
      answerChoiceGenerator: ((dynamic priorAnswer, int idx) {
        var selectedAppScreens = priorAnswer as List<AppScreen>;
        return selectedAppScreens[idx]
            .configurableScreenAreas
            .map((e) => e.name);
      }),
      qTargetIntentUpdaterArg: (QuestBase qb, int idx) =>
          qb.qTargetIntent.copyWith(appScreen: qb.qTargetIntent.appScreen),
      perQuestGenOptions: [
        PerQuestGenOption(
          castFunc: (String lstAreaIdxs) {
            return castStrOfIdxsToIterOfInts(lstAreaIdxs, dflt: 0)
                .map((i) => ScreenWidgetArea.values[i]);
          },
        ),
      ],
    ),
    cascadeType: QRespCascadePatternEm.addsRuleDetailQuestsForSlotOrArea,
    questId: QuestionIdStrings.selectAppScreens,
    validateUserAnswerAfterPatternMatchIsTrueCallback: (ans) => true,
    isRuleQuestion: false,
  ),

  QuestMatcher<int>(
    'if user wants to perform grouping on a ListView, ask how many grouping cols are required & add a Questions for each',
    MatcherBehaviorEnum.addPendingQuestions,
    DerivedQuestGenerator(
      'Select field #{0} to use for row-grouping on {1} screen',
      newQuestCountCalculator: (q) => (q.mainAnswer) as int,
      newQuestPromptArgGen: (quest, idx) =>
          <String>['${idx + 1}', quest.appScreen.name],
      answerChoiceGenerator: ((priorAnswer, idx) {
        // var selectedAppScreens = priorAnswer as int;
        return DbTableFieldName.values.map((e) => e.name);
      }),
      qTargetIntentUpdaterArg: (QuestBase qb, int idx) =>
          qb.qTargetIntent.copyWith(appScreen: qb.qTargetIntent.appScreen),
      perQuestGenOptions: [
        PerQuestGenOption(
          castFunc: (ansr) => DbTableFieldName
              .values[int.tryParse(ansr) ?? CfgConst.cancelSortIndex],
          ruleType: VisualRuleType.groupCfg,
          ruleQuestType: VisRuleQuestType.selectDataFieldName,
        ),
      ],
    ),

    cascadeType: QRespCascadePatternEm.addsRuleDetailQuestsForSlotOrArea,
    screenWidgetArea: ScreenWidgetArea.tableview,
    visRuleTypeForAreaOrSlot: VisualRuleType.groupCfg,
    // if existing Question is for grouping on ListView
    // make sure user said YES (they want grouping)
    validateUserAnswerAfterPatternMatchIsTrueCallback: (ans) => (ans ?? 0) > 0,
    isRuleQuestion: false,
  ),
];
