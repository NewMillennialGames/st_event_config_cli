// GENERATED CODE - DO NOT MODIFY BY HAND

part of InputModels;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RuleResponseBase _$RuleResponseBaseFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'RuleResponseBase',
      json,
      ($checkedConvert) {
        final val = RuleResponseBase(
          $checkedConvert(
              'ruleType', (v) => $enumDecode(_$VisualRuleTypeEnumMap, v)),
        );
        $checkedConvert(
            'userResponses',
            (v) => val.userResponses = (v as Map<String, dynamic>).map(
                  (k, e) => MapEntry(
                      $enumDecode(_$VisRuleQuestTypeEnumMap, k), e as String),
                ));
        return val;
      },
    );

Map<String, dynamic> _$RuleResponseBaseToJson(RuleResponseBase instance) =>
    <String, dynamic>{
      'ruleType': _$VisualRuleTypeEnumMap[instance.ruleType],
      'userResponses': instance.userResponses
          .map((k, e) => MapEntry(_$VisRuleQuestTypeEnumMap[k], e)),
    };

const _$VisualRuleTypeEnumMap = {
  VisualRuleType.sortCfg: 'sortCfg',
  VisualRuleType.filterCfg: 'filterCfg',
  VisualRuleType.styleOrFormat: 'styleOrFormat',
  VisualRuleType.showOrHide: 'showOrHide',
};

const _$VisRuleQuestTypeEnumMap = {
  VisRuleQuestType.selectDataFieldName: 'selectDataFieldName',
  VisRuleQuestType.specifySortAscending: 'specifySortAscending',
  VisRuleQuestType.selectVisualComponentOrStyle: 'selectVisualComponentOrStyle',
  VisRuleQuestType.controlsVisibilityOfAreaOrSlot:
      'controlsVisibilityOfAreaOrSlot',
};

TvRowStyleCfg _$TvRowStyleCfgFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'TvRowStyleCfg',
      json,
      ($checkedConvert) {
        final val = TvRowStyleCfg();
        $checkedConvert(
            'userResponses',
            (v) => val.userResponses = (v as Map<String, dynamic>).map(
                  (k, e) => MapEntry(
                      $enumDecode(_$VisRuleQuestTypeEnumMap, k), e as String),
                ));
        $checkedConvert(
            'selectedRowStyle',
            (v) =>
                val.selectedRowStyle = $enumDecode(_$TvAreaRowStyleEnumMap, v));
        return val;
      },
    );

Map<String, dynamic> _$TvRowStyleCfgToJson(TvRowStyleCfg instance) =>
    <String, dynamic>{
      'userResponses': instance.userResponses
          .map((k, e) => MapEntry(_$VisRuleQuestTypeEnumMap[k], e)),
      'selectedRowStyle': _$TvAreaRowStyleEnumMap[instance.selectedRowStyle],
    };

const _$TvAreaRowStyleEnumMap = {
  TvAreaRowStyle.assetVsAsset: 'assetVsAsset',
  TvAreaRowStyle.assetVsAssetRanked: 'assetVsAssetRanked',
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

TvSortCfg _$TvSortCfgFromJson(Map<String, dynamic> json) => $checkedCreate(
      'TvSortCfg',
      json,
      ($checkedConvert) {
        final val = TvSortCfg();
        $checkedConvert(
            'userResponses',
            (v) => val.userResponses = (v as Map<String, dynamic>).map(
                  (k, e) => MapEntry(
                      $enumDecode(_$VisRuleQuestTypeEnumMap, k), e as String),
                ));
        $checkedConvert('colName',
            (v) => val.colName = $enumDecode(_$DbTableFieldNameEnumMap, v));
        $checkedConvert('asc', (v) => val.asc = v as bool);
        return val;
      },
    );

Map<String, dynamic> _$TvSortCfgToJson(TvSortCfg instance) => <String, dynamic>{
      'userResponses': instance.userResponses
          .map((k, e) => MapEntry(_$VisRuleQuestTypeEnumMap[k], e)),
      'colName': _$DbTableFieldNameEnumMap[instance.colName],
      'asc': instance.asc,
    };

const _$DbTableFieldNameEnumMap = {
  DbTableFieldName.teamName: 'teamName',
  DbTableFieldName.playerName: 'playerName',
  DbTableFieldName.conference: 'conference',
  DbTableFieldName.region: 'region',
  DbTableFieldName.eventName: 'eventName',
  DbTableFieldName.gameDate: 'gameDate',
  DbTableFieldName.gameTime: 'gameTime',
  DbTableFieldName.gameLocation: 'gameLocation',
  DbTableFieldName.imageUrl: 'imageUrl',
  DbTableFieldName.assetOpenPrice: 'assetOpenPrice',
  DbTableFieldName.assetCurrentPrice: 'assetCurrentPrice',
  DbTableFieldName.assetRank: 'assetRank',
  DbTableFieldName.assetPosition: 'assetPosition',
};

TvFilterCfg _$TvFilterCfgFromJson(Map<String, dynamic> json) => $checkedCreate(
      'TvFilterCfg',
      json,
      ($checkedConvert) {
        final val = TvFilterCfg();
        $checkedConvert(
            'userResponses',
            (v) => val.userResponses = (v as Map<String, dynamic>).map(
                  (k, e) => MapEntry(
                      $enumDecode(_$VisRuleQuestTypeEnumMap, k), e as String),
                ));
        $checkedConvert('colName',
            (v) => val.colName = $enumDecode(_$DbTableFieldNameEnumMap, v));
        $checkedConvert('asc', (v) => val.asc = v as bool);
        return val;
      },
    );

Map<String, dynamic> _$TvFilterCfgToJson(TvFilterCfg instance) =>
    <String, dynamic>{
      'userResponses': instance.userResponses
          .map((k, e) => MapEntry(_$VisRuleQuestTypeEnumMap[k], e)),
      'colName': _$DbTableFieldNameEnumMap[instance.colName],
      'asc': instance.asc,
    };

ShowHideCfg _$ShowHideCfgFromJson(Map<String, dynamic> json) => $checkedCreate(
      'ShowHideCfg',
      json,
      ($checkedConvert) {
        final val = ShowHideCfg();
        $checkedConvert(
            'userResponses',
            (v) => val.userResponses = (v as Map<String, dynamic>).map(
                  (k, e) => MapEntry(
                      $enumDecode(_$VisRuleQuestTypeEnumMap, k), e as String),
                ));
        $checkedConvert('shouldShow', (v) => val.shouldShow = v as bool);
        return val;
      },
    );

Map<String, dynamic> _$ShowHideCfgToJson(ShowHideCfg instance) =>
    <String, dynamic>{
      'userResponses': instance.userResponses
          .map((k, e) => MapEntry(_$VisRuleQuestTypeEnumMap[k], e)),
      'shouldShow': instance.shouldShow,
    };
