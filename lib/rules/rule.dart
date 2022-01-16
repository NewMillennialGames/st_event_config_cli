part of CfgInputModels;

abstract class BaseRule {
  //

  BaseRule._();

  factory BaseRule.filter(
    DbRowType recType,
    String propertyName,
    MenuSortOrGroupIndex menuIdx, {
    bool sortDescending = true,
  }) =>
      FilterRule(
        recType,
        propertyName,
        menuIdx: menuIdx,
        sortDescending: sortDescending,
      );
  factory BaseRule.format() => FormatRule();
  factory BaseRule.group() => GroupRule();
  factory BaseRule.show() => ShowRule();
  factory BaseRule.sort() => SortRule();

  // factory BaseRule.navigate() => NavigateRule();

  // interface
  VisualRuleType get ruleType;
  Map<VisualRuleType, String> getEncodedRule();
}

@JsonSerializable()
class FilterRule extends BaseRule {
  //
  // final int filterListIdx;
  // final UiComponentSlotName property;
  DbRowType rowType;
  MenuSortOrGroupIndex menuIdx;
  String propertyName;
  bool sortDescending = true;

  FilterRule(
    this.rowType,
    this.propertyName, {
    this.menuIdx = MenuSortOrGroupIndex.first,
    this.sortDescending = true,
  }) : super._();

  //
  VisualRuleType get ruleType => VisualRuleType.filter;

  //
  @override
  Map<VisualRuleType, String> getEncodedRule() {
    return {};
  }

  factory FilterRule.fromJson(Map<String, dynamic> json) =>
      _$FilterRuleFromJson(json);
  Map<String, dynamic> toJson() => _$FilterRuleToJson(this);
}

@JsonSerializable()
class FormatRule extends BaseRule {
  //
  FormatRule() : super._() {}

  //
  VisualRuleType get ruleType => VisualRuleType.format;

  //
  @override
  Map<VisualRuleType, String> getEncodedRule() {
    return {};
  }
}

@JsonSerializable()
class GroupRule extends BaseRule {
  //
  GroupRule() : super._() {}

  //
  VisualRuleType get ruleType => VisualRuleType.group;
  //
  @override
  Map<VisualRuleType, String> getEncodedRule() {
    return {};
  }
}

@JsonSerializable()
class ShowRule extends BaseRule {
  //
  ShowRule() : super._() {}

  //
  VisualRuleType get ruleType => VisualRuleType.show;
  //
  @override
  Map<VisualRuleType, String> getEncodedRule() {
    return {};
  }
}

@JsonSerializable()
class SortRule extends BaseRule {
  //
  SortRule() : super._() {}

  //
  VisualRuleType get ruleType => VisualRuleType.sort;
  //
  @override
  Map<VisualRuleType, String> getEncodedRule() {
    return {};
  }
}


// @JsonSerializable()
// class NavigateRule extends BaseRule {
//   //
//   NavigateRule() : super._() {}

//   //
//   BehaviorRuleType get ruleType => BehaviorRuleType.navigate;
//   //
//   @override
//   Map<VisualRuleType, String> getEncodedRule() {
//     return {};
//   }
// }


  //   static BaseRule getRule(RuleType typ) {
  //   //
  //   switch (typ) {
  //     case RuleType.filter:
  //       return FilterRule();
  //     case RuleType.format:
  //       return FormatRule();
  //     case RuleType.group:
  //       return GroupRule();
  //     case RuleType.navigate:
  //       return NavigateRule();
  //     case RuleType.show:
  //       return ShowRule();
  //     case RuleType.sort:
  //       return SortRule();
  //     default:
  //       return FilterRule();
  //   }
  // }