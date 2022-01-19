part of InputModels;

class VisualRuleQuestion<ConvertTyp, AnsTyp>
    extends Question<ConvertTyp, AnsTyp> {
  /*
    VisualRuleQuestion questions are multi-part questions
    need to ask user:
      depending on visRuleType, the questions required are one of:
        VisRuleQuestType enum

    must collect enough data to produce:
      class PropertyMap {
        DbRowType recType;
        UiComponentSlotName property;
        String propertyName;
        MenuSortOrGroupIndex menuIdx;
        bool sortDescending;  }

  */
  late final VisRuleQuestDef _questDef;

  VisualRuleQuestion(
    AppSection appSection,
    SectionUiArea uiComp,
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
          // visRuleType.choiceOptions(appSection, uiComp),
          null,
          castFunc,
        ) {
    this._questDef = VisRuleQuestDef.byRuleTyp(visRuleType);
  }

  VisRuleQuestDef get questDef => _questDef;
  List<VisRuleQuestWithChoices> get questsAndChoices =>
      _questDef.questsAndChoices;

  @override
  bool get isRuleQuestion => true;
}
