// GENERATED CODE - DO NOT MODIFY BY HAND

part of OutputModels;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventCfgTree _$EventCfgTreeFromJson(Map<String, dynamic> json) => EventCfgTree(
      json['evTemplateName'] as String,
      json['evTemplateDescription'] as String,
      $enumDecode(_$EvTypeEnumMap, json['evType']),
      evCompetitorType: $enumDecodeNullable(
              _$EvCompetitorTypeEnumMap, json['evCompetitorType']) ??
          EvCompetitorType.team,
      evOpponentType: $enumDecodeNullable(
              _$EvOpponentTypeEnumMap, json['evOpponentType']) ??
          EvOpponentType.sameAsCompetitorType,
      evDuration:
          $enumDecodeNullable(_$EvDurationEnumMap, json['evDuration']) ??
              EvDuration.oneGame,
      evEliminationType: $enumDecodeNullable(
              _$EvEliminationStrategyEnumMap, json['evEliminationType']) ??
          EvEliminationStrategy.roundRobin,
    )..screenConfig = (json['screenConfig'] as Map<String, dynamic>).map(
        (k, e) => MapEntry($enumDecode(_$AppScreenEnumMap, k),
            ScreenCfg.fromJson(e as Map<String, dynamic>)),
      );

Map<String, dynamic> _$EventCfgTreeToJson(EventCfgTree instance) =>
    <String, dynamic>{
      'evTemplateName': instance.evTemplateName,
      'evTemplateDescription': instance.evTemplateDescription,
      'evType': _$EvTypeEnumMap[instance.evType],
      'evCompetitorType': _$EvCompetitorTypeEnumMap[instance.evCompetitorType],
      'evOpponentType': _$EvOpponentTypeEnumMap[instance.evOpponentType],
      'evDuration': _$EvDurationEnumMap[instance.evDuration],
      'evEliminationType':
          _$EvEliminationStrategyEnumMap[instance.evEliminationType],
      'screenConfig': instance.screenConfig
          .map((k, e) => MapEntry(_$AppScreenEnumMap[k], e)),
    };

const _$EvTypeEnumMap = {
  EvType.fantasy: 'fantasy',
  EvType.standard: 'standard',
};

const _$EvCompetitorTypeEnumMap = {
  EvCompetitorType.team: 'team',
  EvCompetitorType.teamPlayer: 'teamPlayer',
  EvCompetitorType.soloPlayer: 'soloPlayer',
  EvCompetitorType.other: 'other',
};

const _$EvOpponentTypeEnumMap = {
  EvOpponentType.sameAsCompetitorType: 'sameAsCompetitorType',
  EvOpponentType.field: 'field',
  EvOpponentType.personalBest: 'personalBest',
};

const _$EvDurationEnumMap = {
  EvDuration.oneGame: 'oneGame',
  EvDuration.tournament: 'tournament',
  EvDuration.season: 'season',
  EvDuration.ongoing: 'ongoing',
};

const _$EvEliminationStrategyEnumMap = {
  EvEliminationStrategy.singleGame: 'singleGame',
  EvEliminationStrategy.bestOfN: 'bestOfN',
  EvEliminationStrategy.roundRobin: 'roundRobin',
  EvEliminationStrategy.singleElim: 'singleElim',
  EvEliminationStrategy.doubeElim: 'doubeElim',
  EvEliminationStrategy.audienceVote: 'audienceVote',
};

const _$AppScreenEnumMap = {
  AppScreen.eventConfiguration: 'eventConfiguration',
  AppScreen.eventSelection: 'eventSelection',
  AppScreen.poolSelection: 'poolSelection',
  AppScreen.marketView: 'marketView',
  AppScreen.socialPools: 'socialPools',
  AppScreen.news: 'news',
  AppScreen.leaderboard: 'leaderboard',
  AppScreen.portfolio: 'portfolio',
  AppScreen.trading: 'trading',
  AppScreen.marketResearch: 'marketResearch',
};

ScreenCfg _$ScreenCfgFromJson(Map<String, dynamic> json) => ScreenCfg(
      $enumDecode(_$AppScreenEnumMap, json['appScreen']),
    )..areaConfig = (json['areaConfig'] as Map<String, dynamic>).map(
        (k, e) => MapEntry($enumDecode(_$ScreenWidgetAreaEnumMap, k),
            ScreenAreaCfg.fromJson(e as Map<String, dynamic>)),
      );

Map<String, dynamic> _$ScreenCfgToJson(ScreenCfg instance) => <String, dynamic>{
      'appScreen': _$AppScreenEnumMap[instance.appScreen],
      'areaConfig': instance.areaConfig
          .map((k, e) => MapEntry(_$ScreenWidgetAreaEnumMap[k], e)),
    };

const _$ScreenWidgetAreaEnumMap = {
  ScreenWidgetArea.navBar: 'navBar',
  ScreenWidgetArea.filterBar: 'filterBar',
  ScreenWidgetArea.header: 'header',
  ScreenWidgetArea.banner: 'banner',
  ScreenWidgetArea.tableview: 'tableview',
  ScreenWidgetArea.footer: 'footer',
};

ScreenAreaCfg _$ScreenAreaCfgFromJson(Map<String, dynamic> json) =>
    ScreenAreaCfg(
      $enumDecode(_$ScreenWidgetAreaEnumMap, json['screenArea']),
    )
      ..visRulesForArea = (json['visRulesForArea'] as Map<String, dynamic>).map(
        (k, e) => MapEntry($enumDecode(_$VisualRuleTypeEnumMap, k),
            SlotOrAreaRuleCfg.fromJson(e as Map<String, dynamic>)),
      )
      ..visConfigBySlotInArea =
          (json['visConfigBySlotInArea'] as Map<String, dynamic>).map(
        (k, e) => MapEntry($enumDecode(_$ScreenAreaWidgetSlotEnumMap, k),
            SlotOrAreaRuleCfg.fromJson(e as Map<String, dynamic>)),
      );

Map<String, dynamic> _$ScreenAreaCfgToJson(ScreenAreaCfg instance) =>
    <String, dynamic>{
      'screenArea': _$ScreenWidgetAreaEnumMap[instance.screenArea],
      'visRulesForArea': instance.visRulesForArea
          .map((k, e) => MapEntry(_$VisualRuleTypeEnumMap[k], e)),
      'visConfigBySlotInArea': instance.visConfigBySlotInArea
          .map((k, e) => MapEntry(_$ScreenAreaWidgetSlotEnumMap[k], e)),
    };

const _$VisualRuleTypeEnumMap = {
  VisualRuleType.sortCfg: 'sortCfg',
  VisualRuleType.groupCfg: 'groupCfg',
  VisualRuleType.filterCfg: 'filterCfg',
  VisualRuleType.styleOrFormat: 'styleOrFormat',
  VisualRuleType.showOrHide: 'showOrHide',
};

const _$ScreenAreaWidgetSlotEnumMap = {
  ScreenAreaWidgetSlot.header: 'header',
  ScreenAreaWidgetSlot.footer: 'footer',
  ScreenAreaWidgetSlot.slot1: 'slot1',
  ScreenAreaWidgetSlot.slot2: 'slot2',
  ScreenAreaWidgetSlot.title: 'title',
  ScreenAreaWidgetSlot.subtitle: 'subtitle',
  ScreenAreaWidgetSlot.bannerUrl: 'bannerUrl',
};

SlotOrAreaRuleCfg _$SlotOrAreaRuleCfgFromJson(Map<String, dynamic> json) =>
    SlotOrAreaRuleCfg(
      $enumDecode(_$VisualRuleTypeEnumMap, json['ruleType']),
      (json['rulesForType'] as List<dynamic>)
          .map((e) => AppVisualRule.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SlotOrAreaRuleCfgToJson(SlotOrAreaRuleCfg instance) =>
    <String, dynamic>{
      'ruleType': _$VisualRuleTypeEnumMap[instance.ruleType],
      'rulesForType': instance.rulesForType,
    };
