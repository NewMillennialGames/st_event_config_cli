part of ConfigDialogRunner;

class NewQuestionCollector {
  /*
    each answered question is passed to this object
    then the scope and context of the question is reviewed

    for certain questions, this NQCollector will auto-generate
    many related sub-questions

    new questions are passed to QuestListMgr
    which assigns them a questionId
    and appends them to the to-be-answered list

    at some point, we may wish to sort questions
    into sensible order, but that process might
    put already answered questions after the current
    question index  (I've solved this but not tested)

  Summary:
  after user selects desired screens to configure, then we ask
  which screen areas (and slots on those areas) to configure
  then we ask them which visual rules they'd like to apply
  to those areas and/or area-slots on each respective screen
  */

  void handleAcquiringNewQuestions(
    DialogMgr _questGroupMgr,
    QuestListMgr _questMgr,
  ) {
    Question questJustAnswered = _questMgr._currentOrLastQuestion;
    // ruleQuestions don't currently generate new questions
    // actually, a sort or group (level 2 or 3) question
    // should generate the questions under it??  TODO
    if (questJustAnswered.isRuleQuestion ||
        questJustAnswered.generatesNoNewQuestions) {
      print(
        'Quest: #${questJustAnswered.questionId} -- ${questJustAnswered.questStr} wont generate any new questions',
      );
      return;
    }

    if (questJustAnswered.asksAreasWithinSelectedScreens &&
        questJustAnswered.appScreen == AppScreen.eventConfiguration) {
      /* called by the last question in hard-coded event list
        user has given us full list of screens they want to configure
        so we don't need to ask individual screens again
       */
      // print('calling: askUserWhichAreasOfSelectedScreensToConfigure');
      askUserWhichAreasOfSelectedScreensToConfigure(
        _questMgr,
        questJustAnswered.response as UserResponse<List<AppScreen>>,
      );
      //
    } else if (questJustAnswered
        .asksAboutRulesAndSlotsWithinSelectedScreenAreas) {
      /*  for all the areas (to be configured) of all of the selected screens
          we need to know which slot(s) on each area they want to configure

          this will be called once for each screen/area combination
          askeUserWhichPartsOfSelectedAreasToConfigure

          I walked up to farmers market to get some caffeine ... give me 15 minutes notice and I'll walk back to my hotel and put on warmer clothes
      */
      // print('calling: askeWhichRulesGoWithAreaAndWhichSlotsToConfig');
      askWhichRulesGoWithAreaAndWhichSlotsToConfig(
        _questMgr,
        questJustAnswered as Question<String, List<ScreenWidgetArea>>,
      );
      //
    } else if (questJustAnswered.asksRuleTypesForSelectedAreasOrSlots) {
      //
      // print('calling: askWhichConfigRulesGoWithEachSlot');
      askWhichConfigRulesGoWithEachSlot(
        _questMgr,
        questJustAnswered as Question<String, List<ScreenAreaWidgetSlot>>,
      );
      //
    } else if (questJustAnswered.asksDetailsForEachVisualRuleType) {
      // print('calling: genRequestedVisualRulesForAreaOrSlot');

      genRequestedVisualRulesForAreaOrSlot(
        _questMgr,
        questJustAnswered as Question<String, List<VisualRuleType>>,
      );
      // if (questJustAnswered is Question<String, List<VisualRuleType>>) {
      //   genRequestedVisualRulesForAreaOrSlot(
      //     _questMgr,
      //     questJustAnswered as Question<String, List<VisualRuleType>>,
      //   );
      // } else if (questJustAnswered
      //     is Question<String, List<ScreenAreaWidgetSlot>>) {
      //   askWhichConfigRulesGoWithEachSlot(
      //     _questMgr,
      //     questJustAnswered as Question<String, List<ScreenAreaWidgetSlot>>,
      //   );
      // }

      //
    } else if (questJustAnswered.asksDetailsForEachBehaveRuleType) {
      // print('calling: genRequestedBehaveRulesForAreaOrSlot');
      genRequestedBehaveRulesForAreaOrSlot(
        _questMgr,
        questJustAnswered as Question<String, List<BehaviorRuleType>>,
      );
      //
    } else {
      print(
        '\n**Quest ID ${questJustAnswered.questionId} about "${questJustAnswered.questStr}" did not generate any new questions',
      );
      print(
        'asksDetailsForEachVisualRuleType: ${questJustAnswered.asksDetailsForEachVisualRuleType} -- ${questJustAnswered.visRuleTypeForAreaOrSlot?.name ?? 'err-missing'}',
      );
      // print(
      //   'Quest ID ${questJustAnswered.questionId} about "${questJustAnswered.question}" did not generate any new questions\n\n',
      // );
    }
  }

  // callbacks when a question needs to add other questions
  void askUserWhichAreasOfSelectedScreensToConfigure(
    QuestListMgr _questMgr,
    UserResponse<List<AppScreen>> response,
  ) {
    // receives list of multiple screens user wants to configure
    // create "include" questions for all areas in selected screens
    // user response to each of these questions will cause a call to:
    // askeUserWhichSlotsOnSelectedAreasToConfigure() below
    // note that these questions have appScreen set, but no ScreenWidgetArea
    List<Question> newQuestions = [];
    for (AppScreen scr in response.answers) {
      // skip screens that dont have configurable areas
      if (!scr.isConfigurable) continue;

      var q = Question<String, List<ScreenWidgetArea>>(
        QuestionQuantifier.appScreenLevel(
          scr,
          responseAddsWhichSlotQuestions: true,
        ),
        'For the ${scr.name} screen, select the areas you`d like to configure?',
        scr.configurableScreenAreas.map((e) => e.name),
        (String idxStrs) {
          return castStrOfIdxsToIterOfInts(idxStrs)
              .map((idx) => scr.configurableScreenAreas[idx])
              .toList();
        },
        acceptsMultiResponses: true,
      );
      newQuestions.add(q);
    }
    // now put these questions in the queue
    _questMgr.appendNewQuestions(
      newQuestions,
      dbgNam: 'askUserWhichAreasOfSelectedScreensToConfigure',
    );
  }

  void askWhichRulesGoWithAreaAndWhichSlotsToConfig(
    QuestListMgr _questMgr,
    Question<String, List<ScreenWidgetArea>> quest,
  ) {
    /*  receives 1 screen but multiple areas

    questions created in this section should GENERATE
    the VisualRuleType questions for areas
    that ask user to provide specific rule-args

    and "which slot" style questions for each slot in an area
    */
    AppScreen screen = quest.appScreen;
    assert(quest.response?.answers is List<ScreenWidgetArea>);

    var areasSelectedForScreenInLastQuest =
        quest.response?.answers as List<ScreenWidgetArea>;
    if (areasSelectedForScreenInLastQuest.length < 1) return;

    // for each configurable area in current screen
    // make a question about it's possible rule-types
    List<Question> newQuestions = [];

    // ask rules for each area
    for (ScreenWidgetArea area in areasSelectedForScreenInLastQuest) {
      if (!area.isConfigureable || area.applicableRuleTypes.length < 1)
        continue;

      var q = Question<String, List<VisualRuleType>>(
        QuestionQuantifier.screenAreaLevel(
          screen,
          area,
          responseAddsWhichRuleTypeQuestions: true,
        ),
        'Which rules would you like to add to the ${area.name} of ${screen.name}?',
        area.applicableRuleTypes.map((r) => r.friendlyName),
        (String idxStrs) {
          return castStrOfIdxsToIterOfInts(idxStrs)
              .map((idx) => area.applicableRuleTypes[idx])
              .toList();
        },
        acceptsMultiResponses: true,
      );
      newQuestions.add(q);
    }

    print(
        'askWhichRulesGoWithAreaAndWhichSlotsToConfig adding ${newQuestions.length} rule questions');
    // ask which slots user would like to configure within each area
    for (ScreenWidgetArea area in areasSelectedForScreenInLastQuest) {
      if (!area.isConfigureable || area.applicableWigetSlots.length < 1)
        continue;

      var q = Question<String, List<ScreenAreaWidgetSlot>>(
        QuestionQuantifier.screenAreaLevel(
          screen,
          area,
          responseAddsWhichSlotQuestions: true,
        ),
        'Which slots/widgets on the ${area.name} of ${screen.name} would you like to configure?',
        area.applicableWigetSlots.map((r) => r.choiceName),
        (String idxStrs) {
          return castStrOfIdxsToIterOfInts(idxStrs)
              .map((idx) => area.applicableWigetSlots[idx])
              .toList();
        },
        acceptsMultiResponses: true,
      );
      newQuestions.add(q);
    }

    _questMgr.appendNewQuestions(
      newQuestions,
      dbgNam: 'askWhichRulesGoWithAreaAndWhichSlotsToConfig',
    );
  }

  void askWhichConfigRulesGoWithEachSlot(
    QuestListMgr _questMgr,
    Question<String, List<ScreenAreaWidgetSlot>> quest,
  ) {
    // receives 1 screen & 1 area but multiple slots

    AppScreen screen = quest.appScreen;
    ScreenWidgetArea screenArea = quest.screenWidgetArea!;

    List<ScreenAreaWidgetSlot> selectedSlotsInArea =
        quest.response?.answers ?? [];
    if (selectedSlotsInArea.length < 1) return;

    List<Question> newQuestions = [];
    for (ScreenAreaWidgetSlot slotInArea in selectedSlotsInArea) {
      //
      if (!slotInArea.isConfigurable ||
          slotInArea.possibleConfigRules.length < 1) continue;

      var q = Question<String, List<VisualRuleType>>(
        QuestionQuantifier.slotAreaLevel(
          screen,
          screenArea,
          slotInArea,
          responseAddsRuleDetailQuestions: true,
        ),
        'Which rules would you like to add to the ${slotInArea.name} area of ${screenArea.name} on screen ${screen.name}?',
        slotInArea.possibleConfigRules.map((r) => r.friendlyName),
        (String idxStrs) {
          return castStrOfIdxsToIterOfInts(idxStrs)
              .map((idx) => slotInArea.possibleConfigRules[idx])
              .toList();
        },
      );
      newQuestions.add(q);
    }

    _questMgr.appendNewQuestions(
      newQuestions,
      dbgNam: 'askWhichConfigRulesGoWithEachSlot',
    );
  }

  void genRequestedVisualRulesForAreaOrSlot(
    QuestListMgr _questMgr,
    Question<String, List<VisualRuleType>> quest,
  ) {
    /*
      user has responded WHICH rules they would like to apply
      to EITHER a screenArea, OR a slot in an area
      usually should be just one ruleType for each
      screen location
    */
    List<VisualRuleType> rulesToCreateForAreaOrSlot =
        quest.response?.answers ?? [];
    if (rulesToCreateForAreaOrSlot.length < 1) return;

    AppScreen screen = quest.appScreen;
    ScreenWidgetArea area = quest.screenWidgetArea!;
    ScreenAreaWidgetSlot? areaSlot = quest.slotInArea;
    //
    List<Question> newQuestions = [];
    // VisualRuleQuestions figure out their questions &
    // select options from the rule-type being passed
    for (VisualRuleType ruleTyp in rulesToCreateForAreaOrSlot) {
      var q = VisualRuleQuestion<String, RuleResponseWrapperIfc>(
        screen,
        area,
        ruleTyp,
        areaSlot,
      );
      newQuestions.add(q);
    }
    _questMgr.appendNewQuestions(
      newQuestions,
      dbgNam: 'genRequestedVisualRulesForAreaOrSlot',
    );
  }

  void genRequestedBehaveRulesForAreaOrSlot(
    QuestListMgr _questMgr,
    Question<String, List<BehaviorRuleType>> quest,
  ) {
    // use example above for this pattern
  }
}
