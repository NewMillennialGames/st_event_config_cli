part of EvCfgEnums;

enum QuestCascadeTyp {
  /* Cascade Type defines:
    how does response from user
    to a current question
    impact future questions in the pending list
   */
  noCascade,
  appendsPerSectionQuestions,
  appendsPerSectionAreaQuestions,
  produceVisualRule,
  produceBehavioralRule
}

extension QuestCascadeTypExt on QuestCascadeTyp {
  //
  bool get generatesNoQuestions => this == QuestCascadeTyp.noCascade;

  bool get addsPerSectionQuestions =>
      this == QuestCascadeTyp.appendsPerSectionQuestions;

  bool get addsAreaQuestions =>
      this == QuestCascadeTyp.appendsPerSectionAreaQuestions;

  bool get producesVisualRules => this == QuestCascadeTyp.produceVisualRule;

  bool get producesBehavioralRules =>
      this == QuestCascadeTyp.produceBehavioralRule;
}
