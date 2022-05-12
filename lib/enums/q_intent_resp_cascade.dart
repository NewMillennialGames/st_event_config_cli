part of EvCfgEnums;

// @JsonEnum()
enum QIntentEm {
  infoOrCliCfg, // behavior of CLI or name of output file
  structural, // governs future Quest2s
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
  /* UserResponseCascadePattern defines:
    how does response from user
    to a current Quest2
    impact future Quest2s in the pending list

    see extension below for clear wording

    I want NO CASCADE Quest2s to sort to LAST position
    so I moved it's index to the bottom of list
   */
  addsWhichAreaInSelectedScreenQuest2s,
  addsWhichRulesForSelectedAreaQuest2s, // for each area of each screen
  addsWhichSlotOfSelectedAreaQuest2s, // for each screen & area
  addsWhichRulesForSlotsInArea, // for each slot in area
  addsRuleDetailQuestsForSlotOrArea,
  // addsVisualRuleDetailQuest2s,
  // addsBehavioralRuleQuest2s,
  noCascade,
}

extension UserResponseCascadePatternExt on QRespCascadePatternEm {
  /*
  properties exposed to Quest2 up thru the Quest2Quantifier
  these properties describe CURRENT Quest2 
  (not the ones they will be creating)
  */
  bool get generatesNoNewQuest2s => this == QRespCascadePatternEm.noCascade;

  bool get addsWhichAreaInSelectedScreenQuest2s =>
      this == QRespCascadePatternEm.addsWhichAreaInSelectedScreenQuest2s;

  bool get addsWhichRulesForSelectedAreaQuest2s =>
      this == QRespCascadePatternEm.addsWhichRulesForSelectedAreaQuest2s;

  bool get addsWhichSlotOfSelectedAreaQuest2s =>
      this == QRespCascadePatternEm.addsWhichSlotOfSelectedAreaQuest2s;

  bool get addsWhichRulesForSlotsInArea =>
      this == QRespCascadePatternEm.addsWhichRulesForSlotsInArea;

  bool get addsRuleDetailQuestsForSlotOrArea =>
      this == QRespCascadePatternEm.addsRuleDetailQuestsForSlotOrArea;

  // bool get addsVisualRuleDetailQuest2s =>
  //     this == QuestCascadeTyp.addsVisualRuleDetailQuest2s;

  // bool get addsBehavioralRuleQuest2s =>
  //     this == QuestCascadeTyp.addsBehavioralRuleQuest2s;
}
