part of EvCfgEnums;

// @JsonEnum()
enum QIntentEm {
  infoOrCliCfg, // behavior of CLI or name of output file
  structural, // governs future questions
  visual, // creates visual rules
  behavioral, // ceates behavioral rules
  diagnostic, // for debugging or testing purposes
}

// @JsonEnum()
enum QTargetLevelEm {
  /* what level or scope is this question
    operating on
  */
  notAnAppRule,
  screenRule,
  areaRule,
  slotRule,
}

enum QRespCascadePatternEm {
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

extension UserResponseCascadePatternExt on QRespCascadePatternEm {
  /*
  properties exposed to Question up thru the QuestionQuantifier
  these properties describe CURRENT question 
  (not the ones they will be creating)
  */
  bool get generatesNoNewQuestions => this == QRespCascadePatternEm.noCascade;

  bool get addsWhichAreaInSelectedScreenQuestions =>
      this == QRespCascadePatternEm.addsWhichAreaInSelectedScreenQuestions;

  bool get addsWhichRulesForSelectedAreaQuestions =>
      this == QRespCascadePatternEm.addsWhichRulesForSelectedAreaQuestions;

  bool get addsWhichSlotOfSelectedAreaQuestions =>
      this == QRespCascadePatternEm.addsWhichSlotOfSelectedAreaQuestions;

  bool get addsWhichRulesForSlotsInArea =>
      this == QRespCascadePatternEm.addsWhichRulesForSlotsInArea;

  bool get addsRuleDetailQuestsForSlotOrArea =>
      this == QRespCascadePatternEm.addsRuleDetailQuestsForSlotOrArea;

  // bool get addsVisualRuleDetailQuestions =>
  //     this == QuestCascadeTyp.addsVisualRuleDetailQuestions;

  // bool get addsBehavioralRuleQuestions =>
  //     this == QuestCascadeTyp.addsBehavioralRuleQuestions;
}
