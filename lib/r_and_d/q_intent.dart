part of RandDee;

/*


*/

enum QIntent {
  infoOrCliCfg, // behavior of CLI or name of output file
  structural, // governs future questions
  visual, // creates visual rules
  behavioral, // ceates behavioral rules
  diagnostic, // for debugging or testing purposes
}

// enum QVisSubtype {
//   // types of visual rules
//   sort,
//   group,
//   filter,
//   formatOrStyle,
//   showOrHide,
//   themePreference,
// }

// enum QVBehSubtype {
//   // behavioral types
//   notifyHandling,
// }

class QIntentWrapper {
  QIntent intent;
  VisualRuleType? visSubtype;
  BehaviorRuleType? behSubtype;

  QIntentWrapper(
    this.intent, {
    this.visSubtype,
    this.behSubtype,
  });

  factory QIntentWrapper.eventLevel({
    bool infoOrCfg = true,
  }) {
    return QIntentWrapper(
      infoOrCfg ? QIntent.infoOrCliCfg : QIntent.structural,
    );
  }

  factory QIntentWrapper.visRules(VisualRuleType ruleSubtype) {
    return QIntentWrapper(QIntent.visual, visSubtype: ruleSubtype);
  }

  // getters
  bool get isDialogLevel => !isVisual && !isBehavioral;
  bool get isVisual => visSubtype != null;
  bool get isBehavioral => behSubtype != null;
}

enum QTargetLevel {
  /* what level or scope is this question
    operating on
  */
  notAnAppRule,
  screenRule,
  areaRule,
  slotRule,
}

class QIntentCfg {
  //
  final QIntentWrapper intentWrapper;
  final QTargetLevel tLevel;

  QIntentCfg._(
    this.intentWrapper,
    this.tLevel,
  );

  // getters
  bool get isDialogLevel => intentWrapper.isDialogLevel;
  bool get isVisual => intentWrapper.isVisual;
  bool get isBehavioral => intentWrapper.isBehavioral;

  factory QIntentCfg.eventLevel({
    bool infoOrCfg = false,
  }) {
    return QIntentCfg._(
      QIntentWrapper.eventLevel(),
      QTargetLevel.notAnAppRule,
    );
  }

  factory QIntentCfg.screenLevel() {
    return QIntentCfg._(
      QIntentWrapper.screenLevel(),
      QTargetLevel.screenRule,
    );
  }

  factory QIntentCfg.areaLevelRules({
    bool infoOrCfg = false,
  }) {
    //
    return QIntentCfg._(
      QIntentWrapper.areaLevelRules(),
      QTargetLevel.notAnAppRule,
    );
  }

  factory QIntentCfg.areaLevelSlots({
    bool infoOrCfg = false,
  }) {
    //
    return QIntentCfg._(
      QIntentWrapper.areaLevelSlots(),
      QTargetLevel.notAnAppRule,
    );
  }

  factory QIntentCfg.ruleLevel({
    bool infoOrCfg = false,
  }) {
    //
    return QIntentCfg._(
      QIntentWrapper.ruleLevel(),
      QTargetLevel.notAnAppRule,
    );
  }

  factory QIntentCfg.ruleDetailMultiResponse({
    bool infoOrCfg = false,
  }) {
    //
    return QIntentCfg._(
      QIntentWrapper.ruleDetailMultiResponse(),
      QTargetLevel.notAnAppRule,
    );
  }
}
