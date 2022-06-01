part of EvCfgConfig;

/*  this file contains the matcher definitions to produce:
      1. further questions
      2. implicit answers
    from the intial configurator questions

this config should drive the whole dynamic
dialog with CLI user

instructions for use:

*/

List<QuestMatcher> stDfltMatcherList = [
  // defines rules for adding new Questions or implicit answers
  // based on answers to prior Questions

  QuestMatcher<List<ScreenWidgetArea>>(
    'build ?`s to specify which areas to config on selected screens',
    cascadeTypeOfMatchedQuest:
        QRespCascadePatternEm.addsWhichAreaInSelectedScreenQuestions,
    derivedQuestGen: DerivedQuestGenerator(
      'Select areas to configure on screen {0}',
      newQuestPromptArgGen: (QuestBase priorAnsweredQuest, int newQuIdx) {
        String nameOfScreenToConfig =
            (priorAnsweredQuest.mainAnswer as List<AppScreen>)[newQuIdx].name;
        return [nameOfScreenToConfig];
      },
      newQuestCountCalculator: (QuestBase priorAnsweredQuest) {
        return (priorAnsweredQuest.mainAnswer as List<dynamic>).length;
      },
      newQuestIdGenFromPriorQuest: (
        QuestBase priorAnsweredQuest,
        int newQuIdx,
      ) {
        // each new question about area on screen should
        // have an ID that lets the next QM identify it to produce new Q's
        String scrName = priorAnsweredQuest.appScreen.name;
        return QuestionIdStrings.specAreasToConfigOnScreen + '-' + scrName;
      },
      answerChoiceGenerator: (
        QuestBase priorAnsweredQuest,
        int newQuIdx,
      ) {
        var selectedAppScreens =
            priorAnsweredQuest.mainAnswer as List<AppScreen>;
        return selectedAppScreens[newQuIdx]
            .configurableScreenAreas
            .map((e) => e.name);
      },
      qTargetIntentUpdaterCallbk: (
        QuestBase priorAnsweredQuest,
        int newQuIdx,
      ) {
        // create target + intent of each generated question
        var selectedAppScreens =
            priorAnsweredQuest.mainAnswer as List<AppScreen>;
        return priorAnsweredQuest.qTargetIntent.copyWith(
            appScreen: selectedAppScreens[newQuIdx],
            cascadeType:
                QRespCascadePatternEm.addsWhichRulesForSelectedAreaQuestions);
      },
      perQuestGenOptions: [
        PerQuestGenOption(
          castFunc: (String lstAreaIdxs) {
            return castStrOfIdxsToIterOfInts(lstAreaIdxs, dflt: 0)
                .map((i) => ScreenWidgetArea.values[i]);
          },
        ),
      ],
    ),
    questIdPatternTest: (qid) => qid == QuestionIdStrings.selectAppScreens,
    validateUserAnswerAfterPatternMatchIsTrueCallback: (ans) => true,
    isRuleQuestion: false,
  ),

  QuestMatcher<List<VisualRuleType>>(
    'build ?`s to specify which rules for areas of selected screens',
    cascadeTypeOfMatchedQuest:
        QRespCascadePatternEm.addsWhichRulesForSelectedAreaQuestions,
    derivedQuestGen: DerivedQuestGenerator(
      'Select which rules to add on area {0} of screen {1}',
      // genBehaviorOfDerivedQuests:
      //     DerivedGenBehaviorOnMatchEnum.addPendingQuestions,
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
      qTargetIntentUpdaterCallbk: (QuestBase priorAnsweredQuest, int idx) {
        var selectedScreenAreas =
            priorAnsweredQuest.mainAnswer as List<ScreenWidgetArea>;
        ScreenWidgetArea currArea = selectedScreenAreas[idx];
        return priorAnsweredQuest.qTargetIntent
            .copyWith(screenWidgetArea: currArea);
      },
      perQuestGenOptions: [
        PerQuestGenOption(
          castFunc: (String lstAreaIdxs) {
            return castStrOfIdxsToIterOfInts(lstAreaIdxs, dflt: 0)
                .map((i) => ScreenWidgetArea.values[i]);
          },
        ),
      ],
    ),
    questIdPatternTest: (qid) =>
        qid.startsWith(QuestionIdStrings.specAreasToConfigOnScreen),
    isRuleQuestion: false,
  ),

  QuestMatcher<List<ScreenAreaWidgetSlot>>(
    'build ?`s to specify which slots in areas on selected screens user wants to config',
    cascadeTypeOfMatchedQuest:
        QRespCascadePatternEm.addsWhichSlotOfSelectedAreaQuestions,
    derivedQuestGen: DerivedQuestGenerator(
      'Select which slots to config within area {0} of screen {1}',
      // genBehaviorOfDerivedQuests:
      //     DerivedGenBehaviorOnMatchEnum.addPendingQuestions,
      newQuestPromptArgGen: (QuestBase priorAnsweredQuest, int idx) {
        var areaName =
            (priorAnsweredQuest.mainAnswer as List<ScreenWidgetArea>)[idx].name;
        var screenName = priorAnsweredQuest.appScreen.name;
        return [areaName, screenName];
      },
      newQuestCountCalculator: (QuestBase priorAnsweredQuest) {
        return (priorAnsweredQuest.mainAnswer as List<ScreenWidgetArea>).length;
      },
      answerChoiceGenerator: (QuestBase priorAnsweredQuest, int idx) {
        var selectedScreenAreas =
            priorAnsweredQuest.mainAnswer as List<ScreenWidgetArea>;
        return selectedScreenAreas[idx]
            .applicableWigetSlots(priorAnsweredQuest.appScreen)
            .map((e) => e.name);
      },
      qTargetIntentUpdaterCallbk: (QuestBase priorAnsweredQuest, int idx) {
        var selectedScreenAreas =
            priorAnsweredQuest.mainAnswer as List<ScreenWidgetArea>;
        ScreenWidgetArea currArea = selectedScreenAreas[idx];
        return priorAnsweredQuest.qTargetIntent
            .copyWith(screenWidgetArea: currArea);
      },
      perQuestGenOptions: [
        PerQuestGenOption(
          castFunc: (String lstAreaIdxs) {
            return castStrOfIdxsToIterOfInts(lstAreaIdxs, dflt: 0)
                .map((i) => ScreenWidgetArea.values[i]);
          },
        ),
      ],
    ),
    questIdPatternTest: (qid) =>
        qid.startsWith(QuestionIdStrings.specAreasToConfigOnScreen),
    isRuleQuestion: false,
  ),

  QuestMatcher<int>(
    'if user wants to perform grouping on a ListView, ask how many grouping cols are required & add a Questions for each',
    cascadeTypeOfMatchedQuest:
        QRespCascadePatternEm.addsRuleDetailQuestsForSlotOrArea,
    derivedQuestGen: DerivedQuestGenerator(
      'Select field #{0} to use for row-grouping on {1} screen',
      // genBehaviorOfDerivedQuests:
      //     DerivedGenBehaviorOnMatchEnum.addPendingQuestions,
      newQuestPromptArgGen: (quest, idx) =>
          <String>['${idx + 1}', quest.appScreen.name],
      newQuestCountCalculator: (q) => (q.mainAnswer) as int,
      answerChoiceGenerator: (QuestBase priorAnsweredQuest, idx) {
        // var selectedAppScreens = priorAnswer as int;
        return DbTableFieldName.values.map((e) => e.name);
      },
      qTargetIntentUpdaterCallbk: (QuestBase qb, int idx) =>
          qb.qTargetIntent.copyWith(appScreen: qb.qTargetIntent.appScreen),
      perQuestGenOptions: [
        PerQuestGenOption(
          castFunc: (ansr) => DbTableFieldName
              .values[int.tryParse(ansr) ?? CfgConst.cancelSortIndex],
          visRuleType: VisualRuleType.groupCfg,
          visRuleQuestType: VisRuleQuestType.selectDataFieldName,
        ),
      ],
    ),
    screenWidgetArea: ScreenWidgetArea.tableview,
    visRuleTypeForAreaOrSlot: VisualRuleType.groupCfg,
    // if existing Question is for grouping on ListView
    // make sure user said YES (they want grouping)
    validateUserAnswerAfterPatternMatchIsTrueCallback: (QuestBase qb) =>
        (qb.mainAnswer ?? 0) > 0,
    isRuleQuestion: false,
  ),
];
