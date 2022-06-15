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
  // called by a DerivedQuestGenerator<PriorAnsType>
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
    // this style quest DOES NOT apply to ui-factory config
    var qDefCollection = QPromptCollection.fromList(prompts);
    return RegionTargetQuest(targIntent, qDefCollection, questId: questId);
  }

  factory QuestBase.ruleSelectQuest(
    QTargetIntent targIntent,
    List<QuestPromptPayload> prompts, {
    String? questId,
  }) {
    // implements QuestFactorytSignature
    // this style quest DOES NOT apply to ui-factory config
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
    // this style quest DOES NOT apply to ui-factory config
    // only creates rule-prep when necessary
    var qDefCollection = QPromptCollection.fromList(prompts);
    // check whether we need rule-prep or just a vis-rule question
    if (targIntent.visRuleTypeForAreaOrSlot?.requiresRulePrepQuestion ??
        false) {
      return RulePrepQuest(
        targIntent,
        qDefCollection,
        questId: questId,
      );
    }
    if (targIntent.visRuleTypeForAreaOrSlot != null) {
      return VisualRuleDetailQuest(
        targIntent,
        qDefCollection,
        questId: questId,
      );
    }
    if (targIntent.behRuleTypeForAreaOrSlot != null) {
      return BehaveRuleDetailQuest(
        targIntent,
        qDefCollection,
        questId: questId,
      );
    }
    print('Error:  QuestBase.rulePrepQuest hit impossible condition');
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

  DerivedQuestGenerator getDerivedQuestGenFromSubtype(
    VisRuleQuestType ruleSubtypeNewQuest,
  ) {
    //
    assert(
      this is RuleSelectQuest || this is RulePrepQuest,
      'cant produce detail quests from this prevAnswQuest',
    );
    return qTargetIntent.visRuleTypeForAreaOrSlot!
        .derQuestGenFromSubtypeForRuleGen(this, ruleSubtypeNewQuest);
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

  // quantified info
  AppScreen get appScreen => qTargetIntent.appScreen;
  bool get _areaAlreadySet => qTargetIntent.screenWidgetArea != null;
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
  }) : super(qTargetIntent, qDefCollection, questId: questId) {
    assert(qTargetIntent.appScreen == AppScreen.eventConfiguration,
        'specific screen should not be set at this level');
    assert(qTargetIntent.screenWidgetArea == null,
        'target should not be specified at this level');
  }

  @override
  QRespCascadePatternEm get respCascadePatternEm => isSelectScreensQuestion
      ? QRespCascadePatternEm.respCreatesWhichAreaInScreenQuestions
      : QRespCascadePatternEm.noCascade;

  @override
  QuestFactorytSignature get derivedQuestConstructor =>
      QuestBase.regionTargetQuest;
}

class RegionTargetQuest extends QuestBase {
  /* 
  */
  RegionTargetQuest(
    QTargetIntent qTargetIntent,
    QPromptCollection qDefCollection, {
    String? questId,
  }) : super(qTargetIntent, qDefCollection, questId: questId) {
    assert(qTargetIntent.appScreen != AppScreen.eventConfiguration, 'wtf');
    assert(
      qTargetIntent.screenWidgetArea == null ||
          qTargetIntent.slotInArea == null,
      'target seems already specified; what is this question? $questId',
    );
  }

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
  }) : super(qTargetIntent, qDefCollection, questId: questId) {
    assert(qTargetIntent.appScreen != AppScreen.eventConfiguration, 'wtf');
    assert(qTargetIntent.screenWidgetArea != null, 'wtf');
  }

  @override
  QRespCascadePatternEm get respCascadePatternEm =>
      QRespCascadePatternEm.respCreatesRulePrepQuestions;

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
  }) : super(qTargetIntent, qDefCollection, questId: questId) {
    assert(qTargetIntent.appScreen != AppScreen.eventConfiguration, 'wtf');
    assert(qTargetIntent.screenWidgetArea != null, 'wtf');
    assert(
      qTargetIntent.visRuleTypeForAreaOrSlot != null ||
          qTargetIntent.behRuleTypeForAreaOrSlot != null,
      'wtf',
    );
  }

  @override
  QRespCascadePatternEm get respCascadePatternEm =>
      QRespCascadePatternEm.respCreatesRuleDetailForSlotOrAreaQuestions;

  @override
  QuestFactorytSignature get derivedQuestConstructor => createsBehavioralQuests
      ? QuestBase.behaveRuleDetailQuest
      : QuestBase.visualRuleDetailQuest;
}

abstract class UiFactoryRuleBase extends QuestBase {
  /* these questions form the end of the dialog chain
    they capture all the details required to fully
    configure one complete rule for the ui-factory-builder
    their answers DO NOT generate new questions
    they simply get converted to JSON for each intended event
  */
  UiFactoryRuleBase(
    QTargetIntent qTargetIntent,
    QPromptCollection qDefCollection, {
    String? questId,
  }) : super(qTargetIntent, qDefCollection, questId: questId) {
    assert(qTargetIntent.appScreen != AppScreen.eventConfiguration, 'wtf');
    assert(qTargetIntent.screenWidgetArea != null, 'wtf');
    assert(
      qTargetIntent.visRuleTypeForAreaOrSlot != null ||
          qTargetIntent.behRuleTypeForAreaOrSlot != null,
      'must contain an explicit rule type',
    );
  }

  // getters
  @override
  QRespCascadePatternEm get respCascadePatternEm =>
      QRespCascadePatternEm.noCascade;

  @override
  QuestFactorytSignature get derivedQuestConstructor {
    throw UnimplementedError(
      'Rule details questions do not generate new questions; they contain the final rule-config details & cascade stops at this level',
    );
  }
}

class VisualRuleDetailQuest extends UiFactoryRuleBase {
  /*  ui-factory visual rules
  */
  VisualRuleDetailQuest(
    QTargetIntent qTargetIntent,
    QPromptCollection qDefCollection, {
    String? questId,
  }) : super(qTargetIntent, qDefCollection, questId: questId) {
    assert(
      qTargetIntent.visRuleTypeForAreaOrSlot != null,
      'must have VIS rule type',
    );
  }
}

class BehaveRuleDetailQuest extends UiFactoryRuleBase {
  /*  ui-factory behavioral rules
  */
  BehaveRuleDetailQuest(
    QTargetIntent qTargetIntent,
    QPromptCollection qDefCollection, {
    String? questId,
  }) : super(qTargetIntent, qDefCollection, questId: questId) {
    assert(
      qTargetIntent.behRuleTypeForAreaOrSlot != null,
      'must have BEH rule type',
    );
  }
}
