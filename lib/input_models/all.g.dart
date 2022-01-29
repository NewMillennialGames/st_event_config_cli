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
