part of OutputModels;

@JsonSerializable()
class SlotOrAreaRuleCfg {
  /*
    this class holds rule definitions
    defined at the area or slot level
    parent container (collection of these instances)
    is how you know scope of "this"
  */
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

  void fillMissingWithDefaults() {
    // TODO
    for (VisRuleQuestType rqt in ruleType.questionsRequired) {
      // for (VisRuleQuestType qt in ruleType.questionsRequired)
      int cnt = rulesForType
          .where((avr) => avr.ruleType.questionsRequired.contains(rqt))
          .length;
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
