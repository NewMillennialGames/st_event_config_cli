part of ConfigDialogRunner;

const List<QuestMatcher> _EMPTY_LST = const [];

class QuestionCascadeDispatcher {
  List<QuestMatcher> matchersToGenTargetingQuests;
  List<QuestMatcher> matchersToGenRuleSelectQuests;
  List<QuestMatcher> matchersToGenRulePrepQuests;
  List<QuestMatcher> matchersToGenRuleDetailQuests;

  QuestionCascadeDispatcher({
    this.matchersToGenTargetingQuests = _EMPTY_LST,
    this.matchersToGenRuleSelectQuests = _EMPTY_LST,
    this.matchersToGenRulePrepQuests = _EMPTY_LST,
    this.matchersToGenRuleDetailQuests = _EMPTY_LST,
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
      matchersToGenRuleDetailQuests = _getMatchersToGenRulePrepQuests();
    }
  }

  void appendNewQuestsOrInsertImplicitAnswers(
    QuestListMgr questListMgr,
    QuestBase questJustAnswered,
  ) {
    /*

    */
    if (questJustAnswered.generatesNoNewQuestions) {
      print(
        'Info  QID: ' +
            questJustAnswered.questId +
            ' generates no new questions',
      );
      return;
    } else {
      print(
        'appendNewQuestsOrInsertImplicitAnswers received QID:  ${questJustAnswered.questId}',
      );
    }

    if (questJustAnswered.isTopLevelEventConfigQuestion) {
      // matching question is about: which screens to config?
      // it carries a list of app-screens and generator below
      // will create one question to select area-list for each screen
      print(
        '\tUser has specified which screens  (building questions to ask which areas in those screens)',
      );
      QMatchCollection _qMatchCollToGenTarget =
          QMatchCollection(matchersToGenTargetingQuests);
      // next line will produce questions that are class RegionTargetQuest
      // and their answers will be handled by next branch below (isRegionTargetQuestion)
      _qMatchCollToGenTarget.appendNewQuestsOrInsertImplicitAnswers(
        questListMgr,
        questJustAnswered,
      );
      return;
      //
    } else if (questJustAnswered.isRegionTargetQuestion) {
      // target AREA questions created above (by isTopLevelEventConfigQuestion)
      // and passed here to generate questions about which slots to target
      // and ask which rules for previously selected area
      print(
        '\tUser has specified Region target (area at least);  Now ask which slots in area, or rules for selected areas',
      );

      var matchersForSlotsOrRules = questJustAnswered.targetPathIsComplete
          ? matchersToGenRuleSelectQuests // currently empty
          : matchersToGenTargetingQuests;

      // below is either ToGenSlotInArea or ToGenRuleSelect on area / slot
      QMatchCollection _qMatchColl = QMatchCollection(matchersForSlotsOrRules);
      _qMatchColl.appendNewQuestsOrInsertImplicitAnswers(
        questListMgr,
        questJustAnswered,
      );
      return;
    } else if (questJustAnswered.isRuleSelectionQuestion) {
      // user has selected rule for area or slot
      print(
        '\tUser has selected rule for area or slot ${questJustAnswered.questId} (now gen rule-prep or rule detail)',
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
      return;
      //
    } else if (questJustAnswered.isRulePrepQuestion) {
      print(
          '\tUser has answered rule prep quest (normally how many slots to configure)');
      var _qMatchCollToGenRuleDetail =
          QMatchCollection(matchersToGenRuleDetailQuests);
      _qMatchCollToGenRuleDetail.appendNewQuestsOrInsertImplicitAnswers(
        questListMgr,
        questJustAnswered,
      );
      return;
    } else if (questJustAnswered.isVisRuleDetailQuestion) {
      // user has provided details for visual rule
      print(
        '\tvisual rule detail quest has been answered; no derived questions here',
      );
      return;
    } else if (questJustAnswered.isBehRuleDetailQuestion) {
      // user has provided details for behavioral rule
      print(
        '\tbehavior rule detail quest has been answered; no derived questions here',
      );
      return;
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
        questIdPatternMatchTest: (String answQid) =>
            answQid.startsWith(QuestionIdStrings.selectAppScreens),
        validateUserAnswerAfterPatternMatchIsTrueCallback:
            (QuestBase priorAnsweredQuest) {
          var lst = priorAnsweredQuest.mainAnswer as Iterable<AppScreen>;
          return lst.length > 0 && !priorAnsweredQuest.targetPathIsComplete;
        },
        derivedQuestGen: DerivedQuestGenerator<List<AppScreen>>(
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
          answerChoiceGenerator: (
            QuestBase priorAnsweredQuest,
            int newQuIdx,
          ) {
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
          perNewQuestGenOpts: [
            PerQuestGenResponsHandlingOpts<List<ScreenWidgetArea>>(
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
            ),
          ],
        ),
      ),
      QuestMatcher<List<ScreenWidgetArea>, List<ScreenAreaWidgetSlot>>(
        '''matches questions in which user has specified screen-areas to config
      build ?s to specify which SLOTS for those selected screen-areas

      the answers to those questions (Area Slots) will match below to
      ask WHICH rules for each selected slot
    ''',

        questIdPatternMatchTest: (String answQid) =>
            answQid.startsWith(QuestionIdStrings.specAreasToConfigOnScreen),
        validateUserAnswerAfterPatternMatchIsTrueCallback:
            (QuestBase priorAnsweredQuest) {
          var lst = priorAnsweredQuest.mainAnswer as Iterable<ScreenWidgetArea>;
          return lst.length > 0 && !priorAnsweredQuest.targetPathIsComplete;
        },
        //
        derivedQuestGen: DerivedQuestGenerator<List<ScreenWidgetArea>>(
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
            );
          },
          perNewQuestGenOpts: [
            PerQuestGenResponsHandlingOpts<List<ScreenAreaWidgetSlot>>(
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
            ),
          ],
        ),
      ),
      QuestMatcher<List<ScreenWidgetArea>, List<VisualRuleType>>(
        '''matches questions in which user specifies screen-areas to config
      build ?s to specify which Rules to config for those selected screen-areas

      skip questions when no rules apply
    ''',
        questIdPatternMatchTest: (qid) =>
            qid.startsWith(QuestionIdStrings.specAreasToConfigOnScreen),
        validateUserAnswerAfterPatternMatchIsTrueCallback:
            (QuestBase priorAnsweredQuest) {
          return (priorAnsweredQuest.mainAnswer as Iterable<ScreenWidgetArea>)
                  .length >
              0;
        },
        //
        derivedQuestGen: DerivedQuestGenerator<List<ScreenWidgetArea>>(
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
            String area = (priorAnsweredQuest.mainAnswer
                    as List<ScreenWidgetArea>)[newQuIdx]
                .name;
            return QuestionIdStrings.specRulesForAreaOnScreen +
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
              targetComplete: true,
            );
          },
          perNewQuestGenOpts: [
            PerQuestGenResponsHandlingOpts<List<VisualRuleType>>(
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
            ),
          ],
        ),
      ),
      QuestMatcher<List<ScreenAreaWidgetSlot>, List<VisualRuleType>>(
        '''matches questions in which user specifies area-slots to config
      build ?s to specify which Rules to config for those selected screen-areas

      skip questions when no rules apply
    ''',
        questIdPatternMatchTest: (qid) =>
            qid.startsWith(QuestionIdStrings.specRuleDetailsForSlotInArea),
        validateUserAnswerAfterPatternMatchIsTrueCallback:
            (QuestBase priorAnsweredQuest) {
          return (priorAnsweredQuest.mainAnswer
                      as Iterable<ScreenAreaWidgetSlot>)
                  .length >
              0;
        },
        //
        derivedQuestGen: DerivedQuestGenerator<List<ScreenAreaWidgetSlot>>(
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
          answerChoiceGenerator: (
            QuestBase priorAnsweredQuest,
            int newQuestIdx,
          ) {
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
              targetComplete: true,
            );
          },
          perNewQuestGenOpts: [
            PerQuestGenResponsHandlingOpts<List<VisualRuleType>>(
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
            ),
          ],
        ),
      ),
    ];
  }

  static List<QuestMatcher> _getMatchersToGenRuleSelectQuests() {
    // rule select questions were generated above when target is complete
    return [];
  }

  static List<QuestMatcher> _getMatchersToGenRulePrepQuests() {
    //
    return [];
  }

  static List<QuestMatcher> _getMatchersToGenRuleDetailQuests() {
    //
    return [];
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

//

//   QuestMatcher<List<ScreenWidgetArea>, List<VisualRuleType>>(
//     '''matches questions in which user specifies screen-areas or slot to config
//   build ?s to specify which Visual rules for those selected screen-areas
//   the answers to those questions (Visual rules) will hit QM below to
//   ask config details for each selected rule
// ''',
//     // match on start of qid
//     questIdPatternMatchTest: (qid) =>
//         qid.startsWith(QuestionIdStrings.specAreasToConfigOnScreen),
//     //
//     validateUserAnswerAfterPatternMatchIsTrueCallback:
//         (QuestBase priorAnsweredQuest) {
//       return (priorAnsweredQuest.mainAnswer as Iterable<ScreenWidgetArea>)
//                   .length >
//               0 &&
//           priorAnsweredQuest.targetPathIsComplete;
//     },
//     // is doing the right thing but not with the TARGET quest-type??
//     derivedQuestGen: DerivedQuestGenerator(
//       'Select which rules to add on area {0} of screen {1} (answ will generate rule detail quests)',
//       newQuestConstructor: QuestBase.ruleSelectQuest,
//       newQuestPromptArgGen: (
//         QuestBase priorAnsweredQuest,
//         int newQuestIdx,
//       ) {
//         List<VisualRuleType> selectedRulesForArea =
//             (priorAnsweredQuest.mainAnswer as Iterable<VisualRuleType>)
//                 .toList();

//         String areaName =
//             priorAnsweredQuest.screenWidgetArea?.name ?? '-na';
//         String screenName = priorAnsweredQuest.appScreen.name;
//         // var curArea = selectedRulesForArea[newQuestIdx];
//         return [
//           areaName.toUpperCase(),
//           screenName.toUpperCase(),
//         ];
//       },
//       newQuestCountCalculator: (QuestBase priorAnsweredQuest) {
//         return (priorAnsweredQuest.mainAnswer as Iterable<VisualRuleType>)
//             .length;
//       },
//       newQuestIdGenFromPriorQuest: (
//         QuestBase priorAnsweredQuest,
//         int newQuIdx,
//       ) {
//         // each new question about area on screen should
//         // have an ID that lets the next QM identify it to produce new Q's
//         String scrName = priorAnsweredQuest.appScreen.name;
//         String area = priorAnsweredQuest.screenWidgetArea?.name ?? '-na';
//         return QuestionIdStrings.specRulesForAreaOnScreen +
//             '-' +
//             scrName +
//             '-' +
//             area;
//       },
//       answerChoiceGenerator: ((
//         QuestBase priorAnsweredQuest,
//         int idx,
//       ) {
//         List<VisualRuleType> selectedRulesForArea =
//             (priorAnsweredQuest.mainAnswer as Iterable<VisualRuleType>)
//                 .toList();
//         VisualRuleType selectedRule = selectedRulesForArea[idx];
//         return selectedRule.requConfigQuests
//             // .applicableRuleTypes(priorAnsweredQuest.appScreen)
//             .map((e) => e.name)
//             .toList();
//       }),
//       deriveTargetFromPriorRespCallbk: (
//         QuestBase priorAnsweredQuest,
//         int newQuestIdx,
//       ) {
//         List<VisualRuleType> selectedRulesForArea =
//             (priorAnsweredQuest.mainAnswer as Iterable<VisualRuleType>)
//                 .toList();
//         VisualRuleType currRule = selectedRulesForArea[newQuestIdx];
//         return priorAnsweredQuest.qTargetResolution.copyWith(
//           screenWidgetArea: priorAnsweredQuest.screenWidgetArea,
//           slotInArea: priorAnsweredQuest.slotInArea,
//           visRuleTypeForAreaOrSlot: currRule,
//           targetComplete: true,
//         );
//       },
//       perNewQuestGenOpts: [
//         PerQuestGenResponsHandlingOpts<List<VisualRuleType>>(
//           newRespCastFunc: (
//             QuestBase newAnsQuest,
//             String lstVisRuleIdxs,
//           ) {
//             List<VisualRuleType> possibleRules =
//                 newAnsQuest.qTargetResolution.possibleRulesForAreaInScreen;
//             return castStrOfIdxsToIterOfInts(lstVisRuleIdxs, dflt: 0)
//                 .map(
//                   (i) => possibleRules[i],
//                 )
//                 .toList();
//           },
//         ),
//       ],
//     ),
//   ),
//   QuestMatcher<List<ScreenAreaWidgetSlot>, List<VisualRuleType>>(
//     '''matches questions in which user specifies slots in screen-areas to config
//   build ?s to specify which rules for those SLOTS in screen-areas

//   the answers to those questions (Visual Rule types) will match below to
//   config details about those rules

//   build ?`s to specify which rules for slots in areas on selected screens user wants to config
// ''',
//     questIdPatternMatchTest: (qid) =>
//         qid.startsWith(QuestionIdStrings.specSlotsToConfigInArea),
//     //
//     derivedQuestGen: DerivedQuestGenerator(
//       'Select which rules to add for slot {0} in area {1} of screen {2} (answ will generate rule detail quests)',
//       newQuestConstructor: QuestBase.ruleSelectQuest,
//       newQuestPromptArgGen: (
//         QuestBase priorAnsweredQuest,
//         int newQuestIdx,
//       ) {
//         List<ScreenAreaWidgetSlot> slotToConfig = (priorAnsweredQuest
//                 .mainAnswer as Iterable<ScreenAreaWidgetSlot>)
//             .toList();
//         String slotName = slotToConfig[newQuestIdx].name;
//         String areaName =
//             priorAnsweredQuest.screenWidgetArea?.name ?? '-na';
//         String screenName = priorAnsweredQuest.appScreen.name;
//         return [
//           slotName.toUpperCase(),
//           areaName.toUpperCase(),
//           screenName.toUpperCase(),
//         ];
//       },
//       newQuestCountCalculator: (QuestBase priorAnsweredQuest) {
//         return (priorAnsweredQuest.mainAnswer
//                 as Iterable<ScreenAreaWidgetSlot>)
//             .length;
//       },
//       newQuestIdGenFromPriorQuest: (
//         QuestBase priorAnsweredQuest,
//         int newQuIdx,
//       ) {
//         // each new question about area on screen should
//         // have an ID that lets the next QM identify it to produce new Q's
//         String scrName = priorAnsweredQuest.appScreen.name;
//         String area = priorAnsweredQuest.screenWidgetArea?.name ?? '-na';
//         return QuestionIdStrings.specRulesForAreaOnScreen +
//             '-' +
//             scrName +
//             '-' +
//             area;
//       },
//       answerChoiceGenerator: ((
//         QuestBase priorAnsweredQuest,
//         int idx,
//       ) {
//         List<ScreenAreaWidgetSlot> selectedScreenSlots = (priorAnsweredQuest
//                 .mainAnswer as Iterable<ScreenAreaWidgetSlot>)
//             .toList();
//         ScreenAreaWidgetSlot selectedSlot = selectedScreenSlots[idx];
//         return selectedSlot
//             .possibleConfigRules(priorAnsweredQuest.screenWidgetArea!)
//             .map((e) => e.name)
//             .toList();
//       }),
//       deriveTargetFromPriorRespCallbk: (
//         QuestBase priorAnsweredQuest,
//         int newQuestIdx,
//       ) {
//         List<ScreenAreaWidgetSlot> selectedAreaSlots = (priorAnsweredQuest
//                 .mainAnswer as Iterable<ScreenAreaWidgetSlot>)
//             .toList();
//         ScreenAreaWidgetSlot currSlot = selectedAreaSlots[newQuestIdx];
//         return priorAnsweredQuest.qTargetResolution.copyWith(
//           screenWidgetArea: priorAnsweredQuest.screenWidgetArea,
//           slotInArea: currSlot,
//           targetComplete: true,
//         );
//       },
//       perNewQuestGenOpts: [
//         PerQuestGenResponsHandlingOpts<List<VisualRuleType>>(
//           newRespCastFunc: (
//             QuestBase newAnsQuest,
//             String lstAreaIdxs,
//           ) {
//             List<VisualRuleType> possibleRules =
//                 newAnsQuest.qTargetResolution.possibleRulesForAreaInScreen;
//             return castStrOfIdxsToIterOfInts(lstAreaIdxs, dflt: 0)
//                 .map(
//                   (i) => possibleRules[i],
//                 )
//                 .toList();
//           },
//         ),
//       ],
//     ),
//   ),
