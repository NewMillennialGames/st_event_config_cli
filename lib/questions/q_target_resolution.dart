part of QuestionsLib;

@freezed
class QTargetResolution extends Equatable with _$QTargetResolution {
  /* describes what a Question pertains to
    it's target (area or area-slot of a screen)
    and general intent

    a QuestMatcher and a DerivedQuestGenerator
    might receive this question along with user answer
    interpret that answer (after type conversion),
    and GENERATE derived questions

        made it equatable to enable searching Q-list
    for filtering and generating new Questions reactively

    targetComplete means
    that this question is ready for rule-selection
    does not need more target details
    this helps the question generation system
    decide which factory constructor method to
    use for derived (generated) questions
  */

  QTargetResolution._();

  factory QTargetResolution(
    AppScreen appScreen,
    ScreenWidgetArea? screenWidgetArea, {
    ScreenAreaWidgetSlot? slotInArea,
    VisualRuleType? visRuleTypeForAreaOrSlot,
    BehaviorRuleType? behRuleTypeForAreaOrSlot,
    @Default(false) bool targetComplete,
  }) = _QTargetResolution;

  int get targetSortIndex {
    /* used to sort all questions
      in to proper order for group

      math below prevents negative score
      returns binary int so less specific question
      appear before derived questions ABOUT the less
      specific question
    */
    int screenScore =
        (appScreen.index + 1) * _weightForTargetEnumIdx(appScreen);
    int areaScore = ((screenWidgetArea?.index ?? -1) + 1) *
        _weightForTargetEnumIdx(screenWidgetArea);
    int slotScore =
        ((slotInArea?.index ?? -1) + 1) * _weightForTargetEnumIdx(slotInArea);
    int visRuleScore = ((visRuleTypeForAreaOrSlot?.index ?? -1) + 1) *
        _weightForTargetEnumIdx(visRuleTypeForAreaOrSlot);
    int behRuleScore = ((behRuleTypeForAreaOrSlot?.index ?? -1) + 1) *
        _weightForTargetEnumIdx(behRuleTypeForAreaOrSlot);
    // return a priority weighted sort order that should keep
    // all questions in reasonable order
    return screenScore + areaScore + slotScore + visRuleScore + behRuleScore;
  }

  String get targetPath {
    // describes section of the app that
    // that enclosing question pertains to
    String screenName = appScreen.name;
    String? area = screenWidgetArea?.name;
    String? slot = slotInArea?.name;
    String? visRuleName = visRuleTypeForAreaOrSlot?.name;
    bool hasRule = visRuleName != null;

    if (area == null) return screenName;
    if (slot == null)
      return screenName + '-' + area + (hasRule ? '-$visRuleName' : '');
    if (!hasRule) return screenName + '-' + area + '-' + slot;
    return screenName + '-' + area + '-' + slot + '-' + visRuleName;
  }

  bool get isTopLevelEventConfigQuestion =>
      appScreen == AppScreen.eventConfiguration &&
      screenWidgetArea == null &&
      slotInArea == null &&
      visRuleTypeForAreaOrSlot == null &&
      behRuleTypeForAreaOrSlot == null;

  bool get _requiresRulePrepQuestion =>
      (screenWidgetArea?.requiresPrepQuestion ?? false) ||
      (slotInArea?.requiresPrepQuestion ?? false);

  bool get requiresVisRulePrepQuestion =>
      _requiresRulePrepQuestion ||
      (visRuleTypeForAreaOrSlot?.requiresVisRulePrepQuestion ?? false);

  bool get requiresBehRulePrepQuestion =>
      _requiresRulePrepQuestion ||
      (behRuleTypeForAreaOrSlot?.requiresRulePrepQuestion ?? false);

  List<ScreenWidgetArea> get possibleAreasForScreen =>
      appScreen.configurableScreenAreas;

  List<VisualRuleType> get possibleRulesForAreaInScreen {
    if (screenWidgetArea == null) return [];
    return screenWidgetArea!.applicableRuleTypes(appScreen);
  }

  List<ScreenAreaWidgetSlot> get possibleSlotsForAreaInScreen {
    if (screenWidgetArea == null) return [];
    return screenWidgetArea!.applicableWigetSlots(appScreen);
  }

  List<VisualRuleType> get possibleRulesForSlotInAreaOfScreen {
    if (screenWidgetArea == null || slotInArea == null) return [];
    return slotInArea!.possibleConfigRules(screenWidgetArea!);
  }

  List<Enum> get possibleVisCompStylesForTarget {
    // component styles for a target area/slot

    if (!targetComplete) {
      print(
        'err:  possibleVisCompStylesForTarget called on incomplete QTargResolution (area or area/slot should be set)',
      );
      return [];
    }

    if (slotInArea != null)
      return slotInArea!.possibleVisualStyles(appScreen, screenWidgetArea!);
    return screenWidgetArea!.possibleVisualStyles(appScreen);
  }

  // equatableKey must be distinct & unique
  String get equatableKey {
    // makes equatable work for searching & sorting Quest2 list
    int screenAreaIdx = 1 + (screenWidgetArea?.index ?? -1);
    int slotInAreaIdx = 1 + (slotInArea?.index ?? -1);
    int visRuleTypeIdx = 1 + (visRuleTypeForAreaOrSlot?.index ?? -1);
    // int behRuleTypeIdx = 1 + (behRuleTypeForAreaOrSlot?.index ?? -1);
    // -$behRuleTypeIdx-${cascadeType.index}
    return '${appScreen.index}-$screenAreaIdx-$slotInAreaIdx-$visRuleTypeIdx';
  }

  /*  certain Questions at top 3 levels (when property answered)
      can generate Quest2s for levels below them
  */

  factory QTargetResolution.forEvent() {
    /*
      sample Question:    for this event:
      'Select the app screens you`d like to configure?',
      when responseAddsWhichAreaQuestions is true
      this answer will build "which area" Quest2s
    */
    return QTargetResolution(
      AppScreen.eventConfiguration,
      null,
    );
  }

  factory QTargetResolution.forTargetting(
    AppScreen appScreen,
    ScreenWidgetArea? screenArea,
    ScreenAreaWidgetSlot? slot,
  ) {
    /*
      sample Question:
      'For the ${scr.name} screen, select the areas you`d like to configure?',
      when responseAddsWhichRuleAndSlotQuest2s is true
      this answer will build "which rule for area" Quest2s
    */
    return QTargetResolution(
      appScreen,
      null,
    );
  }

  factory QTargetResolution.forRuleSelection(
    AppScreen appScreen,
    ScreenWidgetArea screenArea,
    ScreenAreaWidgetSlot? slot,
    // VisualRuleType ruleType,
  ) {
    /*  DG note 4/14/22 -> this constructor was commented and removed previously
          don't remember why or how it's not in use, but I am using it now in tests

    I think this method was deprecated when I switched to sloppy pattern of treating
    Listview rules as slot rules rather than answers under an area level rule

      sample Question:
       'Which rules would you like to add to the ${area.name} of ${screen.name}?',
      when responseAddsWhichRuleTypeQuestsForArea is true
      this answer will build "rule detail ?? for area" Quest2s
    */
    return QTargetResolution(
      appScreen,
      screenArea,
      slotInArea: slot,
      targetComplete: true,
    );
  }

  factory QTargetResolution.forVisRulePrep(
    AppScreen appScreen,
    ScreenWidgetArea screenArea,
    ScreenAreaWidgetSlot? slot,
    VisualRuleType ruleType,
  ) {
    /*  DG note 4/14/22 -> this constructor was commented and removed previously
          don't remember why or how it's not in use, but I am using it now in tests

    I think this method was deprecated when I switched to sloppy pattern of treating
    Listview rules as slot rules rather than answers under an area level rule

      sample Question:
       'Which rules would you like to add to the ${area.name} of ${screen.name}?',
      when responseAddsWhichRuleTypeQuestsForArea is true
      this answer will build "rule detail ?? for area" Quest2s
    */
    return QTargetResolution(
      appScreen,
      screenArea,
      slotInArea: slot,
      visRuleTypeForAreaOrSlot: ruleType,
      targetComplete: true,
    );
  }

  // factory QTargetResolution.areaLevelSlots(
  //   AppScreen appScreen,
  //   ScreenWidgetArea screenArea,
  // ) {
  //   /*
  //     sample Question:
  //     'Which slots/widgets on the ${area.name} of ${screen.name} would you like to configure?',
  //     when responseAddsWhichRuleQuest2s is true
  //     this answer will build "rule detail ?? for slot" Quest2s
  //   */
  //   return QTargetResolution(
  //     appScreen,
  //     screenArea,
  //   );
  // }

  factory QTargetResolution.forVisRuleDetail(
    AppScreen appScreen,
    ScreenWidgetArea screenArea,
    ScreenAreaWidgetSlot? slot,
    VisualRuleType visRuleType,
  ) {
    /*
      sample Question:
     'Which rules would you like to add to the ${slotInArea.name} area of ${screenArea.name} on screen ${screen.name}?',
      when responseAddsRuleDetailQuest2s is true
      this answer will build "rule detail ?? for slot" Quest2s
    */
    return QTargetResolution(
      appScreen,
      screenArea,
      slotInArea: slot,
      visRuleTypeForAreaOrSlot: visRuleType,
      targetComplete: true,
    );
  }

  factory QTargetResolution.forBehRuleDetail(
    AppScreen appScreen,
    ScreenWidgetArea screenArea,
    ScreenAreaWidgetSlot? slot,
    BehaviorRuleType behRuleType,
  ) {
    /*
      sample Question:
     'Which rules would you like to add to the ${slotInArea.name} area of ${screenArea.name} on screen ${screen.name}?',
      when responseAddsRuleDetailQuest2s is true
      this answer will build "rule detail ?? for slot" Quest2s
    */
    return QTargetResolution(
      appScreen,
      screenArea,
      slotInArea: slot,
      behRuleTypeForAreaOrSlot: behRuleType,
      targetComplete: true,
    );
  }

  static int _weightForTargetEnumIdx(dynamic targetEnum) {
    /* allows weighting each QTargetIntent
    by an integer to allow proper sorting
    as new questions are added
  */
    if (targetEnum == null) {
      return 0;
    } else if (targetEnum is AppScreen) {
      return 16;
    } else if (targetEnum is ScreenWidgetArea) {
      return 8;
    } else if (targetEnum is ScreenAreaWidgetSlot) {
      return 4;
    } else if (targetEnum is VisualRuleType) {
      return 2;
    } else if (targetEnum is BehaviorRuleType) {
      return 1;
    }
    return 0;
  }

  // impl for equatable
  @override
  List<Object> get props => [equatableKey]; // equatableKey

  @override
  bool get stringify => true;
}




  // factory QTargetResolution.ruleDetailMultiResponse(
  //   AppScreen appScreen,
  //   ScreenWidgetArea screenWidgetArea,
  //   VisualRuleType? visRuleTypeForSlotInArea,
  //   // rule level always has screen & area; may have slot
  //   ScreenAreaWidgetSlot? slot,
  //   BehaviorRuleType? behRuleTypeForSlotInArea,
  // ) {
  //   // bool isVisual = visRuleTypeForSlotInArea != null;
  //   return QTargetResolution(
  //     appScreen,
  //     screenWidgetArea,
  //     slotInArea: slot,
  //     visRuleTypeForAreaOrSlot: visRuleTypeForSlotInArea,
  //     behRuleTypeForAreaOrSlot: behRuleTypeForSlotInArea,
  //   );
  // }

  // List<VisualRuleType> relatedSubVisualRules(RegionTargetQuest quest) {
  //   if (!this.generatesNoNewQuestions) return [];

  //   List<VisualRuleType> list = [];
  //   switch (this.visRuleTypeForAreaOrSlot!) {
  //     case VisualRuleType.filterCfg:
  //       list.addAll([]);
  //       break;
  //     case VisualRuleType.sortCfg:
  //       list.addAll([]);
  //       break;
  //     case VisualRuleType.showOrHide:
  //       list.addAll([]);
  //       break;
  //     case VisualRuleType.styleOrFormat:
  //       list.addAll([]);
  //       break;
  //   }

  //   return list;
  // }