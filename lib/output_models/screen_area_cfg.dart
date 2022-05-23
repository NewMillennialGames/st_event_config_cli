part of OutputModels;

@JsonSerializable()
class CfgForAreaAndNestedSlots {
  /*
  this Config object encompasses ALL user specified rules
  for one Area and it's child Slots
  under one single screen

  for example:  the TableView on AppScreen

  the actual rule (stored as value in either
    visCfgForArea or visCfgForSlotsByRuleType)
  is a subclass of RuleResponseBase
  */
  ScreenWidgetArea screenArea;
  // area level config rules
  Map<VisualRuleType, SlotOrAreaRuleCfg> visCfgForArea;
  // slot level config (rules embedded)
  Map<VisualRuleType, Map<ScreenAreaWidgetSlot, SlotOrAreaRuleCfg>>
      visCfgForSlotsByRuleType;

  CfgForAreaAndNestedSlots(
    this.screenArea,
    this.visCfgForArea,
    this.visCfgForSlotsByRuleType,
  );

  SlotOrAreaRuleCfg areaRulesByRuleType(VisualRuleType typ) =>
      visCfgForArea[typ]!;

  bool isMissingRuleTyp(VisualRuleType typ) => visCfgForArea[typ] == null;

  //add rules to this object
  void appendAreaOrSlotRule(QuestVisualRule rQuest) {
    //
    VisualRuleType? vrt = rQuest.visRuleTypeForAreaOrSlot;
    assert(
      vrt != null,
      'cant add Quest2 that has no attached rule',
    );
    //
    ScreenAreaWidgetSlot? optSlotInArea = rQuest.slotInArea;
    _validateRuleIsApplicableForAreaOrSlot(
      rQuest.appScreen,
      vrt!,
      optSlotInArea,
    );

    SlotOrAreaRuleCfg cfgForSlotOrArea;
    if (optSlotInArea == null) {
      // this is an area level rule by specific type
      cfgForSlotOrArea = visCfgForArea[vrt] ?? SlotOrAreaRuleCfg([]);
      cfgForSlotOrArea.appendQuestion(rQuest);
      visCfgForArea[vrt] = cfgForSlotOrArea;
    } else {
      // this is a slot level rule
      Map<ScreenAreaWidgetSlot, SlotOrAreaRuleCfg> slotCfgMap =
          _setAndGetMapForRuleAndSlot(vrt, optSlotInArea);
      slotCfgMap[optSlotInArea]!.appendQuestion(rQuest);
      visCfgForSlotsByRuleType[vrt] = slotCfgMap;
    }
  }

  TvRowStyleCfg get rowStyleCfg {
    // what row style to apply to the TableView
    assert(
      screenArea == ScreenWidgetArea.tableview,
      'method only works for TableVw areas',
    );
    SlotOrAreaRuleCfg tableAreaRules =
        this.areaRulesByRuleType(VisualRuleType.styleOrFormat);
    List<RuleResponseBase> lstRules =
        tableAreaRules.rulesOfType(VisualRuleType.styleOrFormat);
    return lstRules.first as TvRowStyleCfg;
  }

  GroupingRules? get groupingRules {
    // what grouping Rules to apply to the TableView
    assert(
      screenArea == ScreenWidgetArea.tableview,
      'method only works for TableVw areas',
    );

    List<TvGroupCfg> definedGroupRules =
        _loadRulesInOrder<TvGroupCfg>(VisualRuleType.groupCfg);
    int ruleCnt = definedGroupRules.length;
    if (ruleCnt < 1) return null;

    TvGroupCfg? gr2 = ruleCnt > 1 ? definedGroupRules[1] : null;
    TvGroupCfg? gr3 = ruleCnt > 2 ? definedGroupRules[2] : null;
    return GroupingRules(definedGroupRules.first, gr2, gr3);
  }

  SortingRules? get sortingRules {
    // what sorting Rules to apply to the TableView
    assert(
      screenArea == ScreenWidgetArea.tableview,
      'method only works for TableVw areas',
    );

    List<TvSortCfg> definedSortRules =
        _loadRulesInOrder<TvSortCfg>(VisualRuleType.sortCfg);
    int sortRuleCnt = definedSortRules.length;
    if (sortRuleCnt < 1) return null;

    TvSortCfg? gr2 = sortRuleCnt > 1 ? definedSortRules[1] : null;
    TvSortCfg? gr3 = sortRuleCnt > 2 ? definedSortRules[2] : null;
    return SortingRules(definedSortRules.first, gr2, gr3);
  }

  FilterRules? get filterRules {
    // what filter Rules to apply to the TableView
    assert(
      screenArea == ScreenWidgetArea.filterBar,
      'method only works for filterBar areas',
    );

    var definedFilterRules =
        _loadRulesInOrder<TvFilterCfg>(VisualRuleType.filterCfg);
    int len = definedFilterRules.length;
    if (len < 1) return null;

    TvFilterCfg? gr2 = len > 1 ? definedFilterRules[1] : null;
    TvFilterCfg? gr3 = len > 2 ? definedFilterRules[2] : null;
    return FilterRules(definedFilterRules.first, gr2, gr3);
  }

  // ********

  Map<ScreenAreaWidgetSlot, SlotOrAreaRuleCfg> _allRulesForTypeInSlots(
    VisualRuleType typ,
    List<ScreenAreaWidgetSlot> slots,
  ) {
    // get all rules of a given type in related slots
    // eg all sort or filter rules
    Map<ScreenAreaWidgetSlot, SlotOrAreaRuleCfg> ruleCfgCopy =
        Map.from(visCfgForSlotsByRuleType[typ]!);
    ruleCfgCopy.removeWhere((slot, ruleCfg) => !slots.contains(slot));
    return ruleCfgCopy;
  }

  List<SlotOrAreaRuleCfg> _slotRuleCollectionInOrder(
    VisualRuleType typ,
    List<ScreenAreaWidgetSlot> slots,
  ) {
    // takes response from _allRulesForTypeInSlots and sorts it
    Map<ScreenAreaWidgetSlot, SlotOrAreaRuleCfg> ruleCfgBySlot =
        _allRulesForTypeInSlots(typ, slots);
    if (ruleCfgBySlot.length < 1) return [];

    List<ScreenAreaWidgetSlot> slotsSorted = (ruleCfgBySlot.keys.toList())
      ..sort((ws1, ws2) => ws1.index.compareTo(ws2.index));

    List<SlotOrAreaRuleCfg> orderedRuleCfg = [];
    for (ScreenAreaWidgetSlot ws in slotsSorted) {
      orderedRuleCfg.add(ruleCfgBySlot[ws]!);
    }
    return orderedRuleCfg;
  }

  List<CastType> _loadRulesInOrder<CastType>(VisualRuleType ruleType) {
    List<SlotOrAreaRuleCfg> ruleByPos = _slotRuleCollectionInOrder(
      ruleType,
      [
        ScreenAreaWidgetSlot.slot1,
        ScreenAreaWidgetSlot.slot2,
        ScreenAreaWidgetSlot.slot3,
      ],
    );

    int sortRuleCnt = ruleByPos.length;
    if (sortRuleCnt < 1 || ruleByPos[0].visRuleList.length < 1) return [];

    List<CastType> definedSortRules = [
      ruleByPos[0].visRuleList.where((e) => e.ruleType == ruleType).first
          as CastType,
      if (sortRuleCnt > 1)
        ruleByPos[1].visRuleList.where((e) => e.ruleType == ruleType).first
            as CastType,
      if (sortRuleCnt > 2)
        ruleByPos[2].visRuleList.where((e) => e.ruleType == ruleType).first
            as CastType,
    ];
    return definedSortRules;
  }

  void _validateRuleIsApplicableForAreaOrSlot(
    AppScreen appScreen,
    VisualRuleType rt,
    ScreenAreaWidgetSlot? slot,
  ) {
    // confirm that passed data makes sense in this class
    if (slot != null) {
      assert(screenArea.applicableWigetSlots(appScreen).contains(slot));
      assert(slot.possibleConfigRules(screenArea).contains(rt));
    } else {
      assert(screenArea.applicableRuleTypes(appScreen).contains(rt));
    }
  }

  Map<ScreenAreaWidgetSlot, SlotOrAreaRuleCfg> _setAndGetMapForRuleAndSlot(
    VisualRuleType vrt,
    ScreenAreaWidgetSlot slot,
  ) {
    //
    Map<ScreenAreaWidgetSlot, SlotOrAreaRuleCfg>? slotMap =
        visCfgForSlotsByRuleType[vrt];
    if (slotMap != null) {
      if (slotMap.containsKey(slot)) return slotMap;
      slotMap[slot] = SlotOrAreaRuleCfg([]);
      return slotMap;
    }

    visCfgForSlotsByRuleType[vrt] = <ScreenAreaWidgetSlot, SlotOrAreaRuleCfg>{
      slot: SlotOrAreaRuleCfg([])
    };
    return visCfgForSlotsByRuleType[vrt]!;
  }

  void fillMissingWithDefaults(AppScreen appScreen) {
    //
    // create missing default rules for this screen area
    for (VisualRuleType rt in screenArea.applicableRuleTypes(appScreen)) {
      if (visCfgForArea.containsKey(rt)) continue;
      //
      visCfgForArea[rt] = SlotOrAreaRuleCfg([])
        ..fillMissingWithDefaults(appScreen, screenArea, null);
    }

    // create missing default rules for SLOTS INSIDE this screen area
    for (ScreenAreaWidgetSlot slot
        in screenArea.applicableWigetSlots(appScreen)) {
      // if (visCfgForSlotsByRuleType.containsKey(slot)) continue;
      //
      for (VisualRuleType vrt in slot.possibleConfigRules(screenArea)) {
        Map<ScreenAreaWidgetSlot, SlotOrAreaRuleCfg> slotCfg =
            _setAndGetMapForRuleAndSlot(vrt, slot);

        slotCfg[slot]!.fillMissingWithDefaults(appScreen, screenArea, slot);
      }
    }
  }

  // JsonSerializable
  factory CfgForAreaAndNestedSlots.fromJson(Map<String, dynamic> json) =>
      _$CfgForAreaAndNestedSlotsFromJson(json);
  // dont need to fill defaults below
  Map<String, dynamic> toJson() => _$CfgForAreaAndNestedSlotsToJson(this);
}
