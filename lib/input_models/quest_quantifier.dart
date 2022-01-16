part of CfgInputModels;

// Map<String, QuestionQuantifier> _qqCache = {};

// String _makeQqKey(
//   QuestCascadeTyp cascadeType,
//   AppSection appSection,
//   UiComponent? uiCompInSection,
//   RuleType? ruleTypeForComp,
// ) {
//   // bump idx for optionals up by 1 so zero represents unset state
//   int uiCompIdx = 1 + (uiCompInSection?.index ?? -1);
//   int ruleTypeForCompIdx = 1 + (ruleTypeForComp?.index ?? -1);
//   return '${cascadeType.index}-${appSection.index}-$uiCompIdx-$ruleTypeForCompIdx';
// }

class QuestionQuantifier {
  // describes question purpose, behavior and output
  final QuestCascadeTyp cascadeType;
  final AppSection appSection;
  final UiComponent? uiCompInSection;
  final VisualRuleType? ruleTypeForComp;

  const QuestionQuantifier._(
    this.cascadeType,
    this.appSection,
    this.uiCompInSection,
    this.ruleTypeForComp,
  );

  bool get addsOrDeletesFutureQuestions =>
      cascadeType.addsOrDeletesFutureQuestions;
  bool get producesVisualRules => cascadeType.producesVisualRules;
  bool get producesBehavioralRules => cascadeType.producesBehavioralRules;

  factory QuestionQuantifier.eventLevel() {
    return const QuestionQuantifier._(
      QuestCascadeTyp.alterFutureQuestionList,
      AppSection.eventConfiguration,
      null,
      null,
    );
  }

  factory QuestionQuantifier.appSectionLevel(
    AppSection appSection,
  ) {
    return QuestionQuantifier._(
      QuestCascadeTyp.alterFutureQuestionList,
      appSection,
      null,
      null,
    );
  }

  factory QuestionQuantifier.uiComponentLevel(
    AppSection appSection,
    UiComponent uiCompInSection,
  ) {
    return QuestionQuantifier._(
      QuestCascadeTyp.alterFutureQuestionList,
      appSection,
      uiCompInSection,
      null,
    );
  }

  factory QuestionQuantifier.ruleCompositionLevel(
    AppSection appSection,
    UiComponent uiCompInSection,
    VisualRuleType ruleTypeForComp,
  ) {
    return QuestionQuantifier._(
      QuestCascadeTyp.produceVisualRule,
      appSection,
      uiCompInSection,
      ruleTypeForComp,
    );
  }
}
