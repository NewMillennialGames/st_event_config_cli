part of InputModels;

class QuestionQuantifier extends Equatable {
  /* describes what a question is about
    it's purpose, behavior and output
    made it equatable to enable searching Q-list

  */

  final QuestCascadeTyp cascadeType;
  final AppScreen appScreen;
  final ScreenWidgetArea? screenWidgetArea;
  final SubWidgetInScreenArea? slotInArea;
  // a rule-type applies to all of:
  //    screen, screen-area, slot in that area
  final VisualRuleType? visRuleTypeForSlotInArea;
  final BehaviorRuleType? behRuleTypeForSlotInArea;

  const QuestionQuantifier._(
    this.cascadeType,
    this.appScreen,
    this.screenWidgetArea,
    this.slotInArea,
    this.visRuleTypeForSlotInArea,
    this.behRuleTypeForSlotInArea,
  );

  String get key {
    // makes equatable work for searching question list
    int uiCompIdx = 1 + (screenWidgetArea?.index ?? -1);
    int visRuleTypeForCompIdx = 1 + (visRuleTypeForSlotInArea?.index ?? -1);
    int behRuleTypeForCompIdx = 1 + (behRuleTypeForSlotInArea?.index ?? -1);
    return '${cascadeType.index}-${appScreen.index}-$uiCompIdx-$visRuleTypeForCompIdx-$behRuleTypeForCompIdx';
  }

  bool get isTopLevelConfigOrScreenQuestion =>
      screenWidgetArea == null &&
      visRuleTypeForSlotInArea == null &&
      behRuleTypeForSlotInArea == null;
  bool get isQuestAboutAreaInScreenOrSlotInArea =>
      screenWidgetArea != null && visRuleTypeForSlotInArea == null;
  //
  bool get generatesNoQuestions => cascadeType.generatesNoQuestions;
  bool get addsWhichAreaInEachScreenQuestions =>
      cascadeType.addsWhichAreaInEachScreenQuestions;
  bool get addsWhichSlotsOfSelectedAreaQuestions =>
      cascadeType.addsWhichSlotsOfSelectedAreaQuestions;
  bool get addsVisualRuleQuestions => cascadeType.addsVisualRuleQuestions;
  bool get addsBehavioralRuleQuestions =>
      cascadeType.addsBehavioralRuleQuestions;

  // factory QuestionQuantifier.forSearchFilter = QuestionQuantifier.custom;
  factory QuestionQuantifier.forSearchFilter(
    QuestCascadeTyp cascadeType,
    AppScreen appScreen,
    ScreenWidgetArea? screenArea,
    SubWidgetInScreenArea? slotInArea,
    VisualRuleType? visRuleTypeForAreaSlot,
    BehaviorRuleType? behRuleTypeForAreaSlot,
  ) {
    return QuestionQuantifier._(
      cascadeType,
      appScreen,
      screenArea,
      slotInArea,
      visRuleTypeForAreaSlot,
      behRuleTypeForAreaSlot,
    );
  }

  /*  certain questions at top 3 levels (when property answered)
      can generate questions for levels below them
  */

  factory QuestionQuantifier.eventLevel({
    bool addsWhichScreenQuestions = false,
  }) {
    return QuestionQuantifier._(
      addsWhichScreenQuestions
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
    bool addsAreaQuestions = false,
  }) {
    // not in use but here for future
    // these individual "Wanna config this screen?" questions are skipped
    // because the FINAL event-level question above
    // has addsWhichScreenQuestions = true and it does all this work for you
    return QuestionQuantifier._(
      addsAreaQuestions
          ? QuestCascadeTyp.addsWhichAreaInEachScreenQuestions
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
    bool addsSlotQuestions = false,
  }) {
    return QuestionQuantifier._(
      addsSlotQuestions
          ? QuestCascadeTyp.addsWhichPartOfSelectedAreaQuestions
          : QuestCascadeTyp.noCascade,
      appScreen,
      screenArea,
      null,
      null,
      null,
    );
  }

  factory QuestionQuantifier.areaSlotLevel(
    AppScreen appScreen,
    ScreenWidgetArea screenArea,
    SubWidgetInScreenArea slot, {
    bool addsRuleQuestions = false,
  }) {
    return QuestionQuantifier._(
      addsRuleQuestions
          ? QuestCascadeTyp.addsWhichPartOfSelectedAreaQuestions
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
    SubWidgetInScreenArea slot,
    VisualRuleType? visRuleTypeForSlotInArea,
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

  // impl for equatable
  @override
  List<Object> get props => [key];

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