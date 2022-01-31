// GENERATED CODE - DO NOT MODIFY BY HAND

part of InputModels;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RuleResponseBase _$RuleResponseBaseFromJson(Map<String, dynamic> json) =>
    RuleResponseBase(
      $enumDecode(_$VisualRuleTypeEnumMap, json['ruleType']),
    );

Map<String, dynamic> _$RuleResponseBaseToJson(RuleResponseBase instance) =>
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
  TvAreaRowStyle.teamDraft: 'teamDraft',
  TvAreaRowStyle.teamLine: 'teamLine',
  TvAreaRowStyle.teamPlayerVsField: 'teamPlayerVsField',
  TvAreaRowStyle.playerVsField: 'playerVsField',
  TvAreaRowStyle.playerVsFieldRanked: 'playerVsFieldRanked',
  TvAreaRowStyle.playerDraft: 'playerDraft',
  TvAreaRowStyle.driverVsField: 'driverVsField',
};

TvSortOrGroupCfg _$TvSortOrGroupCfgFromJson(Map<String, dynamic> json) =>
    TvSortOrGroupCfg()
      ..colName = $enumDecode(_$DbTableFieldNameEnumMap, json['colName'])
      ..order = $enumDecode(_$SortOrGroupIdxOrderEnumMap, json['order'])
      ..asc = json['asc'] as bool;

Map<String, dynamic> _$TvSortOrGroupCfgToJson(TvSortOrGroupCfg instance) =>
    <String, dynamic>{
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

TvFilterCfg _$TvFilterCfgFromJson(Map<String, dynamic> json) => TvFilterCfg()
  ..colName = $enumDecode(_$DbTableFieldNameEnumMap, json['colName'])
  ..order = $enumDecode(_$SortOrGroupIdxOrderEnumMap, json['order'])
  ..asc = json['asc'] as bool;

Map<String, dynamic> _$TvFilterCfgToJson(TvFilterCfg instance) =>
    <String, dynamic>{
      'colName': _$DbTableFieldNameEnumMap[instance.colName],
      'order': _$SortOrGroupIdxOrderEnumMap[instance.order],
      'asc': instance.asc,
    };

ShowHideCfg _$ShowHideCfgFromJson(Map<String, dynamic> json) =>
    ShowHideCfg()..shouldShow = json['shouldShow'] as bool;

Map<String, dynamic> _$ShowHideCfgToJson(ShowHideCfg instance) =>
    <String, dynamic>{
      'shouldShow': instance.shouldShow,
    };
