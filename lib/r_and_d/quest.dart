part of RandDee;

class Quest2 extends Equatable {
  /* 
    cleaner and more testable replacement for:
    Question<ConvertTyp, AnsTyp> and VisualRuleQuestion<>
    it combines those classes so there is no fundamental distinction
    between
    largely a wrapper around qIterDef && qQuantify
  */
  final QTargetIntent qTargetIntent;
  final QDefCollection qDefCollection;
  // final bool addsToUiFactoryConfigRules;

// optional unique value for expedited matching
  String questionId = '';

  Quest2(
    this.qTargetIntent,
    this.qDefCollection, {
    String? questId,
  }) : questionId = questId == null ? qTargetIntent.sortKey : questId {
    // now select first question to be ready for display
    // _currQuestion = qDefCollection.curQuestion;
  }

  QuestPromptInstance? getNextUserPromptIfExists() {
    //
    QuestPromptInstance? nextQpi = qDefCollection.getNextUserPromptIfExists();
    if (nextQpi == null) {
      // out of questions
    }
    return nextQpi;
  }

  // getters
  // QuestPromptInstance? get currQuestion => _currQuestion;
  bool get existsONLYToGenDialogStructure =>
      qTargetIntent.isTopLevelConfigOrScreenQuestion;
  bool get isNotForRuleOutput => existsONLYToGenDialogStructure;
  bool get isMultiPart => qDefCollection.isMultiPart;

  bool get isTopLevelConfigOrScreenQuestion =>
      qTargetIntent.isTopLevelConfigOrScreenQuestion;
  // bool get hasChoices => _currQuestion?.hasChoices ?? false;
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

  // below controls how each question causes cascade creation of new questions
  bool get generatesNoNewQuestions => qTargetIntent.generatesNoNewQuestions;
  bool get addsRuleDetailQuestsForSlotOrArea =>
      qTargetIntent.addsRuleDetailQuestsForSlotOrArea;

  String get sortKey => qTargetIntent.sortKey;
  // ask 2nd & 3rd position for (sort, group, filter)

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

  // impl for equatable
  // but really being used as a search filter
  // to find questions in a specific granularity
  @override
  List<Object> get props => [qTargetIntent];

  @override
  bool get stringify => true;

  // @override
  // List<QuestChoiceOption> get answerOptions => qDefCollection.curQAnswerOptions;

  // @override
  // bool get hasMorePrompts => !qDefCollection.isCompleted;

  // @override
  // String? get nextUserPrompt => qDefCollection.nextPart?.userPrompt;

  // @override
  // SubmitUserResponseFunc get storeUserReponse => throw UnimplementedError('');
}
