part of QuestionsLib;

@freezed
class QTargetQuantify extends Equatable with _$QTargetQuantify {
  /* describes what a question is about
    it's purpose, behavior and output
    made it equatable to enable searching Q-list
    for filtering and generating new questions reactively
  */

  QTargetQuantify._();

  factory QTargetQuantify(
    QIntentCfg intentCfg,
    UserResponseCascadePatternEm cascadeType,
    AppScreen appScreen,
    ScreenWidgetArea? screenWidgetArea,
    ScreenAreaWidgetSlot? slotInArea,
    VisualRuleType? visRuleTypeForAreaOrSlot,
    BehaviorRuleType? behRuleTypeForAreaOrSlot,
  ) = _QTargetQuantify;

  String get sortKey {
    // makes equatable work for searching & sorting question list
    int screenAreaIdx = 1 + (screenWidgetArea?.index ?? -1);
    int slotInAreaIdx = 1 + (slotInArea?.index ?? -1);
    int visRuleTypeIdx = 1 + (visRuleTypeForAreaOrSlot?.index ?? -1);
    // int behRuleTypeIdx = 1 + (behRuleTypeForAreaOrSlot?.index ?? -1);
    // -$behRuleTypeIdx-${cascadeType.index}
    return '${appScreen.index}-$screenAreaIdx-$slotInAreaIdx-$visRuleTypeIdx';
  }

  // equatableKey must be distinct & unique
  String get equatableKey => sortKey;

  bool get isTopLevelConfigOrScreenQuestion =>
      appScreen == AppScreen.eventConfiguration &&
      screenWidgetArea == null &&
      slotInArea == null &&
      visRuleTypeForAreaOrSlot == null &&
      behRuleTypeForAreaOrSlot == null;

  // bool get isQuestAboutAreaInScreenOrSlotInArea =>
  //     screenWidgetArea != null &&
  //     visRuleTypeForAreaOrSlot == null &&
  //     behRuleTypeForAreaOrSlot == null; // && slotInArea == null
  //
  bool get generatesNoNewQuestions => cascadeType.generatesNoNewQuestions;

  bool get addsWhichAreaInSelectedScreenQuestions =>
      cascadeType.addsWhichAreaInSelectedScreenQuestions;

  bool get addsWhichRulesForSelectedAreaQuestions =>
      cascadeType.addsWhichRulesForSelectedAreaQuestions;

  bool get addsWhichSlotOfSelectedAreaQuestions =>
      cascadeType.addsWhichSlotOfSelectedAreaQuestions;

  bool get addsWhichRulesForSlotsInArea =>
      cascadeType.addsWhichRulesForSlotsInArea;

  bool get addsRuleDetailQuestsForSlotOrArea =>
      cascadeType.addsRuleDetailQuestsForSlotOrArea;

  // bool get addsBehavioralRuleQuestions =>
  //     cascadeType.addsBehavioralRuleQuestions;

  /*  certain questions at top 3 levels (when property answered)
      can generate questions for levels below them
  */

  factory QTargetQuantify.eventLevel({
    bool responseAddsWhichAreaQuestions = false,
  }) {
    /*
      sample question:    for this event:
      'Select the app screens you`d like to configure?',
      when responseAddsWhichAreaQuestions is true
      this answer will build "which area" questions
    */
    return QTargetQuantify(
      QIntentCfg.eventLevel(),
      responseAddsWhichAreaQuestions
          ? UserResponseCascadePatternEm.addsWhichAreaInSelectedScreenQuestions
          : UserResponseCascadePatternEm.noCascade,
      AppScreen.eventConfiguration,
      null,
      null,
      null,
      null,
    );
  }

  factory QTargetQuantify.screenLevel(
    AppScreen appScreen, {
    bool responseAddsWhichRuleAndSlotQuestions = false,
  }) {
    /*
      sample question:
      'For the ${scr.name} screen, select the areas you`d like to configure?',
      when responseAddsWhichRuleAndSlotQuestions is true
      this answer will build "which rule for area" questions
    */
    return QTargetQuantify(
      QIntentCfg.eventLevel(),
      responseAddsWhichRuleAndSlotQuestions
          ? UserResponseCascadePatternEm.addsWhichRulesForSelectedAreaQuestions
          : UserResponseCascadePatternEm.noCascade,
      appScreen,
      null,
      null,
      null,
      null,
    );
  }

  factory QTargetQuantify.areaLevelRules(
    AppScreen appScreen,
    ScreenWidgetArea screenArea,
    VisualRuleType ruleType, {
    bool responseAddsRuleDetailQuests = false,
  }) {
    /*  DG note 4/14/22 -> this constructor was commented and removed previously
          don't remember why or how it's not in use, but I am using it now in tests

    I think this method was deprecated when I switched to sloppy pattern of treating
    Listview rules as slot rules rather than answers under an area level rule

      sample question:
       'Which rules would you like to add to the ${area.name} of ${screen.name}?',
      when responseAddsWhichRuleTypeQuestsForArea is true
      this answer will build "rule detail ?? for area" questions
    */
    return QTargetQuantify(
      QIntentCfg.areaLevelRules(ruleType),
      responseAddsRuleDetailQuests
          ? UserResponseCascadePatternEm.addsRuleDetailQuestsForSlotOrArea
          : UserResponseCascadePatternEm.noCascade,
      appScreen,
      screenArea,
      null,
      ruleType,
      null,
    );
  }

  factory QTargetQuantify.areaLevelSlots(
    AppScreen appScreen,
    ScreenWidgetArea screenArea, {
    bool responseAddsWhichRuleQuestions = false,
  }) {
    /*
      sample question:
      'Which slots/widgets on the ${area.name} of ${screen.name} would you like to configure?',
      when responseAddsWhichRuleQuestions is true
      this answer will build "rule detail ?? for slot" questions
    */
    return QTargetQuantify(
      QIntentCfg.areaLevelSlots(VisualRuleType.topDialogStruct),
      responseAddsWhichRuleQuestions
          ? UserResponseCascadePatternEm.addsWhichRulesForSlotsInArea
          : UserResponseCascadePatternEm.noCascade,
      appScreen,
      screenArea,
      null,
      null,
      null,
    );
  }

  factory QTargetQuantify.ruleLevel(
    AppScreen appScreen,
    ScreenWidgetArea screenArea,
    ScreenAreaWidgetSlot? slot, {
    bool responseAddsRuleDetailQuestions = false,
  }) {
    /*
      sample question:
     'Which rules would you like to add to the ${slotInArea.name} area of ${screenArea.name} on screen ${screen.name}?',
      when responseAddsRuleDetailQuestions is true
      this answer will build "rule detail ?? for slot" questions
    */
    return QTargetQuantify(
      QIntentCfg.ruleLevel(VisualRuleType.topDialogStruct),
      responseAddsRuleDetailQuestions
          ? UserResponseCascadePatternEm.addsRuleDetailQuestsForSlotOrArea
          : UserResponseCascadePatternEm.noCascade,
      appScreen,
      screenArea,
      slot,
      null,
      null,
    );
  }

  factory QTargetQuantify.ruleDetailMultiResponse(
    AppScreen appScreen,
    ScreenWidgetArea screenWidgetArea,
    VisualRuleType? visRuleTypeForSlotInArea,
    // rule level always has screen & area; may have slot
    ScreenAreaWidgetSlot? slot,
    BehaviorRuleType? behRuleTypeForSlotInArea, {
    bool addsMoreRuleQuestions = false,
  }) {
    bool isVisual = visRuleTypeForSlotInArea != null;
    return QTargetQuantify(
      QIntentCfg.ruleDetailMultiResponse(
          visRuleTypeForSlotInArea ?? VisualRuleType.topDialogStruct),
      addsMoreRuleQuestions
          ? (isVisual
              ? UserResponseCascadePatternEm.addsRuleDetailQuestsForSlotOrArea
              : UserResponseCascadePatternEm.addsRuleDetailQuestsForSlotOrArea)
          : UserResponseCascadePatternEm.noCascade,
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
        break;
      case VisualRuleType.sortCfg:
        list.addAll([]);
        break;
      case VisualRuleType.showOrHide:
        list.addAll([]);
        break;
      case VisualRuleType.styleOrFormat:
        list.addAll([]);
        break;
    }

    return list;
  }

  // impl for equatable
  @override
  List<Object> get props => [equatableKey]; // equatableKey

  @override
  bool get stringify => true;
}



  // final QuestCascadeTypEnum cascadeType;
  // final AppScreen appScreen;
  // /* properties below are in ORDER
  // if any property is set (not null)
  // then all properties ABOVE it must also be non-null
  // */
  // final ScreenWidgetArea? screenWidgetArea;
  // final ScreenAreaWidgetSlot? slotInArea;
  // // a rule-type applies to all of:
  // //    appScreen, screenWidgetArea, slotInArea
  // final VisualRuleType? visRuleTypeForAreaOrSlot;
  // final BehaviorRuleType? behRuleTypeForAreaOrSlot;

  // const QuestionQuantifier._(
  //   this.cascadeType,
  //   this.appScreen,
  //   this.screenWidgetArea,
  //   this.slotInArea,
  //   this.visRuleTypeForAreaOrSlot,
  //   this.behRuleTypeForAreaOrSlot,
  // );



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