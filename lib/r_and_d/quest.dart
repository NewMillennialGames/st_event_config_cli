part of RandDee;

class Quest2 extends Equatable {
  // largely a wrapper around qIterDef && qQuantify
  final QuestionQuantifier qQuantify;
  final QuestIterDef qIterDef;
  final bool additiveToConfigRules;

// unique value for expedited matching
  String questionId = '';
  // working state
  SingleQuestIteration? _currQuestion;

  Quest2(
    this.qQuantify,
    this.qIterDef, {
    this.additiveToConfigRules = true,
    String? questId,
  }) : questionId = questId == null ? qQuantify.sortKey : questId {
    _currQuestion = qIterDef.nextPart;
  }

  // getters
  Type get expectedAnswerType => _currQuestion?.answType ?? int;
  bool get isNotForOutput => !additiveToConfigRules;
  Iterable<UserResponse> get allAnswers => qIterDef.allTypedAnswers;
  bool get isMultiPart => qIterDef.isMultiPart;
  SingleQuestIteration? get currQuestion => _currQuestion;

  bool get isTopLevelConfigOrScreenQuestion =>
      qQuantify.isTopLevelConfigOrScreenQuestion;
  // List<String>? get answerChoicesList => _answerChoices?.toList();
  bool get hasChoices => _currQuestion?.hasChoices ?? false;
  // quantified info
  AppScreen get appScreen => qQuantify.appScreen;
  ScreenWidgetArea? get screenWidgetArea => qQuantify.screenWidgetArea;
  ScreenAreaWidgetSlot? get slotInArea => qQuantify.slotInArea;
  //
  VisualRuleType? get visRuleTypeForAreaOrSlot =>
      qQuantify.visRuleTypeForAreaOrSlot;
  BehaviorRuleType? get behRuleTypeForAreaOrSlot =>
      qQuantify.behRuleTypeForAreaOrSlot;
  //

  // below controls how each question causes cascade creation of new questions
  bool get generatesNoNewQuestions => qQuantify.generatesNoNewQuestions;

  bool get asksWhichScreensToConfig =>
      qQuantify.appScreen == AppScreen.eventConfiguration &&
      expectedAnswerType == List<AppScreen>;

  bool get addsWhichAreaInSelectedScreenQuestions =>
      qQuantify.addsWhichAreaInSelectedScreenQuestions &&
      appScreen == AppScreen.eventConfiguration &&
      expectedAnswerType == List<AppScreen>;

  bool get addsWhichRulesForSelectedAreaQuestions =>
      qQuantify.addsWhichRulesForSelectedAreaQuestions &&
      expectedAnswerType == List<ScreenWidgetArea>;

  bool get addsWhichSlotOfSelectedAreaQuestions =>
      qQuantify.addsWhichSlotOfSelectedAreaQuestions &&
      expectedAnswerType == List<ScreenWidgetArea>;

  bool get addsWhichRulesForSlotsInArea =>
      qQuantify.addsWhichRulesForSlotsInArea &&
      expectedAnswerType == List<ScreenAreaWidgetSlot>;

  bool get addsRuleDetailQuestsForSlotOrArea =>
      qQuantify.addsRuleDetailQuestsForSlotOrArea;

  // bool get addsBehavioralRuleQuestions => qQuantify.addsBehavioralRuleQuestions;

  String get sortKey => qQuantify.sortKey;
  // ask 2nd & 3rd position for (sort, group, filter)
  // bool get gens2ndOr3rdSortGroupFilterQuests => false;

  // appliesToClientConfiguration == should be exported to file
  bool get appliesToClientConfiguration =>
      qIterDef.isRuleQuestion || appScreen == AppScreen.eventConfiguration;

  void convertAndStoreUserResponse(String userResp) {
    //
    _currQuestion?.typedUserAnsw(userResp);
    if (_currQuestion == null) {
      print('Err:  answer $userResp sent with no current question');
    }
    _currQuestion = qIterDef.nextPart;

    if (_currQuestion == null) {
      print('Quest def $questionId is done!! ');
    }
  }

  Question fromExisting(
    String quStr,
    PerQuestGenOptions pqt,
  ) {
    // used to create derived questions from existing answers
    QuestionQuantifier newQq = pqt.qQuantUpdater(this.qQuantify);
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
  List<Object> get props => [qQuantify];

  @override
  bool get stringify => true;
}
