part of EvCfgEnums;

enum QuestCascadeTypEnum {
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
  addsRuleDetailQuestsForSlotOrArea,
  // addsVisualRuleDetailQuestions,
  // addsBehavioralRuleQuestions,
  noCascade,
}

extension QuestCascadeTypExt on QuestCascadeTypEnum {
  /*
  properties exposed to Question up thru the QuestionQuantifier
  these properties describe CURRENT question 
  (not the ones they will be creating)
  */
  bool get generatesNoNewQuestions => this == QuestCascadeTypEnum.noCascade;

  bool get addsWhichAreaInSelectedScreenQuestions =>
      this == QuestCascadeTypEnum.addsWhichAreaInSelectedScreenQuestions;

  bool get addsWhichRulesForSelectedAreaQuestions =>
      this == QuestCascadeTypEnum.addsWhichRulesForSelectedAreaQuestions;

  bool get addsWhichSlotOfSelectedAreaQuestions =>
      this == QuestCascadeTypEnum.addsWhichSlotOfSelectedAreaQuestions;

  bool get addsWhichRulesForSlotsInArea =>
      this == QuestCascadeTypEnum.addsWhichRulesForSlotsInArea;

  bool get addsRuleDetailQuestsForSlotOrArea =>
      this == QuestCascadeTypEnum.addsRuleDetailQuestsForSlotOrArea;

  // bool get addsVisualRuleDetailQuestions =>
  //     this == QuestCascadeTyp.addsVisualRuleDetailQuestions;

  // bool get addsBehavioralRuleQuestions =>
  //     this == QuestCascadeTyp.addsBehavioralRuleQuestions;
}
