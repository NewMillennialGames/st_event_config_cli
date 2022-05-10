part of RandDee;

class Quest2 extends Equatable implements QuestionIfc {
  /* 
    cleaner and more testable replacement for:
    Question<ConvertTyp, AnsTyp> and VisualRuleQuestion<>
    it combines those classes so there is no fundamental distinction
    between
    largely a wrapper around qIterDef && qQuantify
  */
  final QIntentCfg qIntentCfg;
  final QTargetQuantify qTargetQuant;
  final QDefCollection qDefCollection;
  final bool addsToUiFactoryConfigRules;

// optional unique value for expedited matching
  String questionId = '';
  // _currQuestion is active working state
  QuestPromptInstance? _currQuestion;

  Quest2(
    this.qIntentCfg,
    this.qTargetQuant,
    this.qDefCollection, {
    this.addsToUiFactoryConfigRules = true,
    String? questId,
  }) : questionId = questId == null ? qTargetQuant.sortKey : questId {
    // now select first question to be ready for display
    _currQuestion = qDefCollection.nextPart;
  }

  // factory constructors
  // factory Quest2.asTopLevel(
  //   QTargetQuantify qQuan,
  //   String userPrompt,
  //   List<String> choices,
  //   Type ansTyp, {
  //   bool acceptsMultiResponses = true,
  //   bool isNotForOutput = true,
  //   String questId = '',
  // }) {
  //   var choiceColl = VisQuestChoiceCollection.fromList(
  //       VisRuleQuestType.dialogStruct, choices);
  //   // var respWrap = QTypeWrapper<RuleResponseBase>();

  //   // var xxx = (QTypeWrapper qw, String s) {
  //   //   var rrb = RuleResponseBase(VisualRuleType.filterCfg);
  //   //   return rrb;
  //   // };
  //   List<QuestPromptInstance> q = [
  //     QuestPromptInstance(
  //       userPrompt,
  //       choiceColl,
  //     ),
  //   ];
  //   var qIterDef = QDefCollection.fromMap(q);
  //   return Quest2(
  //     qQuan,
  //     qIterDef,
  //     addsToUiFactoryConfigRules: !isNotForOutput,
  //     questId: questId,
  //   );
  // }

  //   factory Quest2.asVisualRule() {

  // }

  // getters
  // Type get expectedAnswerType => _currQuestion?.answType ?? int;
  bool get existsONLYToGenDialogStructure => !addsToUiFactoryConfigRules;
  bool get isNotForOutput => !addsToUiFactoryConfigRules;

  // Iterable<UserResponse> get allAnswers => qDefCollection.allTypedAnswers;
  bool get isMultiPart => qDefCollection.isMultiPart;
  QuestPromptInstance? get currQuestion => _currQuestion;

  bool get isTopLevelConfigOrScreenQuestion =>
      qTargetQuant.isTopLevelConfigOrScreenQuestion;
  // List<String>? get answerChoicesList => _answerChoices?.toList();
  bool get hasChoices => _currQuestion?.hasChoices ?? false;
  // quantified info
  AppScreen get appScreen => qTargetQuant.appScreen;
  ScreenWidgetArea? get screenWidgetArea => qTargetQuant.screenWidgetArea;
  ScreenAreaWidgetSlot? get slotInArea => qTargetQuant.slotInArea;
  //
  VisualRuleType? get visRuleTypeForAreaOrSlot =>
      qTargetQuant.visRuleTypeForAreaOrSlot;
  BehaviorRuleType? get behRuleTypeForAreaOrSlot =>
      qTargetQuant.behRuleTypeForAreaOrSlot;
  //

  // below controls how each question causes cascade creation of new questions
  bool get generatesNoNewQuestions => qTargetQuant.generatesNoNewQuestions;
  bool get addsRuleDetailQuestsForSlotOrArea =>
      qTargetQuant.addsRuleDetailQuestsForSlotOrArea;

  String get sortKey => qTargetQuant.sortKey;
  // ask 2nd & 3rd position for (sort, group, filter)
  // bool get gens2ndOr3rdSortGroupFilterQuests => false;

  // appliesToClientConfiguration == should be exported to file
  bool get appliesToClientConfiguration =>
      qDefCollection.isRuleQuestion ||
      appScreen == AppScreen.eventConfiguration;

  // ARE BELOW needed with new approach??

  // bool get asksWhichScreensToConfig =>
  //     qQuantify.appScreen == AppScreen.eventConfiguration &&
  //     expectedAnswerType is List<AppScreen>;

  // bool get addsWhichAreaInSelectedScreenQuestions =>
  //     qQuantify.addsWhichAreaInSelectedScreenQuestions &&
  //     appScreen == AppScreen.eventConfiguration &&
  //     expectedAnswerType is List<AppScreen>;

  // bool get addsWhichRulesForSelectedAreaQuestions =>
  //     qQuantify.addsWhichRulesForSelectedAreaQuestions &&
  //     expectedAnswerType is List<ScreenWidgetArea>;

  // bool get addsWhichSlotOfSelectedAreaQuestions =>
  //     qQuantify.addsWhichSlotOfSelectedAreaQuestions &&
  //     expectedAnswerType is List<ScreenWidgetArea>;

  // bool get addsWhichRulesForSlotsInArea =>
  //     qQuantify.addsWhichRulesForSlotsInArea &&
  //     expectedAnswerType is List<ScreenAreaWidgetSlot>;

  void convertAndStoreUserResponse(String userResp) {
    //
    // RuleResponseWrapperIfc? typedResp = _currQuestion?.typedUserAnsw(userResp);
    // if (_currQuestion == null) {
    //   print('Err:  answer $userResp sent with no current question');
    // }
    // _currQuestion = qDefCollection.nextPart;

    // if (_currQuestion == null) {
    //   print('Quest def $questionId is done!! ');
    // }
  }

  Question fromExisting(
    String quStr,
    PerQuestGenOptions pqt,
  ) {
    // used to create derived questions from existing answers
    QTargetQuantify newQq = pqt.qQuantUpdater(this.qTargetQuant);
    String newId = pqt.questId.isNotEmpty
        ? pqt.questId
        : (this.questionId + ':' + newQq.sortKey);
    return Question<String, dynamic>(
      newQq,
      quStr,
      pqt.answerChoices,
      pqt.castFunc,
      defaultAnswerIdx: pqt.defaultAnswerIdx,
      questId: newId,
    );
  }

  // impl for equatable
  // but really being used as a search filter
  // to find questions in a specific granularity
  @override
  List<Object> get props => [qTargetQuant];

  @override
  bool get stringify => true;

  @override
  List<QuestChoiceOption> get answerOptions => qDefCollection.curQAnswerOptions;

  @override
  bool get hasMorePrompts => !qDefCollection.isCompleted;

  @override
  String? get nextUserPrompt => qDefCollection.nextPart?.userPrompt;

  @override
  SubmitUserResponseFunc get storeUserReponse => throw UnimplementedError('');
}
