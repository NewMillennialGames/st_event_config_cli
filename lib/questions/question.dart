part of QuestionsLib;

class QuestPromptPayload<T> {
  //
  String userPrompt;
  Iterable<String> choices;
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

  */
  final QTargetIntent qTargetIntent;
  final QPromptCollection qPromptCollection;
  // optional unique value for expedited matching
  String questId = '';
  // bool isDiagnostic = false;

  QuestBase(
    this.qTargetIntent,
    this.qPromptCollection, {
    String? questId,
  }) : questId = questId == null ? qTargetIntent.sortKey : questId {
    // now select first Quest2 to be ready for display
    // _currQuest2 = qDefCollection.curQuest2;
  }

  factory QuestBase.infoOrCliCfg(
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
    return Quest1Prompt(targIntent, qDefCollection);
  }

  factory QuestBase.dlogCascade(
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
    return QuestMultiPrompt(targIntent, qDefCollection);
  }

  factory QuestBase.multiPrompt(
    QTargetIntent targIntent,
    List<QuestPromptPayload> prompts, {
    String? questId,
  }) {
    //
    var qDefCollection = QPromptCollection.fromList(prompts);
    return QuestMultiPrompt(targIntent, qDefCollection);
  }

  factory QuestBase.visualRule(
    QTargetIntent targIntent,
    String userPrompt,
    Iterable<String> choices,
    CaptureAndCast captureAndCast, {
    String? questId,
  }) {
    //
    var qDefCollection = QPromptCollection.singleRule(
      userPrompt,
      choices,
      captureAndCast,
    );
    return QuestVisualRule(targIntent, qDefCollection);
  }

  factory QuestBase.behavioralRule(
    QTargetIntent targIntent,
    String userPrompt,
    Iterable<String> choices,
    CaptureAndCast captureAndCast, {
    String? questId,
  }) {
    //

    var qDefCollection = QPromptCollection.singleRule(
      userPrompt,
      choices,
      captureAndCast,
    );
    return QuestBehaveRule(targIntent, qDefCollection);
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

  List<String> get allUserAnswers => qPromptCollection.questIterations
      .map((qi) => qi.userAnswers._answers)
      .toList();
  int get promptCount => qPromptCollection.questIterations.length;
  List<VisRuleQuestType> get questTypes => qPromptCollection.questIterations
      .map((e) => e.answChoiceCollection.visRuleQuestType)
      .toList();
  bool get isRuleQuestion => false;
  QuestPromptInstance get firstQuestion =>
      qPromptCollection.questIterations.first;
  CaptureAndCast get _firstPromptAnswers =>
      firstQuestion._answerRepoAndTypeCast;
  dynamic get mainAnswer => _firstPromptAnswers.cast();
  // Caution --- below may not work
  Type get expectedAnswerType => _firstPromptAnswers.cast().runtimeType;

  // getters
  // QuestPromptInstance? get currQuest2 => _currQuest2;
  bool get existsONLYToGenDialogStructure =>
      qTargetIntent.isTopLevelConfigOrScreenQuest2;
  bool get isNotForRuleOutput => existsONLYToGenDialogStructure;
  bool get isMultiPart => qPromptCollection.isMultiPart;

  bool get isTopLevelConfigOrScreenQuest2 =>
      qTargetIntent.isTopLevelConfigOrScreenQuest2;
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
  Iterable<CaptureAndCast> get listResponses => qPromptCollection.listResponses;

  // below controls how each Quest2 causes cascade creation of new Quest2s
  bool get generatesNoNewQuest2s => qTargetIntent.generatesNoNewQuest2s;
  bool get addsRuleDetailQuestsForSlotOrArea =>
      qTargetIntent.addsRuleDetailQuestsForSlotOrArea;

  String get sortKey => qTargetIntent.sortKey;
  // ask 2nd & 3rd position for (sort, group, filter)

  // appliesToClientConfiguration == should be exported to file
  bool get appliesToClientConfiguration =>
      qPromptCollection.isRuleQuestion ||
      appScreen == AppScreen.eventConfiguration;

  // ARE BELOW needed with new approach??

  bool get asksWhichScreensToConfig =>
      qTargetIntent.appScreen == AppScreen.eventConfiguration &&
      expectedAnswerType is List<AppScreen>;

  bool get addsWhichAreaInSelectedScreenQuest2s =>
      qTargetIntent.addsWhichAreaInSelectedScreenQuest2s &&
      appScreen == AppScreen.eventConfiguration &&
      expectedAnswerType is List<AppScreen>;

  bool get addsWhichRulesForSelectedAreaQuest2s =>
      qTargetIntent.addsWhichRulesForSelectedAreaQuest2s &&
      expectedAnswerType is List<ScreenWidgetArea>;

  bool get addsWhichSlotOfSelectedAreaQuest2s =>
      qTargetIntent.addsWhichSlotOfSelectedAreaQuest2s &&
      expectedAnswerType is List<ScreenWidgetArea>;

  bool get addsWhichRulesForSlotsInArea =>
      qTargetIntent.addsWhichRulesForSlotsInArea &&
      expectedAnswerType is List<ScreenAreaWidgetSlot>;

  // impl for equatable
  // but really being used as a search filter
  // to find Quest2s in a specific granularity
  @override
  List<Object> get props => [qTargetIntent];

  @override
  bool get stringify => true;
}

class Quest1Prompt extends QuestBase {
  /*  Question offering only one user prompt / question
    this DOES NOT mean the user cannot select multiple options
  */
  Quest1Prompt(
    QTargetIntent qTargetIntent,
    QPromptCollection qDefCollection, {
    String? questId,
  }) : super(qTargetIntent, qDefCollection, questId: questId) {}
}

class QuestMultiPrompt extends QuestBase {
  /*  Question offering MULTIPLE user prompt / questions

  */

  QuestMultiPrompt(
    QTargetIntent qTargetIntent,
    QPromptCollection qDefCollection, {
    String? questId,
  }) : super(qTargetIntent, qDefCollection, questId: questId) {}
}

class QuestVisualRule extends QuestBase {
  /*  
  */

  QuestVisualRule(
    QTargetIntent qTargetIntent,
    QPromptCollection qDefCollection, {
    String? questId,
  }) : super(qTargetIntent, qDefCollection, questId: questId) {}

  // getters
  bool get isRuleQuestion => true;
}

class QuestBehaveRule extends QuestBase {
  /*  
  */

  QuestBehaveRule(
    QTargetIntent qTargetIntent,
    QPromptCollection qDefCollection, {
    String? questId,
  }) : super(qTargetIntent, qDefCollection, questId: questId) {}

  // getters
  bool get isRuleQuestion => true;
}
