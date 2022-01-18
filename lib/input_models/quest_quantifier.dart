part of CfgInputModels;

// below implements local memoize cache

// Map<String, QuestionQuantifier> _qqCache = {};

// String _makeQqKey(
//   QuestCascadeTyp cascadeType,
//   AppSection appSection,
//   UiComponent? uiCompInSection,
//   VisualRuleType? visRuleTypeForComp,
//   BehaviorRuleType? behRuleTypeForComp,
// ) {
//   // bump idx for optionals up by 1 so zero represents unset state
//   int uiCompIdx = 1 + (uiCompInSection?.index ?? -1);
//   int visRuleTypeForCompIdx = 1 + (visRuleTypeForComp?.index ?? -1);
//   int behRuleTypeForCompIdx = 1 + (behRuleTypeForComp?.index ?? -1);
//   return '${cascadeType.index}-${appSection.index}-$uiCompIdx-$visRuleTypeForCompIdx-$behRuleTypeForCompIdx';
// }

class QuestionQuantifier {
  // describes question purpose, behavior and output
  // not sure if I need to make it equatable or cache dups??
  final QuestCascadeTyp cascadeType;
  final AppSection appSection;
  final UiComponent? uiCompInSection;
  final VisualRuleType? ruleTypeForComp;
  final BehaviorRuleType? behRuleTypeForComp;

  const QuestionQuantifier._(
    this.cascadeType,
    this.appSection,
    this.uiCompInSection,
    this.ruleTypeForComp,
    this.behRuleTypeForComp,
  );

  bool get capturesScalarValues => cascadeType.capturesScalarValues;
  bool get addsOrDeletesFutureQuestions =>
      cascadeType.addsOrDeletesFutureQuestions;
  bool get producesVisualRules => cascadeType.producesVisualRules;
  bool get producesBehavioralRules => cascadeType.producesBehavioralRules;

  factory QuestionQuantifier.custom(
    QuestCascadeTyp cascadeType,
    AppSection appSection,
    UiComponent? uiCompInSection,
    VisualRuleType? visRuleTypeForComp,
    BehaviorRuleType? behRuleTypeForComp,
  ) {
    // var key = _makeQqKey(
    //   cascadeType,
    //   appSection,
    //   uiCompInSection,
    //   visRuleTypeForComp,
    //   behRuleTypeForComp,
    // );

    // var cached = _qqCache[key];
    // if (cached != null) return cached;

    QuestionQuantifier qq = QuestionQuantifier._(
      cascadeType,
      appSection,
      uiCompInSection,
      visRuleTypeForComp,
      behRuleTypeForComp,
    );
    // store in cache
    // _qqCache[key] = qq;
    return qq;
  }

  factory QuestionQuantifier.eventLevel() {
    return const QuestionQuantifier._(
      QuestCascadeTyp.captureValue,
      AppSection.eventConfiguration,
      null,
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
      null,
    );
  }

  factory QuestionQuantifier.ruleCompositionLevel(
    AppSection appSection,
    UiComponent uiCompInSection,
    VisualRuleType? visRuleTypeForComp,
    BehaviorRuleType? behRuleTypeForComp,
  ) {
    return QuestionQuantifier._(
      QuestCascadeTyp.produceVisualRule,
      appSection,
      uiCompInSection,
      visRuleTypeForComp,
      behRuleTypeForComp,
    );
  }
}
