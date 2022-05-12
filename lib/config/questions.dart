part of EvCfgConfig;

// public api
List<Quest2> loadInitialConfigQuest2s() {
  // event config Quest2s DO NOT have areas or uiComponents
  return _Quest2Lst.where((qb) =>
      qb.appScreen == AppScreen.eventConfiguration &&
      qb.isTopLevelConfigOrScreenQuest2).toList();
}

// List<Quest2> loadQuest2sAtTopOfSection(AppScreen appSection) {
//   return _Quest2Lst
//       .where((qb) =>
//           qb.appScreen == appSection && qb.isTopLevelConfigOrScreenQuest2)
//       .toList();
// }

// List<Quest2> loadQuest2sUnderSelectedSections(
//   UserResponse<List<AppScreen>> response,
// ) {
//   // load Quest2s about areas in section
//   List<AppScreen> appSectionsToConfigure = response.answers;
//   List<Quest2> newQuest2s = _Quest2Lst
//       .where((q) =>
//           appSectionsToConfigure.contains(q.appScreen) &&
//           !q.isTopLevelConfigOrScreenQuest2)
//       .toList();
//   return newQuest2s;
// }

// List<Quest2> loadQuest2sForArea(
//   AppScreen screen,
//   ScreenWidgetArea screenWidgetArea,
//   ScreenAreaWidgetSlot slotInArea,
//   UserResponse<List<VisualRuleType>> response,
// ) {
//   /*
//     this method fabricates the rule rather than
//     loading an existing one
//   */
//   List<Quest2> lst = [];
//   for (VisualRuleType applicableRuleForSlot in response.answers) {
//     lst.add(
//       Quest2<String, RuleResponseWrapper>(
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
final List<Quest2> _Quest2Lst = [
  /*  
    eventConfiguration Quest2s list below

    1st generic describes data-type of ultimate
    user ANSWER (value stored in class UserResponse)

    2nd generic describes the data-type
    of the value being sent from std-in
    (aka the user response;  string or int)

    I could get rid of it and ALWAYS expect string
    but then I'd have more boilerplate in ALL
    of my Qb.castFunc code
  */
  Qb(
    QTargetIntent.eventLevel(),
    QDefCollection([]),
    questId: Quest2Ids.eventName,
  ),
  // set true false to shorten manual testing
  if (true) ...[
    Qb(
      QTargetIntent.eventLevel(),
      QDefCollection([]),
      // DlgStr.eventDescrip,
      // null,
      // null,
      questId: Quest2Ids.eventDescrip,
    ),
    Qb(
      QTargetIntent.eventLevel(),
      QDefCollection([]),
      // DlgStr.eventType,
      // EvType.values.map((e) => e.name),
      // (i) => EvType.values[i],
      questId: Quest2Ids.eventType,
    ),
    Qb(
      QTargetIntent.eventLevel(),
      QDefCollection([]),
      // DlgStr.eventWhosCompeting,
      // EvCompetitorType.values.map((e) => e.name),
      // (i) => EvCompetitorType.values[i],
      questId: Quest2Ids.competitorType,
    ),
    Qb(
      QTargetIntent.eventLevel(),
      QDefCollection([]),
      // DlgStr.eventCompPlayAgainst,
      // EvOpponentType.values.map((e) => e.name),
      // (i) => EvOpponentType.values[i],
      questId: Quest2Ids.competeAgainstType,
    ),
    Qb(
      QTargetIntent.eventLevel(),
      QDefCollection([]),
      // DlgStr.eventDuration,
      // EvDuration.values.map((e) => e.name),
      // (i) => EvDuration.values[i],
      questId: Quest2Ids.eventDuration,
    ),
    Qb(
      QTargetIntent.eventLevel(),
      QDefCollection([]),
      // DlgStr.eventEliminationStrategy,
      // EvEliminationStrategy.values.map((e) => e.name),
      // (i) => EvEliminationStrategy.values[i],
      questId: Quest2Ids.eventEliminationStrategy,
    ),
    Qb(
      QTargetIntent.eventLevel(),
      QDefCollection([]),
      // DlgStr.useSameRowStyleForAllScreens,
      // ['no', 'yes'],
      // (i) => i == '1',
      // defaultAnswerIdx: 1,
      questId: Quest2Ids.globalRowStyle,
    ),
  ],
  // ask which screens to configure
  Qb(
    QTargetIntent.eventLevel(responseAddsWhichAreaQuest2s: true),
    QDefCollection([]),
    // DlgStr.selectAppScreens,  // <String, List<AppScreen>>
    // AppScreen.eventConfiguration.topConfigurableScreens.map((e) => e.name),
    // (String strLstIdxs) {
    //   //
    //   return castStrOfIdxsToIterOfInts(strLstIdxs)
    //       .map(
    //           (idx) => AppScreen.eventConfiguration.topConfigurableScreens[idx])
    //       .toList();
    // },
    // acceptsMultiResponses: true,
    // isNotForOutput: true,
    questId: Quest2Ids.selectAppScreens,
  ),
  // after user selects desired screens to configure, then
  // which screen areas (and slots on those areas) are asked automatically;
  // then we ask them which visual rules they'd like to apply
  // to those areas and/or area-slots
];

 
  // we don't need defined Quest2s for them

  // if (AppSection.eventSelection.isConfigureable)
  //   Qb<List<UiComponent>, String>(
  //     Quest2Quantifier.appSectionLevel(AppSection.eventSelection),
  //     AppSection.eventSelection.includeStr,
  //     AppSection.eventSelection.applicableComponents.map((e) => e.name),
  //     AppSection.eventSelection.convertIdxsToComponentList,
  //   ),
  // if (AppSection.poolSelection.isConfigureable)
  //   Qb<List<UiComponent>, String>(
  //     Quest2Quantifier.appSectionLevel(AppSection.poolSelection),
  //     AppSection.poolSelection.includeStr,
  //     AppSection.poolSelection.applicableComponents.map((e) => e.name),
  //     AppSection.poolSelection.convertIdxsToComponentList,
  //   ),

  // if (AppSection.socialPools.isConfigureable)
  //   Qb<List<UiComponent>, String>(
  //     Quest2Quantifier.appSectionLevel(AppSection.socialPools),
  //     AppSection.socialPools.includeStr,
  //     AppSection.socialPools.applicableComponents.map((e) => e.name),
  //     AppSection.socialPools.convertIdxsToComponentList,
  //   ),
  // if (AppSection.news.isConfigureable)
  //   Qb<List<UiComponent>, String>(
  //     Quest2Quantifier.appSectionLevel(AppSection.news),
  //     AppSection.news.includeStr,
  //     AppSection.news.applicableComponents.map((e) => e.name),
  //     AppSection.news.convertIdxsToComponentList,
  //   ),
  // if (AppSection.leaderboard.isConfigureable)
  //   Qb<List<UiComponent>, String>(
  //     Quest2Quantifier.appSectionLevel(AppSection.leaderboard),
  //     AppSection.leaderboard.includeStr,
  //     AppSection.leaderboard.applicableComponents.map((e) => e.name),
  //     AppSection.leaderboard.convertIdxsToComponentList,
  //   ),
  // if (AppSection.portfolio.isConfigureable)
  //   Qb<List<UiComponent>, String>(
  //     Quest2Quantifier.appSectionLevel(AppSection.portfolio),
  //     AppSection.portfolio.includeStr,
  //     AppSection.portfolio.applicableComponents.map((e) => e.name),
  //     AppSection.portfolio.convertIdxsToComponentList,
  //   ),
  // if (AppSection.trading.isConfigureable)
  //   Qb<List<UiComponent>, String>(
  //     Quest2Quantifier.appSectionLevel(AppSection.trading),
  //     AppSection.trading.includeStr,
  //     AppSection.trading.applicableComponents.map((e) => e.name),
  //     AppSection.trading.convertIdxsToComponentList,
  //   ),
  // if (AppSection.marketResearch.isConfigureable)
  //   Qb<List<UiComponent>, String>(
  //     Quest2Quantifier.appSectionLevel(AppSection.marketResearch),
  //     AppSection.marketResearch.includeStr,
  //     AppSection.marketResearch.applicableComponents.map((e) => e.name),
  //     AppSection.marketResearch.convertIdxsToComponentList,
  //   ),