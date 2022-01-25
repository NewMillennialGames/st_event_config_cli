import 'package:json_annotation/json_annotation.dart';

import '../input_models/all.dart';
import '../enums/all.dart';

part 'rule.g.dart';

abstract class AppConfigRule {
  //

  AppConfigRule._();

  factory AppConfigRule.filter(
    RuleResponseWrapper ruleResp,
  ) =>
      FilterRule(ruleResp);
  // visual and styling rules
  factory AppConfigRule.format(
    RuleResponseWrapper pm,
  ) =>
      FormatRule();
  factory AppConfigRule.group(
    RuleResponseWrapper pm,
  ) =>
      GroupRule();
  factory AppConfigRule.show(
    RuleResponseWrapper pm,
  ) =>
      ShowRule();
  factory AppConfigRule.sort(
    RuleResponseWrapper pm,
  ) =>
      SortRule();
  // behavioral rules;  future
  factory AppConfigRule.navigate() => NavigateRule();

  // interface
  // Map<VisualRuleType, String> getEncodedRule();
}

@JsonSerializable()
class AppVisualRule extends AppConfigRule {
  //
  AppVisualRule() : super._();
  // interface
  VisualRuleType get ruleType => VisualRuleType.styleOrFormat;

  factory AppVisualRule.fromJson(Map<String, dynamic> json) =>
      _$AppVisualRuleFromJson(json);
  Map<String, dynamic> toJson() => _$AppVisualRuleToJson(this);
}

class AppBehavioralRule extends AppConfigRule {
  //
  AppBehavioralRule() : super._();
  // interface
  BehaviorRuleType get ruleType => BehaviorRuleType.navigate;
}

@JsonSerializable()
class FilterRule extends AppVisualRule {
  //
  final RuleResponseWrapper ruleResp;
  // final int filterListIdx;
  // final UiComponentSlotName property;
  // DbRowType rowType;
  // MenuSortOrGroupIndex menuIdx;
  // String propertyName;
  // bool sortDescending = true;

  FilterRule(
    this.ruleResp,
  ) : super();

  //
  VisualRuleType get ruleType => VisualRuleType.filterCfg;

  //
  // @override
  // Map<VisualRuleType, String> getEncodedRule() {
  //   return {};
  // }

  factory FilterRule.fromJson(Map<String, dynamic> json) =>
      _$FilterRuleFromJson(json);
  Map<String, dynamic> toJson() => _$FilterRuleToJson(this);
}

@JsonSerializable()
class FormatRule extends AppVisualRule {
  //
  FormatRule() : super();

  //
  VisualRuleType get ruleType => VisualRuleType.styleOrFormat;

  //
  // @override
  // Map<VisualRuleType, String> getEncodedRule() {
  //   return {};
  // }
}

@JsonSerializable()
class GroupRule extends AppVisualRule {
  //
  GroupRule() : super() {}

  //
  VisualRuleType get ruleType => VisualRuleType.groupCfg;
  //
  // @override
  // Map<VisualRuleType, String> getEncodedRule() {
  //   return {};
  // }
}

@JsonSerializable()
class ShowRule extends AppVisualRule {
  //
  ShowRule() : super() {}

  //
  VisualRuleType get ruleType => VisualRuleType.showOrHide;
  //
  // @override
  // Map<VisualRuleType, String> getEncodedRule() {
  //   return {};
  // }
}

@JsonSerializable()
class SortRule extends AppVisualRule {
  //
  SortRule() : super() {}

  //
  VisualRuleType get ruleType => VisualRuleType.sortCfg;
  //
  // @override
  // Map<VisualRuleType, String> getEncodedRule() {
  //   return {};
  // }
}

@JsonSerializable()
class NavigateRule extends AppBehavioralRule {
  //
  NavigateRule() : super() {}

  //
  BehaviorRuleType get ruleType => BehaviorRuleType.navigate;
  //
  // @override
  // Map<VisualRuleType, String> getEncodedRule() {
  //   return {};
  // }
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