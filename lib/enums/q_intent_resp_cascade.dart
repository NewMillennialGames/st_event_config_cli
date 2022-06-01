part of EvCfgEnums;

// @JsonEnum()
enum QIntentEm {
  infoOrCliCfg, // behavior of CLI or name of output file
  dlogCascade, // governs future Quest2s
  visual, // creates visual rules
  behavioral, // ceates behavioral rules
  diagnostic, // for debugging or testing purposes
}

// @JsonEnum()
enum QTargetLevelEm {
  /* what level or scope is this Quest2
    operating on
  */
  notAnAppRule,
  screenRule,
  areaRule,
  slotRule,
}

enum QRespCascadePatternEm {
  /* QRespCascadePatternEm defines:
    how does response from user to a current Question
    
    impact future Questions in the pending list

    see extension below for clear wording

    I want NO CASCADE Questions to sort to LAST position
    so I moved it's index to the bottom of list
   */
  addsWhichAreaInSelectedScreenQuestions,
  addsWhichRulesForSelectedAreaQuestions, // for each area of each screen
  addsWhichSlotOfSelectedAreaQuestions, // for each screen & area
  addsWhichRulesForSlotsInArea, // for each slot in area
  addsRuleDetailQuestsForSlotOrArea,
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
      this == QRespCascadePatternEm.addsWhichAreaInSelectedScreenQuestions;

  bool get addsWhichRulesForSelectedAreaQuestions =>
      this == QRespCascadePatternEm.addsWhichRulesForSelectedAreaQuestions;

  bool get addsWhichSlotOfSelectedAreaQuestions =>
      this == QRespCascadePatternEm.addsWhichSlotOfSelectedAreaQuestions;

  bool get addsWhichRulesForSlotsInArea =>
      this == QRespCascadePatternEm.addsWhichRulesForSlotsInArea;

  bool get addsRuleDetailQuestsForSlotOrArea =>
      this == QRespCascadePatternEm.addsRuleDetailQuestsForSlotOrArea;

  // bool get addsVisualRuleDetailQuest2s =>
  //     this == QuestCascadeTyp.addsVisualRuleDetailQuest2s;

  // bool get addsBehavioralRuleQuest2s =>
  //     this == QuestCascadeTyp.addsBehavioralRuleQuest2s;
}
