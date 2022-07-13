part of QuestionsLib;

typedef IntRange = Tuple2<int, int>;

enum TargetPrecision {
  // describes the INTENT of a QTargetResolution instance
  // QTargetResolution instance is embedded in a
  // QuestBase instance; so this describes the query intent
  // of that enclosing question; what info is asked of our user
  eventLevel,
  screenLevel,
  targetLevel,
  ruleSelect,
  rulePrep,
  ruleDetailVisual,
  ruleDetailBehavior,
}

extension TargetPrecisionExt1 on TargetPrecision {
  //
  bool get targetComplete => this.index >= TargetPrecision.ruleSelect.index;

  bool get isPartOfTargetCompletionQuestion =>
      this == TargetPrecision.targetLevel;

  QuestFactorytSignature get enclosingNewQuestSignature {
    /*
    provides method to create a new question which
    will wrap the enclosing QTargetResolution
    creates the type of question that should WRAP QTR instance
    not the type of a DERIVED question

  currently only used in testing
    */
    switch (this) {
      case TargetPrecision.eventLevel:
        return QuestBase.eventLevelCfgQuest;
      case TargetPrecision.screenLevel:
        return QuestBase.regionTargetQuest;
      case TargetPrecision.targetLevel:
        return QuestBase.regionTargetQuest;
      case TargetPrecision.ruleSelect:
        return QuestBase.ruleSelectQuest;
      case TargetPrecision.rulePrep:
        return QuestBase.rulePrepQuest;
      case TargetPrecision.ruleDetailVisual:
        return QuestBase.visualRuleDetailQuest;
      case TargetPrecision.ruleDetailBehavior:
        return QuestBase.behaveRuleDetailQuest;
    }
  }

  QuestFactorytSignature get derivedNewQuestSignature {
    // returns constructor for DERIVED question of this
    // enclosing QTargetResolution
    TargetPrecision nextTp = TargetPrecision.values[this.index + 1];
    return nextTp.enclosingNewQuestSignature;
  }
}

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
    @Default(TargetPrecision.eventLevel) TargetPrecision precision,
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
    int precisionScore = precision.index * _weightForTargetEnumIdx(precision);
    int visRuleScore = ((visRuleTypeForAreaOrSlot?.index ?? -1) + 1) *
        _weightForTargetEnumIdx(visRuleTypeForAreaOrSlot);
    int behRuleScore = ((behRuleTypeForAreaOrSlot?.index ?? -1) + 1) *
        _weightForTargetEnumIdx(behRuleTypeForAreaOrSlot);

    // return a priority weighted sort order that should keep
    // all questions in reasonable order
    return screenScore +
        areaScore +
        slotScore +
        precisionScore +
        visRuleScore +
        behRuleScore;
  }

  IntRange get userRespCountRangeForTest {
    /*  only for testing
      return range 1 to max possible answers user could
      select for prompt #1 of this question
      ==
      reasonable # of auto-answers for test framework to generate

      # of answers on TOP-LEVEL (first) prompt
      generally dictates HOW MANY derived questions will
      be generated
    */
    switch (precision) {
      case TargetPrecision.eventLevel:
        return IntRange(1, 1);
      case TargetPrecision.screenLevel:
        return IntRange(
          1,
          AppScreen.eventConfiguration.topConfigurableScreens.length,
        );
      case TargetPrecision.targetLevel:
        int subTargetChoiceCnt = this._possibleTargetSubChoices.length;
        return IntRange(subTargetChoiceCnt > 0 ? 1 : 0, subTargetChoiceCnt);

      // int curTargetRuleCnt = this.possibleRulesAtAnyTarget.length;
      // int tot = subTargetChoiceCnt + curTargetRuleCnt;
      // return IntRange(tot > 0 ? 1 : 0, tot);

      case TargetPrecision.ruleSelect:
        return IntRange(1, possibleRulesAtAnyTarget.length);
      case TargetPrecision.rulePrep:
        // asking answer count;  not prompt count:  visRuleTypeForAreaOrSlot!.requPrepQuests.length
        return IntRange(1, 1);

      // below here DO NOT produce derived questions
      case TargetPrecision.ruleDetailVisual:
        return IntRange(
          1,
          visRuleTypeForAreaOrSlot!.requRuleDetailCfgQuests.length,
        );
      case TargetPrecision.ruleDetailBehavior:
        return IntRange(1, 1);
    }
  }

  Iterable<dynamic> get _possibleTargetSubChoices {
    // only valid when precision == TargetPrecision.targetLevel
    // aka NO RULE SET yet
    assert(
      isPartOfTargetCompletionQuestion,
      'reading from an invalid instance',
    );
    // Iterable<dynamic> lst = [];
    if (screenWidgetArea == null) return possibleAreasForScreen;
    if (slotInArea == null) return possibleSlotsForAreaInScreen;
    // if (visRuleTypeForAreaOrSlot == null) return possibleRulesAtAnyTarget;
    // if (behRuleTypeForAreaOrSlot == null) return possibleRulesAtAnyTarget;
    return [1];
  }

  // Iterable<dynamic> get _possibleRuleChoices {
  //   // only valid when precision == TargetPrecision.targetLevel
  //   // aka NO RULE SET yet
  //   assert(
  //     isPartOfTargetCompletionQuestion,
  //     'reading from an invalid instance',
  //   );
  //   if (screenWidgetArea == null) return possibleRulesForAreaInScreen;
  //   if (slotInArea == null) return possibleRulesForSlotInAreaOfScreen;
  //   return [1];
  // }

  QuestFactorytSignature get derivedNewQuestSignature =>
      precision.derivedNewQuestSignature;

  bool get isPartOfTargetCompletionQuestion =>
      precision.isPartOfTargetCompletionQuestion;
  bool get targetComplete => precision.targetComplete || slotInArea != null;
  String get targetPath {
    // describes section of the app that
    // that enclosing question pertains to
    String screenName = appScreen.name;
    String? area = screenWidgetArea?.name;
    String? slot = slotInArea?.name;
    bool hasRule = visRuleTypeForAreaOrSlot != null;
    String visRuleName = visRuleTypeForAreaOrSlot?.name ?? '';

    String intentName = '-' + precision.name;
    if (area == null) return screenName + intentName;
    if (slot == null)
      return screenName +
          '-' +
          area +
          (hasRule ? '-$visRuleName' : '') +
          intentName;
    if (!hasRule) return screenName + '-' + area + '-' + slot + intentName;
    return screenName +
        '-' +
        area +
        '-' +
        slot +
        '-' +
        visRuleName +
        intentName;
  }

  bool get isTopLevelEventConfigQuestion =>
      appScreen == AppScreen.eventConfiguration &&
      screenWidgetArea == null &&
      slotInArea == null &&
      visRuleTypeForAreaOrSlot == null &&
      behRuleTypeForAreaOrSlot == null;

  bool get _targetRequiresRulePrepQuestion =>
      (screenWidgetArea?.requiresPrepQuestion ?? false) ||
      (slotInArea?.requiresPrepQuestion ?? false);

  bool get requiresVisRulePrepQuestion =>
      _targetRequiresRulePrepQuestion ||
      (visRuleTypeForAreaOrSlot?.requiresVisRulePrepQuestion ?? false);

  bool get requiresBehRulePrepQuestion =>
      _targetRequiresRulePrepQuestion ||
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

  List<VisualRuleType> get possibleRulesAtAnyTarget {
    if (slotInArea != null) return possibleRulesForSlotInAreaOfScreen;
    return possibleRulesForAreaInScreen;
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
      precision: TargetPrecision.eventLevel,
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
      screenArea,
      slotInArea: slot,
      precision: TargetPrecision.targetLevel,
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
      precision: TargetPrecision.ruleSelect,
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
      precision: TargetPrecision.rulePrep,
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
      precision: TargetPrecision.ruleDetailVisual,
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
      precision: TargetPrecision.ruleDetailBehavior,
    );
  }

  QuestFactorytSignature get newQuestSignatureForWrapThisInTest {
    /*     for test only
    returns constructor
    to use when creating a question to contain THIS
    (not a derived question)
    called from permutations_test

    */
    return precision.enclosingNewQuestSignature;
  }

  static int _weightForTargetEnumIdx(dynamic targetEnum) {
    /* allows weighting each QTargetIntent
    by an integer to allow proper sorting
    as new questions are added
  */
    if (targetEnum == null) {
      return 0;
    } else if (targetEnum is AppScreen) {
      return 64;
      // 32 reserved for spacing
    } else if (targetEnum is ScreenWidgetArea) {
      return 16;
    } else if (targetEnum is ScreenAreaWidgetSlot) {
      return 8;
    } else if (targetEnum is TargetPrecision) {
      // 4 reserved for precision score
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
