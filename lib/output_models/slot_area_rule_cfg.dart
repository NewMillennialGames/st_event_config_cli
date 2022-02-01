part of OutputModels;

@JsonSerializable()
class SlotOrAreaRuleCfg {
  /*
    this class holds rule definitions
    defined at the area or slot level
    parent container (collection of these instances)
    is how you know scope of "this"
  */
  VisualRuleType _visRuleType;
  List<AppVisualRuleBase> _visRuleList;
  //
  SlotOrAreaRuleCfg(
    this._visRuleType,
    this._visRuleList,
  );

  AppVisualRuleBase ruleByType(VisualRuleType typ) =>
      _visRuleList.firstWhere((e) => e.ruleType == typ);

  factory SlotOrAreaRuleCfg.fromQuest(VisualRuleQuestion rQuest) {
    //
    List<AppVisualRuleBase> vrs = rQuest.asVisualRules();
    return SlotOrAreaRuleCfg(rQuest.visRuleTypeForAreaOrSlot!, vrs);
  }

  void fillMissingWithDefaults() {
    // TODO
    for (VisRuleQuestType rqt in _visRuleType.requiredQuestions) {
      // for (VisRuleQuestType qt in ruleType.questionsRequired)
      int cnt = _visRuleList
          .where((avr) => avr.ruleType.requiredQuestions.contains(rqt))
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
