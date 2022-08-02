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
      questId: questId,
    );
  }

  QuestPromptInstance? getNextUserPromptIfExists() {
    //
    QuestPromptInstance? nextQpi =
        qPromptCollection.getNextUserPromptIfExists();
    if (nextQpi == null) {
      // out of Questions
    }
    return nextQpi;
  }

  QTargetResolution derivedQuestTargetAtAnswerIdx(
    int newQuestIdx,
    int newQuestPromptIdx, {
    bool forRuleSelection = false,
  }) {
    /* returns the next (more precise) QTargetResolution
      instance that will be used on a NEW
      DERIVED (auto-generated) question
      based on user-answers held in this current question

      forRuleSelection means: set target complete
      on this new QTargetResolution

      intended to be overriden in subclass
    */
    assert(isFullyAnswered, 'cant call this method before ? is answered!');
    throw UnimplementedError('should be overriden in subclass');
    // return qTargetResolution.copyWith();
  }

  DerivedQuestGenerator getDerivedRuleQuestGenViaVisType(
    int newQuIdx,
    VisualRuleType? optRuleTypeToCreateDqg,
    RuleTypeFilterFunction? filterFunc,
  ) {
    /*  uses a VisualRuleType to dynamically build a DerivedQuestGenerator
    
    ONLY returns a DQG intended create VISIBLE rule-DETAIL questions
          may be invoked on (this) EITHER a RuleSelectQuest or RulePrepQuest

    called by q_cascade_dispatch
      to build a DerivedQuestGenerator
      from answers to this (current question)
    */
    assert(
      this is RuleSelectQuest || this is RulePrepQuest,
      'cant generate rule-detail quests on QID: "${this.questId}" because its not a rule SELECT or PREP type',
    );
    assert(targetPathIsComplete, 'target must be complete to run this method');

    // when this is RulePrepQuest, we're only dealing with ONE VisualRuleType; so create 1 derived
    int newQuestCountToGenerate = 1;
    VisualRuleType? selRule =
        this is RulePrepQuest ? visRuleTypeForAreaOrSlot : null;

    if (this is RuleSelectQuest) {
      // answer is a list so may create MULTIPLE derived questions
      List<VisualRuleType> selRules = this.mainAnswer as List<VisualRuleType>;
      if (filterFunc != null) {
        selRules = selRules.where(filterFunc).toList();
      } else {
        // skip VRTs that requiresRulePrepQuest;  another matcher will handle those
        selRules = selRules.where((vrt) => !vrt.requiresRulePrepQuest).toList();
      }
      selRule = selRules[newQuIdx];
      newQuestCountToGenerate = selRules.length;
      print(
        'INFO: dynamic DQG from type selected ${selRule.name.toUpperCase()} for $newQuIdx  (${(optRuleTypeToCreateDqg?.name ?? '_noVrtArg').toUpperCase()} could be used instead)',
      );
    }
    VisualRuleType ruleForNextQuestion =
        optRuleTypeToCreateDqg ?? selRule ?? visRuleTypeForAreaOrSlot!;

    String instanceTypeUC = this.runtimeType.toString().toUpperCase();
    print(
      'INFO: getDerivedRuleQuestGenViaVisType creating question for: ${ruleForNextQuestion.name.toUpperCase()} from a $instanceTypeUC question',
    );

    var newTarg = qTargetResolution.copyWith(
      visRuleTypeForAreaOrSlot: ruleForNextQuestion,
      precision: TargetPrecision.ruleDetailVisual,
    );
    return ruleForNextQuestion.makeQuestGenForRuleType(
      this,
      newTarg,
      newQuestCountToGenerate,
    );
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

  // Map<VisRuleQuestType, String> get _userRespMap =>
  //     Map<VisRuleQuestType, String>.fromIterable(qPromptCollection.prompts,
  //         key: (qpi) {
  //       return (qpi as QuestPromptInstance).visQuestType;
  //     }, value: (qpi) {
  //       return (qpi as QuestPromptInstance)._answerRepoAndTypeCast._answers;
  //     });

  RuleResponseBase get asVisRuleResponse {
    //
    RuleResponseBase rrb = visRuleTypeForAreaOrSlot!.ruleResponseContainer;
    print('\nasVisRuleResponse using:   (${qPromptCollection.prompts.length})');

    List<PairedQuestAndResp> pqr = qPromptCollection.listTypedResponses;
    print(pqr);

    rrb.castResponsesToAnswerTypes(pqr);
    return rrb;
  }

  bool get producesDerivedQuestsFromUserAnswers =>
      qTargetResolution.producesDerivedQuestsFromUserAnswers;

  int get countChoicesInFirstPrompt =>
      qPromptCollection.countChoicesInFirstPrompt;

  List<VisRuleQuestType> get embeddedQuestTypes =>
      qPromptCollection.embeddedQuestTypes;

  bool get requiresVisRulePrepQuestion =>
      qTargetResolution.requiresVisRulePrepQuestion;
  bool get requiresBehRulePrepQuestion =>
      qTargetResolution.requiresBehRulePrepQuestion;

  // derivedQuestConstructor overridden in subclasses
  QuestFactorytSignature get derivedQuestConstructor =>
      QuestBase.eventLevelCfgQuest;

  String get targetPath => qTargetResolution.targetPath;
  bool get targetPathIsComplete => qTargetResolution.targetComplete;
  bool get targetUncompleted => !targetPathIsComplete;
  bool get isFullyAnswered => qPromptCollection.allPartsHaveAnswers;

  // define type of question for auto-gen
  bool get isEventConfigQuest =>
      this is EventLevelCfgQuest && qTargetResolution.isEventConfigQuest;
  bool get isRegionTargetQuestion => this is RegionTargetQuest;
  bool get isRuleSelectionQuestion => this is RuleSelectQuest;
  bool get isRulePrepQuestion => this is RulePrepQuest;
  // rule level
  bool get isRuleDetailQuestion => this is RuleQuestBaseAbs; // controls export
  bool get isVisRuleDetailQuestion => this is VisualRuleDetailQuest;
  bool get isBehRuleDetailQuestion => this is BehaveRuleDetailQuest;

  Iterable<CaptureAndCast> get listResponses =>
      qPromptCollection.listResponseCasters;

  List<PairedQuestAndResp> get listTypedResponses =>
      qPromptCollection.listTypedResponses;

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
      qTargetResolution.isEventConfigQuest;
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

  // @override
  // QRespCascadePatternEm get respCascadePatternEm => isSelectScreensQuestion
  //     ? QRespCascadePatternEm.respCreatesWhichAreaInScreenQuestions
  //     : QRespCascadePatternEm.noCascade;

  @override
  QuestFactorytSignature get derivedQuestConstructor =>
      QuestBase.regionTargetQuest;

  @override
  QTargetResolution derivedQuestTargetAtAnswerIdx(
    int newQuestIdx,
    int newQuestPromptIdx, {
    bool forRuleSelection = false,
  }) {
    assert(
      isFullyAnswered && isSelectScreensQuestion,
      'cant call this method before ? is answered or this is wrong event-level quest!',
    );
    assert(
      !forRuleSelection,
      'Event lvl cfg ??s are not precise enough for a complete area-target',
    );
    List<AppScreen> screensToConfig = mainAnswer as List<AppScreen>;
    return qTargetResolution.copyWith(
      appScreen: screensToConfig[newQuestIdx],
      precision: TargetPrecision.screenLevel,
    );
  }
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

  // @override // && !qTargetResolution.targetComplete
  // QRespCascadePatternEm get respCascadePatternEm => _areaAlreadySet
  //     ? QRespCascadePatternEm.respCreatesWhichSlotOfAreaQuestions
  //     : QRespCascadePatternEm.respCreatesWhichAreaInScreenQuestions;

  @override
  QuestFactorytSignature get derivedQuestConstructor => targetPathIsComplete
      ? QuestBase.ruleSelectQuest
      : QuestBase.regionTargetQuest;

  @override
  QTargetResolution derivedQuestTargetAtAnswerIdx(
    int newQuestIdx,
    int newQuestPromptIdx, {
    bool forRuleSelection = false,
  }) {
    assert(
      isFullyAnswered,
      'cant call this method before question has been answered!',
    );
    assert(
      !targetPathIsComplete,
      'seems like target should NOT be Complete, or this is not really a RegionTargetQuest instance?? ${this.runtimeType}',
    );
    forRuleSelection = forRuleSelection || targetPathIsComplete;
    // if not for rule-selection, then this question
    // must be intended to define more precise targetting (area or slot)

    TargetPrecision _nextPrecision = TargetPrecision.targetLevel;
    if (forRuleSelection) {
      _nextPrecision = TargetPrecision.ruleSelect;
    }

    if (mainAnswer is List<ScreenWidgetArea>) {
      //
      ScreenWidgetArea area =
          (mainAnswer as List<ScreenWidgetArea>)[newQuestIdx];
      return qTargetResolution.copyWith(
        screenWidgetArea: area,
        precision: _nextPrecision,
      );
    } else if (mainAnswer is List<ScreenAreaWidgetSlot>) {
      //
      ScreenAreaWidgetSlot slot =
          (mainAnswer as List<ScreenAreaWidgetSlot>)[newQuestIdx];
      return qTargetResolution.copyWith(
        slotInArea: slot,
        precision: _nextPrecision,
      );
    }
    throw UnimplementedError(
      'err: should have been one or the other  ${mainAnswer.runtimeType}',
    );
    // return qTargetResolution.copyWith();
  }
}

class RuleSelectQuest extends QuestBase {
  /*  this class behaves very differently
      from other QuestBase instances
      because its answer can carry BOTH
      VisualRuleType's that need PREP 
      (generate quests to ask how many definitions)
      and those that don't need a prep-question
      (generate quests to directly ask selected rule details)
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
  QuestFactorytSignature get derivedQuestConstructor {
    return QuestBase.rulePrepQuest;
    // throw UnimplementedError(
    //   'you should be calling derivedQuestConstructorRuleSelection (only exists on this class)',
    // );
  }

  @override
  QTargetResolution derivedQuestTargetAtAnswerIdx(
    int newQuestIdx,
    int newQuestPromptIdx, {
    bool forRuleSelection = true,
  }) {
    throw UnimplementedError(
      'you should be calling derivedQuestTargetAtAnswerIdxRuleSelection (only exists on this class)',
    );
  }

  // replacements for overrides above
  // QuestFactorytSignature derivedQuestConstructorRuleSelection(RuleSelectOffsetBehavior selectionOffsetBehavior) =>
  //     QuestBase.rulePrepQuest;

  QTargetResolution derivedQuestTargetAtAnswerIdxRuleSelection(
    int newQuestIdx, {
    RuleSelectOffsetBehavior selectionOffsetBehavior =
        RuleSelectOffsetBehavior.selectFromVrtNeedPrep,
  }) {
    /* rule selection questions get confusing when user
      selects a mix of rules that both DO and DO NOT 
      require a prep-question
      derived questions are generated by different matchers
      and thus user-selection indexes 
      dont line up with the 
      because sublist of VRT does not line up 1-1

      example question scenario:
      select from following rules for to config ListView on MarketView  (multiple allowed)
        0  Select ListView rowStyle  (eg teamVsTeamRanked)
        1  Set sort fields
        2  Set group-by fields

        user selects 0,2  (rowStyle and group-by)
      group-by needs prep (how many grouping fields?)
      and matcher for rule-prep will only build ONE derived question
      however, questIdx 0 (#1) will select rowStyle, not group-by

      so we need methods to convert questIdx 0 into index position #2
      so that derivedQuestTargetAtAnswerIdx (QTargetResolution) 
      gets group-by and not rowStyle
      as its VisualRuleType
    */
    assert(
      isFullyAnswered,
      'cant call this method before ? is answered!',
    );
    assert(
      targetPathIsComplete,
      'target must be complete (fully resolved) within a rule select question!',
    );
    //
    // String userSelectedOptions = _firstPromptAnswers.answer;

    VisualRuleType selRule = selectionOffsetBehavior.selectedVrtByAdjustedIndex(
      mainAnswer as List<VisualRuleType>,
      newQuestIdx,
    );

    TargetPrecision newPrecision = selRule.requiresRulePrepQuest
        ? TargetPrecision.rulePrep
        : TargetPrecision.ruleDetailVisual;
    return qTargetResolution.copyWith(
      visRuleTypeForAreaOrSlot: selRule,
      precision: newPrecision,
    );
  }

  int derivedQuestCount(RuleSelectOffsetBehavior selectionOffsetBehavior) {
    // how many derived questions to create (depends on rule-prep or rule-detail matcher)
    return selectionOffsetBehavior
        .derQuestCountFromSublist(mainAnswer as List<VisualRuleType>);
  }
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

  // @override
  // QRespCascadePatternEm get respCascadePatternEm =>
  //     QRespCascadePatternEm.respCreatesRuleDetailForSlotOrAreaQuestions;

  @override
  QuestFactorytSignature get derivedQuestConstructor => createsBehavioralQuests
      ? QuestBase.behaveRuleDetailQuest
      : QuestBase.visualRuleDetailQuest;

  @override
  QTargetResolution derivedQuestTargetAtAnswerIdx(
    int newQuestIdx,
    int newQuestPromptIdx, {
    bool forRuleSelection = true,
  }) {
    assert(
      isFullyAnswered,
      'cant call this method before ? is answered!',
    );
    assert(
      targetPathIsComplete,
      'target must be complete in a rule prep question!',
    );

    return qTargetResolution.copyWith(
      precision: TargetPrecision.ruleDetailVisual,
    );
  }
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
  // @override
  // QRespCascadePatternEm get respCascadePatternEm =>
  //     QRespCascadePatternEm.noCascade;

  @override
  QuestFactorytSignature get derivedQuestConstructor {
    throw UnimplementedError(
      'Rule details questions do not generate new questions; they contain the final rule-config details & cascade stops at this level',
    );
  }

  @override
  QTargetResolution derivedQuestTargetAtAnswerIdx(
    int newQuestIdx,
    int newQuestPromptIdx, {
    bool forRuleSelection = true,
  }) {
    assert(
      isFullyAnswered,
      'cant call this method before ? is answered!',
    );
    assert(
      targetPathIsComplete,
      'target must be complete in a rule prep question!',
    );
    String m =
        'Error:  Rule detail questions DO NOT produce derived questions.  Why are you calling me?';
    // print(m);
    throw UnimplementedError(m);
    // return qTargetResolution.copyWith();
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
