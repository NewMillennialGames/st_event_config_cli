// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'all.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RuleResponseBase _$RuleResponseBaseFromJson(Map<String, dynamic> json) =>
    RuleResponseBase(
      $enumDecode(_$VisualRuleTypeEnumMap, json['ruleType']),
    );

Map<String, dynamic> _$RuleResponseBaseToJson(RuleResponseBase instance) =>
    <String, dynamic>{
      'ruleType': _$VisualRuleTypeEnumMap[instance.ruleType]!,
    };

const _$VisualRuleTypeEnumMap = {
  VisualRuleType.generalDialogFlow: 'generalDialogFlow',
  VisualRuleType.sortCfg: 'sortCfg',
  VisualRuleType.groupCfg: 'groupCfg',
  VisualRuleType.filterCfg: 'filterCfg',
  VisualRuleType.styleOrFormat: 'styleOrFormat',
  VisualRuleType.showOrHide: 'showOrHide',
  VisualRuleType.themePreference: 'themePreference',
};

TvRowStyleCfg _$TvRowStyleCfgFromJson(Map<String, dynamic> json) =>
    TvRowStyleCfg()
      ..ruleType = $enumDecode(_$VisualRuleTypeEnumMap, json['ruleType'])
      ..selectedRowStyle =
          $enumDecode(_$TvAreaRowStyleEnumMap, json['selectedRowStyle']);

Map<String, dynamic> _$TvRowStyleCfgToJson(TvRowStyleCfg instance) =>
    <String, dynamic>{
      'ruleType': _$VisualRuleTypeEnumMap[instance.ruleType]!,
      'selectedRowStyle': _$TvAreaRowStyleEnumMap[instance.selectedRowStyle]!,
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
  TvAreaRowStyle.digitalAssetScored: 'digitalAssetScored',
};

SortFilterEntry _$SortFilterEntryFromJson(Map<String, dynamic> json) =>
    SortFilterEntry(
      $enumDecode(_$DbTableFieldNameEnumMap, json['colName']),
      json['asc'] as bool,
      menuTitleIfFilter: json['menuTitleIfFilter'] as String?,
    );

Map<String, dynamic> _$SortFilterEntryToJson(SortFilterEntry instance) =>
    <String, dynamic>{
      'colName': _$DbTableFieldNameEnumMap[instance.colName]!,
      'asc': instance.asc,
      'menuTitleIfFilter': instance.menuTitleIfFilter,
    };

const _$DbTableFieldNameEnumMap = {
  DbTableFieldName.assetName: 'assetName',
  DbTableFieldName.assetShortName: 'assetShortName',
  DbTableFieldName.assetOrgName: 'assetOrgName',
  DbTableFieldName.leagueGrouping: 'leagueGrouping',
  DbTableFieldName.competitionDate: 'competitionDate',
  DbTableFieldName.competitionTime: 'competitionTime',
  DbTableFieldName.competitionLocation: 'competitionLocation',
  DbTableFieldName.competitionName: 'competitionName',
  DbTableFieldName.imageUrl: 'imageUrl',
  DbTableFieldName.assetOpenPrice: 'assetOpenPrice',
  DbTableFieldName.assetCurrentPrice: 'assetCurrentPrice',
  DbTableFieldName.assetRankOrScore: 'assetRankOrScore',
  DbTableFieldName.assetPosition: 'assetPosition',
  DbTableFieldName.basedOnEventDelimiters: 'basedOnEventDelimiters',
};

GroupCfgEntry _$GroupCfgEntryFromJson(Map<String, dynamic> json) =>
    GroupCfgEntry(
      $enumDecode(_$DbTableFieldNameEnumMap, json['colName']),
      json['asc'] as bool,
      $enumDecode(_$DisplayJustificationEnumMap, json['justification']),
      json['collapsible'] as bool,
    )..menuTitleIfFilter = json['menuTitleIfFilter'] as String?;

Map<String, dynamic> _$GroupCfgEntryToJson(GroupCfgEntry instance) =>
    <String, dynamic>{
      'colName': _$DbTableFieldNameEnumMap[instance.colName]!,
      'asc': instance.asc,
      'menuTitleIfFilter': instance.menuTitleIfFilter,
      'justification': _$DisplayJustificationEnumMap[instance.justification]!,
      'collapsible': instance.collapsible,
    };

const _$DisplayJustificationEnumMap = {
  DisplayJustification.left: 'left',
  DisplayJustification.center: 'center',
  DisplayJustification.right: 'right',
};

TvSortCfg _$TvSortCfgFromJson(Map<String, dynamic> json) => TvSortCfg()
  ..ruleType = $enumDecode(_$VisualRuleTypeEnumMap, json['ruleType'])
  ..fieldList = (json['fieldList'] as List<dynamic>)
      .map((e) => SortFilterEntry.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$TvSortCfgToJson(TvSortCfg instance) => <String, dynamic>{
      'ruleType': _$VisualRuleTypeEnumMap[instance.ruleType]!,
      'fieldList': instance.fieldList.map((e) => e.toJson()).toList(),
    };

TvFilterCfg _$TvFilterCfgFromJson(Map<String, dynamic> json) => TvFilterCfg()
  ..ruleType = $enumDecode(_$VisualRuleTypeEnumMap, json['ruleType'])
  ..fieldList = (json['fieldList'] as List<dynamic>)
      .map((e) => SortFilterEntry.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$TvFilterCfgToJson(TvFilterCfg instance) =>
    <String, dynamic>{
      'ruleType': _$VisualRuleTypeEnumMap[instance.ruleType]!,
      'fieldList': instance.fieldList.map((e) => e.toJson()).toList(),
    };

TvGroupCfg _$TvGroupCfgFromJson(Map<String, dynamic> json) => TvGroupCfg()
  ..ruleType = $enumDecode(_$VisualRuleTypeEnumMap, json['ruleType'])
  ..fieldList = (json['fieldList'] as List<dynamic>)
      .map((e) => GroupCfgEntry.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$TvGroupCfgToJson(TvGroupCfg instance) =>
    <String, dynamic>{
      'ruleType': _$VisualRuleTypeEnumMap[instance.ruleType]!,
      'fieldList': instance.fieldList.map((e) => e.toJson()).toList(),
    };

ShowHideCfg _$ShowHideCfgFromJson(Map<String, dynamic> json) => ShowHideCfg()
  ..ruleType = $enumDecode(_$VisualRuleTypeEnumMap, json['ruleType'])
  ..shouldShow = json['shouldShow'] as bool;

Map<String, dynamic> _$ShowHideCfgToJson(ShowHideCfg instance) =>
    <String, dynamic>{
      'ruleType': _$VisualRuleTypeEnumMap[instance.ruleType]!,
      'shouldShow': instance.shouldShow,
    };
