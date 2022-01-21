part of EvCfgEnums;

enum QuestCascadeTyp {
  /* Cascade Type defines:
    how does response from user
    to a current question
    impact future questions in the pending list
   */
  noCascade,
  addsWhichAreaInEachScreenQuestions,
  addsWhichPartOfSelectedAreaQuestions, // for each screen
  addsVisualRuleQuestions,
  addsBehavioralRuleQuestions
}

extension QuestCascadeTypExt on QuestCascadeTyp {
  //
  bool get generatesNoQuestions => this == QuestCascadeTyp.noCascade;

  bool get addsWhichAreaInEachScreenQuestions =>
      this == QuestCascadeTyp.addsWhichAreaInEachScreenQuestions;

  bool get addsWhichSlotsOfSelectedAreaQuestions =>
      this == QuestCascadeTyp.addsWhichPartOfSelectedAreaQuestions;

  bool get addsVisualRuleQuestions =>
      this == QuestCascadeTyp.addsVisualRuleQuestions;

  bool get addsBehavioralRuleQuestions =>
      this == QuestCascadeTyp.addsBehavioralRuleQuestions;
}
