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
    RuleResponseWrapper rrw,
  ) =>
      FormatRule(rrw);
  factory AppConfigRule.group(
    RuleResponseWrapper pm,
  ) =>
      GroupRule();
  factory AppConfigRule.show(
    RuleResponseWrapper pm,
  ) =>
      ShowRule(true);
  factory AppConfigRule.sort(
    RuleResponseWrapper pm,
  ) =>
      SortRule();

  // behavioral rules;  future
  factory AppConfigRule.navigate() => NavigateRule();
}

@JsonSerializable()
class AppVisualRule extends AppConfigRule {
  //
  // interface
  final VisualRuleType ruleType;
  //
  AppVisualRule(this.ruleType) : super._();

  // JsonSerializable
  factory AppVisualRule.fromJson(Map<String, dynamic> json) {
    int ruleTypeIdx = json['ruleType'] as int;
    VisualRuleType ruleType = VisualRuleType.values[ruleTypeIdx];
    //
    switch (ruleType) {
      case VisualRuleType.styleOrFormat:
        return FormatRule.fromJson(json);
      default:
        return AppVisualRule(VisualRuleType.styleOrFormat);
    }
  }
  Map<String, dynamic> toJson() => _$AppVisualRuleToJson(this);
}

// @JsonSerializable()
// class StyleFormatCfg {
//   //
//   TvAreaRowStyle rowStyle;
//   StyleFormatCfg(this.rowStyle);

//     factory StyleFormatCfg.fromJson(Map<String, dynamic> json) =>
//       _$StyleFormatCfgFromJson(json);

//   Map<String, dynamic> toJson() => _$StyleFormatCfgToJson(this);
// }

@JsonSerializable()
class FormatRule extends AppVisualRule {
  //
  final RuleResponseWrapper rrw;
  FormatRule(this.rrw) : super(VisualRuleType.styleOrFormat);

  //
  factory FormatRule.fromJson(Map<String, dynamic> json) =>
      _$FormatRuleFromJson(json);

  Map<String, dynamic> toJson() => _$FormatRuleToJson(this);
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
  ) : super(VisualRuleType.filterCfg);

  //
  factory FilterRule.fromJson(Map<String, dynamic> json) =>
      _$FilterRuleFromJson(json);
  Map<String, dynamic> toJson() => _$FilterRuleToJson(this);
}

@JsonSerializable()
class GroupRule extends AppVisualRule {
  //
  GroupRule() : super(VisualRuleType.groupCfg) {}

  //
  factory GroupRule.fromJson(Map<String, dynamic> json) =>
      _$GroupRuleFromJson(json);

  Map<String, dynamic> toJson() => _$GroupRuleToJson(this);
}

@JsonSerializable()
class ShowRule extends AppVisualRule {
  //
  final bool shouldShow;
  //
  ShowRule(this.shouldShow) : super(VisualRuleType.showOrHide) {}

  //
  factory ShowRule.fromJson(Map<String, dynamic> json) =>
      _$ShowRuleFromJson(json);

  Map<String, dynamic> toJson() => _$ShowRuleToJson(this);
}

@JsonSerializable()
class SortRule extends AppVisualRule {
  //
  SortRule() : super(VisualRuleType.sortCfg) {}

  //
  factory SortRule.fromJson(Map<String, dynamic> json) =>
      _$SortRuleFromJson(json);

  Map<String, dynamic> toJson() => _$SortRuleToJson(this);
}

// behavior rules below
//
//
//
//
//

class AppBehavioralRule extends AppConfigRule {
  //
  final BehaviorRuleType ruleType;
  //
  AppBehavioralRule(this.ruleType) : super._();
}

@JsonSerializable()
class NavigateRule extends AppBehavioralRule {
  //
  NavigateRule() : super(BehaviorRuleType.navigate) {}

  //
  factory NavigateRule.fromJson(Map<String, dynamic> json) =>
      _$NavigateRuleFromJson(json);

  Map<String, dynamic> toJson() => _$NavigateRuleToJson(this);
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