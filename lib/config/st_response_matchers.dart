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
  /* defines rules for adding new Questions or implicit answers
    based on answers to prior Questions

  Explaining the generics here:
    QuestMatcher<AnsTypOfMatched, AnsTypOfGend>
      AnsTypOfMatched is the main answer type of matched question
      AnsTypOfGend is the main answer type of generated questions
  */

// #1
  QuestMatcher<List<AppScreen>, List<ScreenWidgetArea>>(
    '''matches question in which user answers which screens to configure
    then derivedQuestGen will build ?s to specify which areas to config on each selected screen
      once user answers those generated questions (selects areas), there needs to be
      two QuestMatchers that match those questions
        1. which rules on selected area of screen
        2. which slots within selected area of screen
    ''',
    // simple match by questId
    questIdPatternMatchTest: (qid) => qid == QuestionIdStrings.selectAppScreens,
    cascadeTypeOfMatchedQuest:
        QRespCascadePatternEm.addsWhichAreaInSelectedScreenQuestions,
    //
    derivedQuestGen: DerivedQuestGenerator<List<AppScreen>>(
      'Select areas you want to configure on screen {0} (answ will create which rule for area quest)',
      newQuestPromptArgGen: (
        QuestBase priorAnsweredQuest,
        int newQuIdx,
      ) {
        // produce args for {0} in prompt template above
        String nameOfScreenToConfig =
            (priorAnsweredQuest.mainAnswer as List<AppScreen>)[newQuIdx].name;
        return [nameOfScreenToConfig.toUpperCase()];
      },
      newQuestCountCalculator: (QuestBase priorAnsweredQuest) {
        // how many new questions to generate?
        return (priorAnsweredQuest.mainAnswer as List<dynamic>).length;
      },
      newQuestIdGenFromPriorQuest: (
        QuestBase priorAnsweredQuest,
        int newQuIdx,
      ) {
        /* each new question about area on screen should
          have an ID that lets the next QM identify it to produce new Q's
        */
        String scrName = priorAnsweredQuest.appScreen.name;
        return QuestionIdStrings.specAreasToConfigOnScreen + '-' + scrName;
      },
      answerChoiceGenerator: (
        QuestBase priorAnsweredQuest,
        int newQuIdx,
      ) {
        // show allowed possible answers for generated questions
        // return List<String>
        var selectedAppScreens =
            priorAnsweredQuest.mainAnswer as List<AppScreen>;
        return selectedAppScreens[newQuIdx]
            .configurableScreenAreas
            .map((swa) => swa.name)
            .toList();
      },
      qTargetIntentUpdaterCallbk: (
        QuestBase priorAnsweredQuest,
        int newQuIdx,
      ) {
        // creates new target + intent (QTargetIntent) for each generated question
        var selectedAppScreens =
            priorAnsweredQuest.mainAnswer as List<AppScreen>;
        return priorAnsweredQuest.qTargetIntent.copyWith(
          appScreen: selectedAppScreens[newQuIdx],
          cascadeType: // of created questions
              QRespCascadePatternEm.addsWhichRulesForSelectedAreaQuestions,
        );
      },
      /* params to handle converting user responses (String 0,1,2)
          on NEW QUESTIONS, into the expected response data-type
          each item in list below is 1-1 sync with question being created
          if perQuestGenOptions.length < result of newQuestCountCalculator()
          then LAST item in perQuestGenOptions will be used to configure
          subsequent new questions

FIXME:
          TO CONSIDER:  what if generic type in PerQuestGenResponsHandlingOpts
          is different than 2nd generic type above in
            QuestMatcher<List<AppScreen>, List<ScreenWidgetArea>>
        that seems like a design mistake???
      */
      perQuestGenOptions: [
        PerQuestGenResponsHandlingOpts<List<ScreenWidgetArea>>(
          newRespCastFunc: (
            QuestBase newAnsQuest,
            String lstAreaIdxs,
          ) {
            List<ScreenWidgetArea> possibleAreasForScreen =
                newAnsQuest.qTargetIntent.possibleAreasForScreen;
            return castStrOfIdxsToIterOfInts(lstAreaIdxs, dflt: 0)
                .map(
                  (i) => possibleAreasForScreen[i],
                )
                .toList();
          },
        ),
      ],
    ),
  ),

// #2
  QuestMatcher<List<ScreenWidgetArea>, List<VisualRuleType>>(
    '''matches questions in which user specifies screen-areas to config
      build ?s to specify which Visual rules for those selected screen-areas
      the answers to those questions (Visual rules) will hit QM below to
      ask config details for each selected rule
    ''',
    // match on start of qid
    questIdPatternMatchTest: (qid) =>
        qid.startsWith(QuestionIdStrings.specAreasToConfigOnScreen),
    cascadeTypeOfMatchedQuest:
        QRespCascadePatternEm.addsWhichRulesForSelectedAreaQuestions,
    //
    derivedQuestGen: DerivedQuestGenerator(
      'Select which rules to add on area {0} of screen {1} (answ will generate rule config quests)',
      newQuestPromptArgGen: (
        QuestBase priorAnsweredQuest,
        int newQuestIdx,
      ) {
        List<ScreenWidgetArea> screenAreasToConfig =
            (priorAnsweredQuest.mainAnswer as Iterable<ScreenWidgetArea>)
                .toList();
        // print('*****');
        // print(screenAreasToConfig);

        String areaName = screenAreasToConfig[newQuestIdx].name;
        String screenName = priorAnsweredQuest.appScreen.name;
        return [
          areaName.toUpperCase(),
          screenName.toUpperCase(),
        ];
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
        ScreenWidgetArea selectedArea = selectedScreenAreas[idx];
        return selectedArea
            .applicableRuleTypes(priorAnsweredQuest.appScreen)
            .map((e) => e.name)
            .toList();
      }),
      qTargetIntentUpdaterCallbk: (
        QuestBase priorAnsweredQuest,
        int newQuestIdx,
      ) {
        List<ScreenWidgetArea> selectedScreenAreas =
            (priorAnsweredQuest.mainAnswer as Iterable<ScreenWidgetArea>)
                .toList();
        ScreenWidgetArea currArea = selectedScreenAreas[newQuestIdx];
        return priorAnsweredQuest.qTargetIntent.copyWith(
          screenWidgetArea: currArea,
          cascadeType: // of created questions
              QRespCascadePatternEm.addsRuleDetailQuestsForSlotOrArea,
        );
      },
      perQuestGenOptions: [
        PerQuestGenResponsHandlingOpts<List<VisualRuleType>>(
          newRespCastFunc: (
            QuestBase newAnsQuest,
            String lstAreaIdxs,
          ) {
            List<VisualRuleType> possibleRules =
                newAnsQuest.qTargetIntent.possibleRulesForAreaInScreen;
            return castStrOfIdxsToIterOfInts(lstAreaIdxs, dflt: 0)
                .map(
                  (i) => possibleRules[i],
                )
                .toList();
          },
        ),
      ],
    ),
  ),

// #3
  QuestMatcher<List<VisualRuleType>, String>(
    '''matches questions in which user specifies vis-rules to config on screen-areas
      build ?s to specify specific rule config for each rule on those selected screen-areas

      the answers to those questions (VisRuleQuestType) will be the
      ui config for THAT RULE, on selected screen area
    ''',
    questIdPatternMatchTest: (qid) =>
        qid.startsWith(QuestionIdStrings.specRulesForAreaOnScreen),
    cascadeTypeOfMatchedQuest:
        QRespCascadePatternEm.addsRuleDetailQuestsForSlotOrArea,
    //
    derivedQuestGen: DerivedQuestGenerator(
      'Config rule {0} within area {1} of screen {2}',
      newQuestPromptArgGen: (
        QuestBase priorAnsweredQuest,
        int idx,
      ) {
        List<VisualRuleType> respList =
            (priorAnsweredQuest.mainAnswer as Iterable<VisualRuleType>)
                .toList();
        var ruleName = respList[idx].name;
        var areaName = priorAnsweredQuest.screenWidgetArea?.name ?? 'area';
        var screenName = priorAnsweredQuest.appScreen.name;
        return [
          ruleName.toUpperCase(),
          areaName.toUpperCase(),
          screenName.toUpperCase()
        ];
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
        List<VisualRuleType> selectedRulesInArea =
            (priorAnsweredQuest.mainAnswer as List<VisualRuleType>);
        // .toList();
        var ruleName = selectedRulesInArea[newQuIdx].name;
        String scrName = priorAnsweredQuest.appScreen.name;
        String area = priorAnsweredQuest.screenWidgetArea?.name ?? '-na';
        return QuestionIdStrings.specRuleDetailsForAreaOnScreen +
            '-' +
            scrName +
            '-' +
            area +
            '-' +
            ruleName;
      },
      answerChoiceGenerator: (
        QuestBase priorAnsweredQuest,
        int newQuestIdx,
      ) {
        List<VisualRuleType> selectedRulesInArea =
            (priorAnsweredQuest.mainAnswer as List<VisualRuleType>);
        VisualRuleType curRule = selectedRulesInArea[newQuestIdx];

        List<VisRuleQuestType> reqCfgQuests = curRule.requConfigQuests;
        return reqCfgQuests.fold<List<String>>(
          [],
          (List<String> chLst, VisRuleQuestType qt) =>
              chLst..addAll(qt.choices),
        );
      },
      qTargetIntentUpdaterCallbk: (
        QuestBase priorAnsweredQuest,
        int newQuestIdx,
      ) {
        List<VisualRuleType> selectedRulesInArea =
            (priorAnsweredQuest.mainAnswer as List<VisualRuleType>);
        VisualRuleType curRule = selectedRulesInArea[newQuestIdx];
        return priorAnsweredQuest.qTargetIntent.copyWith(
          visRuleTypeForAreaOrSlot: curRule,
          cascadeType: // of created questions
              QRespCascadePatternEm.noCascade,
        );
      },
      perQuestGenOptions: [
        PerQuestGenResponsHandlingOpts<String>(
          newRespCastFunc: (
            QuestBase newQuest,
            String lstAreaIdxs,
          ) {
            return lstAreaIdxs;
          },
        ),
      ],
    ),
  ),

// #4
  QuestMatcher<List<ScreenWidgetArea>, List<ScreenAreaWidgetSlot>>(
    '''matches questions in which user specifies screen-areas to config
      build ?s to specify which SLOTS for those selected screen-areas
      
      the answers to those questions (Area Slots) will match below to
      ask WHICH rules for each selected slot
    ''',

    cascadeTypeOfMatchedQuest:
        QRespCascadePatternEm.addsWhichSlotOfSelectedAreaQuestions,
    questIdPatternMatchTest: (qid) =>
        qid.startsWith(QuestionIdStrings.specAreasToConfigOnScreen),
    //
    derivedQuestGen: DerivedQuestGenerator(
      'Select which slots to config within area {0} of screen {1}',
      newQuestPromptArgGen: (
        QuestBase priorAnsweredQuest,
        int newQuestIdx,
      ) {
        List<ScreenWidgetArea> respList =
            (priorAnsweredQuest.mainAnswer as List<ScreenWidgetArea>);
        // .toList();
        var areaName = respList[newQuestIdx].name;
        var screenName = priorAnsweredQuest.appScreen.name;
        return [
          areaName.toUpperCase(),
          screenName.toUpperCase(),
        ];
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
        int newQuestIdx,
      ) {
        List<ScreenWidgetArea> selectedScreenAreas =
            (priorAnsweredQuest.mainAnswer as List<ScreenWidgetArea>);
        // .toList();
        return selectedScreenAreas[newQuestIdx]
            .applicableWigetSlots(priorAnsweredQuest.appScreen)
            .map((e) => e.name)
            .toList();
      },
      qTargetIntentUpdaterCallbk: (
        QuestBase priorAnsweredQuest,
        int newQuestIdx,
      ) {
        List<ScreenWidgetArea> selectedScreenAreas =
            (priorAnsweredQuest.mainAnswer as List<ScreenWidgetArea>);
        // .toList();
        ScreenWidgetArea currArea = selectedScreenAreas[newQuestIdx];
        return priorAnsweredQuest.qTargetIntent.copyWith(
          screenWidgetArea: currArea,
          cascadeType: // of created questions
              QRespCascadePatternEm.addsWhichRulesForSlotsInArea,
        );
      },
      perQuestGenOptions: [
        PerQuestGenResponsHandlingOpts<List<ScreenAreaWidgetSlot>>(
          newRespCastFunc: (
            QuestBase newQuest,
            String lstAreaIdxs,
          ) {
            List<ScreenAreaWidgetSlot> possibleSlots =
                newQuest.qTargetIntent.possibleSlotsForAreaInScreen;

            return castStrOfIdxsToIterOfInts(lstAreaIdxs, dflt: 0)
                .map((i) => possibleSlots[i])
                .toList();
          },
        ),
      ],
    ),
  ),

// #5
  QuestMatcher<List<ScreenAreaWidgetSlot>, List<VisualRuleType>>(
    '''matches questions in which user specifies slots in screen-areas to config
      build ?s to specify which rules for those SLOTS in screen-areas
      
      the answers to those questions (Visual Rule types) will match below to
      config details about those rules

      build ?`s to specify which rules for slots in areas on selected screens user wants to config
    ''',
    cascadeTypeOfMatchedQuest:
        QRespCascadePatternEm.addsWhichRulesForSlotsInArea,
    questIdPatternMatchTest: (qid) =>
        qid.startsWith(QuestionIdStrings.specSlotsToConfigInArea),
    //
    derivedQuestGen: DerivedQuestGenerator(
      'Select which rules to config within slot {0} in area {1} of screen {2}',
      newQuestPromptArgGen: (
        QuestBase priorAnsweredQuest,
        int newQuestIdx,
      ) {
        List<ScreenAreaWidgetSlot> respList =
            (priorAnsweredQuest.mainAnswer as List<ScreenAreaWidgetSlot>);
        // .toList();
        var slotName = respList[newQuestIdx].name;
        var areaName = priorAnsweredQuest.screenWidgetArea?.name ?? 'area';
        var screenName = priorAnsweredQuest.appScreen.name;
        return [
          slotName.toUpperCase(),
          areaName.toUpperCase(),
          screenName.toUpperCase()
        ];
      },
      newQuestCountCalculator: (QuestBase priorAnsweredQuest) {
        return (priorAnsweredQuest.mainAnswer as Iterable<dynamic>).length;
      },
      answerChoiceGenerator: (
        QuestBase priorAnsweredQuest,
        int newQuestIdx,
      ) {
        List<VisualRuleType> possibleRules =
            priorAnsweredQuest.qTargetIntent.possibleRulesForSlotInAreaOfScreen;
        return possibleRules.map((e) => e.name).toList();

        // List<ScreenAreaWidgetSlot> selectedAreaSlots =
        //     (priorAnsweredQuest.mainAnswer as Iterable<ScreenAreaWidgetSlot>)
        //         .toList();
        // ScreenAreaWidgetSlot curSlot = selectedAreaSlots[newQuestIdx];
        // ScreenWidgetArea curArea = priorAnsweredQuest.screenWidgetArea!;
        // return curSlot.possibleConfigRules(curArea).map((e) => e.name).toList();
      },
      qTargetIntentUpdaterCallbk: (
        QuestBase priorAnsweredQuest,
        int newQuestIdx,
      ) {
        // ScreenWidgetArea currArea = priorAnsweredQuest.screenWidgetArea!; //  ?? ScreenWidgetArea.header;
        // String currAreaName = currArea.name;
        List<ScreenAreaWidgetSlot> selectedAreaSlots =
            (priorAnsweredQuest.mainAnswer as List<ScreenAreaWidgetSlot>);
        // .toList();
        ScreenAreaWidgetSlot curSlot = selectedAreaSlots[newQuestIdx];
        return priorAnsweredQuest.qTargetIntent.copyWith(
          slotInArea: curSlot,
          cascadeType: // of created questions
              QRespCascadePatternEm.addsRuleDetailQuestsForSlotOrArea,
        );
      },
      perQuestGenOptions: [
        PerQuestGenResponsHandlingOpts<List<VisualRuleType>>(
          newRespCastFunc: (QuestBase newQuest, String lstAreaIdxs) {
            List<VisualRuleType> possibleRules =
                newQuest.qTargetIntent.possibleRulesForSlotInAreaOfScreen;
            return castStrOfIdxsToIterOfInts(lstAreaIdxs, dflt: 0)
                .map((i) => possibleRules[i])
                .toList();
          },
        ),
      ],
    ),
  ),

  // #6
  QuestMatcher<List<VisualRuleType>, String>(
    '''matches questions in which user specifies vis-rules to config on area-slots
      build ?s to specify specific rule config for each rule on those selected screen-areas

      the answers to those questions (VisRuleQuestType) will be the
      ui config for THAT RULE, on selected screen area SLOT
    ''',
    questIdPatternMatchTest: (qid) =>
        qid.startsWith(QuestionIdStrings.specRulesForSlotInArea),
    cascadeTypeOfMatchedQuest:
        QRespCascadePatternEm.addsRuleDetailQuestsForSlotOrArea,
    //
    derivedQuestGen: DerivedQuestGenerator(
      'Config rule {0} within slot {1} of area {2} on screen {3}',
      newQuestPromptArgGen: (
        QuestBase priorAnsweredQuest,
        int newQuestIdx,
      ) {
        List<VisualRuleType> respList =
            (priorAnsweredQuest.mainAnswer as List<VisualRuleType>);
        // .toList();
        var ruleName = respList[newQuestIdx].name;
        var slotName = priorAnsweredQuest.slotInArea?.name ?? 'slot';
        var areaName = priorAnsweredQuest.screenWidgetArea?.name ?? 'area';
        var screenName = priorAnsweredQuest.appScreen.name;
        return [
          ruleName.toUpperCase(),
          slotName.toUpperCase(),
          areaName.toUpperCase(),
          screenName.toUpperCase()
        ];
      },
      newQuestCountCalculator: (QuestBase priorAnsweredQuest) {
        return (priorAnsweredQuest.mainAnswer as Iterable<dynamic>).length;
      },
      newQuestIdGenFromPriorQuest: (
        QuestBase priorAnsweredQuest,
        int newQuIdx,
      ) {
        List<VisualRuleType> respList =
            (priorAnsweredQuest.mainAnswer as List<VisualRuleType>);
        // .toList();
        var ruleName = respList[newQuIdx].name;
        var targetPath = priorAnsweredQuest.targetPath + '-' + ruleName;
        return QuestionIdStrings.specRuleDetailsForSlotInArea +
            '-' +
            targetPath;
      },
      answerChoiceGenerator: (
        QuestBase priorAnsweredQuest,
        int newQuestIdx,
      ) {
        List<VisualRuleType> selectedRulesInArea =
            (priorAnsweredQuest.mainAnswer as List<VisualRuleType>);
        VisualRuleType curRule = selectedRulesInArea[newQuestIdx];

        List<VisRuleQuestType> reqCfgQuests = curRule.requConfigQuests;
        return reqCfgQuests.fold<List<String>>(
          [],
          (List<String> chLst, VisRuleQuestType qt) =>
              chLst..addAll(qt.choices),
        );
      },
      qTargetIntentUpdaterCallbk: (
        QuestBase priorAnsweredQuest,
        int newQuestIdx,
      ) {
        List<VisualRuleType> selectedRulesInArea =
            (priorAnsweredQuest.mainAnswer as List<VisualRuleType>);
        VisualRuleType curRule = selectedRulesInArea[newQuestIdx];
        return priorAnsweredQuest.qTargetIntent.copyWith(
          visRuleTypeForAreaOrSlot: curRule,
          cascadeType: // of created questions
              QRespCascadePatternEm.addsRuleDetailQuestsForSlotOrArea,
        );
      },
      perQuestGenOptions: [
        PerQuestGenResponsHandlingOpts<String>(
          newRespCastFunc: (
            QuestBase newQuest,
            String lstAreaIdxs,
          ) {
            return lstAreaIdxs;
          },
        ),
      ],
    ),
  ),

  // #7
  QuestMatcher<List<VisualRuleType>, List<VisRuleQuestType>>(
    '''matches questions in which user specifies vis-rules to config on screen-areas
      build ?s to specify specific rule config for each rule on those selected screen-areas

      the answers to those questions (VisRuleQuestType) will be the
      ui config for THAT RULE, on selected screen area
    ''',
    questIdPatternMatchTest: (qid) =>
        qid.startsWith(QuestionIdStrings.specRulesForAreaOnScreen),
    cascadeTypeOfMatchedQuest:
        QRespCascadePatternEm.addsRuleDetailQuestsForSlotOrArea,
    //
    derivedQuestGen: DerivedQuestGenerator(
      'Set details for rule {0} for slot {1} in area {2} of screen {3}',
      newQuestPromptArgGen: (
        QuestBase priorAnsweredQuest,
        int newQuestIdx,
      ) {
        List<VisualRuleType> userSelRuleTypeLst =
            (priorAnsweredQuest.mainAnswer as List<VisualRuleType>);

        VisualRuleType curRule = userSelRuleTypeLst[newQuestIdx];
        var slotName = priorAnsweredQuest.slotInArea?.name ?? 'n/a';
        var areaName = priorAnsweredQuest.screenWidgetArea?.name ?? 'area';
        var screenName = priorAnsweredQuest.appScreen.name;
        return [
          curRule.name.toUpperCase(),
          slotName.toUpperCase(),
          areaName.toUpperCase(),
          screenName.toUpperCase()
        ];
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
        ScreenAreaWidgetSlot? curSlotIfAvail = priorAnsweredQuest.slotInArea;
        String namePrefix = curSlotIfAvail == null
            ? QuestionIdStrings.specRuleDetailsForAreaOnScreen
            : QuestionIdStrings.specRuleDetailsForSlotInArea;

        String scrName = priorAnsweredQuest.appScreen.name;
        String area = priorAnsweredQuest.screenWidgetArea?.name ?? '-na';
        String slotName = curSlotIfAvail?.name ?? 'n/a';
        return namePrefix + '-' + scrName + '-' + area + '-' + slotName;
      },
      answerChoiceGenerator: (
        QuestBase priorAnsweredQuest,
        int newQuestIdx,
      ) {
        List<VisualRuleType> selectedRules =
            (priorAnsweredQuest.mainAnswer as List<VisualRuleType>);
        // .toList();
        VisualRuleType curRule = selectedRules[newQuestIdx];
        // ScreenWidgetArea curArea = priorAnsweredQuest.screenWidgetArea!;
        return curRule.requConfigQuests.map((e) => e.name).toList();
      },
      qTargetIntentUpdaterCallbk: (
        QuestBase priorAnsweredQuest,
        int newQuestIdx,
      ) {
        // ScreenWidgetArea currArea = priorAnsweredQuest.screenWidgetArea!; //  ?? ScreenWidgetArea.header;
        // String currAreaName = currArea.name;
        List<VisualRuleType> selectedRules =
            (priorAnsweredQuest.mainAnswer as List<VisualRuleType>);
        VisualRuleType curRule = selectedRules[newQuestIdx];
        // .toList();
        // ScreenAreaWidgetSlot slot = selectedAreaSlots[idx];
        return priorAnsweredQuest.qTargetIntent.copyWith(
          // screenWidgetArea: currArea,
          visRuleTypeForAreaOrSlot: curRule,
          cascadeType: // of created questions
              QRespCascadePatternEm.addsRuleDetailQuestsForSlotOrArea,
        );
      },
      perQuestGenOptions: [
        PerQuestGenResponsHandlingOpts(
          newRespCastFunc: (QuestBase newQuest, String lstAreaIdxs) {
            var curRule = newQuest.qTargetIntent.visRuleTypeForAreaOrSlot!;
            return castStrOfIdxsToIterOfInts(lstAreaIdxs, dflt: 0).map(
              (i) => curRule.requConfigQuests[i],
            );
          },
        ),
      ],
    ),
  ),

  // #8
  // QuestMatcher<List<VisualRuleType>, List<VisRuleQuestType>>(
  //   '''
  //   ''',
  //   // match by
  //   questIdPatternMatchTest: (qid) => qid == QuestionIdStrings.selectAppScreens,
  //   cascadeTypeOfMatchedQuest:
  //       QRespCascadePatternEm.addsWhichAreaInSelectedScreenQuestions,
  //   derivedQuestGen: DerivedQuestGenerator.noop(),
  //   deriveQuestGenCallbk: (QuestBase qb, int idx) {
  //     //
  //     return DerivedQuestGenerator.noop();
  //   },
  // ),

// #9
  QuestMatcher<VisualRuleType, int>(
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
        PerQuestGenResponsHandlingOpts(
          newRespCastFunc: (QuestBase qb, String ansr) => DbTableFieldName
              .values[int.tryParse(ansr) ?? CfgConst.cancelSortIndex],
          visRuleType: VisualRuleType.groupCfg,
          visRuleQuestType: VisRuleQuestType.selectDataFieldName,
        ),
      ],
    ),
  ),
];
