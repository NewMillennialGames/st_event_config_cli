part of EvCfgConfig;

// public api
List<Question> loadInitialConfigQuestions() {
  // event config questions DO NOT have areas or uiComponents
  return _questionLst
      .where((qb) =>
          qb.appScreen == AppScreen.eventConfiguration &&
          qb.isTopLevelConfigOrScreenQuestion)
      .toList();
}

// List<Question> loadQuestionsAtTopOfSection(AppScreen appSection) {
//   return _questionLst
//       .where((qb) =>
//           qb.appScreen == appSection && qb.isTopLevelConfigOrScreenQuestion)
//       .toList();
// }

// List<Question> loadQuestionsUnderSelectedSections(
//   UserResponse<List<AppScreen>> response,
// ) {
//   // load questions about areas in section
//   List<AppScreen> appSectionsToConfigure = response.answers;
//   List<Question> newQuestions = _questionLst
//       .where((q) =>
//           appSectionsToConfigure.contains(q.appScreen) &&
//           !q.isTopLevelConfigOrScreenQuestion)
//       .toList();
//   return newQuestions;
// }

// List<Question> loadVisualRuleQuestionsForArea(
//   AppScreen screen,
//   ScreenWidgetArea screenWidgetArea,
//   ScreenAreaWidgetSlot slotInArea,
//   UserResponse<List<VisualRuleType>> response,
// ) {
//   /*
//     this method fabricates the rule rather than
//     loading an existing one
//   */
//   List<Question> lst = [];
//   for (VisualRuleType applicableRuleForSlot in response.answers) {
//     lst.add(
//       VisualRuleQuestion<String, RuleResponseWrapper>(
//         screen,
//         screenWidgetArea,
//         slotInArea,
//         applicableRuleForSlot,
//         null,
//       ),
//     );
//   }
//   return lst;
// }

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
    QTargetIntent.eventLevel(),
    DlgStr.eventName,
    null,
    null,
    questId: QuestionIds.eventName,
  ),
  // set true false to shorten manual testing
  if (false) ...[
    Qb<String, String>(
      QTargetIntent.eventLevel(),
      DlgStr.eventDescrip,
      null,
      null,
      questId: QuestionIds.eventDescrip,
    ),
    Qb<int, EvType>(
      QTargetIntent.eventLevel(),
      DlgStr.eventType,
      EvType.values.map((e) => e.name),
      (i) => EvType.values[i],
      questId: QuestionIds.eventType,
    ),
    Qb<int, EvCompetitorType>(
      QTargetIntent.eventLevel(),
      DlgStr.eventWhosCompeting,
      EvCompetitorType.values.map((e) => e.name),
      (i) => EvCompetitorType.values[i],
      questId: QuestionIds.competitorType,
    ),
    Qb<int, EvOpponentType>(
      QTargetIntent.eventLevel(),
      DlgStr.eventCompPlayAgainst,
      EvOpponentType.values.map((e) => e.name),
      (i) => EvOpponentType.values[i],
      questId: QuestionIds.competeAgainstType,
    ),
    Qb<int, EvDuration>(
      QTargetIntent.eventLevel(),
      DlgStr.eventDuration,
      EvDuration.values.map((e) => e.name),
      (i) => EvDuration.values[i],
      questId: QuestionIds.eventDuration,
    ),
    Qb<int, EvEliminationStrategy>(
      QTargetIntent.eventLevel(),
      DlgStr.eventEliminationStrategy,
      EvEliminationStrategy.values.map((e) => e.name),
      (i) => EvEliminationStrategy.values[i],
      questId: QuestionIds.eventEliminationStrategy,
    ),
    Qb<String, bool>(
      QTargetIntent.eventLevel(),
      DlgStr.useSameRowStyleForAllScreens,
      ['no', 'yes'],
      (i) => i == '1',
      defaultAnswerIdx: 1,
      questId: QuestionIds.globalRowStyle,
    ),
  ],
  // ask which screens to configure
  Qb<String, List<AppScreen>>(
    QTargetIntent.eventLevel(responseAddsWhichAreaQuestions: true),
    DlgStr.selectAppScreens,
    AppScreen.eventConfiguration.topConfigurableScreens.map((e) => e.name),
    (String strLstIdxs) {
      //
      return castStrOfIdxsToIterOfInts(strLstIdxs)
          .map(
              (idx) => AppScreen.eventConfiguration.topConfigurableScreens[idx])
          .toList();
    },
    acceptsMultiResponses: true,
    isNotForOutput: true,
    questId: QuestionIds.selectAppScreens,
  ),
  // after user selects desired screens to configure, then
  // which screen areas (and slots on those areas) are asked automatically;
  // then we ask them which visual rules they'd like to apply
  // to those areas and/or area-slots
];

 
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