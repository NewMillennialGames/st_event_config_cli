part of InputModels;

class VisualRuleQuestion<ConvertTyp, AnsTyp extends RuleResponseWrapper>
    extends Question<ConvertTyp, AnsTyp> {
  /*
    VisualRuleQuestion questions are multi-part questions
    need to ask user:
      depending on visRuleType, the questions required are one of:
        VisRuleQuestType enum

    must collect enough data to render the full rule
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

  void castResponseListAndStore(Map<VisRuleQuestType, String> multiAnswerMap) {
    // store user answers
    this.response = UserResponse(RuleResponseWrapper(multiAnswerMap) as AnsTyp);
  }

  @override
  bool get isRuleQuestion => true;
}
