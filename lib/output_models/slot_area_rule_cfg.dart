part of OutputModels;

@JsonSerializable()
class SlotOrAreaRuleCfg {
  //
  VisualRuleType ruleType;
  List<AppVisualRule> rulesForType;
  //
  SlotOrAreaRuleCfg(
    this.ruleType,
    this.rulesForType,
  );

  AppVisualRule ruleByType(VisualRuleType typ) =>
      rulesForType.firstWhere((e) => e.ruleType == typ);

  factory SlotOrAreaRuleCfg.fromQuest(VisualRuleQuestion rQuest) {
    //
    return SlotOrAreaRuleCfg(rQuest.visRuleTypeForAreaOrSlot!, []);
  }

  factory SlotOrAreaRuleCfg.fromJson(Map<String, dynamic> json) =>
      _$SlotOrAreaRuleCfgFromJson(json);

  Map<String, dynamic> toJson() => _$SlotOrAreaRuleCfgToJson(this);
}
