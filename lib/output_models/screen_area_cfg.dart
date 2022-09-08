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
  void appendAreaOrSlotRule(VisualRuleDetailQuest rQuest) {
    //
    VisualRuleType? vrt = rQuest.visRuleTypeForAreaOrSlot;
    assert(
      vrt != null,
      'VisualRuleType is required at this level',
    );
    //
    ScreenAreaWidgetSlot? optSlotInArea = rQuest.slotInArea;
    _validateRuleIsApplicableForAreaOrSlot(
      rQuest.appScreen,
      vrt!,
      optSlotInArea,
    );

    // ConfigLogger.log(Level.FINER,'\nappendAreaOrSlotRule got:  ${rQuest.questId}');
    // ConfigLogger.log(Level.FINER,'\tArea:  ${rQuest.screenWidgetArea?.name}');
    // ConfigLogger.log(Level.FINER,'\tSlot:  ${optSlotInArea?.name}');
    // ConfigLogger.log(Level.FINER,
    //   '\tfor a ${optSlotInArea == null ? "AREA" : "SLOT"} level rule on VRT: ${vrt.name}',
    // );

    SlotOrAreaRuleCfg cfgForSlotOrArea;
    if (optSlotInArea == null) {
      // this is an area level rule by specific type
      cfgForSlotOrArea = visCfgForArea[vrt] ?? SlotOrAreaRuleCfg([]);
      cfgForSlotOrArea.appendQuestion(rQuest);
      visCfgForArea[vrt] = cfgForSlotOrArea;
      // ConfigLogger.log(Level.FINER,'\t area rule count:  ${visCfgForArea.length} (post add)');
    } else {
      // this is a slot level rule
      Map<ScreenAreaWidgetSlot, SlotOrAreaRuleCfg> slotCfgMap =
          _setAndGetMapForRuleAndSlot(vrt, optSlotInArea);
      slotCfgMap[optSlotInArea]!.appendQuestion(rQuest);
      visCfgForSlotsByRuleType[vrt] = slotCfgMap;
    ConfigLogger.log(Level.INFO, 
        '\t slot rule count:  ${visCfgForSlotsByRuleType.length} (post add)',
      );
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
        tableAreaRules.rulesOfVRType(VisualRuleType.styleOrFormat);
    return lstRules.first as TvRowStyleCfg;
  }

  TvGroupCfg? get groupingRules {
    // what grouping Rules to apply to the TableView
    assert(
      screenArea == ScreenWidgetArea.tableview,
      'method only works for TableVw areas',
    );

    // List<TvGroupCfg> definedGroupRules =
    //     _loadRulesInOrder<TvGroupCfg>(VisualRuleType.groupCfg);
    // int ruleCnt = definedGroupRules.length;
    // if (ruleCnt < 1) return null;

    // TvGroupCfg? gr2 = ruleCnt > 1 ? definedGroupRules[1] : null;
    // TvGroupCfg? gr3 = ruleCnt > 2 ? definedGroupRules[2] : null;
    // return GroupingRules(definedGroupRules.first, gr2, gr3);

    SlotOrAreaRuleCfg? areaSortCfg = visCfgForArea[VisualRuleType.groupCfg];
    if (areaSortCfg == null || areaSortCfg.visRuleList.length < 1) return null;
    return areaSortCfg.ruleForObjType(TvGroupCfg) as TvGroupCfg;
  }

  TvSortCfg? get sortingRules {
    // what sorting Rules to apply to the TableView
    assert(
      screenArea == ScreenWidgetArea.tableview,
      'method only works for TableVw areas',
    );

    SlotOrAreaRuleCfg? areaSortCfg = visCfgForArea[VisualRuleType.sortCfg];
    if (areaSortCfg == null || areaSortCfg.visRuleList.length < 1) return null;

    TvSortCfg? definedSortRules =
        areaSortCfg.ruleForObjType(TvSortCfg) as TvSortCfg;
    // int sortRuleCnt = definedSortRules.fieldList.length;
    // TvSortCfg? gr2 = sortRuleCnt > 1 ? areaSortCfg[1] : null;
    // TvSortCfg? gr3 = sortRuleCnt > 2 ? areaSortCfg[2] : null;
    return definedSortRules;
  }

  TvFilterCfg? get filterRules {
    // what filter Rules to apply to the TableView
    assert(
      screenArea == ScreenWidgetArea.filterBar,
      'method only works within cfg for tableview areas  ${screenArea.name}',
    );

    // var definedFilterRules =
    //     _loadRulesInOrder<TvFilterCfg>(VisualRuleType.filterCfg);
    // int len = definedFilterRules.length;
    // if (len < 1) return null;

    // TvFilterCfg? gr2 = len > 1 ? definedFilterRules[1] : null;
    // TvFilterCfg? gr3 = len > 2 ? definedFilterRules[2] : null;

    SlotOrAreaRuleCfg? areaSortCfg = visCfgForArea[VisualRuleType.filterCfg];
    if (areaSortCfg == null || areaSortCfg.visRuleList.length < 1) {
      //
     ConfigLogger.log(Level.WARNING, 'Warning: defgh');
      ConfigLogger.log(Level.WARNING, '*** areaSortCfg is null: ${areaSortCfg == null}');
    ConfigLogger.log(Level.INFO, 
        '*** areaSortCfg visRuleList: ${areaSortCfg?.visRuleList ?? " na"}',
      );
      return null;
    }
    return areaSortCfg.ruleForObjType(TvFilterCfg) as TvFilterCfg;
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
