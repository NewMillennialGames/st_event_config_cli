// GENERATED CODE - DO NOT MODIFY BY HAND

part of EventCfgModels;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FilterRule _$FilterRuleFromJson(Map<String, dynamic> json) => FilterRule(
      $enumDecode(_$EvRecordTypeEnumMap, json['recType']),
      json['propertyName'] as String,
      listIdx: json['listIdx'] as int? ?? 1,
      sortDescending: json['sortDescending'] as bool? ?? true,
    );

Map<String, dynamic> _$FilterRuleToJson(FilterRule instance) =>
    <String, dynamic>{
      'recType': _$EvRecordTypeEnumMap[instance.recType],
      'propertyName': instance.propertyName,
      'listIdx': instance.listIdx,
      'sortDescending': instance.sortDescending,
    };

const _$EvRecordTypeEnumMap = {
  EvRecordType.assetTeamMember: 'assetTeamMember',
  EvRecordType.assetTeam: 'assetTeam',
  EvRecordType.assetSolo: 'assetSolo',
  EvRecordType.game: 'game',
  EvRecordType.competition: 'competition',
  EvRecordType.event: 'event',
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
