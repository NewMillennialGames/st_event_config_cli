part of RandDee;

/*


*/
@JsonEnum()
enum QIntent {
  infoOrCliCfg, // behavior of CLI or name of output file
  structural, // governs future questions
  visual, // creates visual rules
  behavioral, // ceates behavioral rules
  diagnostic, // for debugging or testing purposes
}

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

  factory QIntentWrapper.screenLevel(VisualRuleType visRuleSubtype) {
    return QIntentWrapper(QIntent.visual, visSubtype: visRuleSubtype);
  }

  factory QIntentWrapper.areaLevelRules(VisualRuleType visRuleSubtype) {
    return QIntentWrapper(QIntent.visual, visSubtype: visRuleSubtype);
  }

  factory QIntentWrapper.areaLevelSlots(VisualRuleType visRuleSubtype) {
    return QIntentWrapper(QIntent.visual, visSubtype: visRuleSubtype);
  }

  factory QIntentWrapper.ruleLevel(VisualRuleType visRuleSubtype) {
    return QIntentWrapper(QIntent.visual, visSubtype: visRuleSubtype);
  }

  factory QIntentWrapper.ruleDetailMultiResponse(
      VisualRuleType visRuleSubtype) {
    return QIntentWrapper(QIntent.visual, visSubtype: visRuleSubtype);
  }

  //   factory QIntentWrapper.visRules(VisualRuleType visRuleSubtype) {
  //   return QIntentWrapper(QIntent.visual, visSubtype: visRuleSubtype);
  // }

  // getters
  bool get isDialogLevel => !isVisual && !isBehavioral;
  bool get isVisual => visSubtype != null;
  bool get isBehavioral => behSubtype != null;
}

// @JsonEnum()
enum QTargetLevel {
  /* what level or scope is this question
    operating on
  */
  notAnAppRule,
  screenRule,
  areaRule,
  slotRule,
}

@freezed
class QIntentCfg with _$QIntentCfg {
  //
  factory QIntentCfg(
    QIntentWrapper intentWrapper,
    QTargetLevel tLevel,
  ) = _QIntentCfg;

  QIntentCfg._();

  // getters
  bool get isDialogLevel => intentWrapper.isDialogLevel;
  bool get isVisual => intentWrapper.isVisual;
  bool get isBehavioral => intentWrapper.isBehavioral;

  factory QIntentCfg.eventLevel({
    bool infoOrCfg = false,
  }) {
    return QIntentCfg(
      QIntentWrapper.eventLevel(),
      QTargetLevel.notAnAppRule,
    );
  }

  factory QIntentCfg.screenLevel(VisualRuleType vrt) {
    return QIntentCfg(
      QIntentWrapper.screenLevel(vrt),
      QTargetLevel.screenRule,
    );
  }

  factory QIntentCfg.areaLevelRules(
    VisualRuleType vrt, {
    bool infoOrCfg = false,
  }) {
    //
    return QIntentCfg(
      QIntentWrapper.areaLevelRules(vrt),
      QTargetLevel.notAnAppRule,
    );
  }

  factory QIntentCfg.areaLevelSlots(
    VisualRuleType vrt, {
    bool infoOrCfg = false,
  }) {
    //
    return QIntentCfg(
      QIntentWrapper.areaLevelSlots(vrt),
      QTargetLevel.notAnAppRule,
    );
  }

  factory QIntentCfg.ruleLevel(
    VisualRuleType vrt, {
    bool infoOrCfg = false,
  }) {
    //
    return QIntentCfg(
      QIntentWrapper.ruleLevel(vrt),
      QTargetLevel.notAnAppRule,
    );
  }

  factory QIntentCfg.ruleDetailMultiResponse(
    VisualRuleType vrt, {
    bool infoOrCfg = false,
  }) {
    //
    return QIntentCfg(
      QIntentWrapper.ruleDetailMultiResponse(vrt),
      QTargetLevel.notAnAppRule,
    );
  }
}
