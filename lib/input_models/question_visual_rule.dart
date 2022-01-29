part of InputModels;

class VisualRuleQuestion<ConvertTyp, AnsTyp extends RuleResponseWrapperIfc>
    extends Question<ConvertTyp, AnsTyp> {
  /*
    VisualRuleQuestion questions are multi-part questions
    need to ask user:
      depending on visRuleType, the questions required are one of:
        VisRuleQuestType enum

    must collect enough data to render the full rule
  */
  late final VisRuleChoiceConfig _questDef;

  VisualRuleQuestion(
    AppScreen appSection,
    ScreenWidgetArea screenArea,
    VisualRuleType visRuleType,
    ScreenAreaWidgetSlot? slot,
    // CastUserInputToTyp<ConvertTyp, AnsTyp>? castFunc,
  ) : super(
          QuestionQuantifier.ruleCompositionLevel(
            appSection,
            screenArea,
            visRuleType,
            slot,
            null,
          ),
          'niu--sub questions will be used',
          null,
          null,
        ) {
    this._questDef = VisRuleChoiceConfig.fromRuleTyp(visRuleType);
    this.response = UserResponse(visRuleType.ruleResponseContainer as AnsTyp);
  }

  VisRuleChoiceConfig get questDef => _questDef;
  List<VisRuleQuestWithChoices> get questsAndChoices =>
      _questDef.questsAndChoices;

  @override
  String get questStr => _questDef.questStr;

  void castResponseListAndStore(Map<VisRuleQuestType, String> multiAnswerMap) {
    // store user answers
    (this.response?.answers as RuleResponseWrapperIfc)
        .castResponsesToAnswerTypes(multiAnswerMap);
  }
}
