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

  void buildDefaults() {
    // TODO
    for (VisRuleQuestType rqt in ruleType.questionsRequired) {
      int cnt = rulesForType.where((e) => e.ruleType == rqt).length;
      if (cnt < 1) {
        //

      }
    }
  }

  // JsonSerializable
  factory SlotOrAreaRuleCfg.fromJson(Map<String, dynamic> json) =>
      _$SlotOrAreaRuleCfgFromJson(json);

  Map<String, dynamic> toJson() => _$SlotOrAreaRuleCfgToJson(this);
}
