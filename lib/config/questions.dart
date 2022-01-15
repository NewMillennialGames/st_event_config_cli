import '../input_models/all.dart';
import '../enums/all.dart';

List<Question> _questionLst = [];

// public api
List<Question> loadQuestionsForSection(AppSection appSection) {
  List<Question> _questionLst = _getQuestionList();
  return _questionLst.where((qb) => qb.section == appSection).toList();
}

// accumulate configuration data
final List<Qb> _questData = [
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
    AppSection.eventConfiguration,
    'Enter Event Template Name',
    null,
    null,
  ),
  Qb<String, String>(
    AppSection.eventConfiguration,
    'Enter Event Template Descrip',
    null,
    null,
  ),
  Qb<EvType, int>(
    AppSection.eventConfiguration,
    'Select Event Type',
    EvType.values.map((e) => e.name),
    (i) => EvType.values[i],
  ),
  Qb<EvCompetitorType, int>(
    AppSection.eventConfiguration,
    'Whos competing .. what will be traded',
    EvCompetitorType.values.map((e) => e.name),
    (i) => EvCompetitorType.values[i],
  ),
  Qb<EvOpponentType, int>(
    AppSection.eventConfiguration,
    'Who are they playing against',
    EvOpponentType.values.map((e) => e.name),
    (i) => EvOpponentType.values[i],
  ),
  Qb<EvDuration, int>(
    AppSection.eventConfiguration,
    'How long will event last',
    EvDuration.values.map((e) => e.name),
    (i) => EvDuration.values[i],
  ),
  Qb<EvEliminationStrategy, int>(
    AppSection.eventConfiguration,
    'How does elimination work',
    EvEliminationStrategy.values.map((e) => e.name),
    (i) => EvEliminationStrategy.values[i],
  ),
  if (AppSection.eventSelection.isConfigureable)
    Qb<List<UiComponent>, String>(
      AppSection.eventSelection,
      AppSection.eventSelection.includeStr,
      AppSection.eventSelection.applicableComponents.map((e) => e.name),
      AppSection.eventSelection.convertIdxsToComponentList,
      generatesMoreQuestions: true,
    ),
  if (AppSection.poolSelection.isConfigureable)
    Qb<List<UiComponent>, String>(
      AppSection.poolSelection,
      AppSection.poolSelection.includeStr,
      AppSection.poolSelection.applicableComponents.map((e) => e.name),
      AppSection.poolSelection.convertIdxsToComponentList,
      generatesMoreQuestions: true,
    ),
  if (AppSection.marketView.isConfigureable)
    Qb<List<UiComponent>, String>(
      AppSection.marketView,
      AppSection.marketView.includeStr,
      AppSection.marketView.applicableComponents.map((e) => e.name),
      AppSection.marketView.convertIdxsToComponentList,
      generatesMoreQuestions: true,
    ),
  if (AppSection.socialPools.isConfigureable)
    Qb<List<UiComponent>, String>(
      AppSection.socialPools,
      AppSection.socialPools.includeStr,
      AppSection.socialPools.applicableComponents.map((e) => e.name),
      AppSection.socialPools.convertIdxsToComponentList,
      generatesMoreQuestions: true,
    ),
  if (AppSection.news.isConfigureable)
    Qb<List<UiComponent>, String>(
      AppSection.news,
      AppSection.news.includeStr,
      AppSection.news.applicableComponents.map((e) => e.name),
      AppSection.news.convertIdxsToComponentList,
      generatesMoreQuestions: true,
    ),
  if (AppSection.leaderboard.isConfigureable)
    Qb<List<UiComponent>, String>(
      AppSection.leaderboard,
      AppSection.leaderboard.includeStr,
      AppSection.leaderboard.applicableComponents.map((e) => e.name),
      AppSection.leaderboard.convertIdxsToComponentList,
      generatesMoreQuestions: true,
    ),
  if (AppSection.portfolio.isConfigureable)
    Qb<List<UiComponent>, String>(
      AppSection.portfolio,
      AppSection.portfolio.includeStr,
      AppSection.portfolio.applicableComponents.map((e) => e.name),
      AppSection.portfolio.convertIdxsToComponentList,
      generatesMoreQuestions: true,
    ),
  if (AppSection.trading.isConfigureable)
    Qb<List<UiComponent>, String>(
      AppSection.trading,
      AppSection.trading.includeStr,
      AppSection.trading.applicableComponents.map((e) => e.name),
      AppSection.trading.convertIdxsToComponentList,
      generatesMoreQuestions: true,
    ),
  if (AppSection.marketResearch.isConfigureable)
    Qb<List<UiComponent>, String>(
      AppSection.marketResearch,
      AppSection.marketResearch.includeStr,
      AppSection.marketResearch.applicableComponents.map((e) => e.name),
      AppSection.marketResearch.convertIdxsToComponentList,
      generatesMoreQuestions: true,
    ),
];

//
List<Question> _getQuestionList() {
  // first run will store data in a global
  if (_questionLst.length > 4) return _questionLst;

  int qNum = 0;
  for (Qb q in _questData) {
    qNum += 1;
    _questionLst.add(Question(
      qNum,
      q,
    ));
  }
  return _questionLst;
}
