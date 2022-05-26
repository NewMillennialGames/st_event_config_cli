part of EvCfgConfig;

// public api
List<QuestBase> loadInitialConfigQuestions() {
  // event config Quest2s DO NOT have areas or uiComponents
  return _initQuestionLst
      .where((qb) =>
          qb.appScreen == AppScreen.eventConfiguration &&
          qb.isTopLevelEventConfigQuestion)
      .toList();
}

// List<QuestBase> loadQuest2sAtTopOfSection(AppScreen appSection) {
//   return _Quest2Lst
//       .where((qb) =>
//           qb.appScreen == appSection && qb.isTopLevelConfigOrScreenQuest2)
//       .toList();
// }

// List<QuestBase> loadQuest2sUnderSelectedSections(
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

// List<QuestBase> loadQuest2sForArea(
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
final List<QuestBase> _initQuestionLst = [
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
  QuestBase.initialEventConfigRule(
    QTargetIntent.eventLevel(),
    DlgStr.eventName,
    [],
    CaptureAndCast<String>((s) => s),
    questId: QuestionIdStrings.eventName,
  ),
  // set true false to shorten manual testing
  if (true) ...[
    QuestBase.initialEventConfigRule(
      QTargetIntent.eventLevel(),
      DlgStr.eventDescrip,
      [],
      CaptureAndCast<String>((s) => s),
      questId: QuestionIdStrings.eventDescrip,
    ),
    QuestBase.initialEventConfigRule(
      QTargetIntent.eventLevel(),
      // QDefCollection([]),
      DlgStr.eventType,
      EvType.values.map((e) => e.name),
      CaptureAndCast<EvType>(
        (s) => EvType.values[int.tryParse(s) ?? 0],
      ),
      questId: QuestionIdStrings.eventType,
    ),
    QuestBase.initialEventConfigRule(
      QTargetIntent.eventLevel(),
      // QDefCollection([]),
      DlgStr.eventWhosCompeting,
      EvCompetitorType.values.map((e) => e.name),
      CaptureAndCast<EvCompetitorType>(
        (s) => EvCompetitorType.values[int.tryParse(s) ?? 0],
      ),
      questId: QuestionIdStrings.competitorType,
    ),
    QuestBase.initialEventConfigRule(
      QTargetIntent.eventLevel(),
      // QDefCollection([]),
      DlgStr.eventCompPlayAgainst,
      EvOpponentType.values.map((e) => e.name),
      CaptureAndCast<EvOpponentType>(
          (s) => EvOpponentType.values[int.tryParse(s) ?? 0]),
      // (i) => EvOpponentType.values[i],
      questId: QuestionIdStrings.competeAgainstType,
    ),
    QuestBase.initialEventConfigRule(
      QTargetIntent.eventLevel(),
      // QDefCollection([]),
      DlgStr.eventDuration,
      EvDuration.values.map((e) => e.name),
      CaptureAndCast<EvDuration>(
          (s) => EvDuration.values[int.tryParse(s) ?? 0]),
      // (i) => EvDuration.values[i],
      questId: QuestionIdStrings.eventDuration,
    ),
    QuestBase.initialEventConfigRule(
      QTargetIntent.eventLevel(),
      // QDefCollection([]),
      DlgStr.eventEliminationStrategy,
      EvEliminationStrategy.values.map((e) => e.name),
      CaptureAndCast<EvEliminationStrategy>(
          (s) => EvEliminationStrategy.values[int.tryParse(s) ?? 0]),
      // (i) => EvEliminationStrategy.values[i],
      questId: QuestionIdStrings.eventEliminationStrategy,
    ),
    QuestBase.initialEventConfigRule(
      QTargetIntent.eventLevel(),
      // QDefCollection([]),
      DlgStr.useSameRowStyleForAllScreens,
      ['no', 'yes'],
      CaptureAndCast<bool>((ls) => ls == '1'),
      // (i) => i == '1',
      // defaultAnswerIdx: 1,
      questId: QuestionIdStrings.globalRowStyle,
    ),
  ],
  // ask which screens to configure
  QuestBase.dlogCascade(
    QTargetIntent.eventLevel(responseAddsWhichAreaQuestions: true),
    // QDefCollection([]),
    DlgStr.selectAppScreens, // <String, List<AppScreen>>
    AppScreen.eventConfiguration.topConfigurableScreens.map((e) => e.name),
    CaptureAndCast<List<AppScreen>>((s) => castStrOfIdxsToIterOfInts(s)
        .map((idx) => AppScreen.eventConfiguration.topConfigurableScreens[idx])
        .toList()),
    questId: QuestionIdStrings.selectAppScreens,
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