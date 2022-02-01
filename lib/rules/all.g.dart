// GENERATED CODE - DO NOT MODIFY BY HAND

part of CfgRules;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppVisualRuleBase _$AppVisualRuleFromJson(Map<String, dynamic> json) =>
    AppVisualRuleBase(
      $enumDecode(_$VisualRuleTypeEnumMap, json['ruleType']),
    );

Map<String, dynamic> _$AppVisualRuleToJson(AppVisualRuleBase instance) =>
    <String, dynamic>{
      'ruleType': _$VisualRuleTypeEnumMap[instance.ruleType],
    };

const _$VisualRuleTypeEnumMap = {
  VisualRuleType.sortCfg: 'sortCfg',
  VisualRuleType.groupCfg: 'groupCfg',
  VisualRuleType.filterCfg: 'filterCfg',
  VisualRuleType.styleOrFormat: 'styleOrFormat',
  VisualRuleType.showOrHide: 'showOrHide',
};

StyleOrFormatRule _$StyleOrFormatRuleFromJson(Map<String, dynamic> json) =>
    StyleOrFormatRule(
      TvRowStyleCfg.fromJson(json['rrw'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$StyleOrFormatRuleToJson(StyleOrFormatRule instance) =>
    <String, dynamic>{
      'rrw': instance.rrw,
    };

FilterRule _$FilterRuleFromJson(Map<String, dynamic> json) => FilterRule(
      RuleResponseBase.fromJson(json['ruleResp'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FilterRuleToJson(FilterRule instance) =>
    <String, dynamic>{
      'ruleResp': instance.ruleResp,
    };

GroupRule _$GroupRuleFromJson(Map<String, dynamic> json) => GroupRule();

Map<String, dynamic> _$GroupRuleToJson(GroupRule instance) =>
    <String, dynamic>{};

ShowRule _$ShowRuleFromJson(Map<String, dynamic> json) => ShowRule(
      json['shouldShow'] as bool,
    );

Map<String, dynamic> _$ShowRuleToJson(ShowRule instance) => <String, dynamic>{
      'shouldShow': instance.shouldShow,
    };

SortRule _$SortRuleFromJson(Map<String, dynamic> json) => SortRule();

Map<String, dynamic> _$SortRuleToJson(SortRule instance) => <String, dynamic>{};

NavigateRule _$NavigateRuleFromJson(Map<String, dynamic> json) =>
    NavigateRule();

Map<String, dynamic> _$NavigateRuleToJson(NavigateRule instance) =>
    <String, dynamic>{};
