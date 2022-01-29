part of OutputModels;

@JsonSerializable()
class ScreenAreaCfg {
  // ComponentRules
  ScreenWidgetArea screenArea;
  // area level config rules
  Map<VisualRuleType, SlotOrAreaRuleCfg> visRulesForArea = {};
  // slot level config (rules embedded)
  Map<ScreenAreaWidgetSlot, SlotOrAreaRuleCfg> visConfigBySlotInArea = {};

  ScreenAreaCfg(
    this.screenArea,
  );

  void buildDefaults() {
    // TODO
    for (ScreenAreaWidgetSlot slot in screenArea.applicableWigetSlots) {
      if (!visConfigBySlotInArea.containsKey(slot)) {
        //
        for (VisualRuleType vrt in slot.possibleConfigRules) {
          visConfigBySlotInArea[slot] = SlotOrAreaRuleCfg(vrt, [])
            ..buildDefaults();
        }
      }
    }
  }

  void appendAreaOrSlotRule(VisualRuleQuestion rQuest) {
    //
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

  factory ScreenAreaCfg.fromJson(Map<String, dynamic> json) =>
      _$ScreenAreaCfgFromJson(json);

  Map<String, dynamic> toJson() => _$ScreenAreaCfgToJson(this);
}
