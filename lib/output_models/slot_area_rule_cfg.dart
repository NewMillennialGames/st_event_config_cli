part of OutputModels;

// typedef AnyRuleType = Type extends RuleResponseBase;

@JsonSerializable()
class SlotOrAreaRuleCfg {
  /*
    this class holds rule definitions
    defined at the area or slot level
    parent container (collection of these instances)
    is how you know scope of "this"
  */
  final VisualRuleType visRuleType;
  final List<RuleResponseBase> visRuleList;
  //
  SlotOrAreaRuleCfg(
    this.visRuleType,
    this.visRuleList,
  );

  List<RuleResponseBase> rulesOfType(VisualRuleType rt) =>
      visRuleList.where((rr) => rr.ruleType == rt).toList();

  // GroupingRules? get groupingRules {
  //   List<TvGroupCfg> definedGroupRules =
  //       rulesOfType(VisualRuleType.groupCfg) as List<TvGroupCfg>;

  //   int len = definedGroupRules.length;
  //   if (len < 1) return null;

  //   definedGroupRules
  //       .sort((r1, r2) => r1.order.index.compareTo(r2.order.index));

  //   TvGroupCfg? gr2 = len > 1 ? definedGroupRules[1] : null;
  //   TvGroupCfg? gr3 = len > 2 ? definedGroupRules[2] : null;
  //   return GroupingRules(definedGroupRules.first, gr2, gr3);
  // }

  SortingRules? get sortingRules {
    List<TvSortCfg> definedSortRules =
        rulesOfType(VisualRuleType.sortCfg) as List<TvSortCfg>;

    int len = definedSortRules.length;
    if (len < 1) return null;

    // definedGroupRules
    //     .sort((r1, r2) => r1.order.index.compareTo(r2.order.index));

    TvSortCfg? gr2 = len > 1 ? definedSortRules[1] : null;
    TvSortCfg? gr3 = len > 2 ? definedSortRules[2] : null;
    return SortingRules(definedSortRules.first, gr2, gr3);
  }

  FilterRules? get filterRules {
    List<TvFilterCfg> definedFilterRules =
        rulesOfType(VisualRuleType.filterCfg) as List<TvFilterCfg>;

    int len = definedFilterRules.length;
    if (len < 1) return null;

    // definedGroupRules
    //     .sort((r1, r2) => r1.order.index.compareTo(r2.order.index));

    TvFilterCfg? gr2 = len > 1 ? definedFilterRules[1] : null;
    TvFilterCfg? gr3 = len > 2 ? definedFilterRules[2] : null;
    return FilterRules(definedFilterRules.first, gr2, gr3);
  }

  void appendQuestion(VisRuleStyleQuest rQuest) {
    print(
        'adding VisRuleStyleQuest ${rQuest.questionId} in ${visRuleType.name}');
    this.visRuleList.add(rQuest.response!.answers);
  }

  void fillMissingWithDefaults(
    AppScreen appScreen,
    ScreenWidgetArea screenArea,
    ScreenAreaWidgetSlot? optSlot,
  ) {
    /* walk through existing responses for this VisualRuleType
        and add any that are missing
    */
    var requiredResponses = Set<VisRuleQuestType>()
      ..addAll(visRuleType.requiredQuestions);

    Iterable<List<VisRuleQuestType>> answerTypesSoFar =
        visRuleList.map((e) => e.requiredQuestions);

    List<VisRuleQuestType> lstVrqt = [];
    if (answerTypesSoFar.length > 0) {
      lstVrqt = answerTypesSoFar
          .reduce((finalLst, lsVals) => finalLst..addAll(lsVals));
    }

    Set<VisRuleQuestType> existingResponses = Set<VisRuleQuestType>()
      ..addAll(lstVrqt);

    Set<VisRuleQuestType> missingResponses =
        requiredResponses.difference(existingResponses);
    if (missingResponses.length < 1) return;

    var answerBuilder = DefaultAnswerBuilder.forMissingAreaOrSlot(
      appScreen,
      screenArea,
      visRuleType,
      optSlot,
      missingResponses,
    );
    visRuleList.addAll(answerBuilder.defaultAnswers);
  }

  // JsonSerializable
  factory SlotOrAreaRuleCfg.fromJson(Map<String, dynamic> json) =>
      _$SlotOrAreaRuleCfgFromJson(json);

  Map<String, dynamic> toJson() => _$SlotOrAreaRuleCfgToJson(this);
}
