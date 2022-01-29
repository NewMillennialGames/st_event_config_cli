// GENERATED CODE - DO NOT MODIFY BY HAND

part of InputModels;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RuleResponseWrapper _$RuleResponseWrapperFromJson(Map<String, dynamic> json) =>
    RuleResponseWrapper(
      $enumDecode(_$VisualRuleTypeEnumMap, json['ruleType']),
    );

Map<String, dynamic> _$RuleResponseWrapperToJson(
        RuleResponseWrapper instance) =>
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

TvRowStyleCfg _$TvRowStyleCfgFromJson(Map<String, dynamic> json) =>
    TvRowStyleCfg()
      ..selectedRowStyle =
          $enumDecode(_$TvAreaRowStyleEnumMap, json['selectedRowStyle']);

Map<String, dynamic> _$TvRowStyleCfgToJson(TvRowStyleCfg instance) =>
    <String, dynamic>{
      'selectedRowStyle': _$TvAreaRowStyleEnumMap[instance.selectedRowStyle],
    };

const _$TvAreaRowStyleEnumMap = {
  TvAreaRowStyle.teamVsTeam: 'teamVsTeam',
  TvAreaRowStyle.teamVsTeamRanked: 'teamVsTeamRanked',
  TvAreaRowStyle.teamVsField: 'teamVsField',
  TvAreaRowStyle.teamVsFieldRanked: 'teamVsFieldRanked',
  TvAreaRowStyle.playerVsField: 'playerVsField',
  TvAreaRowStyle.playerVsFieldRanked: 'playerVsFieldRanked',
  TvAreaRowStyle.teamPlayerVsField: 'teamPlayerVsField',
  TvAreaRowStyle.driverVsField: 'driverVsField',
};

TvSortCfg _$TvSortCfgFromJson(Map<String, dynamic> json) => TvSortCfg()
  ..tableName = json['tableName'] as String
  ..colName = json['colName'] as String
  ..order = $enumDecode(_$SortOrGroupIdxOrderEnumMap, json['order'])
  ..asc = json['asc'] as bool;

Map<String, dynamic> _$TvSortCfgToJson(TvSortCfg instance) => <String, dynamic>{
      'tableName': instance.tableName,
      'colName': instance.colName,
      'order': _$SortOrGroupIdxOrderEnumMap[instance.order],
      'asc': instance.asc,
    };

const _$SortOrGroupIdxOrderEnumMap = {
  SortOrGroupIdxOrder.first: 'first',
  SortOrGroupIdxOrder.second: 'second',
  SortOrGroupIdxOrder.third: 'third',
};
