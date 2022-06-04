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
    // simple match by questId
    questIdPatternTest: (qid) => qid == QuestionIdStrings.selectAppScreens,
    //
    derivedQuestGen: DerivedQuestGenerator(
      'Select areas to configure on screen {0}',
      newQuestPromptArgGen: (
        QuestBase priorAnsweredQuest,
        int newQuIdx,
      ) {
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
        // adding 1 to skip eventConfig screen enum
        return selectedAppScreens[newQuIdx]
            .configurableScreenAreas
            .map((swa) => swa.name)
            .toList();
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
          cascadeType: // of created questions
              QRespCascadePatternEm.addsWhichRulesForSelectedAreaQuestions,
        );
      },
      perQuestGenOptions: [
        PerQuestGenOption(
          castFunc: (QuestBase qb, String lstAreaIdxs) {
            List<ScreenWidgetArea> possibleAreasForScreen =
                qb.appScreen.configurableScreenAreas;
            return castStrOfIdxsToIterOfInts(lstAreaIdxs, dflt: 0).map(
              (i) => possibleAreasForScreen[i],
            );
          },
        ),
      ],
    ),
  ),

  QuestMatcher<List<VisualRuleType>>(
    'build ?`s to specify which rules for areas of selected screens',
    cascadeTypeOfMatchedQuest:
        QRespCascadePatternEm.addsWhichRulesForSelectedAreaQuestions,
    questIdPatternTest: (qid) =>
        qid.startsWith(QuestionIdStrings.specAreasToConfigOnScreen),
    //
    derivedQuestGen: DerivedQuestGenerator(
      'Select which rules to add on area {0} of screen {1}',
      newQuestPromptArgGen: (
        QuestBase priorAnsweredQuest,
        int newQuestIdx,
      ) {
        List<ScreenWidgetArea> screenAreasToConfig =
            (priorAnsweredQuest.mainAnswer as Iterable<ScreenWidgetArea>)
                .toList();
        print('*****');
        print(screenAreasToConfig);

        String areaName = screenAreasToConfig[newQuestIdx].name;
        String screenName = priorAnsweredQuest.appScreen.name;
        return [areaName, screenName];
      },
      newQuestCountCalculator: (QuestBase priorAnsweredQuest) {
        return (priorAnsweredQuest.mainAnswer as Iterable<ScreenWidgetArea>)
            .length;
      },
      newQuestIdGenFromPriorQuest: (
        QuestBase priorAnsweredQuest,
        int newQuIdx,
      ) {
        // each new question about area on screen should
        // have an ID that lets the next QM identify it to produce new Q's
        String scrName = priorAnsweredQuest.appScreen.name;
        String area = priorAnsweredQuest.screenWidgetArea?.name ?? '-na';
        return QuestionIdStrings.specRulesForAreaOnScreen +
            '-' +
            scrName +
            '-' +
            area;
      },
      answerChoiceGenerator: ((
        QuestBase priorAnsweredQuest,
        int idx,
      ) {
        List<ScreenWidgetArea> selectedScreenAreas =
            (priorAnsweredQuest.mainAnswer as Iterable<ScreenWidgetArea>)
                .toList();
        return selectedScreenAreas[idx]
            .applicableRuleTypes(priorAnsweredQuest.appScreen)
            .map((e) => e.name)
            .toList();
      }),
      qTargetIntentUpdaterCallbk: (
        QuestBase priorAnsweredQuest,
        int idx,
      ) {
        List<ScreenWidgetArea> selectedScreenAreas =
            (priorAnsweredQuest.mainAnswer as Iterable<ScreenWidgetArea>)
                .toList();
        ScreenWidgetArea currArea = selectedScreenAreas[idx];
        return priorAnsweredQuest.qTargetIntent.copyWith(
          screenWidgetArea: currArea,
          cascadeType: // of created questions
              QRespCascadePatternEm.addsRuleDetailQuestsForSlotOrArea,
        );
      },
      perQuestGenOptions: [
        PerQuestGenOption(
          castFunc: (QuestBase qb, String lstAreaIdxs) {
            return castStrOfIdxsToIterOfInts(lstAreaIdxs, dflt: 0)
                .map(
                  (i) => ScreenWidgetArea.values[i],
                )
                .toList();
          },
        ),
      ],
    ),
  ),

  QuestMatcher<List<ScreenAreaWidgetSlot>>(
    'build ?`s to specify which slots in areas on selected screens user wants to config',
    cascadeTypeOfMatchedQuest:
        QRespCascadePatternEm.addsWhichSlotOfSelectedAreaQuestions,
    questIdPatternTest: (qid) =>
        qid.startsWith(QuestionIdStrings.specAreasToConfigOnScreen),
    //
    derivedQuestGen: DerivedQuestGenerator(
      'Select which slots to config within area {0} of screen {1}',
      newQuestPromptArgGen: (
        QuestBase priorAnsweredQuest,
        int idx,
      ) {
        List<ScreenWidgetArea> respList =
            (priorAnsweredQuest.mainAnswer as Iterable<ScreenWidgetArea>)
                .toList();
        var areaName = respList[idx].name;
        var screenName = priorAnsweredQuest.appScreen.name;
        return [areaName, screenName];
      },
      newQuestCountCalculator: (QuestBase priorAnsweredQuest) {
        return (priorAnsweredQuest.mainAnswer as Iterable<dynamic>).length;
      },
      newQuestIdGenFromPriorQuest: (
        QuestBase priorAnsweredQuest,
        int newQuIdx,
      ) {
        // each new question about area on screen should
        // have an ID that lets the next QM identify it to produce new Q's
        String scrName = priorAnsweredQuest.appScreen.name;
        String area = priorAnsweredQuest.screenWidgetArea?.name ?? '-na';
        return QuestionIdStrings.specSlotsToConfigInArea +
            '-' +
            scrName +
            '-' +
            area;
      },
      answerChoiceGenerator: (
        QuestBase priorAnsweredQuest,
        int idx,
      ) {
        List<ScreenWidgetArea> selectedScreenAreas =
            (priorAnsweredQuest.mainAnswer as Iterable<ScreenWidgetArea>)
                .toList();
        return selectedScreenAreas[idx]
            .applicableWigetSlots(priorAnsweredQuest.appScreen)
            .map((e) => e.name)
            .toList();
      },
      qTargetIntentUpdaterCallbk: (
        QuestBase priorAnsweredQuest,
        int idx,
      ) {
        List<ScreenWidgetArea> selectedScreenAreas =
            (priorAnsweredQuest.mainAnswer as Iterable<ScreenWidgetArea>)
                .toList();
        ScreenWidgetArea currArea = selectedScreenAreas[idx];
        return priorAnsweredQuest.qTargetIntent.copyWith(
          screenWidgetArea: currArea,
          cascadeType: // of created questions
              QRespCascadePatternEm.addsWhichSlotOfSelectedAreaQuestions,
        );
      },
      perQuestGenOptions: [
        PerQuestGenOption(
          castFunc: (QuestBase qb, String lstAreaIdxs) {
            return castStrOfIdxsToIterOfInts(lstAreaIdxs, dflt: 0).map(
              (i) => ScreenAreaWidgetSlot.values[i],
            );
          },
        ),
      ],
    ),
  ),

  QuestMatcher<List<VisualRuleType>>(
    'build ?`s to specify which rules for slots in areas on selected screens user wants to config',
    cascadeTypeOfMatchedQuest:
        QRespCascadePatternEm.addsRuleDetailQuestsForSlotOrArea,
    questIdPatternTest: (qid) =>
        qid.startsWith(QuestionIdStrings.specSlotsToConfigInArea),
    //
    derivedQuestGen: DerivedQuestGenerator(
      'Select which rules to config within slot {0} in area {1} of screen {2}',
      newQuestPromptArgGen: (
        QuestBase priorAnsweredQuest,
        int idx,
      ) {
        List<ScreenAreaWidgetSlot> respList =
            (priorAnsweredQuest.mainAnswer as Iterable<ScreenAreaWidgetSlot>)
                .toList();
        var slotName = respList[idx].name;
        var areaName = priorAnsweredQuest.screenWidgetArea?.name ?? 'area';
        var screenName = priorAnsweredQuest.appScreen.name;
        return [slotName, areaName, screenName];
      },
      newQuestCountCalculator: (QuestBase priorAnsweredQuest) {
        return (priorAnsweredQuest.mainAnswer as Iterable<dynamic>).length;
      },
      answerChoiceGenerator: (
        QuestBase priorAnsweredQuest,
        int idx,
      ) {
        List<ScreenAreaWidgetSlot> selectedAreaSlots =
            (priorAnsweredQuest.mainAnswer as Iterable<ScreenAreaWidgetSlot>)
                .toList();
        ScreenAreaWidgetSlot curSlot = selectedAreaSlots[idx];
        ScreenWidgetArea curArea = priorAnsweredQuest.screenWidgetArea!;
        return curSlot.possibleConfigRules(curArea).map((e) => e.name).toList();
      },
      qTargetIntentUpdaterCallbk: (
        QuestBase priorAnsweredQuest,
        int idx,
      ) {
        // ScreenWidgetArea currArea = priorAnsweredQuest.screenWidgetArea!; //  ?? ScreenWidgetArea.header;
        // String currAreaName = currArea.name;
        List<ScreenAreaWidgetSlot> selectedAreaSlots =
            (priorAnsweredQuest.mainAnswer as Iterable<ScreenAreaWidgetSlot>)
                .toList();
        ScreenAreaWidgetSlot slot = selectedAreaSlots[idx];
        return priorAnsweredQuest.qTargetIntent.copyWith(
          // screenWidgetArea: currArea,
          slotInArea: slot,
          cascadeType: // of created questions
              QRespCascadePatternEm.addsRuleDetailQuestsForSlotOrArea,
        );
      },
      perQuestGenOptions: [
        PerQuestGenOption(
          castFunc: (QuestBase qb, String lstAreaIdxs) {
            return castStrOfIdxsToIterOfInts(lstAreaIdxs, dflt: 0).map(
              (i) => ScreenAreaWidgetSlot.values[i],
            );
          },
        ),
      ],
    ),
  ),

  QuestMatcher<int>(
    'if user wants to perform grouping on a ListView, ask how many grouping cols are required & add a Questions for each',
    cascadeTypeOfMatchedQuest:
        QRespCascadePatternEm.addsRuleDetailQuestsForSlotOrArea,
    screenWidgetArea: ScreenWidgetArea.tableview,
    visRuleTypeForAreaOrSlot: VisualRuleType.groupCfg,
    // if existing Question is for grouping on ListView
    // make sure user said YES (they want grouping)
    validateUserAnswerAfterPatternMatchIsTrueCallback: (QuestBase qb) =>
        qb.mainAnswer as int > 0,

    //
    derivedQuestGen: DerivedQuestGenerator(
      'Select field #{0} to use for row-grouping on {1} area of screen {2}',
      newQuestPromptArgGen: (
        QuestBase priorAnsweredQuest,
        idx,
      ) {
        int slotNum = idx + 1;
        var areaName = (priorAnsweredQuest.qTargetIntent.screenWidgetArea ??
                ScreenWidgetArea.tableview)
            .name;
        return <String>[
          '$slotNum',
          areaName,
          priorAnsweredQuest.appScreen.name
        ];
      },
      newQuestCountCalculator: (
        QuestBase priorAnsweredQuest,
      ) =>
          (priorAnsweredQuest.mainAnswer) as int,
      answerChoiceGenerator: (
        QuestBase priorAnsweredQuest,
        int idx,
      ) {
        return DbTableFieldName.values.map((e) => e.name).toList();
      },
      qTargetIntentUpdaterCallbk: (
        QuestBase priorAnsweredQuest,
        int idx,
      ) {
        return priorAnsweredQuest.qTargetIntent.copyWith(
          visRuleTypeForAreaOrSlot: VisualRuleType.groupCfg,
        );
      },
      perQuestGenOptions: [
        PerQuestGenOption(
          castFunc: (QuestBase qb, String ansr) => DbTableFieldName
              .values[int.tryParse(ansr) ?? CfgConst.cancelSortIndex],
          visRuleType: VisualRuleType.groupCfg,
          visRuleQuestType: VisRuleQuestType.selectDataFieldName,
        ),
      ],
    ),
  ),
];
