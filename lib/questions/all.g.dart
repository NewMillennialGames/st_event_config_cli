// GENERATED CODE - DO NOT MODIFY BY HAND

part of InputModels;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RuleResponseBase _$RuleResponseBaseFromJson(Map<String, dynamic> json) =>
    RuleResponseBase(
      $enumDecode(_$VisualRuleTypeEnumMap, json['ruleType']),
    )..userResponses = (json['userResponses'] as Map<String, dynamic>).map(
        (k, e) =>
            MapEntry($enumDecode(_$VisRuleQuestTypeEnumMap, k), e as String),
      );

Map<String, dynamic> _$RuleResponseBaseToJson(RuleResponseBase instance) =>
    <String, dynamic>{
      'ruleType': _$VisualRuleTypeEnumMap[instance.ruleType],
      'userResponses': instance.userResponses
          .map((k, e) => MapEntry(_$VisRuleQuestTypeEnumMap[k], e)),
    };

const _$VisualRuleTypeEnumMap = {
  VisualRuleType.sortCfg: 'sortCfg',
  VisualRuleType.groupCfg: 'groupCfg',
  VisualRuleType.filterCfg: 'filterCfg',
  VisualRuleType.styleOrFormat: 'styleOrFormat',
  VisualRuleType.showOrHide: 'showOrHide',
};

const _$VisRuleQuestTypeEnumMap = {
  VisRuleQuestType.selectDataFieldName: 'selectDataFieldName',
  VisRuleQuestType.specifyPositionInGroup: 'specifyPositionInGroup',
  VisRuleQuestType.specifySortAscending: 'specifySortAscending',
  VisRuleQuestType.selectVisualComponentOrStyle: 'selectVisualComponentOrStyle',
  VisRuleQuestType.controlsVisibilityOfAreaOrSlot:
      'controlsVisibilityOfAreaOrSlot',
};

TvRowStyleCfg _$TvRowStyleCfgFromJson(Map<String, dynamic> json) =>
    TvRowStyleCfg()
      ..userResponses = (json['userResponses'] as Map<String, dynamic>).map(
        (k, e) =>
            MapEntry($enumDecode(_$VisRuleQuestTypeEnumMap, k), e as String),
      )
      ..selectedRowStyle =
          $enumDecode(_$TvAreaRowStyleEnumMap, json['selectedRowStyle']);

Map<String, dynamic> _$TvRowStyleCfgToJson(TvRowStyleCfg instance) =>
    <String, dynamic>{
      'userResponses': instance.userResponses
          .map((k, e) => MapEntry(_$VisRuleQuestTypeEnumMap[k], e)),
      'selectedRowStyle': _$TvAreaRowStyleEnumMap[instance.selectedRowStyle],
    };

const _$TvAreaRowStyleEnumMap = {
  TvAreaRowStyle.assetVsAsset: 'teamVsTeam',
  TvAreaRowStyle.assetVsAssetRanked: 'teamVsTeamRanked',
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

TvSortCfg _$TvSortCfgFromJson(Map<String, dynamic> json) => TvSortCfg()
  ..userResponses = (json['userResponses'] as Map<String, dynamic>).map(
    (k, e) => MapEntry($enumDecode(_$VisRuleQuestTypeEnumMap, k), e as String),
  )
  ..colName = $enumDecode(_$DbTableFieldNameEnumMap, json['colName'])
  ..order = $enumDecode(_$SortOrGroupIdxOrderEnumMap, json['order'])
  ..asc = json['asc'] as bool;

Map<String, dynamic> _$TvSortCfgToJson(TvSortCfg instance) => <String, dynamic>{
      'userResponses': instance.userResponses
          .map((k, e) => MapEntry(_$VisRuleQuestTypeEnumMap[k], e)),
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
  DbTableFieldName.gameLocation: 'eventLocation',
  DbTableFieldName.imageUrl: 'eventBannerUrl',
  DbTableFieldName.assetOpenPrice: 'assetOpenPrice',
  DbTableFieldName.assetCurrentPrice: 'assetCurrentPrice',
};

const _$SortOrGroupIdxOrderEnumMap = {
  SortOrGroupIdxOrder.first: 'first',
  SortOrGroupIdxOrder.second: 'second',
  SortOrGroupIdxOrder.third: 'third',
};

TvGroupCfg _$TvGroupCfgFromJson(Map<String, dynamic> json) => TvGroupCfg()
  ..userResponses = (json['userResponses'] as Map<String, dynamic>).map(
    (k, e) => MapEntry($enumDecode(_$VisRuleQuestTypeEnumMap, k), e as String),
  )
  ..colName = $enumDecode(_$DbTableFieldNameEnumMap, json['colName'])
  ..order = $enumDecode(_$SortOrGroupIdxOrderEnumMap, json['order'])
  ..asc = json['asc'] as bool;

Map<String, dynamic> _$TvGroupCfgToJson(TvGroupCfg instance) =>
    <String, dynamic>{
      'userResponses': instance.userResponses
          .map((k, e) => MapEntry(_$VisRuleQuestTypeEnumMap[k], e)),
      'colName': _$DbTableFieldNameEnumMap[instance.colName],
      'order': _$SortOrGroupIdxOrderEnumMap[instance.order],
      'asc': instance.asc,
    };

TvFilterCfg _$TvFilterCfgFromJson(Map<String, dynamic> json) => TvFilterCfg()
  ..userResponses = (json['userResponses'] as Map<String, dynamic>).map(
    (k, e) => MapEntry($enumDecode(_$VisRuleQuestTypeEnumMap, k), e as String),
  )
  ..colName = $enumDecode(_$DbTableFieldNameEnumMap, json['colName'])
  ..order = $enumDecode(_$SortOrGroupIdxOrderEnumMap, json['order'])
  ..asc = json['asc'] as bool;

Map<String, dynamic> _$TvFilterCfgToJson(TvFilterCfg instance) =>
    <String, dynamic>{
      'userResponses': instance.userResponses
          .map((k, e) => MapEntry(_$VisRuleQuestTypeEnumMap[k], e)),
      'colName': _$DbTableFieldNameEnumMap[instance.colName],
      'order': _$SortOrGroupIdxOrderEnumMap[instance.order],
      'asc': instance.asc,
    };

ShowHideCfg _$ShowHideCfgFromJson(Map<String, dynamic> json) => ShowHideCfg()
  ..userResponses = (json['userResponses'] as Map<String, dynamic>).map(
    (k, e) => MapEntry($enumDecode(_$VisRuleQuestTypeEnumMap, k), e as String),
  )
  ..shouldShow = json['shouldShow'] as bool;

Map<String, dynamic> _$ShowHideCfgToJson(ShowHideCfg instance) =>
    <String, dynamic>{
      'userResponses': instance.userResponses
          .map((k, e) => MapEntry(_$VisRuleQuestTypeEnumMap[k], e)),
      'shouldShow': instance.shouldShow,
    };
