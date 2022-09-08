part of OutputModels;

class DefaultAnswerBuilder {
  //
  List<RuleResponseBase> _defaultAnswers = [];
  //
  DefaultAnswerBuilder._(this._defaultAnswers);

  factory DefaultAnswerBuilder.forMissingAreaOrSlot(
    AppScreen appScreen,
    ScreenWidgetArea screenArea,
    ScreenAreaWidgetSlot? slot,
    Set<VisRuleQuestType> needRespQuestTypes,
  ) {
    //     VisualRuleType visRuleType,
    List<VisualRuleType> allAreaRules =
        screenArea.applicableRuleTypes(appScreen);
    List<VisualRuleType> allSlotRules =
        slot?.possibleConfigRules(screenArea) ?? [];

    Map<VisRuleQuestType, String> _answers = {};
    for (VisRuleQuestType ruleQuestTyp in needRespQuestTypes) {
      _answers[ruleQuestTyp] = '${ruleQuestTyp.defaultChoice}';
    }

    List<RuleResponseBase> _Answers = [];

    // var respContainer = visRuleType.ruleResponseContainer;
    // respContainer.castResponsesToAnswerTypes(_answers);
    // return DefaultAnswerBuilder._([respContainer]);

    return DefaultAnswerBuilder._([]);
  }

  List<RuleResponseBase> get defaultAnswers => _defaultAnswers;
}
