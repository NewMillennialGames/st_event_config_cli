part of EventCfgModels;

abstract class BaseRule {
  //

  BaseRule._();

  factory BaseRule.filter(
    DbRowType recType,
    String propertyName,
    int listIdx, {
    bool sortDescending = true,
  }) =>
      FilterRule(
        recType,
        propertyName,
        listIdx: listIdx,
        sortDescending: sortDescending,
      );
  factory BaseRule.format() => FormatRule();
  factory BaseRule.group() => GroupRule();
  factory BaseRule.navigate() => NavigateRule();
  factory BaseRule.show() => NavigateRule();
  factory BaseRule.sort() => NavigateRule();

  // interface
  RuleType get ruleType;
  Map<RuleType, String> getEncodedRule();
}

@JsonSerializable()
class FilterRule extends BaseRule {
  //
  // final int filterListIdx;
  // final UiComponentSlotName property;
  DbRowType recType;
  String propertyName;
  int listIdx;
  bool sortDescending = true;

  FilterRule(
    this.recType,
    this.propertyName, {
    this.listIdx = 1,
    this.sortDescending = true,
  }) : super._() {}

  //
  RuleType get ruleType => RuleType.filter;

  //
  @override
  Map<RuleType, String> getEncodedRule() {
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
  RuleType get ruleType => RuleType.format;

  //
  @override
  Map<RuleType, String> getEncodedRule() {
    return {};
  }
}

@JsonSerializable()
class GroupRule extends BaseRule {
  //
  GroupRule() : super._() {}

  //
  RuleType get ruleType => RuleType.group;
  //
  @override
  Map<RuleType, String> getEncodedRule() {
    return {};
  }
}

@JsonSerializable()
class NavigateRule extends BaseRule {
  //
  NavigateRule() : super._() {}

  //
  RuleType get ruleType => RuleType.navigate;
  //
  @override
  Map<RuleType, String> getEncodedRule() {
    return {};
  }
}

@JsonSerializable()
class ShowRule extends BaseRule {
  //
  ShowRule() : super._() {}

  //
  RuleType get ruleType => RuleType.show;
  //
  @override
  Map<RuleType, String> getEncodedRule() {
    return {};
  }
}

@JsonSerializable()
class SortRule extends BaseRule {
  //
  SortRule() : super._() {}

  //
  RuleType get ruleType => RuleType.sort;
  //
  @override
  Map<RuleType, String> getEncodedRule() {
    return {};
  }
}




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