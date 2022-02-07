// part of CfgRules;

// @JsonSerializable()
// class AppVisualRuleBase {
//   //
//   // interface
//   final VisualRuleType ruleType;
//   //
//   AppVisualRuleBase(this.ruleType);

//   factory AppVisualRuleBase.filter(
//     RuleResponseBase ruleResp,
//   ) =>
//       FilterRule(ruleResp);
//   // visual and styling rules
//   factory AppVisualRuleBase.format(
//     TvRowStyleCfg rrw, // RuleResponseBase
//   ) =>
//       StyleOrFormatRule(rrw);
//   factory AppVisualRuleBase.group(
//     RuleResponseBase pm,
//   ) =>
//       GroupRule();
//   factory AppVisualRuleBase.show(
//     RuleResponseBase pm,
//   ) =>
//       ShowRule(true);
//   factory AppVisualRuleBase.sort(
//     RuleResponseBase pm,
//   ) =>
//       SortRule();

//   // JsonSerializable
//   factory AppVisualRuleBase.fromJson(Map<String, dynamic> json) {
//     int ruleTypeIdx = json['ruleType'] as int;
//     VisualRuleType ruleType = VisualRuleType.values[ruleTypeIdx];
//     //
//     switch (ruleType) {
//       case VisualRuleType.styleOrFormat:
//         return StyleOrFormatRule.fromJson(json);
//       default:
//         return AppVisualRuleBase(VisualRuleType.styleOrFormat);
//     }
//   }
//   Map<String, dynamic> toJson() => _$AppVisualRuleToJson(this);
// }

// @JsonSerializable()
// class StyleOrFormatRule extends AppVisualRuleBase {
//   //
//   final TvRowStyleCfg rrw;
//   StyleOrFormatRule(this.rrw) : super(VisualRuleType.styleOrFormat);

//   //
//   factory StyleOrFormatRule.fromJson(Map<String, dynamic> json) =>
//       _$StyleOrFormatRuleFromJson(json);

//   Map<String, dynamic> toJson() => _$StyleOrFormatRuleToJson(this);
// }

// @JsonSerializable()
// class FilterRule extends AppVisualRuleBase {
//   //
//   final RuleResponseBase ruleResp;
//   // final int filterListIdx;
//   // final UiComponentSlotName property;
//   // DbRowType rowType;
//   // MenuSortOrGroupIndex menuIdx;
//   // String propertyName;
//   // bool sortDescending = true;

//   FilterRule(
//     this.ruleResp,
//   ) : super(VisualRuleType.filterCfg);

//   //
//   factory FilterRule.fromJson(Map<String, dynamic> json) =>
//       _$FilterRuleFromJson(json);
//   Map<String, dynamic> toJson() => _$FilterRuleToJson(this);
// }

// @JsonSerializable()
// class GroupRule extends AppVisualRuleBase {
//   //
//   GroupRule() : super(VisualRuleType.groupCfg) {}

//   //
//   factory GroupRule.fromJson(Map<String, dynamic> json) =>
//       _$GroupRuleFromJson(json);

//   Map<String, dynamic> toJson() => _$GroupRuleToJson(this);
// }

// @JsonSerializable()
// class ShowRule extends AppVisualRuleBase {
//   //
//   final bool shouldShow;
//   //
//   ShowRule(this.shouldShow) : super(VisualRuleType.showOrHide) {}

//   //
//   factory ShowRule.fromJson(Map<String, dynamic> json) =>
//       _$ShowRuleFromJson(json);

//   Map<String, dynamic> toJson() => _$ShowRuleToJson(this);
// }

// @JsonSerializable()
// class SortRule extends AppVisualRuleBase {
//   //
//   SortRule() : super(VisualRuleType.sortCfg) {}

//   //
//   factory SortRule.fromJson(Map<String, dynamic> json) =>
//       _$SortRuleFromJson(json);

//   Map<String, dynamic> toJson() => _$SortRuleToJson(this);
// }




// // abstract class AppVisCfgRuleIfc {
// //   //
// //   // AppVisCfgRuleIfc._();

// //   // factory AppVisCfgRuleIfc.filter(
// //   //   RuleResponseBase ruleResp,
// //   // ) =>
// //   //     FilterRule(ruleResp);
// //   // // visual and styling rules
// //   // factory AppVisCfgRuleIfc.format(
// //   //   TvRowStyleCfg rrw, // RuleResponseBase
// //   // ) =>
// //   //     StyleOrFormatRule(rrw);
// //   // factory AppVisCfgRuleIfc.group(
// //   //   RuleResponseBase pm,
// //   // ) =>
// //   //     GroupRule();
// //   // factory AppVisCfgRuleIfc.show(
// //   //   RuleResponseBase pm,
// //   // ) =>
// //   //     ShowRule(true);
// //   // factory AppVisCfgRuleIfc.sort(
// //   //   RuleResponseBase pm,
// //   // ) =>
// //   //     SortRule();

// //   // behavioral rules;  future
// //   // factory AppVisCfgRuleIfc.navigate() => NavigateRule();
// // }




//   //   static BaseRule getRule(RuleType typ) {
//   //   //
//   //   switch (typ) {
//   //     case RuleType.filter:
//   //       return FilterRule();
//   //     case RuleType.format:
//   //       return FormatRule();
//   //     case RuleType.group:
//   //       return GroupRule();
//   //     case RuleType.navigate:
//   //       return NavigateRule();
//   //     case RuleType.show:
//   //       return ShowRule();
//   //     case RuleType.sort:
//   //       return SortRule();
//   //     default:
//   //       return FilterRule();
//   //   }
//   // }