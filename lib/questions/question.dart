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
  ) : captureAndCast = CaptureAndCast<T>(_castFunc);
}

abstract class QuestBase with EquatableMixin {
  /*
    largely a wrapper around QTargetIntent && QDefCollection
    base class for all our 5 specific question types:

      1. event level config & behavior
      2. targeting questions (pick area or area-slot)
      3. rule-selection questions (which rule for target)
      4. rule-prep questions  (opt details to gen rule-detail)
      5. rule-detail questions (rule config details)

    it's vital that 5 Factory quest constructors respect
    this standard signature:   QuestFactorytSignature
  */
  final QTargetResolution qTargetResolution;
  final QPromptCollection qPromptCollection;
  // optional unique value for expedited matching
  String questId = '';
  String? helpMsgOnError;

  QuestBase(
    this.qTargetResolution,
    this.qPromptCollection, {
    String? questId,
    this.helpMsgOnError,
  }) : questId = questId == null
            ? (qTargetResolution.targetPath + qTargetResolution.equatableKey)
            : questId {
    // confirm that our derived quest signatures
    // line up and make sense
    // assert(
    //   qTargetResolution.derivedNewQuestSignature ==
    //       this.derivedQuestConstructor,
    //   'Err: something out of line!!',
    // );
  }

  // constructors with common QuestFactorytSignature
  // called by a DerivedQuestGenerator<PriorAnsType>
  factory QuestBase.eventLevelCfgQuest(
    QTargetResolution targIntent,
    List<QuestPromptPayload> prompts, {
    String? questId,
  }) {
    // implements QuestFactorytSignature
    // applies to ui-factory config rules
    var qDefCollection = QPromptCollection.fromList(prompts);
    return EventLevelCfgQuest(
        targIntent.copyWith(precision: TargetPrecision.eventLevel),
        qDefCollection,
        questId: questId);
  }

  factory QuestBase.regionTargetQuest(
    QTargetResolution targIntent,
    List<QuestPromptPayload> prompts, {
    String? questId,
  }) {
    // implements QuestFactorytSignature
    // this style quest DOES NOT apply to ui-factory config
    var qDefCollection = QPromptCollection.fromList(prompts);
    return RegionTargetQuest(
        targIntent.copyWith(precision: TargetPrecision.targetLevel),
        qDefCollection,
        questId: questId);
  }

  factory QuestBase.ruleSelectQuest(
    QTargetResolution targIntent,
    List<QuestPromptPayload> prompts, {
    String? questId,
  }) {
    // implements QuestFactorytSignature
    // this style quest DOES NOT apply to ui-factory config
    var qDefCollection = QPromptCollection.fromList(prompts);
    var completeTarg =
        targIntent.copyWith(precision: TargetPrecision.ruleSelect);
    return RuleSelectQuest(completeTarg, qDefCollection, questId: questId);
  }
  //
  factory QuestBase.rulePrepQuest(
    QTargetResolution targIntent,
    List<QuestPromptPayload> prompts, {
    String? questId,
  }) {
    // implements QuestFactorytSignature
    // this style quest DOES NOT apply to ui-factory config
    // only creates rule-prep when necessary
    var qDefCollection = QPromptCollection.fromList(prompts);
    var completeTarg = targIntent.copyWith(precision: TargetPrecision.rulePrep);

    // check whether we need rule-prep or just a vis-rule question
    if (completeTarg.requiresVisRulePrepQuestion) {
      return RulePrepQuest(
        completeTarg,
        qDefCollection,
        questId: questId,
      );
    }
    if (completeTarg.visRuleTypeForAreaOrSlot != null) {
      return VisualRuleDetailQuest(
        completeTarg.copyWith(precision: TargetPrecision.ruleDetailVisual),
        qDefCollection,
        questId: questId,
      );
    }
    if (completeTarg.behRuleTypeForAreaOrSlot != null) {
      return BehaveRuleDetailQuest(
        completeTarg.copyWith(precision: TargetPrecision.ruleDetailBehavior),
        qDefCollection,
        questId: questId,
      );
    }
    print('Error:  QuestBase.rulePrepQuest hit impossible condition');
    return RulePrepQuest(completeTarg, qDefCollection, questId: questId);
  }

  factory QuestBase.visualRuleDetailQuest(
    QTargetResolution targIntent,
    List<QuestPromptPayload> prompts, {
    String? questId,
  }) {
    // implements QuestFactorytSignature
    // applies to ui-factory config
    var qDefCollection = QPromptCollection.fromList(prompts);
    return VisualRuleDetailQuest(
        targIntent.copyWith(precision: TargetPrecision.ruleDetailVisual),
        qDefCollection,
        questId: questId);
  }

  factory QuestBase.behaveRuleDetailQuest(
    QTargetResolution targIntent,
    List<QuestPromptPayload> prompts, {
    String? questId,
  }) {
    // implements QuestFactorytSignature
    // applies to ui-factory config
    var qDefCollection = QPromptCollection.fromList(prompts);
    return BehaveRuleDetailQuest(
        targIntent.copyWith(precision: TargetPrecision.ruleDetailBehavior),
        qDefCollection,
        questId: questId);
  }
  // end constructors with common QuestFactorytSignature

  // manual constructors to call explicitly
  factory QuestBase.initialEventConfigRule(
    QTargetResolution targIntent,
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
      targIntent.copyWith(precision: TargetPrecision.eventLevel),
      qDefCollection,
      questId: questId,
      isSelectScreensQuestion: isSelectScreensQuestion,
    );
  }

  factory QuestBase.regionTargetQuestManual(
    QTargetResolution targIntent,
    String userPrompt,
    Iterable<String> choices,
    CaptureAndCast captureAndCast, {
    String? questId,
  }) {
    // used in test
    var qDefCollection = QPromptCollection.singleDialog(
      userPrompt,
      choices,
      captureAndCast,
    );
    return RegionTargetQuest(
        targIntent.copyWith(precision: TargetPrecision.targetLevel),
        qDefCollection,
        questId: questId);
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

  DerivedQuestGenerator getDerivedRuleQuestGenViaVisType(
    int newQuIdx,
    VisualRuleType? pendingRule,
  ) {
    //
    assert(
      this is RuleSelectQuest || this is RulePrepQuest,
      'cant produce detail quests on ${this.questId}',
    );

    VisualRuleType? selRule =
        this is RulePrepQuest ? visRuleTypeForAreaOrSlot : null;
    if (this is RuleSelectQuest) {
      selRule = (this.mainAnswer as List<VisualRuleType>)[newQuIdx];
    }
    VisualRuleType curRule =
        pendingRule ?? selRule ?? visRuleTypeForAreaOrSlot!;

    // print(
    //   'getDerivedRuleQuestGenViaVisType: ${curRule.name}',
    // );

    var newTarg = qTargetResolution.copyWith(
      visRuleTypeForAreaOrSlot: curRule,
      precision: TargetPrecision.ruleDetailVisual,
    );
    return curRule.makeQuestGenForRuleType(this, newTarg);
  }

  bool containsPromptWhere(bool Function(QuestPromptInstance qpi) promptTest) {
    // check if this contains an instance that matches promptTest
    for (QuestPromptInstance qpi in qPromptCollection.prompts) {
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
    for (QuestPromptInstance qpi in qPromptCollection.prompts) {
      if (promptTest(qpi)) {
        l.add(qpi);
      }
    }
    return l;
  }

  // getters
  /* userRespCountRangeForTest
  reflects the REASONABLE / ALLOWED
  range of choices the user may pick
  from FIRST PROMOT of current question
  */

  Map<VisRuleQuestType, String> get _userRespMap =>
      Map<VisRuleQuestType, String>.fromIterable(qPromptCollection.prompts,
          key: (qpi) {
        return (qpi as QuestPromptInstance).visQuestType;
      }, value: (qpi) {
        return (qpi as QuestPromptInstance)._answerRepoAndTypeCast._answers;
      });

  RuleResponseBase get asVisRuleResponse =>
      visRuleTypeForAreaOrSlot!.ruleResponseContainer
        ..castResponsesToAnswerTypes(_userRespMap);

  bool get producesDerivedQuestsFromUserAnswers =>
      qTargetResolution.producesDerivedQuestsFromUserAnswers;

  int get countChoicesInFirstPrompt =>
      qPromptCollection.countChoicesInFirstPrompt;

  // IntRange get userRespCountRangeForTest =>
  //     qTargetResolution.userRespCountRangeForTest;

  List<VisRuleQuestType> get embeddedQuestTypes =>
      qPromptCollection.embeddedQuestTypes;

  bool get requiresVisRulePrepQuestion =>
      qTargetResolution.requiresVisRulePrepQuestion;
  bool get requiresBehRulePrepQuestion =>
      qTargetResolution.requiresBehRulePrepQuestion;

  bool get doesCreateDerivedQuests =>
      respCascadePatternEm != QRespCascadePatternEm.noCascade;

  // respCascadePatternEm overridden in subclasses
  QRespCascadePatternEm get respCascadePatternEm =>
      QRespCascadePatternEm.noCascade;

  // derivedQuestConstructor overridden in subclasses
  QuestFactorytSignature get derivedQuestConstructor =>
      QuestBase.eventLevelCfgQuest;

  String get targetPath => qTargetResolution.targetPath;
  bool get targetPathIsComplete => qTargetResolution.targetComplete;
  bool get targetUncompleted => !targetPathIsComplete;
  bool get isFullyAnswered => qPromptCollection.allPartsHaveAnswers;

  // define type of question for auto-gen
  bool get isEventConfigScreenEntryPointQuest =>
      this is EventLevelCfgQuest &&
      qTargetResolution.isEventConfigScreenEntryPointQuest;
  bool get isRegionTargetQuestion => this is RegionTargetQuest;
  bool get isRuleSelectionQuestion => this is RuleSelectQuest;
  bool get isRulePrepQuestion => this is RulePrepQuest;
  // rule level
  bool get isRuleDetailQuestion => this is RuleQuestBaseAbs; // controls export
  bool get isVisRuleDetailQuestion => this is VisualRuleDetailQuest;
  bool get isBehRuleDetailQuestion => this is BehaveRuleDetailQuest;

  Iterable<CaptureAndCast> get listResponses => qPromptCollection.listResponses;
  int get promptCount => qPromptCollection.prompts.length;
  List<VisRuleQuestType> get visQuestTypes => qPromptCollection.prompts
      .map((e) => e.answChoiceCollection.visRuleQuestType)
      .toList();
  QuestPromptInstance get firstPrompt => qPromptCollection.prompts.first;
  CaptureAndCast get _firstPromptAnswers => firstPrompt._answerRepoAndTypeCast;
  dynamic get mainAnswer => _firstPromptAnswers.cast(this);
  // Caution --- below may not work
  Type get expectedAnswerType => _firstPromptAnswers.cast(this).runtimeType;

  bool get existsONLYToGenDialogStructure =>
      qTargetResolution.isEventConfigScreenEntryPointQuest;
  bool get isNotForRuleOutput => existsONLYToGenDialogStructure;
  // does questions have multi-prompts
  bool get isMultiPrompt => qPromptCollection.isMultiPrompt;
  // does the first prompt allow user to select more than one choice?
  bool get multiChoicesAllowed => qPromptCollection.multiChoicesAllowed;

  // quantified info
  AppScreen get appScreen => qTargetResolution.appScreen;
  bool get _areaAlreadySet => qTargetResolution.screenWidgetArea != null;
  ScreenWidgetArea? get screenWidgetArea => qTargetResolution.screenWidgetArea;
  ScreenAreaWidgetSlot? get slotInArea => qTargetResolution.slotInArea;
  //
  VisualRuleType? get visRuleTypeForAreaOrSlot =>
      qTargetResolution.visRuleTypeForAreaOrSlot;
  BehaviorRuleType? get behRuleTypeForAreaOrSlot =>
      qTargetResolution.behRuleTypeForAreaOrSlot;
  //
  // below controls how each Quest2 causes cascade creation of new Quest2s
  bool get generatesNoNewQuestions => !doesCreateDerivedQuests;
  bool get addsRuleDetailQuestsForSlotOrArea =>
      isRuleSelectionQuestion || isRulePrepQuestion;

  int get sortKey => qTargetResolution.targetSortIndex;
  // impl for equatable
  // but really being used as a search filter
  // to find Quest2s in a specific granularity
  @override
  List<Object> get props => [qTargetResolution];

  @override
  bool get stringify => true;

  void setAllAnswersWhileTesting(List<String> userResponses) {
    // test code only
    int idx = 0;
    for (QuestPromptInstance qpi in qPromptCollection.prompts) {
      //
      qpi.collectResponse(userResponses[idx]);
      idx++;
    }
  }
}

class EventLevelCfgQuest extends QuestBase {
  /*  applies to ui-factory config rules

  isSelectScreensQuestion is the top level question
  that begins the process of generating
  area/slot "target" questions

  a "target" is some part of the app to which we'd like
  to attach 1-n visual or behavioral rules
  */
  final bool isSelectScreensQuestion; // starts targetting dialog when true
  EventLevelCfgQuest(
    QTargetResolution qTargetIntent,
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
    QTargetResolution qTargetIntent,
    QPromptCollection qDefCollection, {
    String? questId,
  }) : super(qTargetIntent, qDefCollection, questId: questId) {
    assert(
      qTargetIntent.appScreen != AppScreen.eventConfiguration,
      'target quest must have defined screen',
    );
    assert(
      qTargetIntent.screenWidgetArea == null ||
          qTargetIntent.slotInArea == null,
      'target seems already specified; what is this question? $questId',
    );
  }

  @override // && !qTargetResolution.targetComplete
  QRespCascadePatternEm get respCascadePatternEm => _areaAlreadySet
      ? QRespCascadePatternEm.respCreatesWhichSlotOfAreaQuestions
      : QRespCascadePatternEm.respCreatesWhichAreaInScreenQuestions;

  @override
  QuestFactorytSignature get derivedQuestConstructor => targetPathIsComplete
      ? QuestBase.ruleSelectQuest
      : QuestBase.regionTargetQuest;
}

class RuleSelectQuest extends QuestBase {
  /*  

  */
  RuleSelectQuest(
    QTargetResolution qTargetIntent,
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
    QTargetResolution qTargetIntent,
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

abstract class RuleQuestBaseAbs extends QuestBase {
  /* these questions form the end of the dialog chain
    they capture all the details required to fully
    configure one complete rule for the ui-factory-builder
    their answers DO NOT generate new questions
    they simply get converted to JSON for each intended event
  */
  RuleQuestBaseAbs(
    QTargetResolution qTargetIntent,
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

class VisualRuleDetailQuest extends RuleQuestBaseAbs {
  /*  ui-factory visual rules
  */
  VisualRuleDetailQuest(
    QTargetResolution qTargetIntent,
    QPromptCollection qDefCollection, {
    String? questId,
  }) : super(qTargetIntent, qDefCollection, questId: questId) {
    assert(
      qTargetIntent.visRuleTypeForAreaOrSlot != null,
      'must have VIS rule type',
    );
  }
}

class BehaveRuleDetailQuest extends RuleQuestBaseAbs {
  /*  ui-factory behavioral rules
  */
  BehaveRuleDetailQuest(
    QTargetResolution qTargetIntent,
    QPromptCollection qDefCollection, {
    String? questId,
  }) : super(qTargetIntent, qDefCollection, questId: questId) {
    assert(
      qTargetIntent.behRuleTypeForAreaOrSlot != null,
      'must have BEH rule type',
    );
  }
}
