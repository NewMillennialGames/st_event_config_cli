part of InputModels;

class BehaveRuleQuestion<ConvertTyp, AnsTyp extends RuleResponseBase>
    extends Question<ConvertTyp, AnsTyp> {
  /*
    not implemented or tested ...
    DO NOT use until fully built ...
  */
  late final VisRuleChoiceConfig _questDef;

  BehaveRuleQuestion(
    AppScreen appSection,
    ScreenWidgetArea screenArea,
    VisualRuleType visRuleType,
    ScreenAreaWidgetSlot? slot,
    // CastUserInputToTyp<ConvertTyp, AnsTyp>? castFunc,
  ) : super(
          QuestionQuantifier.ruleDetailMultiResponse(
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
  }

  VisRuleChoiceConfig get questDef => _questDef;
  List<VisRuleQuestWithChoices> get questsAndChoices =>
      _questDef.questsAndChoices;

  void castResponseListAndStore(Map<VisRuleQuestType, String> multiAnswerMap) {
    // store user answers
    // this.response = UserResponse(RuleResponseWrapper(multiAnswerMap) as AnsTyp);
  }
}
