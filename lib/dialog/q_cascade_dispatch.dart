part of ConfigDialogRunner;

class QuestionCascadeDispatcher {
  // handles logic for creating new questions
  final QMatchCollection _qMatchColl;

  QuestionCascadeDispatcher(QMatchCollection? qTargetMatchColl)
      : _qMatchColl = qTargetMatchColl != null
            ? qTargetMatchColl
            : QMatchCollection.scoretrader() {}

  void appendNewQuestsOrInsertImplicitAnswers(
    QuestListMgr questListMgr,
    QuestBase questJustAnswered,
  ) {
    /*

    */
    print(
      'appendNewQuestsOrInsertImplicitAnswers received QID:  ${questJustAnswered.questId}',
    );
    if (questJustAnswered.generatesNoNewQuestions) return;

    if (questJustAnswered.isTopLevelEventConfigQuestion) {
      // matching question is about: which screens to config?
      print('\tWhich screens');
      DerivedQuestGenerator<List<AppScreen>> genAreaInScreenSelectQuests =
          _getAreaDerGen();
      List<QuestBase> newQuests = genAreaInScreenSelectQuests
          .getDerivedAutoGenQuestions(questJustAnswered, null);
      questListMgr.appendGeneratedQuestsAndAnswers(newQuests);
      //
    } else if (questJustAnswered.isRegionTargetQuestion) {
      // creat questions to specify slot to target, or rule for selected area
      print('\tRegion target');
      _qMatchColl.appendNewQuestsOrInsertImplicitAnswers(
        questListMgr,
        questJustAnswered,
      );
    } else if (questJustAnswered.isRuleSelectionQuestion) {
      // pick which rule for area or slot
      print('\tRule selection');

      List<QuestBase> newQuests;
      if (questJustAnswered.slotInArea != null) {
        DerivedQuestGenerator<List<ScreenAreaWidgetSlot>> dqg =
            _getQuesGenForRuleInSlot();
        newQuests = dqg.getDerivedAutoGenQuestions(questJustAnswered, null);
      } else {
        DerivedQuestGenerator<List<ScreenWidgetArea>> dqg =
            _getQuesGenForRuleInArea();
        newQuests = dqg.getDerivedAutoGenQuestions(questJustAnswered, null);
      }
      questListMgr.appendGeneratedQuestsAndAnswers(newQuests);
      //
    } else if (questJustAnswered.isRulePrepQuestion) {
      // optional; ask how many detail prompts to produce
      print('\trule prep');
    } else if (questJustAnswered.isVisRuleDetailQuestion) {
      // collect details for visual rule
      print('\tvisual rule details');
    } else if (questJustAnswered.isBehRuleDetailQuestion) {
      // collect details for a behavioral rule
      print('\behave rule details');
    }
  }

  // void gentNewQuestionsFromUserResponse(
  //   QuestListMgr questListMgr,
  //   QuestBase questJustAnswered,
  // ) {
  //   // TODO:
  // }
}

DerivedQuestGenerator<List<AppScreen>> _getAreaDerGen() {
  //
  return DerivedQuestGenerator<List<AppScreen>>(
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
      var selectedAppScreens = priorAnsweredQuest.mainAnswer as List<AppScreen>;
      String scrName = selectedAppScreens[newQuIdx].name;
      return QuestionIdStrings.specAreasToConfigOnScreen + '-' + scrName;
    },
    answerChoiceGenerator: (
      QuestBase priorAnsweredQuest,
      int newQuIdx,
    ) {
      // show allowed possible answers for generated questions
      // return List<String>
      var selectedAppScreens = priorAnsweredQuest.mainAnswer as List<AppScreen>;
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
      var selectedAppScreens = priorAnsweredQuest.mainAnswer as List<AppScreen>;
      return priorAnsweredQuest.qTargetIntent.copyWith(
        appScreen: selectedAppScreens[newQuIdx],
        // screenWidgetArea:
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
  );
}

DerivedQuestGenerator<List<ScreenWidgetArea>> _getQuesGenForRuleInArea() {
  //
  return DerivedQuestGenerator(
    'Select which rules to add on area {0} of screen {1} (answ will generate rule detail quests)',
    newQuestConstructor: QuestBase.ruleSelectQuest,
    newQuestPromptArgGen: (
      QuestBase priorAnsweredQuest,
      int newQuestIdx,
    ) {
      List<VisualRuleType> selectedRulesForArea =
          (priorAnsweredQuest.mainAnswer as Iterable<VisualRuleType>).toList();

      String areaName = priorAnsweredQuest.screenWidgetArea?.name ?? '-na';
      String screenName = priorAnsweredQuest.appScreen.name;
      // var curArea = selectedRulesForArea[newQuestIdx];
      return [
        areaName.toUpperCase(),
        screenName.toUpperCase(),
      ];
    },
    newQuestCountCalculator: (QuestBase priorAnsweredQuest) {
      return (priorAnsweredQuest.mainAnswer as Iterable<VisualRuleType>).length;
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
      // List<ScreenWidgetArea> selectedScreenAreas =
      //     (priorAnsweredQuest.mainAnswer as Iterable<ScreenWidgetArea>)
      //         .toList();
      // ScreenWidgetArea selectedArea = selectedScreenAreas[idx];
      // return selectedArea
      //     .applicableRuleTypes(priorAnsweredQuest.appScreen)
      //     .map((e) => e.name)
      //     .toList();

      List<VisualRuleType> selectedRulesForArea =
          (priorAnsweredQuest.mainAnswer as Iterable<VisualRuleType>).toList();
      VisualRuleType selectedRule = selectedRulesForArea[idx];
      return selectedRule.requConfigQuests
          // .applicableRuleTypes(priorAnsweredQuest.appScreen)
          .map((e) => e.name)
          .toList();
    }),
    qTargetIntentUpdaterCallbk: (
      QuestBase priorAnsweredQuest,
      int newQuestIdx,
    ) {
      List<VisualRuleType> selectedRulesForArea =
          (priorAnsweredQuest.mainAnswer as Iterable<VisualRuleType>).toList();
      VisualRuleType currRule = selectedRulesForArea[newQuestIdx];
      return priorAnsweredQuest.qTargetIntent.copyWith(
        visRuleTypeForAreaOrSlot: currRule,
      );
    },
    perQuestGenOptions: [
      PerQuestGenResponsHandlingOpts<List<VisualRuleType>>(
        newRespCastFunc: (
          QuestBase newAnsQuest,
          String lstVisRuleIdxs,
        ) {
          List<VisualRuleType> possibleRules =
              newAnsQuest.qTargetIntent.possibleRulesForAreaInScreen;
          return castStrOfIdxsToIterOfInts(lstVisRuleIdxs, dflt: 0)
              .map(
                (i) => possibleRules[i],
              )
              .toList();
        },
      ),
    ],
  );
}

DerivedQuestGenerator<List<ScreenAreaWidgetSlot>> _getQuesGenForRuleInSlot() {
  //
  return DerivedQuestGenerator(
    'Select which rules to add for slot {0} in area {1} of screen {2} (answ will generate rule detail quests)',
    newQuestConstructor: QuestBase.ruleSelectQuest,
    newQuestPromptArgGen: (
      QuestBase priorAnsweredQuest,
      int newQuestIdx,
    ) {
      List<ScreenAreaWidgetSlot> slotToConfig =
          (priorAnsweredQuest.mainAnswer as Iterable<ScreenAreaWidgetSlot>)
              .toList();
      String slotName = slotToConfig[newQuestIdx].name;
      String areaName = priorAnsweredQuest.screenWidgetArea?.name ?? '-na';
      String screenName = priorAnsweredQuest.appScreen.name;
      return [
        slotName.toUpperCase(),
        areaName.toUpperCase(),
        screenName.toUpperCase(),
      ];
    },
    newQuestCountCalculator: (QuestBase priorAnsweredQuest) {
      return (priorAnsweredQuest.mainAnswer as Iterable<ScreenAreaWidgetSlot>)
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
      List<ScreenAreaWidgetSlot> selectedScreenSlots =
          (priorAnsweredQuest.mainAnswer as Iterable<ScreenAreaWidgetSlot>)
              .toList();
      ScreenAreaWidgetSlot selectedSlot = selectedScreenSlots[idx];
      return selectedSlot
          .possibleConfigRules(priorAnsweredQuest.screenWidgetArea!)
          .map((e) => e.name)
          .toList();
    }),
    qTargetIntentUpdaterCallbk: (
      QuestBase priorAnsweredQuest,
      int newQuestIdx,
    ) {
      List<ScreenAreaWidgetSlot> selectedAreaSlots =
          (priorAnsweredQuest.mainAnswer as Iterable<ScreenAreaWidgetSlot>)
              .toList();
      ScreenAreaWidgetSlot currSlot = selectedAreaSlots[newQuestIdx];
      return priorAnsweredQuest.qTargetIntent.copyWith(slotInArea: currSlot);
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
  );
}
