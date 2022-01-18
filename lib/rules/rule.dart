import 'package:json_annotation/json_annotation.dart';

import '../input_models/all.dart';
import '../app_entities/all.dart';
import '../enums/all.dart';

part 'rule.g.dart';

abstract class AppConfigRule {
  //

  AppConfigRule._();

  factory AppConfigRule.filter(
    PropertyMap pm,
    // DbRowType recType,
    // String propertyName,
    // MenuSortOrGroupIndex menuIdx, {
    // bool sortDescending = true,
  ) =>
      FilterRule(
        pm.recType,
        pm.propertyName,
        menuIdx: pm.menuIdx,
        sortDescending: pm.sortDescending,
      );
  // visual and styling rules
  factory AppConfigRule.format(
    PropertyMap pm,
  ) =>
      FormatRule();
  factory AppConfigRule.group(
    PropertyMap pm,
  ) =>
      GroupRule();
  factory AppConfigRule.show(
    PropertyMap pm,
  ) =>
      ShowRule();
  factory AppConfigRule.sort(
    PropertyMap pm,
  ) =>
      SortRule();
  // behavioral rules;  future
  factory AppConfigRule.navigate() => NavigateRule();

  // interface
  // Map<VisualRuleType, String> getEncodedRule();
}

abstract class _AppVisualRule extends AppConfigRule {
  //
  _AppVisualRule._() : super._();
  // interface
  VisualRuleType get ruleType;
}

abstract class _AppBehavioralRule extends AppConfigRule {
  //
  _AppBehavioralRule._() : super._();
  // interface
  BehaviorRuleType get ruleType;
}

@JsonSerializable()
class FilterRule extends _AppVisualRule {
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
  // @override
  // Map<VisualRuleType, String> getEncodedRule() {
  //   return {};
  // }

  factory FilterRule.fromJson(Map<String, dynamic> json) =>
      _$FilterRuleFromJson(json);
  Map<String, dynamic> toJson() => _$FilterRuleToJson(this);
}

@JsonSerializable()
class FormatRule extends _AppVisualRule {
  //
  FormatRule() : super._() {}

  //
  VisualRuleType get ruleType => VisualRuleType.format;

  //
  // @override
  // Map<VisualRuleType, String> getEncodedRule() {
  //   return {};
  // }
}

@JsonSerializable()
class GroupRule extends _AppVisualRule {
  //
  GroupRule() : super._() {}

  //
  VisualRuleType get ruleType => VisualRuleType.group;
  //
  // @override
  // Map<VisualRuleType, String> getEncodedRule() {
  //   return {};
  // }
}

@JsonSerializable()
class ShowRule extends _AppVisualRule {
  //
  ShowRule() : super._() {}

  //
  VisualRuleType get ruleType => VisualRuleType.show;
  //
  // @override
  // Map<VisualRuleType, String> getEncodedRule() {
  //   return {};
  // }
}

@JsonSerializable()
class SortRule extends _AppVisualRule {
  //
  SortRule() : super._() {}

  //
  VisualRuleType get ruleType => VisualRuleType.sort;
  //
  // @override
  // Map<VisualRuleType, String> getEncodedRule() {
  //   return {};
  // }
}

@JsonSerializable()
class NavigateRule extends _AppBehavioralRule {
  //
  NavigateRule() : super._() {}

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