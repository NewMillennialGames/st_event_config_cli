part of EvCfgEnums;

enum UserResponseCascadePatternEm {
  /* UserResponseCascadePattern defines:
    how does response from user
    to a current question
    impact future questions in the pending list

    see extension below for clear wording

    I want NO CASCADE questions to sort to LAST position
    so I moved it's index to the bottom of list
   */
  addsWhichAreaInSelectedScreenQuestions,
  addsWhichRulesForSelectedAreaQuestions, // for each area of each screen
  addsWhichSlotOfSelectedAreaQuestions, // for each screen & area
  addsWhichRulesForSlotsInArea, // for each slot in area
  addsRuleDetailQuestsForSlotOrArea,
  // addsVisualRuleDetailQuestions,
  // addsBehavioralRuleQuestions,
  noCascade,
}

extension UserResponseCascadePatternExt on UserResponseCascadePatternEm {
  /*
  properties exposed to Question up thru the QuestionQuantifier
  these properties describe CURRENT question 
  (not the ones they will be creating)
  */
  bool get generatesNoNewQuestions =>
      this == UserResponseCascadePatternEm.noCascade;

  bool get addsWhichAreaInSelectedScreenQuestions =>
      this ==
      UserResponseCascadePatternEm.addsWhichAreaInSelectedScreenQuestions;

  bool get addsWhichRulesForSelectedAreaQuestions =>
      this ==
      UserResponseCascadePatternEm.addsWhichRulesForSelectedAreaQuestions;

  bool get addsWhichSlotOfSelectedAreaQuestions =>
      this == UserResponseCascadePatternEm.addsWhichSlotOfSelectedAreaQuestions;

  bool get addsWhichRulesForSlotsInArea =>
      this == UserResponseCascadePatternEm.addsWhichRulesForSlotsInArea;

  bool get addsRuleDetailQuestsForSlotOrArea =>
      this == UserResponseCascadePatternEm.addsRuleDetailQuestsForSlotOrArea;

  // bool get addsVisualRuleDetailQuestions =>
  //     this == QuestCascadeTyp.addsVisualRuleDetailQuestions;

  // bool get addsBehavioralRuleQuestions =>
  //     this == QuestCascadeTyp.addsBehavioralRuleQuestions;
}
