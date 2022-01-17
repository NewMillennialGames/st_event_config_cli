// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FilterRule _$FilterRuleFromJson(Map<String, dynamic> json) => FilterRule(
      $enumDecode(_$DbRowTypeEnumMap, json['rowType']),
      json['propertyName'] as String,
      menuIdx:
          $enumDecodeNullable(_$MenuSortOrGroupIndexEnumMap, json['menuIdx']) ??
              MenuSortOrGroupIndex.first,
      sortDescending: json['sortDescending'] as bool? ?? true,
    );

Map<String, dynamic> _$FilterRuleToJson(FilterRule instance) =>
    <String, dynamic>{
      'rowType': _$DbRowTypeEnumMap[instance.rowType],
      'menuIdx': _$MenuSortOrGroupIndexEnumMap[instance.menuIdx],
      'propertyName': instance.propertyName,
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

const _$MenuSortOrGroupIndexEnumMap = {
  MenuSortOrGroupIndex.first: 'first',
  MenuSortOrGroupIndex.second: 'second',
  MenuSortOrGroupIndex.third: 'third',
};

FormatRule _$FormatRuleFromJson(Map<String, dynamic> json) => FormatRule();

Map<String, dynamic> _$FormatRuleToJson(FormatRule instance) =>
    <String, dynamic>{};

GroupRule _$GroupRuleFromJson(Map<String, dynamic> json) => GroupRule();

Map<String, dynamic> _$GroupRuleToJson(GroupRule instance) =>
    <String, dynamic>{};

ShowRule _$ShowRuleFromJson(Map<String, dynamic> json) => ShowRule();

Map<String, dynamic> _$ShowRuleToJson(ShowRule instance) => <String, dynamic>{};

SortRule _$SortRuleFromJson(Map<String, dynamic> json) => SortRule();

Map<String, dynamic> _$SortRuleToJson(SortRule instance) => <String, dynamic>{};

NavigateRule _$NavigateRuleFromJson(Map<String, dynamic> json) =>
    NavigateRule();

Map<String, dynamic> _$NavigateRuleToJson(NavigateRule instance) =>
    <String, dynamic>{};
