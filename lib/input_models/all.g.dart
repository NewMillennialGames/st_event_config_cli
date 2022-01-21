// GENERATED CODE - DO NOT MODIFY BY HAND

part of InputModels;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RuleResponseWrapper _$RuleResponseWrapperFromJson(Map<String, dynamic> json) =>
    RuleResponseWrapper(
      (json['userResponses'] as Map<String, dynamic>).map(
        (k, e) =>
            MapEntry($enumDecode(_$VisRuleQuestTypeEnumMap, k), e as String),
      ),
    );

Map<String, dynamic> _$RuleResponseWrapperToJson(
        RuleResponseWrapper instance) =>
    <String, dynamic>{
      'userResponses': instance.userResponses
          .map((k, e) => MapEntry(_$VisRuleQuestTypeEnumMap[k], e)),
    };

const _$VisRuleQuestTypeEnumMap = {
  VisRuleQuestType.getValueFromTableAndField: 'whichTable',
  VisRuleQuestType.selectFieldForSortOrGroup: 'whichField',
  VisRuleQuestType.specifyPositionInGroup: 'whichLevelPos',
  VisRuleQuestType.setSortOrder: 'isAscending',
  VisRuleQuestType.selectVisualComponentOrStyle: 'whichRowStyle',
  VisRuleQuestType.controlsVisibilityOfAreaOrSlot: 'shouldShow',
};
