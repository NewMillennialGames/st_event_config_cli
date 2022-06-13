part of QuestionsLib;

/* classes below with "rule" in the name
    are those to be exported to the ui_factory
    as they contain app ui config rules
*/

class QuestPromptPayload<T> {
  // data container for constructing new questions
  String userPrompt;
  List<String> choices;
  VisRuleQuestType questType;
  CaptureAndCast<T> captureAndCast;

  QuestPromptPayload(
    this.userPrompt,
    this.choices,
    this.questType,
    CastStrToAnswTypCallback<T> _castFunc,
  ) : captureAndCast = CaptureAndCast(_castFunc);
}

abstract class QuestBase with EquatableMixin {
  /*
    cleaner and more testable replacement for:
    Question<ConvertTyp, AnsTyp> and RuleTypeQuestion
    it combines those classes so there is no fundamental distinction
    between them;  keep consistent interface going forward
    largely a wrapper around QTargetIntent && QDefCollection

    it's vital that ALL Factory constructors respect this
    standard signature:   QuestFactorytSignature


  */
  final QTargetIntent qTargetIntent;
  final QPromptCollection qPromptCollection;
  // optional unique value for expedited matching
  String questId = '';
  String? helpMsgOnError;
  // bool isDiagnostic = false;

  QuestBase(
    this.qTargetIntent,
    this.qPromptCollection, {
    String? questId,
    this.helpMsgOnError,
  }) : questId = questId == null ? qTargetIntent.equatableKey : questId;

  // constructors with common QuestFactorytSignature
  factory QuestBase.eventLevelCfgQuest(
    QTargetIntent targIntent,
    List<QuestPromptPayload> prompts, {
    String? questId,
  }) {
    // implements QuestFactorytSignature
    // applies to ui-factory config rules
    var qDefCollection = QPromptCollection.fromList(prompts);
    return EventLevelCfgQuest(targIntent, qDefCollection, questId: questId);
  }

  factory QuestBase.regionTargetQuest(
    QTargetIntent targIntent,
    List<QuestPromptPayload> prompts, {
    String? questId,
  }) {
    // implements QuestFactorytSignature
    // DOES NOT apply to ui-factory config
    var qDefCollection = QPromptCollection.fromList(prompts);
    return RegionTargetQuest(targIntent, qDefCollection, questId: questId);
  }

  factory QuestBase.ruleSelectQuest(
    QTargetIntent targIntent,
    List<QuestPromptPayload> prompts, {
    String? questId,
  }) {
    // implements QuestFactorytSignature
    // DOES NOT apply to ui-factory config
    var qDefCollection = QPromptCollection.fromList(prompts);
    return RuleSelectQuest(targIntent, qDefCollection, questId: questId);
  }
  //
  factory QuestBase.rulePrepQuest(
    QTargetIntent targIntent,
    List<QuestPromptPayload> prompts, {
    String? questId,
  }) {
    // implements QuestFactorytSignature
    // DOES NOT apply to ui-factory config
    var qDefCollection = QPromptCollection.fromList(prompts);
    return RulePrepQuest(targIntent, qDefCollection, questId: questId);
  }

  factory QuestBase.visualRuleDetailQuest(
    QTargetIntent targIntent,
    List<QuestPromptPayload> prompts, {
    String? questId,
  }) {
    // implements QuestFactorytSignature
    // applies to ui-factory config
    var qDefCollection = QPromptCollection.fromList(prompts);
    return VisualRuleDetailQuest(targIntent, qDefCollection, questId: questId);
  }

  factory QuestBase.behaveRuleDetailQuest(
    QTargetIntent targIntent,
    List<QuestPromptPayload> prompts, {
    String? questId,
  }) {
    // implements QuestFactorytSignature
    // applies to ui-factory config
    var qDefCollection = QPromptCollection.fromList(prompts);
    return BehaveRuleDetailQuest(targIntent, qDefCollection, questId: questId);
  }
  // end constructors with common QuestFactorytSignature

  // manual constructors to call explicitly
  factory QuestBase.initialEventConfigRule(
    QTargetIntent targIntent,
    String userPrompt,
    Iterable<String> choices,
    CaptureAndCast captureAndCast, {
    String? questId,
    bool isSelectScreensQuestion = false,
  }) {
    //
    var qDefCollection = QPromptCollection.singleDialog(
      userPrompt,
      choices,
      captureAndCast,
    );
    return EventLevelCfgQuest(
      targIntent,
      qDefCollection,
      questId: questId,
      isSelectScreensQuestion: isSelectScreensQuestion,
    );
  }

  factory QuestBase.regionTargetQuestManual(
    QTargetIntent targIntent,
    String userPrompt,
    Iterable<String> choices,
    CaptureAndCast captureAndCast, {
    String? questId,
  }) {
    //
    var qDefCollection = QPromptCollection.singleDialog(
      userPrompt,
      choices,
      captureAndCast,
    );
    return RegionTargetQuest(targIntent, qDefCollection, questId: questId);
  }

  QuestPromptInstance? getNextUserPromptIfExists() {
    //
    QuestPromptInstance? nextQpi =
        qPromptCollection.getNextUserPromptIfExists();
    if (nextQpi == null) {
      // out of Quest2s
    }
    return nextQpi;
  }

  bool containsPromptWhere(bool Function(QuestPromptInstance qpi) promptTest) {
    // check if this contains an instance that matches promptTest
    for (QuestPromptInstance qpi in qPromptCollection.questIterations) {
      if (promptTest(qpi)) {
        return true;
      }
    }
    return false;
  }

  List<QuestPromptInstance> matchingPromptsWhere(
    bool Function(QuestPromptInstance qpi) promptTest,
  ) {
    // return list of prompt instances
    List<QuestPromptInstance> l = [];
    for (QuestPromptInstance qpi in qPromptCollection.questIterations) {
      if (promptTest(qpi)) {
        l.add(qpi);
      }
    }
    return l;
  }

  // getters
  bool get doesCreateDerivedQuests =>
      respCascadePatternEm != QRespCascadePatternEm.noCascade;
  // derivedQuestConstructor overridden in subclasses
  QuestFactorytSignature get derivedQuestConstructor =>
      QuestBase.eventLevelCfgQuest;
  // respCascadePatternEm overridden in subclasses
  QRespCascadePatternEm get respCascadePatternEm =>
      QRespCascadePatternEm.noCascade;

  String get targetPath => qTargetIntent.targetPath;
  bool get isFullyAnswered => qPromptCollection.allPartsHaveAnswers;

  // define type of question for auto-gen
  bool get isTopLevelEventConfigQuestion =>
      this is EventLevelCfgQuest && qTargetIntent.isTopLevelEventConfigQuestion;
  bool get isRegionTargetQuestion => this is RegionTargetQuest;
  bool get isRuleSelectionQuestion => this is RuleSelectQuest;
  bool get isRulePrepQuestion => this is RulePrepQuest;
  // rule level
  bool get isRuleDetailQuestion => this is UiFactoryRuleBase; // controls export
  bool get isVisRuleDetailQuestion => this is VisualRuleDetailQuest;
  bool get isBehRuleDetailQuestion => this is BehaveRuleDetailQuest;

  Iterable<CaptureAndCast> get listResponses => qPromptCollection.listResponses;
  int get promptCount => qPromptCollection.questIterations.length;
  List<VisRuleQuestType> get questTypes => qPromptCollection.questIterations
      .map((e) => e.answChoiceCollection.visRuleQuestType)
      .toList();
  QuestPromptInstance get firstQuestion =>
      qPromptCollection.questIterations.first;
  CaptureAndCast get _firstPromptAnswers =>
      firstQuestion._answerRepoAndTypeCast;
  dynamic get mainAnswer => _firstPromptAnswers.cast(this);
  // Caution --- below may not work
  Type get expectedAnswerType => _firstPromptAnswers.cast(this).runtimeType;

  bool get existsONLYToGenDialogStructure =>
      qTargetIntent.isTopLevelEventConfigQuestion;
  bool get isNotForRuleOutput => existsONLYToGenDialogStructure;
  bool get isMultiPart => qPromptCollection.isMultiPart;

  // bool get hasChoices => _currQuest2?.hasChoices ?? false;
  // quantified info
  AppScreen get appScreen => qTargetIntent.appScreen;
  ScreenWidgetArea? get screenWidgetArea => qTargetIntent.screenWidgetArea;
  ScreenAreaWidgetSlot? get slotInArea => qTargetIntent.slotInArea;
  //
  VisualRuleType? get visRuleTypeForAreaOrSlot =>
      qTargetIntent.visRuleTypeForAreaOrSlot;
  BehaviorRuleType? get behRuleTypeForAreaOrSlot =>
      qTargetIntent.behRuleTypeForAreaOrSlot;
  //
  // below controls how each Quest2 causes cascade creation of new Quest2s
  bool get generatesNoNewQuestions => !doesCreateDerivedQuests;
  bool get addsRuleDetailQuestsForSlotOrArea =>
      isRuleSelectionQuestion || isRulePrepQuestion;

  int get sortKey => qTargetIntent.targetSortIndex;
  // ask 2nd & 3rd position for (sort, group, filter)

  // appliesToClientConfiguration == should be exported to file
  // bool get appliesToClientConfiguration =>
  //     this is UiFactoryRuleBase ||
  //     qPromptCollection.isRuleQuestion ||
  //     appScreen == AppScreen.eventConfiguration;

  // ARE BELOW needed with new approach??

  // bool get asksWhichScreensToConfig =>
  //     qTargetIntent.appScreen == AppScreen.eventConfiguration &&
  //     expectedAnswerType is List<AppScreen>;

  // bool get addsWhichAreaInSelectedScreenQuestions =>
  //     qTargetIntent.addsWhichAreaInSelectedScreenQuestions &&
  //     appScreen == AppScreen.eventConfiguration &&
  //     expectedAnswerType is List<AppScreen>;

  // bool get addsWhichRulesForSelectedAreaQuestions =>
  //     qTargetIntent.addsWhichRulesForSelectedAreaQuestions &&
  //     expectedAnswerType is List<ScreenWidgetArea>;

  // bool get addsWhichSlotOfSelectedAreaQuest2s =>
  //     qTargetIntent.addsWhichSlotOfSelectedAreaQuestions &&
  //     expectedAnswerType is List<ScreenWidgetArea>;

  // bool get addsWhichRulesForSlotsInArea =>
  //     qTargetIntent.addsWhichRulesForSlotsInArea &&
  //     expectedAnswerType is List<ScreenAreaWidgetSlot>;

  // impl for equatable
  // but really being used as a search filter
  // to find Quest2s in a specific granularity
  @override
  List<Object> get props => [qTargetIntent];

  @override
  bool get stringify => true;

  void setAllAnswersWhileTesting(List<String> userResponses) {
    // test code only
    int idx = 0;
    for (QuestPromptInstance qpi in qPromptCollection.questIterations) {
      //
      qpi.collectResponse(userResponses[idx]);
      idx++;
    }
  }
}

class EventLevelCfgQuest extends QuestBase {
  /*  applies to ui-factory config rules
  */
  final bool isSelectScreensQuestion; // this is special
  EventLevelCfgQuest(
    QTargetIntent qTargetIntent,
    QPromptCollection qDefCollection, {
    String? questId,
    this.isSelectScreensQuestion = false,
  }) : super(qTargetIntent, qDefCollection, questId: questId) {}

  @override
  QRespCascadePatternEm get respCascadePatternEm => isSelectScreensQuestion
      ? QRespCascadePatternEm.respCreatesWhichAreaInScreenQuestions
      : QRespCascadePatternEm.noCascade;

  @override
  QuestFactorytSignature get derivedQuestConstructor =>
      QuestBase.regionTargetQuest;
}

class RegionTargetQuest extends QuestBase {
  /*  Question offering only one user prompt / question
    this DOES NOT mean the user cannot select multiple options
  */
  RegionTargetQuest(
    QTargetIntent qTargetIntent,
    QPromptCollection qDefCollection, {
    String? questId,
  }) : super(qTargetIntent, qDefCollection, questId: questId) {}

  bool get _areaAlreadySet => qTargetIntent.screenWidgetArea != null;

  @override
  QRespCascadePatternEm get respCascadePatternEm => _areaAlreadySet
      ? QRespCascadePatternEm.respCreatesWhichSlotOfAreaQuestions
      : QRespCascadePatternEm.respCreatesWhichAreaInScreenQuestions;

  @override
  QuestFactorytSignature get derivedQuestConstructor =>
      QuestBase.ruleSelectQuest;
}

class RuleSelectQuest extends QuestBase {
  /*  

  */
  RuleSelectQuest(
    QTargetIntent qTargetIntent,
    QPromptCollection qDefCollection, {
    String? questId,
  }) : super(qTargetIntent, qDefCollection, questId: questId) {}

  @override
  QRespCascadePatternEm get respCascadePatternEm =>
      QRespCascadePatternEm.respCreatesWhichRulesForAreaOrSlotQuestions;

  @override
  QuestFactorytSignature get derivedQuestConstructor => QuestBase.rulePrepQuest;
}

class RulePrepQuest extends QuestBase {
  /*  intermediate step to guide creation of Rule detail questions
      not every rule-type requires one of these
  */
  final bool createsBehavioralQuests;
  RulePrepQuest(
    QTargetIntent qTargetIntent,
    QPromptCollection qDefCollection, {
    String? questId,
    this.createsBehavioralQuests = false,
  }) : super(qTargetIntent, qDefCollection, questId: questId) {}

  @override
  QRespCascadePatternEm get respCascadePatternEm =>
      QRespCascadePatternEm.respCreatesWhichSlotOfAreaQuestions;

  @override
  QuestFactorytSignature get derivedQuestConstructor => createsBehavioralQuests
      ? QuestBase.behaveRuleDetailQuest
      : QuestBase.visualRuleDetailQuest;
}

abstract class UiFactoryRuleBase extends QuestBase {
  // applies to ui-factory config rules
  UiFactoryRuleBase(
    QTargetIntent qTargetIntent,
    QPromptCollection qDefCollection, {
    String? questId,
  }) : super(qTargetIntent, qDefCollection, questId: questId) {
    assert(
        qTargetIntent.visRuleTypeForAreaOrSlot != null, 'must have rule type');
  }

  // getters
  @override
  QRespCascadePatternEm get respCascadePatternEm =>
      QRespCascadePatternEm.respCreatesRuleDetailForSlotOrAreaQuestions;
}

class VisualRuleDetailQuest extends UiFactoryRuleBase {
  /*  applies to ui-factory config rules
  */
  VisualRuleDetailQuest(
    QTargetIntent qTargetIntent,
    QPromptCollection qDefCollection, {
    String? questId,
  }) : super(qTargetIntent, qDefCollection, questId: questId) {}

  @override
  QRespCascadePatternEm get respCascadePatternEm =>
      QRespCascadePatternEm.noCascade;
}

class BehaveRuleDetailQuest extends UiFactoryRuleBase {
  /*  applies to ui-factory config rules
  */
  BehaveRuleDetailQuest(
    QTargetIntent qTargetIntent,
    QPromptCollection qDefCollection, {
    String? questId,
  }) : super(qTargetIntent, qDefCollection, questId: questId) {}

  @override
  QRespCascadePatternEm get respCascadePatternEm =>
      QRespCascadePatternEm.noCascade;
}
