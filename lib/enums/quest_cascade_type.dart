part of EventCfgEnums;

enum QuestCascadeTyp {
  alterFutureQuestionList,
  produceVisualRule,
  produceBehavioralRule
}

extension QuestCascadeTypExt on QuestCascadeTyp {
  //
  bool get addsOrDeletesFutureQuestions =>
      this == QuestCascadeTyp.alterFutureQuestionList;

  bool get producesVisualRules => this == QuestCascadeTyp.produceVisualRule;

  bool get producesBehavioralRules =>
      this == QuestCascadeTyp.produceBehavioralRule;
}
