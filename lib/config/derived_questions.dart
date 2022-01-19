part of QuestConfig;

//
List<Question> fabricateVisualRuleQuestions(
  AppSection section,
  SectionUiArea uiComp,
  UserResponse<List<VisualRuleType>> response,
) {
  /*
    this method fabricates the rule rather than
    loading an existing one
  */
  List<Question> lst = [];
  for (VisualRuleType rt in response.answers) {
    lst.add(
      VisualRuleQuestion<String, RuleResponseWrapper>(
        section,
        uiComp,
        rt,
        castInputStrToPropertyMap,
      ),
    );
  }
  return lst;
}

RuleResponseWrapper castInputStrToPropertyMap(String userInput) {
  //
  return RuleResponseWrapper(
    DbRowType.asset,
    UiAreaSlotName.header,
    'propertyName',
    MenuSortOrGroupIndex.first,
    sortDescending: true,
  );
}
