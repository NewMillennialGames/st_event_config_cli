part of CfgInputModels;

class VisualRuleQuestion<ConvertTyp, AnsTyp>
    extends Question<ConvertTyp, AnsTyp> {
  /*
    Rule questions are multi-part questions
    need to ask user:
      1) which table to use
      2) which col/attr/property from that table
      3) priority position of selected property

    must collect enough data to produce:
      class PropertyMap {
        DbRowType recType;
        UiComponentSlotName property;
        String propertyName;
        MenuSortOrGroupIndex menuIdx;
        bool sortDescending;  }

  */
  VisualRuleQuestion(
    AppSection appSection,
    UiComponent uiComp,
    VisualRuleType visRuleType,
    CastUserInputToTyp<ConvertTyp, AnsTyp>? castFunc,
  ) : super(
          QuestionQuantifier.ruleCompositionLevel(
            appSection,
            uiComp,
            visRuleType,
            null,
          ),
          visRuleType.questionStr(appSection, uiComp),
          visRuleType.choiceOptions(appSection, uiComp),
          castFunc,
        );

  List<String> get dbTableChoices =>
      DbRowType.values.map((e) => e.name).toList();

  List<String> dbTablePropertyChoices(DbRowType rt) =>
      rt.associatedProperties.map((e) => e.name).toList();

  @override
  bool get isRuleQuestion => true;
}
