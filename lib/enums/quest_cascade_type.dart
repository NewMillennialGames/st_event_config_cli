part of EvCfgEnums;

enum QuestCascadeTyp {
  /* Cascade Type defines:
    how does response from user
    to a current question
    impact future questions in the pending list

    see extension below for clear wording
   */
  noCascade,
  addsWhichAreaInEachScreenQuestions,
  addsWhichSlotOfSelectedAreaQuestions, // for each screen
  addsWhichRuleForAreaOrSlotOfScreen, // for each area and slot of each screen
  addsVisualRuleQuestions,
  addsBehavioralRuleQuestions
}

extension QuestCascadeTypExt on QuestCascadeTyp {
  /*
  properties exposed to Question up thru the QuestionQuantifier
  these properties describe CURRENT question 
  (not the ones they will be creating)
  */
  bool get generatesNoNewQuestions => this == QuestCascadeTyp.noCascade;

  bool get asksAboutRulesAndSlotsWithinSelectedScreenAreas =>
      this == QuestCascadeTyp.addsWhichAreaInEachScreenQuestions;

  bool get asksSlotsWithinSelectedScreenAreas =>
      this == QuestCascadeTyp.addsWhichSlotOfSelectedAreaQuestions;

  bool get asksRuleTypesForSelectedAreasOrSlots =>
      this == QuestCascadeTyp.addsWhichRuleForAreaOrSlotOfScreen;

  bool get asksDetailsForEachVisualRuleType =>
      this == QuestCascadeTyp.addsVisualRuleQuestions;

  bool get asksDetailsForEachBehaveRuleType =>
      this == QuestCascadeTyp.addsBehavioralRuleQuestions;
}
