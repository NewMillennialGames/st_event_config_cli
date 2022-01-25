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

  factory SlotOrAreaRuleCfg.fromJson(Map<String, dynamic> json) =>
      _$SlotOrAreaRuleCfgFromJson(json);

  Map<String, dynamic> toJson() => _$SlotOrAreaRuleCfgToJson(this);
}
