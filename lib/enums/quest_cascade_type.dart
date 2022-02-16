part of EvCfgEnums;

enum QuestCascadeTyp {
  /* Cascade Type defines:
    how does response from user
    to a current question
    impact future questions in the pending list

    see extension below for clear wording

    I want NO CASCADE questions to sort to LAST position
    so I moved it's index to the bottom of list
   */
  addsWhichAreaInSelectedScreenQuestions,
  addsWhichRulesForSelectedAreaQuestions, // for each area of each screen
  addsWhichSlotOfSelectedAreaQuestions, // for each screen
  addsWhichRulesForSlotsInArea, // for each slot in area
  addsVisualRuleQuestions,
  addsVisualRuleDetailQuestions,
  addsBehavioralRuleQuestions,
  noCascade,
}

extension QuestCascadeTypExt on QuestCascadeTyp {
  /*
  properties exposed to Question up thru the QuestionQuantifier
  these properties describe CURRENT question 
  (not the ones they will be creating)
  */
  bool get generatesNoNewQuestions => this == QuestCascadeTyp.noCascade;

  bool get addsWhichAreaInSelectedScreenQuestions =>
      this == QuestCascadeTyp.addsWhichAreaInSelectedScreenQuestions;

  bool get addsWhichRulesForSelectedAreaQuestions =>
      this == QuestCascadeTyp.addsWhichRulesForSelectedAreaQuestions;

  bool get addsWhichSlotOfSelectedAreaQuestions =>
      this == QuestCascadeTyp.addsWhichSlotOfSelectedAreaQuestions;

  bool get addsWhichRulesForSlotsInArea =>
      this == QuestCascadeTyp.addsWhichRulesForSlotsInArea;

  bool get addsVisualRuleQuestions =>
      this == QuestCascadeTyp.addsVisualRuleQuestions;

  bool get addsVisualRuleDetailQuestions =>
      this == QuestCascadeTyp.addsVisualRuleDetailQuestions;

  bool get addsBehavioralRuleQuestions =>
      this == QuestCascadeTyp.addsBehavioralRuleQuestions;
}
