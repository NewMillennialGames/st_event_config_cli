part of OutputModels;

@JsonSerializable()
class CfgForAreaAndNestedSlots {
  // Area and Slot Rules
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

  void fillMissingWithDefaults() {
    //
    // create missing default rules for this screen area
    for (VisualRuleType rt in screenArea.applicableRuleTypes) {
      if (visCfgForArea.containsKey(rt)) continue;
      //
      visCfgForArea[rt] = SlotOrAreaRuleCfg(rt, [])..fillMissingWithDefaults();
    }

    // create missing default rules for SLOTS INSIDE this screen area
    for (ScreenAreaWidgetSlot slot in screenArea.applicableWigetSlots) {
      if (visCfgBySlotInArea.containsKey(slot)) continue;
      //
      for (VisualRuleType vrt in slot.possibleConfigRules) {
        visCfgBySlotInArea[slot] = SlotOrAreaRuleCfg(vrt, [])
          ..fillMissingWithDefaults();
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
    ScreenAreaWidgetSlot? slotInArea = rQuest.slotInArea;
    _validateRuleAndSlotIsApplicable(
      rQuest.visRuleTypeForAreaOrSlot!,
      slotInArea,
    );
    if (slotInArea == null) {
      // this is an area level rule
      visCfgForArea[rQuest.visRuleTypeForAreaOrSlot!] =
          SlotOrAreaRuleCfg.fromQuest(rQuest);
    } else {
      // this is a slot level rule
      visCfgBySlotInArea[slotInArea] = SlotOrAreaRuleCfg.fromQuest(rQuest);
    }
  }

  // JsonSerializable
  factory CfgForAreaAndNestedSlots.fromJson(Map<String, dynamic> json) =>
      _$CfgForAreaAndNestedSlotsFromJson(json);
  // dont need to fill defaults below
  Map<String, dynamic> toJson() => _$CfgForAreaAndNestedSlotsToJson(this);
}
