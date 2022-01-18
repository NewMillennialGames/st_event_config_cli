part of QuestConfig;

// import '../rules/rule.dart';

//
List<Question> fabricateVisualRuleQuestions(
  AppSection section,
  UiComponent uiComp,
  UserResponse<List<VisualRuleType>> response,
) {
  /*
    this method fabricates the rule rather than
    loading an existing one
  */
  List<Question> lst = [];
  for (VisualRuleType rt in response.answers) {
    lst.add(
      VisualRuleQuestion<String, PropertyMap>(
        section,
        uiComp,
        rt,
        castInputStrToPropertyMap,
      ),
    );
  }

  return lst;
}

PropertyMap castInputStrToPropertyMap(String userInput) {
  //
  return PropertyMap(
    DbRowType.asset,
    UiComponentSlotName.header,
    'propertyName',
    MenuSortOrGroupIndex.first,
    sortDescending: true,
  );
}
