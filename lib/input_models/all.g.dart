// GENERATED CODE - DO NOT MODIFY BY HAND

part of CfgInputModels;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FilterRule _$FilterRuleFromJson(Map<String, dynamic> json) => FilterRule(
      $enumDecode(_$DbRowTypeEnumMap, json['recType']),
      json['propertyName'] as String,
      listIdx: json['listIdx'] as int? ?? 1,
      sortDescending: json['sortDescending'] as bool? ?? true,
    );

Map<String, dynamic> _$FilterRuleToJson(FilterRule instance) =>
    <String, dynamic>{
      'recType': _$DbRowTypeEnumMap[instance.recType],
      'propertyName': instance.propertyName,
      'listIdx': instance.listIdx,
      'sortDescending': instance.sortDescending,
    };

const _$DbRowTypeEnumMap = {
  DbRowType.asset: 'asset',
  DbRowType.player: 'player',
  DbRowType.team: 'team',
  DbRowType.game: 'game',
  DbRowType.competition: 'competition',
  DbRowType.event: 'event',
};

FormatRule _$FormatRuleFromJson(Map<String, dynamic> json) => FormatRule();

Map<String, dynamic> _$FormatRuleToJson(FormatRule instance) =>
    <String, dynamic>{};

GroupRule _$GroupRuleFromJson(Map<String, dynamic> json) => GroupRule();

Map<String, dynamic> _$GroupRuleToJson(GroupRule instance) =>
    <String, dynamic>{};

NavigateRule _$NavigateRuleFromJson(Map<String, dynamic> json) =>
    NavigateRule();

Map<String, dynamic> _$NavigateRuleToJson(NavigateRule instance) =>
    <String, dynamic>{};

ShowRule _$ShowRuleFromJson(Map<String, dynamic> json) => ShowRule();

Map<String, dynamic> _$ShowRuleToJson(ShowRule instance) => <String, dynamic>{};

SortRule _$SortRuleFromJson(Map<String, dynamic> json) => SortRule();

Map<String, dynamic> _$SortRuleToJson(SortRule instance) => <String, dynamic>{};
