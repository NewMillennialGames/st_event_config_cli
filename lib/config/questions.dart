part of QuestConfig;

// public api
List<Question> loadInitialConfigQuestions() {
  // event config questions DO NOT have areas or uiComponents
  return _questionLst
      .where((qb) =>
          qb.appScreen == AppScreen.eventConfiguration &&
          qb.isTopLevelSectionQuestion)
      .toList();
}

List<Question> loadQuestionsAtTopOfSection(AppScreen appSection) {
  return _questionLst
      .where((qb) => qb.appScreen == appSection && qb.isTopLevelSectionQuestion)
      .toList();
}

List<Question> loadQuestionsUnderSelectedSections(
  UserResponse<List<AppScreen>> response,
) {
  // load questions about areas in section
  List<AppScreen> appSectionsToConfigure = response.answers;
  List<Question> newQuestions = _questionLst
      .where((q) =>
          appSectionsToConfigure.contains(q.appScreen) &&
          !q.isTopLevelSectionQuestion)
      .toList();
  return newQuestions;
}

List<Question> loadVisualRuleQuestionsForArea(
  AppScreen screen,
  ScreenWidgetArea screenWidgetArea,
  SubWidgetInScreenArea slotInArea,
  UserResponse<List<VisualRuleType>> response,
) {
  /*
    this method fabricates the rule rather than
    loading an existing one
  */
  List<Question> lst = [];
  for (VisualRuleType applicableRuleForSlot in response.answers) {
    lst.add(
      VisualRuleQuestion<String, RuleResponseWrapper>(
        screen,
        screenWidgetArea,
        slotInArea,
        applicableRuleForSlot,
        null,
      ),
    );
  }
  return lst;
}

// accumulate configuration data
final List<Question> _questionLst = [
  /*  
    eventConfiguration questions list below

    1st generic describes data-type of ultimate
    user ANSWER (value stored in class UserResponse)

    2nd generic describes the data-type
    of the value being sent from std-in
    (aka the user response;  string or int)

    I could get rid of it and ALWAYS expect string
    but then I'd have more boilerplate in ALL
    of my Qb.castFunc code
  */
  Qb<String, String>(
    QuestionQuantifier.eventLevel(),
    DlgStr.eventName,
    null,
    null,
  ),
  Qb<String, String>(
    QuestionQuantifier.eventLevel(),
    DlgStr.eventDescrip,
    null,
    null,
  ),
  Qb<int, EvType>(
    QuestionQuantifier.eventLevel(),
    DlgStr.eventType,
    EvType.values.map((e) => e.name),
    (i) => EvType.values[i],
  ),
  Qb<int, EvCompetitorType>(
    QuestionQuantifier.eventLevel(),
    DlgStr.eventWhosCompeting,
    EvCompetitorType.values.map((e) => e.name),
    (i) => EvCompetitorType.values[i],
  ),
  Qb<int, EvOpponentType>(
    QuestionQuantifier.eventLevel(),
    DlgStr.eventCompPlayAgainst,
    EvOpponentType.values.map((e) => e.name),
    (i) => EvOpponentType.values[i],
  ),
  Qb<int, EvDuration>(
    QuestionQuantifier.eventLevel(),
    DlgStr.eventDuration,
    EvDuration.values.map((e) => e.name),
    (i) => EvDuration.values[i],
  ),
  Qb<int, EvEliminationStrategy>(
    QuestionQuantifier.eventLevel(),
    DlgStr.eventEliminationStrategy,
    EvEliminationStrategy.values.map((e) => e.name),
    (i) => EvEliminationStrategy.values[i],
  ),
  Qb<String, List<AppScreen>>(
    QuestionQuantifier.eventLevel(addsWhichScreenQuestions: true),
    'Which app areas shall we configure?',
    AppScreen.eventConfiguration.sectionConfigOptions.map((e) => e.name),
    (String strLstIdxs) {
      //
      List<int> _sectionIds = strLstIdxs
          .split(',')
          .map((e) => int.tryParse(e) ?? -1)
          .where((i) => i >= 0)
          .toList();
      return _sectionIds
          .map((idx) => AppScreen.eventConfiguration.sectionConfigOptions[idx])
          .toList();
    },
    acceptsMultiResponses: true,
  ),
  // top sections are asked automatically;
  // and if user proceeds, then we ask them
  // which UI components in the section they want to configure

  // if (AppScreen.marketView.isConfigureable)
  //   Qb<String, List<ScreenWidgetArea>>(
  //     QuestionQuantifier.appScreenLevel(AppScreen.marketView,
  //         addsAreaQuestions: true),
  //     AppScreen.marketView.includeStr,
  //     AppScreen.marketView.applicableComponents.map((e) => e.name),
  //     AppScreen.marketView.convertIdxsToComponentList,
  //   ),
  // if (AppScreen.marketView.isConfigureable)
  //   for (ScreenWidgetArea uic in AppScreen.marketView.applicableComponents)
  //     for (VisualRuleType rt in uic.applicableRuleTypes)
  //       Qb<String, bool>(
  //         QuestionQuantifier.screenAreaLevel(AppScreen.marketView, uic,
  //             addsSlotQuestions: true),
  //         'Want to configure ${rt.name} on ${uic.name}?',
  //         null,
  //         (yOrN) => yOrN.toUpperCase().startsWith('Y'),
  //       ),
];





//
// List<Question> _getQuestionList() {
//   // first run will store data in a global
//   if (_questionLst.length > 4) return _questionLst;

//   int qNum = 0;
//   for (Qb q in _questData) {
//     qNum += 1;
//     _questionLst.add(Question(
//       qNum,
//       q,
//     ));
//   }
//   return _questionLst;
// }




  // we don't need defined questions for them

  // if (AppSection.eventSelection.isConfigureable)
  //   Qb<List<UiComponent>, String>(
  //     QuestionQuantifier.appSectionLevel(AppSection.eventSelection),
  //     AppSection.eventSelection.includeStr,
  //     AppSection.eventSelection.applicableComponents.map((e) => e.name),
  //     AppSection.eventSelection.convertIdxsToComponentList,
  //   ),
  // if (AppSection.poolSelection.isConfigureable)
  //   Qb<List<UiComponent>, String>(
  //     QuestionQuantifier.appSectionLevel(AppSection.poolSelection),
  //     AppSection.poolSelection.includeStr,
  //     AppSection.poolSelection.applicableComponents.map((e) => e.name),
  //     AppSection.poolSelection.convertIdxsToComponentList,
  //   ),

  // if (AppSection.socialPools.isConfigureable)
  //   Qb<List<UiComponent>, String>(
  //     QuestionQuantifier.appSectionLevel(AppSection.socialPools),
  //     AppSection.socialPools.includeStr,
  //     AppSection.socialPools.applicableComponents.map((e) => e.name),
  //     AppSection.socialPools.convertIdxsToComponentList,
  //   ),
  // if (AppSection.news.isConfigureable)
  //   Qb<List<UiComponent>, String>(
  //     QuestionQuantifier.appSectionLevel(AppSection.news),
  //     AppSection.news.includeStr,
  //     AppSection.news.applicableComponents.map((e) => e.name),
  //     AppSection.news.convertIdxsToComponentList,
  //   ),
  // if (AppSection.leaderboard.isConfigureable)
  //   Qb<List<UiComponent>, String>(
  //     QuestionQuantifier.appSectionLevel(AppSection.leaderboard),
  //     AppSection.leaderboard.includeStr,
  //     AppSection.leaderboard.applicableComponents.map((e) => e.name),
  //     AppSection.leaderboard.convertIdxsToComponentList,
  //   ),
  // if (AppSection.portfolio.isConfigureable)
  //   Qb<List<UiComponent>, String>(
  //     QuestionQuantifier.appSectionLevel(AppSection.portfolio),
  //     AppSection.portfolio.includeStr,
  //     AppSection.portfolio.applicableComponents.map((e) => e.name),
  //     AppSection.portfolio.convertIdxsToComponentList,
  //   ),
  // if (AppSection.trading.isConfigureable)
  //   Qb<List<UiComponent>, String>(
  //     QuestionQuantifier.appSectionLevel(AppSection.trading),
  //     AppSection.trading.includeStr,
  //     AppSection.trading.applicableComponents.map((e) => e.name),
  //     AppSection.trading.convertIdxsToComponentList,
  //   ),
  // if (AppSection.marketResearch.isConfigureable)
  //   Qb<List<UiComponent>, String>(
  //     QuestionQuantifier.appSectionLevel(AppSection.marketResearch),
  //     AppSection.marketResearch.includeStr,
  //     AppSection.marketResearch.applicableComponents.map((e) => e.name),
  //     AppSection.marketResearch.convertIdxsToComponentList,
  //   ),