part of EvCfgConfig;

/*  this file contains the matcher definitions to produce:
      1. further questions
      2. implicit answers
    from the intial configurator questions

this config should drive the whole dynamic
dialog
*/

const String _whichAreasForScreenConst = 'whichAreasForScreen';

List<QuestMatcher> stDfltMatcherList = [
  // defines rules for adding new Questions or implicit answers
  // based on answers to prior Questions

  QuestMatcher<List<ScreenWidgetArea>>(
    'build ?`s to specify which areas to config on selected screens',
    MatcherBehaviorEnum.addPendingQuestions,
    DerivedQuestGenerator(
      'Select areas to configure on screen {0}',
      newQuestPromptArgGen: (QuestBase priorAnsweredQuest, int idx) {
        return [(priorAnsweredQuest.mainAnswer as List<AppScreen>)[idx].name];
      },
      newQuestCountCalculator: (QuestBase priorAnsweredQuest) {
        return (priorAnsweredQuest.mainAnswer as List<AppScreen>).length;
      },
      newQuestIdGenFromPriorQuest: (QuestBase priorQ, int idx) {
        // each new question about area on screen should
        // have an ID that lets the next QM identify it to produce new Q's
        String scrName = priorQ.appScreen.name; // + '-' + priorQ.mainAnswer
        return _whichAreasForScreenConst + '-' + scrName;
      },
      answerChoiceGenerator: ((QuestBase priorAnsweredQuest, int idx) {
        var selectedAppScreens =
            priorAnsweredQuest.mainAnswer as List<AppScreen>;
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
    questIdPatternTest: (qid) => qid == QuestionIdStrings.selectAppScreens,
    validateUserAnswerAfterPatternMatchIsTrueCallback: (ans) => true,
    isRuleQuestion: false,
  ),

  QuestMatcher<List<VisualRuleType>>(
    'build ?`s to specify which rules for areas of selected screens',
    MatcherBehaviorEnum.addPendingQuestions,
    DerivedQuestGenerator(
      'Select which rules to configure on area {0} of screen {1}',
      newQuestPromptArgGen: (QuestBase priorAnsweredQuest, int idx) {
        var areaName =
            (priorAnsweredQuest.mainAnswer as List<ScreenWidgetArea>)[idx].name;
        var screenName = priorAnsweredQuest.qTargetIntent.appScreen.name;
        return [areaName, screenName];
      },
      newQuestCountCalculator: (QuestBase priorAnsweredQuest) {
        return (priorAnsweredQuest.mainAnswer as List<ScreenWidgetArea>).length;
      },
      answerChoiceGenerator: ((QuestBase priorAnsweredQuest, int idx) {
        var selectedScreenAreas =
            priorAnsweredQuest.mainAnswer as List<ScreenWidgetArea>;
        return selectedScreenAreas[idx]
            .applicableRuleTypes(priorAnsweredQuest.qTargetIntent.appScreen)
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
    questIdPatternTest: (qid) => qid.startsWith(_whichAreasForScreenConst),

    // validateUserAnswerAfterPatternMatchIsTrueCallback: (QuestBase qb) {
    //   bool addsWhichRulesForSelectedAreaQuestions =
    //       qb.qTargetIntent.addsWhichRulesForSelectedAreaQuestions;
    //   return addsWhichRulesForSelectedAreaQuestions &&
    //       qb.expectedAnswerType == List<VisualRuleType>;
    // },
    isRuleQuestion: false,
  ),

  QuestMatcher<int>(
    'if user wants to perform grouping on a ListView, ask how many grouping cols are required & add a Questions for each',
    MatcherBehaviorEnum.addPendingQuestions,
    DerivedQuestGenerator(
      'Select field #{0} to use for row-grouping on {1} screen',
      newQuestPromptArgGen: (quest, idx) =>
          <String>['${idx + 1}', quest.appScreen.name],
      newQuestCountCalculator: (q) => (q.mainAnswer) as int,
      answerChoiceGenerator: ((QuestBase priorAnsweredQuest, idx) {
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
    validateUserAnswerAfterPatternMatchIsTrueCallback: (QuestBase qb) =>
        (qb.mainAnswer ?? 0) > 0,
    isRuleQuestion: false,
  ),
];
