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
  ..colName = $enumDecode(_$DbTableFieldNameEnumMap, json['colName'])
  ..order = $enumDecode(_$SortOrGroupIdxOrderEnumMap, json['order'])
  ..asc = json['asc'] as bool;

Map<String, dynamic> _$TvSortCfgToJson(TvSortCfg instance) => <String, dynamic>{
      'colName': _$DbTableFieldNameEnumMap[instance.colName],
      'order': _$SortOrGroupIdxOrderEnumMap[instance.order],
      'asc': instance.asc,
    };

const _$DbTableFieldNameEnumMap = {
  DbTableFieldName.teamName: 'teamName',
  DbTableFieldName.playerName: 'playerName',
  DbTableFieldName.conference: 'conference',
  DbTableFieldName.region: 'region',
  DbTableFieldName.eventName: 'eventName',
  DbTableFieldName.eventLocation: 'eventLocation',
  DbTableFieldName.eventBannerUrl: 'eventBannerUrl',
  DbTableFieldName.assetOpenPrice: 'assetOpenPrice',
  DbTableFieldName.assetCurrentPrice: 'assetCurrentPrice',
};

const _$SortOrGroupIdxOrderEnumMap = {
  SortOrGroupIdxOrder.first: 'first',
  SortOrGroupIdxOrder.second: 'second',
  SortOrGroupIdxOrder.third: 'third',
};
