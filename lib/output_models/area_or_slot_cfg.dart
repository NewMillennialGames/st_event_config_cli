part of OutputModels;

@JsonSerializable()
class CfgForAreaAndNestedSlots {
  /*
  this Config object encompasses ALL user specified rules
  for all of the screen Areas and Slots
  under one single screen
  the actual rule (stored as value in either
    visCfgForArea or visCfgBySlotInArea)
  is a subclass of RuleResponseBase
  */
  ScreenWidgetArea screenArea;
  // area level config rules
  Map<VisualRuleType, SlotOrAreaRuleCfg> visCfgForArea = {};
  // slot level config (rules embedded)
  Map<ScreenAreaWidgetSlot, SlotOrAreaRuleCfg> visCfgBySlotInArea = {};

  CfgForAreaAndNestedSlots(
    this.screenArea,
  );

  SlotOrAreaRuleCfg areaRuleByRuleType(VisualRuleType typ) =>
      visCfgForArea[typ]!;

  SlotOrAreaRuleCfg slotRulesBySlot(
    ScreenAreaWidgetSlot slot,
  ) =>
      visCfgBySlotInArea[slot]!;

  void _validateRuleAndSlotIsApplicable(
    VisualRuleType rt,
    ScreenAreaWidgetSlot? slot,
  ) {
    // confirm that passed data makes sense in this class
    if (slot != null) {
      assert(screenArea.applicableWigetSlots.contains(slot));
      assert(slot.possibleConfigRules.contains(rt));
    } else {
      assert(screenArea.applicableRuleTypes.contains(rt));
    }
  }

  void fillMissingWithDefaults(AppScreen appScreen) {
    //
    // create missing default rules for this screen area
    for (VisualRuleType rt in screenArea.applicableRuleTypes) {
      if (visCfgForArea.containsKey(rt)) continue;
      //
      visCfgForArea[rt] = SlotOrAreaRuleCfg(rt, [])
        ..fillMissingWithDefaults(appScreen, screenArea, null);
    }

    // create missing default rules for SLOTS INSIDE this screen area
    for (ScreenAreaWidgetSlot slot in screenArea.applicableWigetSlots) {
      if (visCfgBySlotInArea.containsKey(slot)) continue;
      //
      for (VisualRuleType vrt in slot.possibleConfigRules) {
        visCfgBySlotInArea[slot] = SlotOrAreaRuleCfg(vrt, [])
          ..fillMissingWithDefaults(appScreen, screenArea, slot);
      }
    }
  }

  void appendAreaOrSlotRule(VisRuleStyleQuest rQuest) {
    //
    assert(
      rQuest.visRuleTypeForAreaOrSlot != null,
      'cant add question that has no attached rule',
    );
    //
    ScreenAreaWidgetSlot? optSlotInArea = rQuest.slotInArea;
    _validateRuleAndSlotIsApplicable(
      rQuest.visRuleTypeForAreaOrSlot!,
      optSlotInArea,
    );

    SlotOrAreaRuleCfg cfgForSlotOrArea;
    if (optSlotInArea == null) {
      // this is an area level rule by specific type
      cfgForSlotOrArea = visCfgForArea[rQuest.visRuleTypeForAreaOrSlot!] ??
          SlotOrAreaRuleCfg(rQuest.visRuleTypeForAreaOrSlot!, []);
      cfgForSlotOrArea.appendQuestion(rQuest);
      visCfgForArea[rQuest.visRuleTypeForAreaOrSlot!] = cfgForSlotOrArea;
    } else {
      // this is a slot level rule
      cfgForSlotOrArea = visCfgBySlotInArea[optSlotInArea] ??
          SlotOrAreaRuleCfg(rQuest.visRuleTypeForAreaOrSlot!, []);
      cfgForSlotOrArea.appendQuestion(rQuest);
      visCfgBySlotInArea[optSlotInArea] = cfgForSlotOrArea;
    }
  }

  // JsonSerializable
  factory CfgForAreaAndNestedSlots.fromJson(Map<String, dynamic> json) =>
      _$CfgForAreaAndNestedSlotsFromJson(json);
  // dont need to fill defaults below
  Map<String, dynamic> toJson() => _$CfgForAreaAndNestedSlotsToJson(this);
}
