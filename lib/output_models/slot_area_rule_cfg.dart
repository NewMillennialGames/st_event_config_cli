part of OutputModels;

@JsonSerializable()
class SlotOrAreaRuleCfg {
  /*
    this class holds rule definitions
    defined at the area or slot level
    parent container (collection of these instances)
    is how you know scope of "this"
  */
  VisualRuleType visRuleType;
  List<RuleResponseBase> visRuleList;
  //
  SlotOrAreaRuleCfg(
    this.visRuleType,
    this.visRuleList,
  );

  RuleResponseBase ruleByType(VisualRuleType typ) =>
      visRuleList.firstWhere((e) => e.ruleType == typ);

  GroupingRules? get groupingRules {
    List<TvSortCfg> definedGroupRules = visRuleList
        .whereType<TvSortCfg>()
        .where((e) => e.ruleType == VisualRuleType.groupCfg)
        .toList();

    int len = definedGroupRules.length;
    if (len < 1) return null;

    definedGroupRules
        .sort((r1, r2) => r1.ruleType.index.compareTo(r2.ruleType.index));

    TvSortCfg? gr2 = len > 1 ? definedGroupRules[1] : null;
    TvSortCfg? gr3 = len > 2 ? definedGroupRules[2] : null;
    return GroupingRules(definedGroupRules.first, gr2, gr3);
  }

  SortingRules? get sortingRules {
    List<TvSortCfg> definedGroupRules = visRuleList
        .whereType<TvSortCfg>()
        .where((e) => e.ruleType == VisualRuleType.sortCfg)
        .toList();

    int len = definedGroupRules.length;
    if (len < 1) return null;

    definedGroupRules
        .sort((r1, r2) => r1.ruleType.index.compareTo(r2.ruleType.index));

    TvSortCfg? gr2 = len > 1 ? definedGroupRules[1] : null;
    TvSortCfg? gr3 = len > 2 ? definedGroupRules[2] : null;
    return SortingRules(definedGroupRules.first, gr2, gr3);
  }

  factory SlotOrAreaRuleCfg.fromQuest(VisRuleStyleQuest rQuest) {
    //
    TvSortCfg vrs = rQuest.asVisualRules as TvSortCfg;
    return SlotOrAreaRuleCfg(rQuest.visRuleTypeForAreaOrSlot!, [vrs]);
  }

  void fillMissingWithDefaults() {
    // TODO
    for (VisRuleQuestType rqt in visRuleType.requiredQuestions) {
      // for (VisRuleQuestType qt in ruleType.questionsRequired)
      int cnt = visRuleList
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
