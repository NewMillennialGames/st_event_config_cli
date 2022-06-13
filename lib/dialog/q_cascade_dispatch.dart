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
      print('\twhich screens');
      DerivedQuestGenerator<List<AppScreen>> genAreaInScreenSelectQuests =
          _getAreaDerGen();
      List<QuestBase> newQuests = genAreaInScreenSelectQuests
          .getDerivedAutoGenQuestions(questJustAnswered, null);
      questListMgr.appendGeneratedQuestsAndAnswers(newQuests);
      //
    } else if (questJustAnswered.isRegionTargetQuestion) {
      // creat questions to specify slot to target, or rule for selected area
      print('\tregion target');
      _qMatchColl.appendNewQuestsOrInsertImplicitAnswers(
        questListMgr,
        questJustAnswered,
      );
    } else if (questJustAnswered.isRuleSelectionQuestion) {
      // pick which rule for area or slot
      print('\trule selection');
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
      // FIXME:  cascadeType: // of created questions
      // QRespCascadePatternEm.respCreatesWhichRulesForAreaOrSlotQuestions,
      return priorAnsweredQuest.qTargetIntent.copyWith(
        appScreen: selectedAppScreens[newQuIdx],
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
