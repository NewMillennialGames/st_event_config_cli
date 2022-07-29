part of EvCfgEnums;

enum QRespCascadePatternEm {
  /* QRespCascadePatternEm defines:
    how does response from user to a current Question
    
    impact future Questions in the pending list

    see extension below for clear wording

    I want NO CASCADE Questions to sort to LAST position
    so I moved it's index to the bottom of list
   */
  respCreatesWhichAreaInScreenQuestions,
  respCreatesWhichSlotOfAreaQuestions, // for each screen & area
  respCreatesWhichRulesForAreaOrSlotQuestions, // for each area of each screen
  respCreatesRulePrepQuestions, // for each slot in area
  respCreatesRuleDetailForSlotOrAreaQuestions,
  //
  noCascade,
}

extension UserResponseCascadePatternExt on QRespCascadePatternEm {
  /*
  properties exposed to Quest2 up thru the Quest2Quantifier
  these properties describe CURRENT Quest2 
  (not the ones they will be creating)
  */
  bool get generatesNoNewQuestions => this == QRespCascadePatternEm.noCascade;

  bool get addsWhichAreaInSelectedScreenQuestions =>
      this == QRespCascadePatternEm.respCreatesWhichAreaInScreenQuestions;

  bool get addsWhichRulesForSelectedAreaQuestions =>
      this == QRespCascadePatternEm.respCreatesWhichRulesForAreaOrSlotQuestions;

  bool get addsWhichSlotOfSelectedAreaQuestions =>
      this == QRespCascadePatternEm.respCreatesWhichSlotOfAreaQuestions;

  bool get addsWhichRulesForSlotsInArea =>
      this == QRespCascadePatternEm.respCreatesRulePrepQuestions;

  bool get addsRuleDetailQuestsForSlotOrArea =>
      this == QRespCascadePatternEm.respCreatesRuleDetailForSlotOrAreaQuestions;

  // bool get addsVisualRuleDetailQuest2s =>
  //     this == QuestCascadeTyp.addsVisualRuleDetailQuest2s;

  // bool get addsBehavioralRuleQuest2s =>
  //     this == QuestCascadeTyp.addsBehavioralRuleQuest2s;
}
