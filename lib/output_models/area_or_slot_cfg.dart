part of OutputModels;

@JsonSerializable()
class CfgForAreaAndNestedSlots {
  // Area and Slot Rules
  ScreenWidgetArea screenArea;
  // area level config rules
  Map<VisualRuleType, SlotOrAreaRuleCfg> visRulesForArea = {};
  // slot level config (rules embedded)
  Map<ScreenAreaWidgetSlot, SlotOrAreaRuleCfg> visConfigBySlotInArea = {};

  CfgForAreaAndNestedSlots(
    this.screenArea,
  );

  void _validateRuleAndSlotIsApplicable(
    VisualRuleType rt,
    ScreenAreaWidgetSlot? slot,
  ) {
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
      if (visRulesForArea.containsKey(rt)) continue;
      //
      visRulesForArea[rt] = SlotOrAreaRuleCfg(rt, [])
        ..fillMissingWithDefaults();
    }

    // create missing default rules for SLOTS INSIDE this screen area
    for (ScreenAreaWidgetSlot slot in screenArea.applicableWigetSlots) {
      if (visConfigBySlotInArea.containsKey(slot)) continue;
      //
      for (VisualRuleType vrt in slot.possibleConfigRules) {
        visConfigBySlotInArea[slot] = SlotOrAreaRuleCfg(vrt, [])
          ..fillMissingWithDefaults();
      }
    }
  }

  void appendAreaOrSlotRule(VisualRuleQuestion rQuest) {
    //
    assert(rQuest.visRuleTypeForAreaOrSlot != null,
        'cant add question that has no attached rule');
    //
    _validateRuleAndSlotIsApplicable(
      rQuest.visRuleTypeForAreaOrSlot!,
      rQuest.slotInArea,
    );
    if (rQuest.slotInArea == null) {
      // this is an area level rule
      visRulesForArea[rQuest.visRuleTypeForAreaOrSlot!] =
          SlotOrAreaRuleCfg.fromQuest(rQuest);
    } else {
      // this is a slot level rule
      visConfigBySlotInArea[rQuest.slotInArea!] =
          SlotOrAreaRuleCfg.fromQuest(rQuest);
    }
  }

  // JsonSerializable
  factory CfgForAreaAndNestedSlots.fromJson(Map<String, dynamic> json) =>
      _$ScreenAreaCfgFromJson(json);
  // dont need to fill defaults below
  Map<String, dynamic> toJson() => _$ScreenAreaCfgToJson(this);
}
