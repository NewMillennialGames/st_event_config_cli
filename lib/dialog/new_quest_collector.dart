part of ConfigDialogRunner;

class NewQuestionCollector {
  //

  void handleAcquiringNewQuestions(
    DialogMgr _questGroupMgr,
    QuestListMgr _questMgr,
    Question questJustAnswered,
  ) {
    // ruleQuestions don't currently generate new questions
    if (questJustAnswered.isRuleQuestion ||
        questJustAnswered.generatesNoNewQuestions) {
      print(
          'Quest: #${questJustAnswered.questionId} -- ${questJustAnswered.question} wont generated any new questions');
      return;
    }

    if (questJustAnswered.asksAreasWithinSelectedScreens &&
        questJustAnswered.appScreen == AppScreen.eventConfiguration) {
      /* called by the last question in hard-coded event list
        user has given us full list of screens they want to configure
        so we don't need to ask individual screens again
       */
      askUserWhichAreasOfSelectedScreensToConfigure(
        _questMgr,
        questJustAnswered.response as UserResponse<List<AppScreen>>,
      );
      //
    } else if (questJustAnswered.asksSlotsWithinSelectedScreenAreas) {
      /*  for all the areas (to be configured) of all of the selected screens
          we need to know which slot(s) on each area they want to configure

          this will be called once for each screen/area combination
          askeUserWhichPartsOfSelectedAreasToConfigure
      */

      askeUserWhichSlotsOnSelectedAreasToConfigure(
        _questMgr,
        questJustAnswered as Question<String, List<ScreenWidgetArea>>,
      );
      //
    } else if (questJustAnswered.asksRuleTypesForSelectedAreasOrSlots) {
    } else if (questJustAnswered.asksDetailsForEachVisualRuleType &&
        questJustAnswered.visRuleTypeForSlotInArea != null) {
      generateAssociatedUiRuleTypeQuestions(
        questJustAnswered.qQuantify.screenWidgetArea!,
        questJustAnswered.response as UserResponse<List<VisualRuleType>>,
      );
      //
    } else if (questJustAnswered.asksDetailsForEachBehaveRuleType &&
        questJustAnswered.behRuleTypeForSlotInArea != null) {
      generateAssociatedBehRuleTypeQuestions(
        questJustAnswered.qQuantify.screenWidgetArea!,
        questJustAnswered.response as UserResponse<List<BehaviorRuleType>>,
      );
      //
    }
  }

  // callbacks when a question needs to add other questions
  void askUserWhichAreasOfSelectedScreensToConfigure(
    QuestListMgr _questMgr,
    UserResponse<List<AppScreen>> response,
  ) {
    // should add "include" questions for all areas in selected section
    List<Question> newQuestions = [];
    for (AppScreen scr in response.answers) {
      var q = Question<String, List<ScreenWidgetArea>>(
        QuestionQuantifier.appScreenLevel(
          scr,
          addsAreaQuestions: true,
        ),
        'For screen ${scr.name}, select the areas would you like to configure?',
        scr.configurableScreenAreas.map((e) => e.name),
        (String idxStrs) {
          return idxStrs
              .split(',')
              .map((idxStr) => int.tryParse(idxStr) ?? -1)
              .where((idx) => idx >= 0)
              .map((idx) => scr.configurableScreenAreas[idx])
              .toList();
        },
      );
      newQuestions.add(q);
    }
    // now put these questions in the queue
    _questMgr.appendQuestions(newQuestions);
  }

  void askeUserWhichSlotsOnSelectedAreasToConfigure(
    QuestListMgr _questMgr,
    Question<String, List<ScreenWidgetArea>> quest,
  ) {
    var screen = quest.appScreen;
    var area = quest.screenWidgetArea!;

    var areasSelectedInLastQuest =
        quest.response?.answers as List<ScreenWidgetArea>;
    if (areasSelectedInLastQuest.length < 1) return;

    List<Question> newQuestions = [];
    // for (ScreenWidgetArea slot in areasSelectedInLastQuest) {
    var q = Question<String, List<SubWidgetInScreenArea>>(
      QuestionQuantifier.screenAreaLevel(
        screen,
        area,
        addsSlotQuestions: true,
      ),
      'Which properties would you like to configure on ${area.name} of ${screen.name}?',
      area.applicablePropertySlots.map((r) => r.name),
      (String idxStrs) {
        return idxStrs
            .split(',')
            .map((idxStr) => int.tryParse(idxStr) ?? -1)
            .where((idx) => idx >= 0)
            .map((idx) => area.applicablePropertySlots[idx])
            .toList();
      },
    );
    newQuestions.add(q);
    // }
    _questMgr.appendQuestions(newQuestions);
  }

  void askWhichConfigRulesToApplyToSelectedAreaOrSlot() {
    //
  }

  void addQuestionsForVisRulesInSelectedAreas(
    UserResponse<List<ScreenWidgetArea>> response,
  ) {}

  void generateAssociatedUiRuleTypeQuestions(
    ScreenWidgetArea uiComp,
    UserResponse<List<VisualRuleType>> response,
  ) {
    //
    var includedQuestions = loadVisualRuleQuestionsForArea(
      _questGroupMgr.currentSectiontype,
      uiComp,
      response,
    );
    _questMgr.appendQuestions(
      includedQuestions,
    );
  }

  void generateAssociatedBehRuleTypeQuestions(
    ScreenWidgetArea uiComp,
    UserResponse<List<BehaviorRuleType>> response,
  ) {
    // future
    // var includedQuestions = loadAddlRuleQuestions(
    //     _questGroupMgr.currentSectiontype, uiComp, response);
    // _questMgr.appendQuestions(
    //     _questGroupMgr.currentSectiontype, includedQuestions);
  }
}
