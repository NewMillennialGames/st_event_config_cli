part of RandDee;

abstract class QuestBase with EquatableMixin {
  //
  final QTargetIntent qTargetIntent;
  final QDefCollection qDefCollection;
  // optional unique value for expedited matching
  String questId = '';

  QuestBase(
    this.qTargetIntent,
    this.qDefCollection, {
    String? questId,
  }) : questId = questId == null ? qTargetIntent.sortKey : questId {
    // now select first Quest2 to be ready for display
    // _currQuest2 = qDefCollection.curQuest2;
  }

  QuestPromptInstance? getNextUserPromptIfExists() {
    //
    QuestPromptInstance? nextQpi = qDefCollection.getNextUserPromptIfExists();
    if (nextQpi == null) {
      // out of Quest2s
    }
    return nextQpi;
  }

  bool containsPromptWhere(bool Function(QuestPromptInstance qpi) promptTest) {
    // check if this contains an instance that matches promptTest
    for (QuestPromptInstance qpi in qDefCollection.questIterations) {
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
    for (QuestPromptInstance qpi in qDefCollection.questIterations) {
      if (promptTest(qpi)) {
        l.add(qpi);
      }
    }
    return l;
  }

  QuestPromptInstance get firstQuestion => qDefCollection.questIterations.first;
  CaptureAndCast get _firstPromptAnswers => firstQuestion._userAnswers;
  dynamic get mainAnswer => _firstPromptAnswers.cast();
  // Caution --- below may not work
  Type get expectedAnswerType => _firstPromptAnswers.cast().runtimeType;

  // getters
  // QuestPromptInstance? get currQuest2 => _currQuest2;
  bool get existsONLYToGenDialogStructure =>
      qTargetIntent.isTopLevelConfigOrScreenQuest2;
  bool get isNotForRuleOutput => existsONLYToGenDialogStructure;
  bool get isMultiPart => qDefCollection.isMultiPart;

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

  // below controls how each Quest2 causes cascade creation of new Quest2s
  bool get generatesNoNewQuest2s => qTargetIntent.generatesNoNewQuest2s;
  bool get addsRuleDetailQuestsForSlotOrArea =>
      qTargetIntent.addsRuleDetailQuestsForSlotOrArea;

  String get sortKey => qTargetIntent.sortKey;
  // ask 2nd & 3rd position for (sort, group, filter)

  // appliesToClientConfiguration == should be exported to file
  bool get appliesToClientConfiguration =>
      qDefCollection.isRuleQuest2 || appScreen == AppScreen.eventConfiguration;

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

class Quest2 extends QuestBase {
  /*  SINGLE question instance
  
    cleaner and more testable replacement for:
    Quest2<ConvertTyp, AnsTyp> and Quest2<>
    it combines those classes so there is no fundamental distinction
    between
    largely a wrapper around qIterDef && qQuantify
  */
//   final QTargetIntent qTargetIntent;
//   final QDefCollection qDefCollection;
//   // final bool addsToUiFactoryConfigRules;

// // optional unique value for expedited matching
//   String questId = '';

  Quest2(
    QTargetIntent qTargetIntent,
    QDefCollection qDefCollection, {
    String? questId,
  }) : super(qTargetIntent, qDefCollection, questId: questId) {}
}

class QuestMulti extends QuestBase {
  /*  SINGLE question instance
  
    cleaner and more testable replacement for:
    Quest2<ConvertTyp, AnsTyp> and Quest2<>
    it combines those classes so there is no fundamental distinction
    between
    largely a wrapper around qIterDef && qQuantify
  */
//   final QTargetIntent qTargetIntent;
//   final QDefCollection qDefCollection;
//   // final bool addsToUiFactoryConfigRules;

// // optional unique value for expedited matching
//   String questId = '';

  QuestMulti(
    QTargetIntent qTargetIntent,
    QDefCollection qDefCollection, {
    String? questId,
  }) : super(qTargetIntent, qDefCollection, questId: questId) {}
}
