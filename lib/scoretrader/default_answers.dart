part of StUiController;

class DefaultAnswerBuilder {
  //
  List<RuleResponseBase> _defaultAnswers = [];
  //
  DefaultAnswerBuilder._(this._defaultAnswers);

  factory DefaultAnswerBuilder.forMissingAreaOrSlot(
    AppScreen appScreen,
    ScreenWidgetArea screenArea,
    VisualRuleType visRuleType,
    ScreenAreaWidgetSlot? slot,
    Set<VisRuleQuestType> needRespQuestTypes,
  ) {
    //
    Map<VisRuleQuestType, String> _answers = {};
    for (VisRuleQuestType ruleQuestTyp in needRespQuestTypes) {
      _answers[ruleQuestTyp] = '${ruleQuestTyp.defaultChoice}';
    }

    var respContainer = visRuleType.ruleResponseContainer;
    respContainer.castResponsesToAnswerTypes(_answers);
    return DefaultAnswerBuilder._([respContainer]);
  }

  List<RuleResponseBase> get defaultAnswers => _defaultAnswers;
}
