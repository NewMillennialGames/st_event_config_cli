import '../input_models/all.dart';
import '../enums/all.dart';
import './strings.dart';

typedef Qb<ConvertTyp, AnsTyp> = Question<ConvertTyp, AnsTyp>;

// public api
List<Question> loadQuestionsForSection(AppSection appSection) {
  // List<Question> _questionLst = _getQuestionList();
  return _questionLst
      .where((qb) => qb.appSection == appSection && qb.uiComponent == null)
      .toList();
}

List<Question> loadSpecificComponentQuestions(
  AppSection section,
  UserResponse<List<UiComponent>> response,
) {
  // load questions about components in section
  List<UiComponent> relatedComponentsToConfigure = response.answers;
  List<Question> newQuestions = _questionLst
      .where((q) =>
          q.appSection == section &&
          relatedComponentsToConfigure.contains(q.uiComponent))
      .toList();
  return newQuestions;
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
  // top sections are asked automatically;
  // and if user proceeds, then we ask them
  // which UI components in the section they want to configure

  if (AppSection.marketView.isConfigureable)
    Qb<String, List<UiComponent>>(
      QuestionQuantifier.appSectionLevel(AppSection.marketView),
      AppSection.marketView.includeStr,
      AppSection.marketView.applicableComponents.map((e) => e.name),
      AppSection.marketView.convertIdxsToComponentList,
    ),
  if (AppSection.marketView.isConfigureable)
    for (UiComponent uic in AppSection.marketView.applicableComponents)
      for (VisualRuleType rt in uic.applicableRuleTypes)
        Qb<String, bool>(
          QuestionQuantifier.uiComponentLevel(AppSection.marketView, uic),
          'Want to configure ${rt.name} on ${uic.name}?',
          null,
          (yOrN) => yOrN.toUpperCase().startsWith('Y'),
        ),
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