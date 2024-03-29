part of EvCfgConfig;

// public api
List<QuestBase> loadInitialConfigQuestions() {
  // event config Quest2s DO NOT have areas or uiComponents
  return _initQuestionLst
      .where((qb) =>
          qb.appScreen == AppScreen.eventConfiguration && qb.isEventConfigQuest)
      .toList();
}

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
    QTargetResolution.forEvent(),
    DlgStr.eventName,
    [],
    CaptureAndCast<String>((qb, s) => s),
    questId: QuestionIdStrings.eventName,
  ),
  // should be true;  set false to shorten manual testing
  if (true) ...[
    QuestBase.initialEventConfigRule(
      QTargetResolution.forEvent(),
      DlgStr.eventDescrip,
      [],
      CaptureAndCast<String>((qb, s) => s),
      questId: QuestionIdStrings.eventDescrip,
    ),
    QuestBase.initialEventConfigRule(
      QTargetResolution.forEvent(),
      DlgStr.eventType,
      EvType.values.map((e) => e.name),
      CaptureAndCast<EvType>(
        (qb, s) => EvType.values[int.tryParse(s) ?? 0],
      ),
      questId: QuestionIdStrings.eventType,
    ),
    QuestBase.initialEventConfigRule(
      QTargetResolution.forEvent(),
      DlgStr.eventWhosCompeting,
      EvCompetitorType.values.map((e) => e.name),
      CaptureAndCast<EvCompetitorType>(
        (qb, s) => EvCompetitorType.values[int.tryParse(s) ?? 0],
      ),
      questId: QuestionIdStrings.competitorType,
    ),
    QuestBase.initialEventConfigRule(
      QTargetResolution.forEvent(),
      DlgStr.eventCompPlayAgainst,
      EvOpponentType.values.map((e) => e.name),
      CaptureAndCast<EvOpponentType>(
        (qb, s) => EvOpponentType.values[int.tryParse(s) ?? 0],
      ),
      questId: QuestionIdStrings.competeAgainstType,
    ),
    QuestBase.initialEventConfigRule(
      QTargetResolution.forEvent(),
      DlgStr.eventDuration,
      EvDuration.values.map((e) => e.name),
      CaptureAndCast<EvDuration>(
        (qb, s) => EvDuration.values[int.tryParse(s) ?? 0],
      ),
      questId: QuestionIdStrings.eventDuration,
    ),
    QuestBase.initialEventConfigRule(
      QTargetResolution.forEvent(),
      DlgStr.eventEliminationStrategy,
      EvEliminationStrategy.values.map((e) => e.name),
      CaptureAndCast<EvEliminationStrategy>(
        (qb, s) => EvEliminationStrategy.values[int.tryParse(s) ?? 0],
      ),
      questId: QuestionIdStrings.eventEliminationStrategy,
    ),
    QuestBase.initialEventConfigRule(
      QTargetResolution.forEvent(),
      DlgStr.useSameRowStyleForAllScreens,
      ['no', 'yes'],
      CaptureAndCast<bool>((qb, ls) => ls == '1'),
      questId: QuestionIdStrings.globalRowStyle,
    ),
    QuestBase.initialEventConfigRule(
      QTargetResolution.forEvent(),
      DlgStr.eventGameAgeOffPolicy,
      EvGameAgeOffRule.values.map((e) => e.name),
      CaptureAndCast<EvGameAgeOffRule>(
        (QuestBase qb, String s) =>
            EvGameAgeOffRule.values[int.tryParse(s) ?? 0],
      ),
      questId: QuestionIdStrings.eventAgeOffGameRule,
    ),
    // below not needed;  each filter menu lets you set field to use
    // QuestBase.initialEventConfigRule(
    //   QTargetResolution.forEvent(),
    //   DlgStr.useAssetShortNameInFilters,
    //   ['no', 'yes'],
    //   CaptureAndCast<bool>((qb, ls) => ls == '1'),
    //   questId: QuestionIdStrings.useAssetShortNameInFilters,
    // ),
    QuestBase.initialEventConfigRule(
      QTargetResolution.forEvent(),
      DlgStr.selectAssetNameDisplayStyle,
      EvAssetNameDisplayStyle.values.map((e) => e.name),
      CaptureAndCast<EvAssetNameDisplayStyle>(
        (QuestBase qb, String s) =>
            EvAssetNameDisplayStyle.values[int.tryParse(s) ?? 0],
      ),
      questId: QuestionIdStrings.selectAssetNameDisplayStyle,
    ),
    QuestBase.initialEventConfigRule(
      QTargetResolution.forEvent(),
      DlgStr.hideStockTicker,
      ['no', 'yes'],
      // cast logic inverted because ShowHideCfg (RuleResponseBase) uses "Show"
      CaptureAndCast<bool>((QuestBase qb, String ls) => ls.startsWith('1')),
      questId: QuestionIdStrings.hideStockTicker,
    ),
  ],
  // ask which screens to configure
  QuestBase.initialEventConfigRule(
    QTargetResolution.forEvent(),
    DlgStr.selectAppScreens, // <String, List<AppScreen>>
    AppScreen.eventConfiguration.configurableAppScreens.map((e) => e.name),
    CaptureAndCast<List<AppScreen>>(
      (QuestBase qb, String s) => castStrOfIdxsToIterOfInts(s)
          .map(
            (idx) => AppScreen.eventConfiguration.configurableAppScreens[idx],
          )
          .toList(),
    ),
    questId: QuestionIdStrings.selectAppScreens,
    isSelectScreensQuestion: true,
  ),
  // after user selects desired screens to configure, then
  // which screen areas (and slots on those areas) are asked automatically;
  // then we ask them which visual rules they'd like to apply
  // to those areas and/or which area-slots are desired
];
