part of RandDee;

enum QIntent {
  infoOrCliCfg, // behavior of CLI or name of output file
  structural, // governs future questions
  visual, // creates visual rules
  behavioral, // ceates behavioral rules
  diagnostic, // for debugging or testing purposes
}

enum QVisSubtype {
  // types of visual rules
  sort,
  group,
  filter,
  formatOrStyle,
  showOrHide,
  themePreference,
}

enum QVBehSubtype {
  // behavioral types
  notifyHandling,
}

class QIntentWrapper {
  QIntent intent;
  QVisSubtype? visSubtype;
  QVBehSubtype? behSubtype;

  QIntentWrapper(
    this.intent, {
    this.visSubtype,
    this.behSubtype,
  });

  factory QIntentWrapper.topLevel({
    bool infoOrCfg = true,
  }) {
    return QIntentWrapper(
      infoOrCfg ? QIntent.infoOrCliCfg : QIntent.structural,
    );
  }

  factory QIntentWrapper.visRules(QVisSubtype ruleSubtype) {
    return QIntentWrapper(QIntent.visual, visSubtype: ruleSubtype);
  }

  // getters
  bool get isDialogLevel => !isVisual && !isBehavioral;
  bool get isVisual => visSubtype != null;
  bool get isBehavioral => behSubtype != null;

  // List<VisRuleQuestType> get questsToAsk => isVisual ? [] : [];
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

class QIntentCfg<AnswType> {
  //
  final QIntentWrapper intentWrapper;
  final QTargetLevel level;
  final CastStrToAnswTypCallback<AnswType> answerConverter;

  QIntentCfg._(
    this.intentWrapper,
    this.level,
    this.answerConverter,
  );

  // getters
  bool get isDialogLevel => intentWrapper.isDialogLevel;
  bool get isVisual => intentWrapper.isVisual;
  bool get isBehavioral => intentWrapper.isBehavioral;

  factory QIntentCfg.topLevel(
      CastStrToAnswTypCallback<AnswType> answerConverter,
      {bool infoOrCfg = false}) {
    //
    return QIntentCfg._(
      QIntentWrapper.topLevel(),
      QTargetLevel.notAnAppRule,
      answerConverter,
    );
  }
}




/*
    sortCfg, // global or within groups
  groupCfg, // how to group rows
  filterCfg, // to create filter menus
  styleOrFormat, // select rowStyle for ListView
  showOrHide, // control visibility

*/