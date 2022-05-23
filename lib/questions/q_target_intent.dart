part of QuestionsLib;

@freezed
class QTargetIntent extends Equatable
    with _$QTargetIntent
    implements QuestFactory {
  /* describes what a Question is about
    it's purpose, behavior and intent
    made it equatable to enable searching Q-list
    for filtering and generating new Quest2s reactively
  */

  QTargetIntent._();

  factory QTargetIntent(
    QRespCascadePatternEm cascadeType,
    AppScreen appScreen,
    ScreenWidgetArea? screenWidgetArea, {
    ScreenAreaWidgetSlot? slotInArea,
    VisualRuleType? visRuleTypeForAreaOrSlot,
    BehaviorRuleType? behRuleTypeForAreaOrSlot,
    @Default(false) bool cliConfig,
  }) = _QTargetIntent;

  // IMPORTANT:  impl of QuestFactory
  QuestFactorytSignature get preferredQuestionConstructor {
    /* very important
      returns the factory method required to build
      new auto-derived questions (from user answers)
    */
    if (visRuleTypeForAreaOrSlot != null) {
      return QuestBase.questVisualRule;
    } else if (behRuleTypeForAreaOrSlot != null) {
      return QuestBase.questBehaveRule;
    } else if (cliConfig) {
      return QuestBase.quest1Prompt;
    } else if (slotInArea != null || screenWidgetArea != null) {
      return QuestBase.questMultiPrompt;
    }
    return QuestBase.quest1Prompt;
  }

  QIntentEm get intent {
    // not yet tested
    bool noAppRules =
        visRuleTypeForAreaOrSlot == null && behRuleTypeForAreaOrSlot == null;
    if (noAppRules)
      return cliConfig ? QIntentEm.infoOrCliCfg : QIntentEm.dlogCascade;
    if (visRuleTypeForAreaOrSlot != null) return QIntentEm.visual;
    if (behRuleTypeForAreaOrSlot != null) return QIntentEm.behavioral;
    return QIntentEm.diagnostic;
  }

  QTargetLevelEm get tLevel {
    // not yet tested
    if (appScreen == AppScreen.eventConfiguration)
      return QTargetLevelEm.notAnAppRule;
    if (screenWidgetArea == null) return QTargetLevelEm.screenRule;
    if (slotInArea == null) return QTargetLevelEm.areaRule;
    return QTargetLevelEm.slotRule;
  }

  String get sortKey {
    // makes equatable work for searching & sorting Quest2 list
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
  bool get generatesNoNewQuest2s => cascadeType.generatesNoNewQuest2s;

  bool get addsWhichAreaInSelectedScreenQuest2s =>
      cascadeType.addsWhichAreaInSelectedScreenQuest2s;

  bool get addsWhichRulesForSelectedAreaQuest2s =>
      cascadeType.addsWhichRulesForSelectedAreaQuest2s;

  bool get addsWhichSlotOfSelectedAreaQuest2s =>
      cascadeType.addsWhichSlotOfSelectedAreaQuest2s;

  bool get addsWhichRulesForSlotsInArea =>
      cascadeType.addsWhichRulesForSlotsInArea;

  bool get addsRuleDetailQuestsForSlotOrArea =>
      cascadeType.addsRuleDetailQuestsForSlotOrArea;

  // bool get addsBehavioralRuleQuest2s =>
  //     cascadeType.addsBehavioralRuleQuest2s;

  /*  certain Quest2s at top 3 levels (when property answered)
      can generate Quest2s for levels below them
  */

  factory QTargetIntent.eventLevel({
    bool responseAddsWhichAreaQuestions = false,
  }) {
    /*
      sample Quest2:    for this event:
      'Select the app screens you`d like to configure?',
      when responseAddsWhichAreaQuest2s is true
      this answer will build "which area" Quest2s
    */
    return QTargetIntent(
      // QIntentCfg.eventLevel(),
      responseAddsWhichAreaQuestions
          ? QRespCascadePatternEm.addsWhichAreaInSelectedScreenQuest2s
          : QRespCascadePatternEm.noCascade,
      AppScreen.eventConfiguration,
      null,
    );
  }

  factory QTargetIntent.screenLevel(
    AppScreen appScreen, {
    bool responseAddsWhichRuleAndSlotQuest2s = false,
  }) {
    /*
      sample Quest2:
      'For the ${scr.name} screen, select the areas you`d like to configure?',
      when responseAddsWhichRuleAndSlotQuest2s is true
      this answer will build "which rule for area" Quest2s
    */
    return QTargetIntent(
      // QIntentCfg.eventLevel(),
      responseAddsWhichRuleAndSlotQuest2s
          ? QRespCascadePatternEm.addsWhichRulesForSelectedAreaQuest2s
          : QRespCascadePatternEm.noCascade,
      appScreen,
      null,
    );
  }

  factory QTargetIntent.areaLevelRules(
    AppScreen appScreen,
    ScreenWidgetArea screenArea,
    VisualRuleType ruleType, {
    bool responseAddsRuleDetailQuests = false,
  }) {
    /*  DG note 4/14/22 -> this constructor was commented and removed previously
          don't remember why or how it's not in use, but I am using it now in tests

    I think this method was deprecated when I switched to sloppy pattern of treating
    Listview rules as slot rules rather than answers under an area level rule

      sample Quest2:
       'Which rules would you like to add to the ${area.name} of ${screen.name}?',
      when responseAddsWhichRuleTypeQuestsForArea is true
      this answer will build "rule detail ?? for area" Quest2s
    */
    return QTargetIntent(
      // QIntentCfg.areaLevelRules(ruleType),
      responseAddsRuleDetailQuests
          ? QRespCascadePatternEm.addsRuleDetailQuestsForSlotOrArea
          : QRespCascadePatternEm.noCascade,
      appScreen,
      screenArea,
      visRuleTypeForAreaOrSlot: ruleType,
    );
  }

  factory QTargetIntent.areaLevelSlots(
    AppScreen appScreen,
    ScreenWidgetArea screenArea, {
    bool responseAddsWhichRuleQuest2s = false,
  }) {
    /*
      sample Quest2:
      'Which slots/widgets on the ${area.name} of ${screen.name} would you like to configure?',
      when responseAddsWhichRuleQuest2s is true
      this answer will build "rule detail ?? for slot" Quest2s
    */
    return QTargetIntent(
      // QIntentCfg.areaLevelSlots(VisualRuleType.topDialogStruct),
      responseAddsWhichRuleQuest2s
          ? QRespCascadePatternEm.addsWhichRulesForSlotsInArea
          : QRespCascadePatternEm.noCascade,
      appScreen,
      screenArea,
    );
  }

  factory QTargetIntent.ruleLevel(
    AppScreen appScreen,
    ScreenWidgetArea screenArea,
    ScreenAreaWidgetSlot? slot, {
    bool responseAddsRuleDetailQuest2s = false,
  }) {
    /*
      sample Quest2:
     'Which rules would you like to add to the ${slotInArea.name} area of ${screenArea.name} on screen ${screen.name}?',
      when responseAddsRuleDetailQuest2s is true
      this answer will build "rule detail ?? for slot" Quest2s
    */
    return QTargetIntent(
      // QIntentCfg.ruleLevel(VisualRuleType.topDialogStruct),
      responseAddsRuleDetailQuest2s
          ? QRespCascadePatternEm.addsRuleDetailQuestsForSlotOrArea
          : QRespCascadePatternEm.noCascade,
      appScreen,
      screenArea,
      slotInArea: slot,
    );
  }

  factory QTargetIntent.ruleDetailMultiResponse(
    AppScreen appScreen,
    ScreenWidgetArea screenWidgetArea,
    VisualRuleType? visRuleTypeForSlotInArea,
    // rule level always has screen & area; may have slot
    ScreenAreaWidgetSlot? slot,
    BehaviorRuleType? behRuleTypeForSlotInArea, {
    bool addsMoreRuleQuest2s = false,
  }) {
    bool isVisual = visRuleTypeForSlotInArea != null;
    return QTargetIntent(
      // QIntentCfg.ruleDetailMultiResponse(
      //     visRuleTypeForSlotInArea ?? VisualRuleType.topDialogStruct),
      addsMoreRuleQuest2s
          ? (isVisual
              ? QRespCascadePatternEm.addsRuleDetailQuestsForSlotOrArea
              : QRespCascadePatternEm.addsRuleDetailQuestsForSlotOrArea)
          : QRespCascadePatternEm.noCascade,
      appScreen,
      screenWidgetArea,
      slotInArea: slot,
      visRuleTypeForAreaOrSlot: visRuleTypeForSlotInArea,
      behRuleTypeForAreaOrSlot: behRuleTypeForSlotInArea,
    );
  }

  List<VisualRuleType> relatedSubVisualRules(Quest1Prompt quest) {
    if (!this.generatesNoNewQuest2s) return [];

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

  // const Quest2Quantifier._(
  //   this.cascadeType,
  //   this.appScreen,
  //   this.screenWidgetArea,
  //   this.slotInArea,
  //   this.visRuleTypeForAreaOrSlot,
  //   this.behRuleTypeForAreaOrSlot,
  // );



// below implements local memoize cache

// Map<String, Quest2Quantifier> _qqCache = {};

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

    // Quest2Quantifier qq = Quest2Quantifier._(
    //   cascadeType,
    //   appSection,
    //   uiCompInSection,
    //   visRuleTypeForComp,
    //   behRuleTypeForComp,
    // );
    // store in cache
    // _qqCache[key] = qq;
    // return qq;