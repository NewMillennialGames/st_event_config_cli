part of ConfigDialogRunner;

/*
  future note for improvement:

  DONE:  see  QuestBase.derivedQuestTargetAtAnswerIdx

    many of the DerivedQuestGenerator instances below
    have a lot of code to cast an answer
    into a sublist of "reasonable" or possible
      (based on enum config)
    answers, before deciding WHICH answer to use
    in generation of the NEXT question

    most of this logic (possible sub-values) 
    is already implemented on each QTargetResolution
    instance (part of a question)

    if we could build a method on QuestBase
    that was smart enough to derive an answer
      (based on questIdx or promptIdx)
    and return a NEW, fully formed QTargetResolution
    instance, then we could centralize all this logic
    and reduce a lot of code duplication ...
*/

const List<QuestMatcher> _EMPTY_LST = const [];

class QCascadeDispatcher {
  List<QuestMatcher> matchersToGenEventDetailQuests;
  List<QuestMatcher> matchersToGenTargetingQuests;
  List<QuestMatcher> matchersToGenRuleSelectQuests;
  List<QuestMatcher> matchersToGenRulePrepQuests;
  List<QuestMatcher> matchersToGenRuleDetailQuests;
  final GenStatsCollector statsCollector = GenStatsCollector();
  final bool testMode;

  QCascadeDispatcher({
    this.matchersToGenEventDetailQuests = _EMPTY_LST,
    this.matchersToGenTargetingQuests = _EMPTY_LST,
    this.matchersToGenRuleSelectQuests = _EMPTY_LST,
    this.matchersToGenRulePrepQuests = _EMPTY_LST,
    this.matchersToGenRuleDetailQuests = _EMPTY_LST,
    this.testMode = false,
  }) {
    // will use scoretrader defaults unless args passed to constructor
    if (matchersToGenEventDetailQuests.length < 1) {
      matchersToGenEventDetailQuests = _getEventLevelMatchers();
    }
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
    //   ConfigLogger.log(Level.FINER,
    //     'Info  QID: ' +
    //         questJustAnswered.questId +
    //         ' generates no new questions',
    //   );
    //   return;
    // } else {
    //   ConfigLogger.log(Level.FINER,
    //     'appendNewQuestsOrInsertImplicitAnswers received QID:  ${questJustAnswered.questId}',
    //   );
    // }

    // collect q-gen stats
    if (testMode) {
      statsCollector.startCounting(questListMgr, questJustAnswered);
    }

    // generate questions based on type of just answered
    if (questJustAnswered.isEventConfigQuest) {
      // matching question is about: which screens to config?
      // it carries a list of app-screens and generator below
      // will create one question to select area-list for each screen

      // TODO: make below more generic based on target property
      if (!(questJustAnswered.mainAnswer is List<AppScreen>) &&
          questJustAnswered.questId != QuestionIdStrings.eventAgeOffGameRule) {
        print('bailing on ${questJustAnswered.questId}');
        return;
      }

      if (questJustAnswered.questId == QuestionIdStrings.eventAgeOffGameRule) {
        EvGameAgeOffRule gameAgeOffRule =
            questJustAnswered.mainAnswer as EvGameAgeOffRule;
        if (gameAgeOffRule != EvGameAgeOffRule.timeAfterGameEnds) return;

        QMatchCollection _qMatchCollToGenEventDetail =
            QMatchCollection(matchersToGenEventDetailQuests);

        List<QuestBase> newQuests =
            _qMatchCollToGenEventDetail.getGendQuestions(questJustAnswered);
        questListMgr.appendEventLvlQuests(newQuests, addAfterCurrent: true);
        print('just ran on:  ${questJustAnswered.questId}');
        return;
      }

      // String screenCfgTargets = (questJustAnswered.mainAnswer as List<AppScreen>)
      //     .fold<String>(
      //         '', (String allNames, AppScreen as) => allNames + as.name + '; ');
      // ConfigLogger.log(Level.FINER,
      //   '\tUser has specified ${topTargets} screens for configuration',
      // );
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
      // ConfigLogger.log(Level.FINER,
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
      // ConfigLogger.log(Level.FINER,
      //   '\tUser has selected rule(s) for area or slot ${questJustAnswered.questId} (now gen rule-prep or rule-detail)',
      // );

      var matchersForPrepOrDetail =
          matchersToGenRulePrepQuests + matchersToGenRuleDetailQuests;

      var _qMatchCollToGenRulePrepOrDetail =
          QMatchCollection(matchersForPrepOrDetail);
      _qMatchCollToGenRulePrepOrDetail.appendNewQuestsOrInsertImplicitAnswers(
        questListMgr,
        questJustAnswered,
      );
      //
    } else if (questJustAnswered.isRulePrepQuestion) {
      //ConfigLogger.log(Level.FINER,
      //   '\tUser has answered rule prep quest (normally # of pos to configure)',
      // );
      var _qMatchCollToGenRuleDetail =
          QMatchCollection(matchersToGenRuleDetailQuests);
      _qMatchCollToGenRuleDetail.appendNewQuestsOrInsertImplicitAnswers(
        questListMgr,
        questJustAnswered,
      );
    } else if (questJustAnswered.isVisRuleDetailQuestion) {
      // user has provided details for visual rule
      ConfigLogger.log(
        Level.INFO,
        '\tvisual rule detail quest has been answered; no derived questions here',
      );
    } else if (questJustAnswered.isBehRuleDetailQuestion) {
      // user has provided details for behavioral rule
      ConfigLogger.log(
        Level.INFO,
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
    /*  these QM's match with questions intended
        to specify "targets" (area/slots of screens)
        and create both deeper targeting questions
        (eg area with screen, or slot within area)
        as well as rule (prep or select) questions
          (only once target complete)
    */
    return [
      QuestMatcher<List<AppScreen>, List<ScreenWidgetArea>>(
        '''match quest containing list of app-screens that user wants to configure
      and generate one question for each in which we ask which areas
      on that screen will be configured
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
            int promptIdx,
          ) {
            // produce args for {0} in prompt template above
            QTargetResolution newQtr =
                priorAnsweredQuest.derivedQuestTargetAtAnswerIdx(
              newQuIdx,
              promptIdx,
            );
            return [newQtr.screenNmUpper];
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
            QTargetResolution newQtr =
                priorAnsweredQuest.derivedQuestTargetAtAnswerIdx(
              0,
              0,
            );

            return QuestionIdStrings.specAreasToConfigOnScreen +
                '-' +
                newQtr.screenNmUpper;
          },
          answerChoiceGenerator: (
            QuestBase priorAnsweredQuest,
            int newQuIdx,
            int promptIdx,
          ) {
            // show allowed possible answers for generated questions
            QTargetResolution newQtr =
                priorAnsweredQuest.derivedQuestTargetAtAnswerIdx(
              newQuIdx,
              promptIdx,
            );
            return newQtr.possibleAreasForScreen
                .map((swa) => swa.name)
                .toList();
          },
          deriveTargetFromPriorRespCallbk: (
            QuestBase priorAnsweredQuest,
            int newQuIdx,
          ) {
            //
            return priorAnsweredQuest.derivedQuestTargetAtAnswerIdx(
              newQuIdx,
              0,
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
          'Select which slots to config within area {0} of screen {1}',
          newQuestConstructor: QuestBase.regionTargetQuest,
          newQuestPromptArgGen: (
            QuestBase priorAnsweredQuest,
            int newQuestIdx,
            int promptIdx,
          ) {
            //
            QTargetResolution newQtr =
                priorAnsweredQuest.derivedQuestTargetAtAnswerIdx(
              newQuestIdx,
              promptIdx,
            );
            return [
              newQtr.areaNmUpper,
              newQtr.screenNmUpper,
            ];
          },
          bailQGenWhenTrueCallbk: (QuestBase priorAnsweredQuest, int qIdx) {
            // bail (return true) when no configurable slots exist in area of screen
            QTargetResolution newQtr =
                priorAnsweredQuest.derivedQuestTargetAtAnswerIdx(
              qIdx,
              0,
            );
            return newQtr.possibleSlotsForAreaInScreen.length < 1;
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
            // String scrName = priorAnsweredQuest.appScreen.name;
            // String area = priorAnsweredQuest.screenWidgetArea?.name ?? '-na11';
            // return QuestionIdStrings.specSlotsToConfigInArea +
            //     '-' +
            //     scrName +
            //     '-' +
            //     area;
            QTargetResolution newQtr =
                priorAnsweredQuest.derivedQuestTargetAtAnswerIdx(
              newQuIdx,
              0,
            );
            return QuestionIdStrings.specSlotsToConfigInArea +
                '-' +
                newQtr.targetPath;
          },
          answerChoiceGenerator: (
            QuestBase priorAnsweredQuest,
            int newQuestIdx,
            int promptIdx,
          ) {
            //
            QTargetResolution newQtr =
                priorAnsweredQuest.derivedQuestTargetAtAnswerIdx(
              newQuestIdx,
              promptIdx,
            );
            return newQtr.possibleSlotsForAreaInScreen
                .map((e) => e.name)
                .toList();
          },
          deriveTargetFromPriorRespCallbk: (
            QuestBase priorAnsweredQuest,
            int newQuestIdx,
          ) {
            //
            return priorAnsweredQuest.derivedQuestTargetAtAnswerIdx(
              newQuestIdx,
              0,
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
      ..._matchTargetCompleteAndGenRuleSelectQuests
    ];
  }

  static List<QuestMatcher> _getMatchersToGenRuleSelectQuests() {
    // target (or prep) questions were generated above
    // now use those answers to generate rule-seleciton questions
    return _matchTargetCompleteAndGenRuleSelectQuests;
  }

  static List<QuestMatcher> _getMatchersToGenRulePrepQuests() {
    //
    return [
      QuestMatcher<List<VisualRuleType>, int>(
        '''builds rule-prep questions (eg how many slots) from answers on rule-select question
        matches questions in which user specifies rules to config for an area or slot 
        and at least 1 selected rule requiresVisRulePrepQuestion
  --
      matcher to build rule-detail questions is below
    ''',
        RuleSelectQuest,
        questIdPatternMatchTest: (qid) =>
            qid.startsWith(QuestionIdStrings.specRulesForAreaOnScreen) ||
            qid.startsWith(QuestionIdStrings.specRulesForSlotInArea),
        validateUserAnswerAfterPatternMatchIsTrueCallback:
            (QuestBase priorAnsweredQuest) {
          var selectedRules =
              priorAnsweredQuest.mainAnswer as Iterable<VisualRuleType>;
          if (selectedRules.length < 1) return false;

          bool atLeastOneNeedsPrep = selectedRules.fold<bool>(
              false,
              (bool needsPrep, VisualRuleType vrt) =>
                  needsPrep || vrt.needsVisRulePrepQuestion);
          return atLeastOneNeedsPrep;
        },
        //
        derivedQuestGen: DerivedQuestGenerator.singlePrompt(
          '{0}', //  (rule prep ?)
          newQuestConstructor: QuestBase.rulePrepQuest,
          newQuestPromptArgGen: (
            QuestBase priorAnsweredQuest,
            int newQuestIdx,
            int promptIdx,
          ) {
            // using a special call for this class only
            QTargetResolution newQtr = (priorAnsweredQuest as RuleSelectQuest)
                .derivedQuestTargetAtAnswerIdxRuleSelection(
              newQuestIdx,
              selectionOffsetBehavior:
                  RuleSelectionOffsetBehavior.selectFromVrtNeedPrep,
            );
            String templ = newQtr.rulePromptTemplate(forRuleDetail: false);
            String promptArg1 = templ.format([newQtr.targetPath]);
            return [promptArg1];
          },
          newQuestCountCalculator: (QuestBase priorAnsweredQuest) {
            // how many questions to generate
            var lstRules =
                priorAnsweredQuest.mainAnswer as Iterable<VisualRuleType>;
            return lstRules.where((rt) => rt.needsVisRulePrepQuestion).length;
          },
          newQuestIdGenFromPriorQuest: (
            QuestBase priorAnsweredQuest,
            int newQuIdx,
          ) {
            // each new question about area on screen should
            // have an ID that lets the next QM identify it to produce new Q's
            QTargetResolution newQtr = (priorAnsweredQuest as RuleSelectQuest)
                .derivedQuestTargetAtAnswerIdxRuleSelection(
              newQuIdx,
              selectionOffsetBehavior:
                  RuleSelectionOffsetBehavior.selectFromVrtNeedPrep,
            );
            return QuestionIdStrings.prepQuestForVisRule +
                '-' +
                newQtr.targetPath;
          },
          answerChoiceGenerator: (
            QuestBase priorAnsweredQuest,
            int newQuestIdx,
            int promptIdx,
          ) {
            List<VisualRuleType> selectedScreenAreas =
                (priorAnsweredQuest.mainAnswer as List<VisualRuleType>)
                    .where((vrt) => vrt.needsVisRulePrepQuestion)
                    .toList();
            VisualRuleType vrt = selectedScreenAreas[newQuestIdx];
            // ConfigLogger.log(Level.FINER, 'VisualRuleType.name:  ${vrt.name}');
            // bail out so question not created
            if (!vrt.needsVisRulePrepQuestion) return [];
            return ['0', '1', '2', '3'];
          },
          deriveTargetFromPriorRespCallbk: (
            QuestBase priorAnsweredQuest,
            int newQuestIdx,
          ) {
            /* this call is special
                we use derivedQuestTargetAtAnswerIdxRuleSelection
                instead of derivedQuestTargetAtAnswerIdx
            */
            return (priorAnsweredQuest as RuleSelectQuest)
                .derivedQuestTargetAtAnswerIdxRuleSelection(
              newQuestIdx,
              selectionOffsetBehavior:
                  RuleSelectionOffsetBehavior.selectFromVrtNeedPrep,
            );
          },
          newRespCastFunc: (
            QuestBase newQuest,
            String lstAreaIdxs,
          ) {
            //  return # of (filter/sort/group) slots selected
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
        and the rules DO NOT require an intermediate "prep" step
        (eg not for rule-prep questions)
        rule-prep matcher is defined above

      the answers to those questions (set of VisRuleQuestType) will be the
      ui config for THAT RULE, on selected screen area
    ''',
        RuleSelectQuest,
        questIdPatternMatchTest: (String qid) =>
            qid.startsWith(QuestionIdStrings.specRulesForAreaOnScreen) ||
            qid.startsWith(QuestionIdStrings.specRulesForSlotInArea),
        validateUserAnswerAfterPatternMatchIsTrueCallback:
            (QuestBase priorAnsweredQuest) {
          Iterable<VisualRuleType> answr =
              priorAnsweredQuest.mainAnswer as Iterable<VisualRuleType>;
          Iterable<VisualRuleType> selRulesNoPrep =
              answr.where((vrt) => !vrt.needsVisRulePrepQuestion);
          bool atLeastOneHasNoPrep = selRulesNoPrep.length > 0;
          // ConfigLogger.log(Level.FINER,'atLeastOneHasNoPrep: $atLeastOneHasNoPrep');
          if (!atLeastOneHasNoPrep) return false;

          // ConfigLogger.log(Level.FINER,'validateUserAnswerAfterPatternMatchIsTrueCallback:');
          // ConfigLogger.log(Level.FINER, '\tAnswLen: ${selRulesNoPrep.length} (1 in example)');
          // ConfigLogger.log(Level.FINER,
          //     '\tisRuleSelectionQuestion: ${priorAnsweredQuest.isRuleSelectionQuestion}');
          //ConfigLogger.log(Level.FINER,
          //     '\ttargetPathIsComplete: ${priorAnsweredQuest.targetPathIsComplete}');
          // ConfigLogger.log(Level.FINER,'\ttargetPath: ${priorAnsweredQuest.targetPath}');
          // ConfigLogger.log(Level.FINER,'\tatLeastOneHasNoPrep: ${atLeastOneHasNoPrep}');
          return priorAnsweredQuest.isRuleSelectionQuestion &&
              priorAnsweredQuest.targetPathIsComplete;
        },
        //
        derivedQuestGen: DerivedQuestGenerator.noop(),
        deriveQuestGenCallbk: (QuestBase priorAnsweredQuest, int newQuIdx) {
          //
          RuleSelectQuest ansRuleSelQuest =
              priorAnsweredQuest as RuleSelectQuest;

          QTargetResolution newQtr =
              ansRuleSelQuest.derivedQuestTargetAtAnswerIdxRuleSelection(
            newQuIdx,
            selectionOffsetBehavior:
                RuleSelectionOffsetBehavior.selectFromVrtNoPrep,
          );

          VisualRuleType selRule = newQtr.visRuleTypeForAreaOrSlot!;
          // bail out if requiresVisRulePrepQuestion
          if (selRule.needsVisRulePrepQuestion)
            return DerivedQuestGenerator.noop();

          return ansRuleSelQuest.getDerivedRuleQuestGenViaVisType(newQtr);
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
          // ConfigLogger.log(Level.FINER,
          //   'rulePrep:  priorAnsweredQuest.mainAnswer: ${priorAnsweredQuest.mainAnswer as int}',
          // );
          // ConfigLogger.log(Level.FINER,
          //   '\tpriorAnsweredQuest.targetPathIsComplete: ${priorAnsweredQuest.targetPathIsComplete}',
          // );

          // int desiredCount = int.tryParse(rulePrepAnswers.first) ?? 1;
          int desiredCount = priorAnsweredQuest.mainAnswer;
          return desiredCount > 0 &&
              priorAnsweredQuest.isRulePrepQuestion &&
              priorAnsweredQuest.targetPathIsComplete;
        },
        //
        derivedQuestGen: DerivedQuestGenerator.noop(),
        deriveQuestGenCallbk: (
          QuestBase priorAnsweredRulePrepQuest,
          int newQuIdx,
        ) {
          //
          RulePrepQuest ansRulePrepQuest =
              priorAnsweredRulePrepQuest as RulePrepQuest;

          QTargetResolution newQtr =
              ansRulePrepQuest.derivedQuestTargetAtAnswerIdx(newQuIdx, 0);
          return ansRulePrepQuest.getDerivedRuleQuestGenViaVisType(newQtr);
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
}

List<QuestMatcher> _matchTargetCompleteAndGenRuleSelectQuests = [
  QuestMatcher<List<ScreenWidgetArea>, List<VisualRuleType>>(
    '''matches questions in which user specifies screen-areas to config
      (meaning target-path is complete in matched question)
      build ?s to specify which Rules are needed
      for those selected screen-areas

      skip questions when no rules apply to a selected area
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
      'Select which rules to config within area {0} of screen {1}',
      newQuestConstructor: QuestBase.ruleSelectQuest,
      newQuestPromptArgGen: (
        QuestBase priorAnsweredQuest,
        int newQuestIdx,
        int promptIdx,
      ) {
        //
        QTargetResolution newQtr =
            priorAnsweredQuest.derivedQuestTargetAtAnswerIdx(
          newQuestIdx,
          promptIdx,
          forRuleSelection: true,
        );
        var screenAreasWithRules = newQtr.possibleAreasForScreen;

        var areaName = screenAreasWithRules[newQuestIdx].name;
        var screenName = newQtr.appScreen.name;
        return [
          areaName.toUpperCase(),
          screenName.toUpperCase(),
        ];
      },
      newQuestCountCalculator: (QuestBase priorAnsweredQuest) {
        var selectedScreenAreas =
            priorAnsweredQuest.mainAnswer as Iterable<ScreenWidgetArea>;
        var screenAreasWithRules = selectedScreenAreas.where(
            (swa) => swa.isConfigureableOnScreen(priorAnsweredQuest.appScreen));

        // ConfigLogger.log(Level.FINER,
        //   '(((((( screenAreasWithRules.len ${screenAreasWithRules.length}  (${qtr2.possibleRulesForAreaInScreen.length})',
        // );
        return screenAreasWithRules.length;
      },
      newQuestIdGenFromPriorQuest: (
        QuestBase priorAnsweredQuest,
        int newQuestIdx,
      ) {
        // each new question about area on screen should
        // have an ID that lets the next QM identify it to produce new Q's
        QTargetResolution newQtr =
            priorAnsweredQuest.derivedQuestTargetAtAnswerIdx(
          newQuestIdx,
          0,
          forRuleSelection: true,
        );
        return QuestionIdStrings.specRulesForAreaOnScreen +
            '-' +
            newQtr.targetPath;
      },
      answerChoiceGenerator: (
        QuestBase priorAnsweredQuest,
        int newQuestIdx,
        int promptIdx,
      ) {
        List<ScreenWidgetArea> selectedScreenAreas =
            (priorAnsweredQuest.mainAnswer as List<ScreenWidgetArea>);
        var screenAreasWithRules = selectedScreenAreas
            .where((swa) =>
                swa.applicableRuleTypes(priorAnsweredQuest.appScreen).length >
                0)
            .toList();

        ScreenWidgetArea area = screenAreasWithRules[newQuestIdx];
        if (area.applicableRuleTypes(priorAnsweredQuest.appScreen).length < 1)
          return [];

        return area
            .applicableRuleTypes(priorAnsweredQuest.appScreen)
            .map((e) => e.name)
            .toList();
      },
      deriveTargetFromPriorRespCallbk: (
        QuestBase priorAnsweredQuest,
        int newQuestIdx,
      ) {
        //
        return priorAnsweredQuest.derivedQuestTargetAtAnswerIdx(
          newQuestIdx,
          0,
          forRuleSelection: true,
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
      build ?s to specify which Rules to config for those
      specific area-slots

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
      'Select which rules to config on slot {0} of area {1} of screen {2}',
      newQuestConstructor: QuestBase.ruleSelectQuest,
      newQuestPromptArgGen: (
        QuestBase priorAnsweredQuest,
        int newQuestIdx,
        int promptIdx,
      ) {
        //
        QTargetResolution newQtr =
            priorAnsweredQuest.derivedQuestTargetAtAnswerIdx(
          newQuestIdx,
          promptIdx,
          forRuleSelection: true,
        );
        return [
          newQtr.slotNmUpper,
          newQtr.areaNmUpper,
          newQtr.screenNmUpper,
        ];
      },
      newQuestCountCalculator: (QuestBase priorAnsweredQuest) {
        return (priorAnsweredQuest.mainAnswer as Iterable<dynamic>).length;
      },
      newQuestIdGenFromPriorQuest: (
        QuestBase priorAnsweredQuest,
        int newQuestIdx,
      ) {
        // each new question about area on screen should
        // have an ID that lets the next QM identify it to produce new Q's
        QTargetResolution newQtr =
            priorAnsweredQuest.derivedQuestTargetAtAnswerIdx(
          newQuestIdx,
          0,
          forRuleSelection: true,
        );
        return QuestionIdStrings.specRulesForSlotInArea +
            '-' +
            newQtr.targetPath;
      },
      answerChoiceGenerator: (
        QuestBase priorAnsweredQuest,
        int newQuestIdx,
        int promptIdx,
      ) {
        //
        QTargetResolution newQtr =
            priorAnsweredQuest.derivedQuestTargetAtAnswerIdx(
          newQuestIdx,
          promptIdx,
          forRuleSelection: true,
        );
        ScreenAreaWidgetSlot slot = newQtr.slotInArea!;
        if (!slot.isConfigurableOn(priorAnsweredQuest.screenWidgetArea!))
          return [];
        return newQtr.possibleRulesForSlotInAreaOfScreen
            .map((e) => e.name)
            .toList();
      },
      deriveTargetFromPriorRespCallbk: (
        QuestBase priorAnsweredQuest,
        int newQuestIdx,
      ) {
        //
        return priorAnsweredQuest.derivedQuestTargetAtAnswerIdx(
          newQuestIdx,
          0,
          forRuleSelection: true,
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

List<QuestMatcher> _getEventLevelMatchers() {
  //
  return [
    QuestMatcher<EvGameAgeOffRule, double>(
      '''builds quests in response to answers at event level''',
      EventLevelCfgQuest,
      questIdPatternMatchTest: (qid) =>
          qid == QuestionIdStrings.eventAgeOffGameRule,
      validateUserAnswerAfterPatternMatchIsTrueCallback:
          (QuestBase priorAnsweredQuest) {
        EvGameAgeOffRule ageRule =
            priorAnsweredQuest.mainAnswer as EvGameAgeOffRule;

        return EvGameAgeOffRule.timeAfterGameEnds == ageRule;
      },
      //
      derivedQuestGen: DerivedQuestGenerator.singlePrompt(
        '{0}', //  event config
        newQuestConstructor: QuestBase.eventLevelCfgQuest,
        newQuestPromptArgGen: (
          QuestBase priorAnsweredQuest,
          int newQuestIdx,
          int promptIdx,
        ) {
          return [EvGameAgeOffRule.timeAfterGameEnds.prompt];
        },
        newQuestCountCalculator: (QuestBase priorAnsweredQuest) {
          // how many questions to generate
          return 1;
        },
        newQuestIdGenFromPriorQuest: (
          QuestBase priorAnsweredQuest,
          int newQuIdx,
        ) {
          return QuestionIdStrings.eventAgeOffGameRuleHoursAfter;
        },
        answerChoiceGenerator: (
          QuestBase priorAnsweredQuest,
          int newQuestIdx,
          int promptIdx,
        ) {
          return [
            'Type hours to wait (decimals allowed) below & press return',
            ''
          ];
        },
        deriveTargetFromPriorRespCallbk: (
          QuestBase priorAnsweredQuest,
          int newQuestIdx,
        ) {
          /* */
          return (priorAnsweredQuest as EventLevelCfgQuest)
              .derivedQuestTargetAtAnswerIdx(
            newQuestIdx,
            1,
            forRuleSelection: false,
          );
        },
        newRespCastFunc: (
          QuestBase newQuest,
          String hoursToWaitAsStr,
        ) {
          return double.tryParse(hoursToWaitAsStr) ?? 2.0;
        },
        acceptsMultiResponses: false,
      ),
    )
  ];
}
