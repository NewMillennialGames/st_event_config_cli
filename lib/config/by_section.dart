import '../enums/all.dart';
import '../input_models/all.dart';
// import '../config/questions.dart';

List<Question> loadAddlSectionQuestions(
  AppSection section,
  UserResponse<List<UiComponent>> response,
) {
  List<Question> lst = [];

  return lst;
}

//
List<Question> loadAddlRuleQuestions(
  UiComponent uiComp,
  UserResponse<List<RuleType>> response,
) {
  List<Question> lst = [];

  return lst;
}

final Map<AppSection, List<Qb>> _questData = {
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
  AppSection.eventSelection: [
    if (AppSection.eventSelection.isConfigureable)
      ...AppSection.eventSelection.applicableComponents.map((uiComp) {
        return Qb<List<RuleType>, String>(
          AppSection.eventSelection,
          uiComp.includeStr(AppSection.eventSelection),
          uiComp.applicableRuleTypes.map((e) => e.name),
          uiComp.convertIdxsToRuleList,
          generatesMoreQuestions: true,
        );
      }),
  ],
};
