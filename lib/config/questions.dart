import '../input_models/all.dart';
import '../enums/all.dart';

// List<Question> _questionLst = [];

// public api
List<Question> loadQuestionsForSection(AppSection appSection) {
  // List<Question> _questionLst = _getQuestionList();
  return _questionLst.where((qb) => qb.section == appSection).toList();
}

typedef Qb<ConvertTyp, AnsTyp> = Question;

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
    'Enter Event Template Name',
    null,
    null,
  ),
  Qb<String, String>(
    QuestionQuantifier.eventLevel(),
    'Enter Event Template Descrip',
    null,
    null,
  ),
  Qb<int, EvType>(
    QuestionQuantifier.eventLevel(),
    'Select Event Type',
    EvType.values.map((e) => e.name),
    (i) => EvType.values[i],
  ),
  Qb<int, EvCompetitorType>(
    QuestionQuantifier.eventLevel(),
    'Whos competing .. what will be traded',
    EvCompetitorType.values.map((e) => e.name),
    (i) => EvCompetitorType.values[i],
  ),
  Qb<int, EvOpponentType>(
    QuestionQuantifier.eventLevel(),
    'Who are they playing against',
    EvOpponentType.values.map((e) => e.name),
    (i) => EvOpponentType.values[i],
  ),
  Qb<int, EvDuration>(
    QuestionQuantifier.eventLevel(),
    'How long will event last',
    EvDuration.values.map((e) => e.name),
    (i) => EvDuration.values[i],
  ),
  Qb<int, EvEliminationStrategy>(
    QuestionQuantifier.eventLevel(),
    'How does competitor elimination work',
    EvEliminationStrategy.values.map((e) => e.name),
    (i) => EvEliminationStrategy.values[i],
  ),
  // sections are asked automatically;
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
  // if (AppSection.marketView.isConfigureable)
  //   Qb<List<UiComponent>, String>(
  //     QuestionQuantifier.appSectionLevel(AppSection.marketView),
  //     AppSection.marketView.includeStr,
  //     AppSection.marketView.applicableComponents.map((e) => e.name),
  //     AppSection.marketView.convertIdxsToComponentList,
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
