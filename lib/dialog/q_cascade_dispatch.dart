part of ConfigDialogRunner;

const List<QuestMatcher> _EMPTY_LST = const [];

class QCascadeDispatcher {
  List<QuestMatcher> matchersToGenTargetingQuests;
  List<QuestMatcher> matchersToGenRuleSelectQuests;
  List<QuestMatcher> matchersToGenRulePrepQuests;
  List<QuestMatcher> matchersToGenRuleDetailQuests;
  final GenStatsCollector statsCollector = GenStatsCollector();
  final bool testMode;

  QCascadeDispatcher({
    this.matchersToGenTargetingQuests = _EMPTY_LST,
    this.matchersToGenRuleSelectQuests = _EMPTY_LST,
    this.matchersToGenRulePrepQuests = _EMPTY_LST,
    this.matchersToGenRuleDetailQuests = _EMPTY_LST,
    this.testMode = false,
  }) {
    // will use scoretrader defaults unless args passed to constructor
    if (matchersToGenTargetingQuests.length < 1) {
      matchersToGenTargetingQuests = _getMatchersToGenTargetingQuests();
    }
    if (matchersToGenRuleSelectQuests.length < 1) {
      matchersToGenRuleSelectQuests = _getMatchersToGenRuleSelectQuests();
    }
    if (matchersToGenRulePrepQuests.length < 1) {
      matchersToGenRulePrepQuests = _getMatchersToGenRulePrepQuests();
    }
    if (matchersToGenRuleDetailQuests.length < 1) {
      matchersToGenRuleDetailQuests = _getMatchersToGenRuleDetailQuests();
    }
  }

  void appendNewQuestsOrInsertImplicitAnswers(
    QuestListMgr questListMgr,
    QuestBase questJustAnswered,
  ) {
    /*

    */
    // if (questJustAnswered.generatesNoNewQuestions) {
    //   print(
    //     'Info  QID: ' +
    //         questJustAnswered.questId +
    //         ' generates no new questions',
    //   );
    //   return;
    // } else {
    //   print(
    //     'appendNewQuestsOrInsertImplicitAnswers received QID:  ${questJustAnswered.questId}',
    //   );
    // }

    // collect q-gen stats
    if (testMode) {
      statsCollector.startCounting(questListMgr, questJustAnswered);
    }

    // generate questions based on type of just answered
    if (questJustAnswered.isEventConfigScreenEntryPointQuest) {
      // matching question is about: which screens to config?
      // it carries a list of app-screens and generator below
      // will create one question to select area-list for each screen
      print(
        '\tUser has specified which screens  (building "target" questions to ask which areas in those screens)',
      );
      QMatchCollection _qMatchCollToGenTarget =
          QMatchCollection(matchersToGenTargetingQuests);
      // next line will produce questions that are class RegionTargetQuest
      // and their answers will be handled by next branch below (isRegionTargetQuestion)
      _qMatchCollToGenTarget.appendNewQuestsOrInsertImplicitAnswers(
        questListMgr,
        questJustAnswered,
      );

      //
    } else if (questJustAnswered.isRegionTargetQuestion) {
      // target AREA questions created above (by isTopLevelEventConfigQuestion)
      // and passed here to generate questions about which slots to target
      // and ask which rules for previously selected area
      // print(
      //   '\tUser has specified Region target (area at least);  Now ask which slots in area, or rules for selected areas',
      // );

      var matchersForSlotsOrRules = questJustAnswered.targetPathIsComplete
          ? matchersToGenRuleSelectQuests //
          : matchersToGenTargetingQuests;

      // below is either ToGenSlotInArea or ToGenRuleSelect on area / slot
      QMatchCollection _qMatchColl = QMatchCollection(matchersForSlotsOrRules);
      _qMatchColl.appendNewQuestsOrInsertImplicitAnswers(
        questListMgr,
        questJustAnswered,
      );
    } else if (questJustAnswered.isRuleSelectionQuestion) {
      // user has selected rule for area or slot
      print(
        '\tUser has selected rule(s) for area or slot ${questJustAnswered.questId} (now gen rule-prep or rule-detail)',
      );
      var requiresRulePrepQuestion =
          questJustAnswered.requiresVisRulePrepQuestion ||
              questJustAnswered.requiresBehRulePrepQuestion;

      var matchersForPrepOrDetail = requiresRulePrepQuestion
          ? matchersToGenRulePrepQuests
          : matchersToGenRuleDetailQuests;

      var _qMatchCollToGenRulePrepOrDetail =
          QMatchCollection(matchersForPrepOrDetail);
      _qMatchCollToGenRulePrepOrDetail.appendNewQuestsOrInsertImplicitAnswers(
        questListMgr,
        questJustAnswered,
      );
      //
    } else if (questJustAnswered.isRulePrepQuestion) {
      print(
        '\tUser has answered rule prep quest (normally # of pos to configure)',
      );
      var _qMatchCollToGenRuleDetail =
          QMatchCollection(matchersToGenRuleDetailQuests);
      _qMatchCollToGenRuleDetail.appendNewQuestsOrInsertImplicitAnswers(
        questListMgr,
        questJustAnswered,
      );
    } else if (questJustAnswered.isVisRuleDetailQuestion) {
      // user has provided details for visual rule
      print(
        '\tvisual rule detail quest has been answered; no derived questions here',
      );
    } else if (questJustAnswered.isBehRuleDetailQuestion) {
      // user has provided details for behavioral rule
      print(
        '\tbehavior rule detail quest has been answered; no derived questions here',
      );
    }

    if (testMode) {
      // record how many new questions (both unanswered / pending and completed) were generated
      statsCollector.collectPostGenTotals(
        questListMgr,
        questJustAnswered,
        printSummary: testMode,
      );
    }
  }

  // begin static matchers lists
  List<QuestMatcher> _getMatchersToGenTargetingQuests() {
    //
    return [
      QuestMatcher<List<AppScreen>, List<ScreenWidgetArea>>(
        '''
      receive list of user selected app-screens
      and generate one question for each
      in which we ask which areas on that screen
      need to be configured
''',
        EventLevelCfgQuest,
        questIdPatternMatchTest: (String answQid) =>
            answQid.startsWith(QuestionIdStrings.selectAppScreens),
        validateUserAnswerAfterPatternMatchIsTrueCallback:
            (QuestBase priorAnsweredQuest) {
          var lst = priorAnsweredQuest.mainAnswer as Iterable<AppScreen>;
          return lst.length > 0 && priorAnsweredQuest.targetUncompleted;
        },
        derivedQuestGen: DerivedQuestGenerator.singlePrompt(
          'Select areas you want to configure on screen {0} (resp will gen which rule/slot for each area quest)',
          newQuestConstructor: QuestBase.regionTargetQuest,
          newQuestPromptArgGen: (
            QuestBase priorAnsweredQuest,
            int newQuIdx,
          ) {
            // produce args for {0} in prompt template above
            String nameOfScreenToConfig =
                (priorAnsweredQuest.mainAnswer as List<AppScreen>)[newQuIdx]
                    .name;
            return [nameOfScreenToConfig.toUpperCase()];
          },
          newQuestCountCalculator: (QuestBase priorAnsweredQuest) {
            // how many screens selected,
            // so how many new questions to generate?
            return (priorAnsweredQuest.mainAnswer as List<AppScreen>).length;
          },
          newQuestIdGenFromPriorQuest: (
            QuestBase priorAnsweredQuest,
            int newQuIdx,
          ) {
            /* each new question about area on screen should
          have an ID that lets the next QuestMatcher identify it to produce new Q's
          specAreasToConfigOnScreen is important so appropriate matchers fire
          on each of these answers
        */
            var selectedAppScreens =
                priorAnsweredQuest.mainAnswer as List<AppScreen>;
            String scrName = selectedAppScreens[newQuIdx].name;

            return QuestionIdStrings.specAreasToConfigOnScreen + '-' + scrName;
          },
          answerChoiceGenerator:
              (QuestBase priorAnsweredQuest, int newQuIdx, int promptIdx) {
            // show allowed possible answers for generated questions
            var selectedAppScreens =
                priorAnsweredQuest.mainAnswer as List<AppScreen>;
            var selectedAppScreen = selectedAppScreens[newQuIdx];
            return selectedAppScreen.configurableScreenAreas
                .map((swa) => swa.name)
                .toList();
          },
          deriveTargetFromPriorRespCallbk: (
            QuestBase priorAnsweredQuest,
            int newQuIdx,
          ) {
            // creates new target + intent (QTargetIntent) for each generated question
            var selectedAppScreens =
                priorAnsweredQuest.mainAnswer as List<AppScreen>;
            return priorAnsweredQuest.qTargetResolution.copyWith(
              appScreen: selectedAppScreens[newQuIdx],
              precision: TargetPrecision.targetLevel,
            );
          },
          /* params to handle converting user responses (String 0,1,2)
          on NEW QUESTIONS, into the expected response data-type
          each item in list below is 1-1 sync with quest-prompt being created
          if perQuestGenOptions.length < result of newQuestCountCalculator()
          then LAST item in perQuestGenOptions will be used to configure
          subsequent new questions

FIXME:
          TO CONSIDER:  what if generic type in PerQuestGenResponsHandlingOpts
          is different than 2nd generic type above in
            QuestMatcher<List<AppScreen>, List<ScreenWidgetArea>>
        that seems like a design mistake???
      */
          newRespCastFunc: (
            QuestBase newAnsQuest,
            String lstAreaIdxs,
          ) {
            List<ScreenWidgetArea> possibleAreasForScreen =
                newAnsQuest.qTargetResolution.possibleAreasForScreen;
            return castStrOfIdxsToIterOfInts(lstAreaIdxs, dflt: 0)
                .map(
                  (i) => possibleAreasForScreen[i],
                )
                .toList();
          },
          acceptsMultiResponses: true,
        ),
      ),
      QuestMatcher<List<ScreenWidgetArea>, List<ScreenAreaWidgetSlot>>(
        '''matches questions in which user has specified screen-areas to config
      build ?s to specify which SLOTS for those selected screen-areas

      the answers to those questions (Area Slots) will match below to
      ask WHICH rules for each selected slot
    ''',
        RegionTargetQuest,
        questIdPatternMatchTest: (String answQid) =>
            answQid.startsWith(QuestionIdStrings.specAreasToConfigOnScreen),
        validateUserAnswerAfterPatternMatchIsTrueCallback:
            (QuestBase priorAnsweredQuest) {
          var lst = priorAnsweredQuest.mainAnswer as Iterable<ScreenWidgetArea>;
          return lst.length > 0 && priorAnsweredQuest.targetUncompleted;
        },
        //
        derivedQuestGen: DerivedQuestGenerator.singlePrompt(
          // <List<ScreenWidgetArea>>
          'Select which slots to config within area {0} of screen {1}',
          newQuestConstructor: QuestBase.regionTargetQuest,
          newQuestPromptArgGen: (
            QuestBase priorAnsweredQuest,
            int newQuestIdx,
          ) {
            List<ScreenWidgetArea> respList =
                (priorAnsweredQuest.mainAnswer as List<ScreenWidgetArea>);
            var areaName = respList[newQuestIdx].name;
            var screenName = priorAnsweredQuest.appScreen.name;
            return [
              areaName.toUpperCase(),
              screenName.toUpperCase(),
            ];
          },
          bailQGenWhenTrueCallbk: (QuestBase priorAnsweredQuest, int qIdx) {
            // print('bail out of creating question when returns true');
            List<ScreenWidgetArea> respList =
                (priorAnsweredQuest.mainAnswer as List<ScreenWidgetArea>);
            return respList[qIdx]
                    .applicableWigetSlots(priorAnsweredQuest.appScreen)
                    .length <
                1;
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
            String area = priorAnsweredQuest.screenWidgetArea?.name ?? '-na11';
            return QuestionIdStrings.specSlotsToConfigInArea +
                '-' +
                scrName +
                '-' +
                area;
          },
          answerChoiceGenerator: (
            QuestBase priorAnsweredQuest,
            int newQuestIdx,
            int promptIdx,
          ) {
            List<ScreenWidgetArea> selectedScreenAreas =
                (priorAnsweredQuest.mainAnswer as List<ScreenWidgetArea>);
            return selectedScreenAreas[newQuestIdx]
                .applicableWigetSlots(priorAnsweredQuest.appScreen)
                .map((e) => e.name)
                .toList();
          },
          deriveTargetFromPriorRespCallbk: (
            QuestBase priorAnsweredQuest,
            int newQuestIdx,
          ) {
            List<ScreenWidgetArea> selectedScreenAreas =
                (priorAnsweredQuest.mainAnswer as List<ScreenWidgetArea>);
            ScreenWidgetArea currArea = selectedScreenAreas[newQuestIdx];
            // print(
            //   'info: make ? with target ${priorAnsweredQuest.targetPath} for $currArea',
            // );
            return priorAnsweredQuest.qTargetResolution.copyWith(
              screenWidgetArea: currArea,
              precision: TargetPrecision.targetLevel,
            );
          },
          newRespCastFunc: (
            QuestBase newQuest,
            String lstAreaIdxs,
          ) {
            List<ScreenAreaWidgetSlot> possibleSlots =
                newQuest.qTargetResolution.possibleSlotsForAreaInScreen;

            return castStrOfIdxsToIterOfInts(lstAreaIdxs, dflt: 0)
                .map((i) => possibleSlots[i])
                .toList();
          },
          acceptsMultiResponses: true,
        ),
      ),
      ..._matchRuleSelectionQuestions
    ];
  }

  static List<QuestMatcher> _getMatchersToGenRuleSelectQuests() {
    // rule select questions were generated above when target is complete
    return _matchRuleSelectionQuestions;
  }

  static List<QuestMatcher> _getMatchersToGenRulePrepQuests() {
    //
    return [
      QuestMatcher<List<VisualRuleType>, int>(
        '''matches questions in which user specifies rules for screen-areas to config
        and requiresVisRulePrepQuestion is true
      build ?s prep questions for these rules
    ''',
        RuleSelectQuest,
        questIdPatternMatchTest: (qid) =>
            qid.startsWith(QuestionIdStrings.specRulesForAreaOnScreen) ||
            qid.startsWith(QuestionIdStrings.specRulesForSlotInArea),
        validateUserAnswerAfterPatternMatchIsTrueCallback:
            (QuestBase priorAnsweredQuest) {
          var selectedRules =
              priorAnsweredQuest.mainAnswer as Iterable<VisualRuleType>;
          return priorAnsweredQuest is RuleSelectQuest &&
              selectedRules.length > 0 &&
              selectedRules.fold<bool>(
                  false,
                  (bool needsPrep, VisualRuleType vtr) =>
                      needsPrep || vtr.requiresVisRulePrepQuestion);
        },
        //
        derivedQuestGen: DerivedQuestGenerator.singlePrompt(
          '{0}',
          newQuestConstructor: QuestBase.rulePrepQuest,
          newQuestPromptArgGen: (
            QuestBase priorAnsweredQuest,
            int newQuestIdx,
          ) {
            List<VisualRuleType> respList =
                (priorAnsweredQuest.mainAnswer as List<VisualRuleType>);
            VisualRuleType curRule = respList[newQuestIdx];

            QTargetResolution newTarg =
                priorAnsweredQuest.qTargetResolution.copyWith(
              visRuleTypeForAreaOrSlot: curRule,
              precision: curRule.requiresVisRulePrepQuestion
                  ? TargetPrecision.rulePrep
                  : TargetPrecision.ruleDetailVisual,
            );
            String promptArg1 =
                curRule.prepTemplate.format([newTarg.targetPath]);
            return [promptArg1];
          },
          newQuestCountCalculator: (QuestBase priorAnsweredQuest) {
            // how many questions to generate
            var lstRules =
                priorAnsweredQuest.mainAnswer as Iterable<VisualRuleType>;
            return lstRules
                .where((rt) => rt.requiresVisRulePrepQuestion)
                .length;
          },
          newQuestIdGenFromPriorQuest: (
            QuestBase priorAnsweredQuest,
            int newQuIdx,
          ) {
            // each new question about area on screen should
            // have an ID that lets the next QM identify it to produce new Q's

            List<VisualRuleType> respList =
                (priorAnsweredQuest.mainAnswer as List<VisualRuleType>)
                    .where((rt) => rt.requiresVisRulePrepQuestion)
                    .toList();
            VisualRuleType curRule = respList[newQuIdx];

            QTargetResolution newTarg =
                priorAnsweredQuest.qTargetResolution.copyWith(
              visRuleTypeForAreaOrSlot: curRule,
              precision: curRule.requiresVisRulePrepQuestion
                  ? TargetPrecision.rulePrep
                  : TargetPrecision.ruleDetailVisual,
            );
            return QuestionIdStrings.prepQuestForVisRule + newTarg.targetPath;
          },
          answerChoiceGenerator: (
            QuestBase priorAnsweredQuest,
            int newQuestIdx,
            int promptIdx,
          ) {
            List<VisualRuleType> selectedScreenAreas =
                (priorAnsweredQuest.mainAnswer as List<VisualRuleType>)
                    .where((rt) => rt.requiresVisRulePrepQuestion)
                    .toList();
            VisualRuleType vrt = selectedScreenAreas[newQuestIdx];
            // bail out so question not created
            if (!vrt.requiresVisRulePrepQuestion) return [];
            return ['0', '1', '2', '3'];
          },
          deriveTargetFromPriorRespCallbk: (
            QuestBase priorAnsweredQuest,
            int newQuestIdx,
          ) {
            List<VisualRuleType> selectedRules =
                (priorAnsweredQuest.mainAnswer as List<VisualRuleType>)
                    .where((rt) => rt.requiresVisRulePrepQuestion)
                    .toList();
            VisualRuleType vrt = selectedRules[newQuestIdx];
            return priorAnsweredQuest.qTargetResolution.copyWith(
              visRuleTypeForAreaOrSlot: vrt,
              precision: TargetPrecision.rulePrep,
            );
          },
          newRespCastFunc: (
            QuestBase newQuest,
            String lstAreaIdxs,
          ) {
            //                 // .map((i) => '$i')
            return castStrOfIdxsToIterOfInts(lstAreaIdxs, dflt: 0)
                .toList()
                .first;
          },
          acceptsMultiResponses: false,
        ),
      )
    ];
  }

  static List<QuestMatcher> _getMatchersToGenRuleDetailQuests() {
    /* 
    these matchers need to catch answered questions that:
      1. specify rules directly
      2. specify rules indirectly via answers to rule-prep questions
      AND
      1. target (area or slot) is COMPLETE (path fully specified)
    
    they should NOT catch rule-select questions that REQUIRE prep questions
    or questions for which target is not yet complete
    those are caught above in _getMatchersToGenRulePrepQuests()

    we don't need to define specific DerivedQuestGenerator instances
    because each VisualRuleType knows how to produce it's own

  Explaining the generics here:
    QuestMatcher<AnsTypOfMatched, AnsTypOfGendExpectedAnswer>
      AnsTypOfMatched is the main answer type of matched question
      AnsTypOfGendExpectedAnswer is the main answer type of generated questions

  since all of these are rule-details questions, the
  AnsTypOfGendExpectedAnswer is always List<String>
  */
    return [
      QuestMatcher<List<VisualRuleType>, List<String>>(
        '''build rule details questions directly from rule-selection questions
        
        matches questions in which user specifies rules for
        screen-areas or slots to config
        not for rule-prep questions
        that matcher is below

      the answers to those questions (set of VisRuleQuestType) will be the
      ui config for THAT RULE, on selected screen area
    ''',
        RuleSelectQuest,
        questIdPatternMatchTest: (String qid) =>
            qid.startsWith(QuestionIdStrings.specRulesForAreaOnScreen) ||
            qid.startsWith(QuestionIdStrings.specRulesForSlotInArea),
        validateUserAnswerAfterPatternMatchIsTrueCallback:
            (QuestBase priorAnsweredQuest) {
          return (priorAnsweredQuest.mainAnswer as Iterable<VisualRuleType>)
                      .length >
                  0 &&
              priorAnsweredQuest.isRuleSelectionQuestion &&
              priorAnsweredQuest.targetPathIsComplete;
        },
        //
        derivedQuestGen: DerivedQuestGenerator.noop(),
        deriveQuestGenCallbk: (QuestBase priorAnsweredQuest, int newQuIdx) {
          //
          var answers = priorAnsweredQuest.mainAnswer as List<VisualRuleType>;
          VisualRuleType selRule = answers[newQuIdx];
          return priorAnsweredQuest.getDerivedRuleQuestGenViaVisType(
            newQuIdx,
            selRule,
          );
        },
      ),
      QuestMatcher<List<VisualRuleType>, List<String>>(
        '''builds actual rule-detail-config questions 
          from rule-prep questions
        
        matches rule prep questions for which user 
        specifies # of vis-rules to config on screen-areas
    ''',
        RulePrepQuest,
        questIdPatternMatchTest: (String qid) =>
            qid.startsWith(QuestionIdStrings.prepQuestForVisRule),
        validateUserAnswerAfterPatternMatchIsTrueCallback:
            (QuestBase priorAnsweredQuest) {
          // print(
          //   'priorAnsweredQuest.mainAnswer: ${priorAnsweredQuest.mainAnswer as int}',
          // );
          // print(
          //   'priorAnsweredQuest.isRulePrepQuestion: ${priorAnsweredQuest.isRulePrepQuestion}',
          // );
          // print(
          //   'priorAnsweredQuest.targetPathIsComplete: ${priorAnsweredQuest.targetPathIsComplete}',
          // );
          // List<String> rulePrepAnswers = priorAnsweredQuest.mainAnswer;
          // assert(rulePrepAnswers.length > 0, '');
          // int desiredCount = int.tryParse(rulePrepAnswers.first) ?? 1;
          int desiredCount = priorAnsweredQuest.mainAnswer;
          return desiredCount > 0 &&
              priorAnsweredQuest.isRulePrepQuestion &&
              priorAnsweredQuest.targetPathIsComplete;
        },
        //
        derivedQuestGen: DerivedQuestGenerator.noop(),
        deriveQuestGenCallbk: (QuestBase priorAnsweredQuest, int newQuIdx) {
          // var answers = priorAnsweredQuest.mainAnswer as List<VisualRuleType>;
          // VisualRuleType selRule = answers[newQuIdx];
          return priorAnsweredQuest.getDerivedRuleQuestGenViaVisType(
              newQuIdx, null);
        },
      ),
    ];
  }

  // test only
  List<QuestMatcher> get allMatchersTestOnly =>
      matchersToGenTargetingQuests +
      matchersToGenRuleSelectQuests +
      matchersToGenRulePrepQuests +
      matchersToGenRuleDetailQuests;

  //
  // void niu_createPrepQuestions(
  //   QuestListMgr questListMgr,
  //   QuestBase _answeredQuest,
  // ) {
  //   /*
  //     use intended rule info from current question
  //     to fabricate a DerivedQuestGenerator for each
  //     question-subtype
  //     and then use those to produce required new questions
  //   */
  //   assert(
  //     _answeredQuest is RuleSelectQuest,
  //     'cant produce detail quests from prevAnswQuest ${_answeredQuest.questId} which is a ${_answeredQuest.runtimeType}',
  //   );
  //   assert(
  //     _answeredQuest.visRuleTypeForAreaOrSlot != null,
  //     'oops; can only create rule-prep questions at vis-rule level',
  //   );
  //   VisualRuleType visRuleTyp = _answeredQuest.visRuleTypeForAreaOrSlot!;
  //   List<VisRuleQuestType> ruleSubtypeLst = visRuleTyp.requConfigQuests;

  //   assert(ruleSubtypeLst.isNotEmpty, 'need subtypes to guide prep');
  //   List<QuestBase> newQuests = [];
  //   for (VisRuleQuestType ruleSubtype in ruleSubtypeLst) {
  //     //
  //     DerivedQuestGenerator dqg =
  //         _answeredQuest.getDerivedRuleQuestGenViaVisType(ruleSubtype);
  //     Iterable<QuestBase> generatedQuestions =
  //         dqg.getDerivedAutoGenQuestions(_answeredQuest);
  //     newQuests.addAll(generatedQuestions);
  //   }

  //   questListMgr.appendGeneratedQuestsAndAnswers(newQuests);
  // }

  // void niu_createRuleDetailQuestions(
  //   QuestListMgr questListMgr,
  //   QuestBase _answeredQuest,
  // ) {
  //   /*
  //     use intended rule info from current question
  //     to fabricate a DerivedQuestGenerator for each
  //     question-subtype
  //     and then use those to produce required new questions
  //   */
  //   assert(
  //     _answeredQuest.visRuleTypeForAreaOrSlot != null &&
  //         (_answeredQuest.isRulePrepQuestion ||
  //             _answeredQuest.isRuleSelectionQuestion),
  //     'oops; can only create rule questions below the vis-rule level',
  //   );
  //   VisualRuleType visRuleTyp = _answeredQuest.visRuleTypeForAreaOrSlot!;
  //   List<VisRuleQuestType> ruleSubtypeLst = visRuleTyp.requConfigQuests;

  //   List<QuestBase> newQuests = [];
  //   for (VisRuleQuestType ruleSubtype in ruleSubtypeLst) {
  //     //
  //     DerivedQuestGenerator dqg =
  //         _answeredQuest.getDerivedRuleQuestGenViaVisType(ruleSubtype);
  //     Iterable<QuestBase> generatedQuestions =
  //         dqg.getDerivedAutoGenQuestions(_answeredQuest);
  //     newQuests.addAll(generatedQuestions);
  //   }

  //   questListMgr.appendGeneratedQuestsAndAnswers(newQuests);
  // }

  // end of def for QuestionCascadeDispatcher
}

List<QuestMatcher> _matchRuleSelectionQuestions = [
  QuestMatcher<List<ScreenWidgetArea>, List<VisualRuleType>>(
    '''matches questions in which user specifies screen-areas to config
      build ?s to specify which Rules to config for those selected screen-areas

      skip questions when no rules apply
    ''',
    RegionTargetQuest,
    questIdPatternMatchTest: (qid) =>
        qid.startsWith(QuestionIdStrings.specAreasToConfigOnScreen),
    validateUserAnswerAfterPatternMatchIsTrueCallback:
        (QuestBase priorAnsweredQuest) {
      return (priorAnsweredQuest.mainAnswer as Iterable<ScreenWidgetArea>)
              .length >
          0;
    },
    //
    derivedQuestGen: DerivedQuestGenerator.singlePrompt(
      // <List<ScreenWidgetArea>>
      'Select which rules to config within area {0} of screen {1}',
      newQuestConstructor: QuestBase.ruleSelectQuest,
      newQuestPromptArgGen: (
        QuestBase priorAnsweredQuest,
        int newQuestIdx,
      ) {
        List<ScreenWidgetArea> respList =
            (priorAnsweredQuest.mainAnswer as List<ScreenWidgetArea>);
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
        String area =
            (priorAnsweredQuest.mainAnswer as List<ScreenWidgetArea>)[newQuIdx]
                .name;
        return QuestionIdStrings.specRulesForAreaOnScreen +
            '-' +
            scrName +
            '-' +
            area;
      },
      answerChoiceGenerator:
          (QuestBase priorAnsweredQuest, int newQuestIdx, int promptIdx) {
        List<ScreenWidgetArea> selectedScreenAreas =
            (priorAnsweredQuest.mainAnswer as List<ScreenWidgetArea>);
        ScreenWidgetArea area = selectedScreenAreas[newQuestIdx];
        if (!area.isConfigureable) return [];
        return area
            .applicableRuleTypes(priorAnsweredQuest.appScreen)
            .map((e) => e.name)
            .toList();
      },
      deriveTargetFromPriorRespCallbk: (
        QuestBase priorAnsweredQuest,
        int newQuestIdx,
      ) {
        List<ScreenWidgetArea> selectedScreenAreas =
            (priorAnsweredQuest.mainAnswer as List<ScreenWidgetArea>);
        ScreenWidgetArea currArea = selectedScreenAreas[newQuestIdx];
        // print(
        //   'info: make ? with target ${priorAnsweredQuest.targetPath} for $currArea',
        // );
        return priorAnsweredQuest.qTargetResolution.copyWith(
          screenWidgetArea: currArea,
          precision: TargetPrecision.ruleSelect,
        );
      },
      newRespCastFunc: (
        QuestBase newQuest,
        String lstAreaIdxs,
      ) {
        List<VisualRuleType> possibleRules =
            newQuest.qTargetResolution.possibleRulesForAreaInScreen;

        return castStrOfIdxsToIterOfInts(lstAreaIdxs, dflt: 0)
            .map((i) => possibleRules[i])
            .toList();
      },
      acceptsMultiResponses: true,
    ),
  ),
  QuestMatcher<List<ScreenAreaWidgetSlot>, List<VisualRuleType>>(
    '''matches questions in which user specifies area-slots to config
      build ?s to specify which Rules to config for those selected screen-areas

      skip questions when no rules apply
    ''',
    RegionTargetQuest,
    questIdPatternMatchTest: (qid) =>
        qid.startsWith(QuestionIdStrings.specSlotsToConfigInArea),
    validateUserAnswerAfterPatternMatchIsTrueCallback:
        (QuestBase priorAnsweredQuest) {
      return (priorAnsweredQuest.mainAnswer as Iterable<ScreenAreaWidgetSlot>)
              .length >
          0;
    },
    //
    derivedQuestGen: DerivedQuestGenerator.singlePrompt(
      // <List<ScreenAreaWidgetSlot>>
      'Select which rules to config on slot {0} of area {1} of screen {2}',
      newQuestConstructor: QuestBase.ruleSelectQuest,
      newQuestPromptArgGen: (
        QuestBase priorAnsweredQuest,
        int newQuestIdx,
      ) {
        List<ScreenAreaWidgetSlot> selectedSlots =
            (priorAnsweredQuest.mainAnswer as List<ScreenAreaWidgetSlot>);
        var slotName = selectedSlots[newQuestIdx].name;
        var areaName = priorAnsweredQuest.screenWidgetArea?.name ?? '-na33';
        var screenName = priorAnsweredQuest.appScreen.name;
        return [
          slotName.toUpperCase(),
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
        String area = priorAnsweredQuest.screenWidgetArea!.name;
        String slot = (priorAnsweredQuest.mainAnswer
                as List<ScreenAreaWidgetSlot>)[newQuIdx]
            .name;
        return QuestionIdStrings.specRulesForSlotInArea +
            '-' +
            scrName +
            '-' +
            area +
            '-' +
            slot;
      },
      answerChoiceGenerator:
          (QuestBase priorAnsweredQuest, int newQuestIdx, int promptIdx) {
        List<ScreenAreaWidgetSlot> selectedScreenSlots =
            (priorAnsweredQuest.mainAnswer as List<ScreenAreaWidgetSlot>);
        ScreenAreaWidgetSlot slot = selectedScreenSlots[newQuestIdx];
        if (!slot.isConfigurableOn(priorAnsweredQuest.screenWidgetArea!))
          return [];
        return slot
            .possibleConfigRules(priorAnsweredQuest.screenWidgetArea!)
            .map((e) => e.name)
            .toList();
      },
      deriveTargetFromPriorRespCallbk: (
        QuestBase priorAnsweredQuest,
        int newQuestIdx,
      ) {
        List<ScreenAreaWidgetSlot> selectedScreenSlots =
            (priorAnsweredQuest.mainAnswer as List<ScreenAreaWidgetSlot>);
        ScreenAreaWidgetSlot slot = selectedScreenSlots[newQuestIdx];
        // print(
        //   'info: make ? with target ${priorAnsweredQuest.targetPath} for $currArea',
        // );
        return priorAnsweredQuest.qTargetResolution.copyWith(
          slotInArea: slot,
          precision: TargetPrecision.ruleSelect,
        );
      },
      newRespCastFunc: (
        QuestBase newQuest,
        String lstAreaIdxs,
      ) {
        List<VisualRuleType> possibleRules =
            newQuest.qTargetResolution.possibleRulesForAreaInScreen;

        return castStrOfIdxsToIterOfInts(lstAreaIdxs, dflt: 0)
            .map((i) => possibleRules[i])
            .toList();
      },
      acceptsMultiResponses: true,
    ),
  ),
];
