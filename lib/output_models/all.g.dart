// GENERATED CODE - DO NOT MODIFY BY HAND

part of OutputModels;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TopEventCfg _$TopEventCfgFromJson(Map<String, dynamic> json) => TopEventCfg(
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
    )..applySameRowStyleToAllScreens =
        json['applySameRowStyleToAllScreens'] as bool;

Map<String, dynamic> _$TopEventCfgToJson(TopEventCfg instance) =>
    <String, dynamic>{
      'evTemplateName': instance.evTemplateName,
      'evTemplateDescription': instance.evTemplateDescription,
      'evType': _$EvTypeEnumMap[instance.evType],
      'evCompetitorType': _$EvCompetitorTypeEnumMap[instance.evCompetitorType],
      'evOpponentType': _$EvOpponentTypeEnumMap[instance.evOpponentType],
      'evDuration': _$EvDurationEnumMap[instance.evDuration],
      'evEliminationType':
          _$EvEliminationStrategyEnumMap[instance.evEliminationType],
      'applySameRowStyleToAllScreens': instance.applySameRowStyleToAllScreens,
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

EventCfgTree _$EventCfgTreeFromJson(Map<String, dynamic> json) => EventCfgTree(
      TopEventCfg.fromJson(json['eventCfg'] as Map<String, dynamic>),
      (json['screenConfigMap'] as Map<String, dynamic>).map(
        (k, e) => MapEntry($enumDecode(_$AppScreenEnumMap, k),
            ScreenCfgByArea.fromJson(e as Map<String, dynamic>)),
      ),
    );

Map<String, dynamic> _$EventCfgTreeToJson(EventCfgTree instance) =>
    <String, dynamic>{
      'eventCfg': instance.eventCfg.toJson(),
      'screenConfigMap': instance.screenConfigMap
          .map((k, e) => MapEntry(_$AppScreenEnumMap[k], e.toJson())),
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

ScreenCfgByArea _$ScreenCfgByAreaFromJson(Map<String, dynamic> json) =>
    ScreenCfgByArea(
      $enumDecode(_$AppScreenEnumMap, json['appScreen']),
      (json['areaConfig'] as Map<String, dynamic>).map(
        (k, e) => MapEntry($enumDecode(_$ScreenWidgetAreaEnumMap, k),
            CfgForAreaAndNestedSlots.fromJson(e as Map<String, dynamic>)),
      ),
    );

Map<String, dynamic> _$ScreenCfgByAreaToJson(ScreenCfgByArea instance) =>
    <String, dynamic>{
      'appScreen': _$AppScreenEnumMap[instance.appScreen],
      'areaConfig': instance.areaConfig
          .map((k, e) => MapEntry(_$ScreenWidgetAreaEnumMap[k], e.toJson())),
    };

const _$ScreenWidgetAreaEnumMap = {
  ScreenWidgetArea.navBar: 'navBar',
  ScreenWidgetArea.filterBar: 'filterBar',
  ScreenWidgetArea.header: 'header',
  ScreenWidgetArea.banner: 'banner',
  ScreenWidgetArea.tableview: 'tableview',
  ScreenWidgetArea.footer: 'footer',
};

CfgForAreaAndNestedSlots _$CfgForAreaAndNestedSlotsFromJson(
        Map<String, dynamic> json) =>
    CfgForAreaAndNestedSlots(
      $enumDecode(_$ScreenWidgetAreaEnumMap, json['screenArea']),
      (json['visCfgForArea'] as Map<String, dynamic>).map(
        (k, e) => MapEntry($enumDecode(_$VisualRuleTypeEnumMap, k),
            SlotOrAreaRuleCfg.fromJson(e as Map<String, dynamic>)),
      ),
      (json['visCfgForSlotsByRuleType'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(
            $enumDecode(_$VisualRuleTypeEnumMap, k),
            (e as Map<String, dynamic>).map(
              (k, e) => MapEntry($enumDecode(_$ScreenAreaWidgetSlotEnumMap, k),
                  SlotOrAreaRuleCfg.fromJson(e as Map<String, dynamic>)),
            )),
      ),
    );

Map<String, dynamic> _$CfgForAreaAndNestedSlotsToJson(
        CfgForAreaAndNestedSlots instance) =>
    <String, dynamic>{
      'screenArea': _$ScreenWidgetAreaEnumMap[instance.screenArea],
      'visCfgForArea': instance.visCfgForArea
          .map((k, e) => MapEntry(_$VisualRuleTypeEnumMap[k], e.toJson())),
      'visCfgForSlotsByRuleType': instance.visCfgForSlotsByRuleType.map(
          (k, e) => MapEntry(
              _$VisualRuleTypeEnumMap[k],
              e.map((k, e) =>
                  MapEntry(_$ScreenAreaWidgetSlotEnumMap[k], e.toJson())))),
    };

const _$VisualRuleTypeEnumMap = {
  VisualRuleType.sortCfg: 'sortCfg',
  VisualRuleType.filterCfg: 'filterCfg',
  VisualRuleType.styleOrFormat: 'styleOrFormat',
  VisualRuleType.showOrHide: 'showOrHide',
};

const _$ScreenAreaWidgetSlotEnumMap = {
  ScreenAreaWidgetSlot.header: 'header',
  ScreenAreaWidgetSlot.footer: 'footer',
  ScreenAreaWidgetSlot.menuSortPosOrSlot1: 'menuSortPosOrSlot1',
  ScreenAreaWidgetSlot.menuSortPosOrSlot2: 'menuSortPosOrSlot2',
  ScreenAreaWidgetSlot.menuSortPosOrSlot3: 'menuSortPosOrSlot3',
  ScreenAreaWidgetSlot.title: 'title',
  ScreenAreaWidgetSlot.subtitle: 'subtitle',
  ScreenAreaWidgetSlot.bannerUrl: 'bannerUrl',
};

SlotOrAreaRuleCfg _$SlotOrAreaRuleCfgFromJson(Map<String, dynamic> json) =>
    SlotOrAreaRuleCfg(
      (json['visRuleList'] as List<dynamic>)
          .map((e) => RuleResponseBase.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SlotOrAreaRuleCfgToJson(SlotOrAreaRuleCfg instance) =>
    <String, dynamic>{
      'visRuleList': instance.visRuleList.map((e) => e.toJson()).toList(),
    };
