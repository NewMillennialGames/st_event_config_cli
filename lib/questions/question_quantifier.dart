part of InputModels;

class QuestionQuantifier extends Equatable {
  /* describes what a question is about
    it's purpose, behavior and output
    made it equatable to enable searching Q-list
  */

  final QuestCascadeTyp cascadeType;
  final AppScreen appScreen;
  /* properties below are in ORDER
  if any property is set (not null)
  then all properties ABOVE it must also be non-null
  */
  final ScreenWidgetArea? screenWidgetArea;
  final ScreenAreaWidgetSlot? slotInArea;
  // a rule-type applies to all of:
  //    appScreen, screenWidgetArea, slotInArea
  final VisualRuleType? visRuleTypeForAreaOrSlot;
  final BehaviorRuleType? behRuleTypeForAreaOrSlot;

  const QuestionQuantifier._(
    this.cascadeType,
    this.appScreen,
    this.screenWidgetArea,
    this.slotInArea,
    this.visRuleTypeForAreaOrSlot,
    this.behRuleTypeForAreaOrSlot,
  );

  String get sortKey {
    // makes equatable work for searching & sorting question list
    int screenAreaIdx = 1 + (screenWidgetArea?.index ?? -1);
    int slotInAreaIdx = 1 + (slotInArea?.index ?? -1);
    int visRuleTypeIdx = 1 + (visRuleTypeForAreaOrSlot?.index ?? -1);
    int behRuleTypeIdx = 1 + (behRuleTypeForAreaOrSlot?.index ?? -1);
    return '${appScreen.index}-$screenAreaIdx-$slotInAreaIdx-$visRuleTypeIdx-$behRuleTypeIdx-${cascadeType.index}';
  }

  // equatableKey must be distinct & unique
  String get equatableKey => sortKey;

  bool get isTopLevelConfigOrScreenQuestion =>
      appScreen == AppScreen.eventConfiguration &&
      screenWidgetArea == null &&
      slotInArea == null &&
      visRuleTypeForAreaOrSlot == null &&
      behRuleTypeForAreaOrSlot == null;

  bool get isQuestAboutAreaInScreenOrSlotInArea =>
      screenWidgetArea != null &&
      visRuleTypeForAreaOrSlot == null &&
      behRuleTypeForAreaOrSlot == null; // && slotInArea == null
  //
  bool get generatesNoNewQuestions => cascadeType.generatesNoNewQuestions;
  bool get asksAreasWithinSelectedScreens =>
      cascadeType.asksAboutRulesAndSlotsWithinSelectedScreenAreas;
  bool get asksAboutRulesAndSlotsWithinSelectedScreenAreas =>
      cascadeType.asksSlotsWithinSelectedScreenAreas;
  bool get asksRuleTypesForSelectedAreasOrSlots =>
      cascadeType.asksRuleTypesForSelectedAreasOrSlots;
  bool get asksDetailsForEachVisualRuleType =>
      cascadeType.asksDetailsForEachVisualRuleType;
  bool get asksDetailsForEachBehaveRuleType =>
      cascadeType.asksDetailsForEachBehaveRuleType;

  // factory QuestionQuantifier.forSearchFilter = QuestionQuantifier.custom;
  // factory QuestionQuantifier.forSearchFilter(
  //   QuestCascadeTyp cascadeType,
  //   AppScreen appScreen,
  //   ScreenWidgetArea? screenArea,
  //   ScreenAreaWidgetSlot? slotInArea,
  //   VisualRuleType? visRuleTypeForAreaSlot,
  //   BehaviorRuleType? behRuleTypeForAreaSlot,
  // ) {
  //   return QuestionQuantifier._(
  //     cascadeType,
  //     appScreen,
  //     screenArea,
  //     slotInArea,
  //     visRuleTypeForAreaSlot,
  //     behRuleTypeForAreaSlot,
  //   );
  // }

  /*  certain questions at top 3 levels (when property answered)
      can generate questions for levels below them
  */

  factory QuestionQuantifier.eventLevel({
    bool responseAddsWhichAreaQuestions = false,
  }) {
    return QuestionQuantifier._(
      responseAddsWhichAreaQuestions
          ? QuestCascadeTyp.addsWhichAreaInEachScreenQuestions
          : QuestCascadeTyp.noCascade,
      AppScreen.eventConfiguration,
      null,
      null,
      null,
      null,
    );
  }

  factory QuestionQuantifier.appScreenLevel(
    AppScreen appScreen, {
    bool responseAddsWhichSlotQuestions = false,
  }) {
    // not in use but here for future
    // these individual "Wanna config this screen?" questions are skipped
    // because the FINAL event-level question above
    // has addsWhichScreenQuestions = true and it does all this work for you
    return QuestionQuantifier._(
      responseAddsWhichSlotQuestions
          ? QuestCascadeTyp.addsWhichSlotOfSelectedAreaQuestions
          : QuestCascadeTyp.noCascade,
      appScreen,
      null,
      null,
      null,
      null,
    );
  }

  factory QuestionQuantifier.screenAreaLevel(
    AppScreen appScreen,
    ScreenWidgetArea screenArea, {
    bool responseAddsWhichRuleTypeQuestions = false,
    bool responseAddsWhichSlotQuestions = false,
  }) {
    return QuestionQuantifier._(
      responseAddsWhichRuleTypeQuestions
          ? QuestCascadeTyp.addsVisualRuleQuestions
          : (responseAddsWhichSlotQuestions
              ? QuestCascadeTyp.addsWhichSlotOfSelectedAreaQuestions
              : QuestCascadeTyp.noCascade),
      appScreen,
      screenArea,
      null,
      null,
      null,
    );
  }

  factory QuestionQuantifier.slotAreaLevel(
    AppScreen appScreen,
    ScreenWidgetArea screenArea,
    ScreenAreaWidgetSlot slot, {
    bool responseAddsRuleDetailQuestions = false,
  }) {
    return QuestionQuantifier._(
      responseAddsRuleDetailQuestions
          ? QuestCascadeTyp.addsVisualRuleQuestions
          : QuestCascadeTyp.noCascade,
      appScreen,
      screenArea,
      slot,
      null,
      null,
    );
  }

  factory QuestionQuantifier.ruleCompositionLevel(
    AppScreen appScreen,
    ScreenWidgetArea screenWidgetArea,
    VisualRuleType visRuleTypeForSlotInArea,
    // rule level always has screen & area; may have slot
    ScreenAreaWidgetSlot? slot,
    BehaviorRuleType? behRuleTypeForSlotInArea, {
    bool addsMoreRuleQuestions = false,
  }) {
    bool isVisual = visRuleTypeForSlotInArea != null;
    return QuestionQuantifier._(
      addsMoreRuleQuestions
          ? (isVisual
              ? QuestCascadeTyp.addsVisualRuleQuestions
              : QuestCascadeTyp.addsBehavioralRuleQuestions)
          : QuestCascadeTyp.noCascade,
      appScreen,
      screenWidgetArea,
      slot,
      visRuleTypeForSlotInArea,
      behRuleTypeForSlotInArea,
    );
  }

  List<VisualRuleType> relatedSubVisualRules(Question quest) {
    if (!this.generatesNoNewQuestions) return [];

    List<VisualRuleType> list = [];
    switch (this.visRuleTypeForAreaOrSlot!) {
      case VisualRuleType.filterCfg:
        list.addAll([]);
    }

    return list;
  }

  // impl for equatable
  @override
  List<Object> get props => [equatableKey];

  @override
  bool get stringify => true;
}



// below implements local memoize cache

// Map<String, QuestionQuantifier> _qqCache = {};

// String _makeQqKey(
//   QuestCascadeTyp cascadeType,
//   AppSection appSection,
//   UiComponent? uiCompInSection,
//   VisualRuleType? visRuleTypeForComp,
//   BehaviorRuleType? behRuleTypeForComp,
// ) {
//   // bump idx for optionals up by 1 so zero represents unset state
//   int uiCompIdx = 1 + (uiCompInSection?.index ?? -1);
//   int visRuleTypeForCompIdx = 1 + (visRuleTypeForComp?.index ?? -1);
//   int behRuleTypeForCompIdx = 1 + (behRuleTypeForComp?.index ?? -1);
//   return '${cascadeType.index}-${appSection.index}-$uiCompIdx-$visRuleTypeForCompIdx-$behRuleTypeForCompIdx';
// }


    // var key = _makeQqKey(
    //   cascadeType,
    //   appSection,
    //   uiCompInSection,
    //   visRuleTypeForComp,
    //   behRuleTypeForComp,
    // );

    // var cached = _qqCache[key];
    // if (cached != null) return cached;

    // QuestionQuantifier qq = QuestionQuantifier._(
    //   cascadeType,
    //   appSection,
    //   uiCompInSection,
    //   visRuleTypeForComp,
    //   behRuleTypeForComp,
    // );
    // store in cache
    // _qqCache[key] = qq;
    // return qq;