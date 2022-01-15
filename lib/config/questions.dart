import '../input_models/all.dart';
import '../enums/all.dart';

// public api
List<Question> loadQuestionsForSection(AppSection appSection) {
  List<Question> _questionLst = _getQuestionList();
  return _questionLst.where((qb) => qb.section == appSection).toList();
}

// accumulate configuration data
final List<Qb> _questData = [
  // eventConfiguration questions
  Qb<String>(
    AppSection.eventConfiguration,
    'Enter Event Template Name',
  ),
  Qb<String>(
    AppSection.eventConfiguration,
    'Enter Event Template Descrip',
  ),
  Qb<EvType>(
    AppSection.eventConfiguration,
    'Select Event Type',
    EvType.values.map((e) => e.name),
    (i) => EvType.values[i],
  ),
  Qb<EvCompetitorType>(
    AppSection.eventConfiguration,
    'Whos competing .. what will be traded',
    EvCompetitorType.values.map((e) => e.name),
    (i) => EvCompetitorType.values[i],
  ),
  Qb<EvOpponentType>(
    AppSection.eventConfiguration,
    'Who are they playing against',
    EvOpponentType.values.map((e) => e.name),
    (i) => EvOpponentType.values[i],
  ),
  Qb<EvDuration>(
    AppSection.eventConfiguration,
    'How long will event last',
    EvDuration.values.map((e) => e.name),
    (i) => EvDuration.values[i],
  ),
  Qb<EvEliminationStrategy>(
    AppSection.eventConfiguration,
    'How does elimination work',
    EvEliminationStrategy.values.map((e) => e.name),
    (i) => EvEliminationStrategy.values[i],
  ),

  if (AppSection.eventSelection.isConfigureable)
    Qb<List<int>>(
      AppSection.eventSelection,
      AppSection.eventSelection.includeStr,
      AppSection.eventSelection.applicableComponents.map((e) => e.name),
      // (commaLstOfInts) => commaLstOfInts.,
    ),
];

List<Question> _questionLst = [];
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
