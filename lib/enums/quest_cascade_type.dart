part of EventCfgEnums;

enum QuestCascadeTyp {
  captureValue,
  alterFutureQuestionList,
  produceVisualRule,
  produceBehavioralRule
}

extension QuestCascadeTypExt on QuestCascadeTyp {
  //
  bool get capturesScalarValues => this == QuestCascadeTyp.captureValue;

  bool get addsOrDeletesFutureQuestions =>
      this == QuestCascadeTyp.alterFutureQuestionList;

  bool get producesVisualRules => this == QuestCascadeTyp.produceVisualRule;

  bool get producesBehavioralRules =>
      this == QuestCascadeTyp.produceBehavioralRule;
}
