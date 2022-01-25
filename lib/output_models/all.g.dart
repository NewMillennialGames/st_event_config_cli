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
      (json['areaConfig'] as Map<String, dynamic>).map(
        (k, e) => MapEntry($enumDecode(_$ScreenWidgetAreaEnumMap, k),
            ScreenAreaCfg.fromJson(e as Map<String, dynamic>)),
      ),
      (json['slotConfig'] as Map<String, dynamic>).map(
        (k, e) => MapEntry($enumDecode(_$ScreenWidgetAreaEnumMap, k),
            SlotOrAreaRuleCfg.fromJson(e as Map<String, dynamic>)),
      ),
    );

Map<String, dynamic> _$ScreenCfgToJson(ScreenCfg instance) => <String, dynamic>{
      'appScreen': _$AppScreenEnumMap[instance.appScreen],
      'areaConfig': instance.areaConfig
          .map((k, e) => MapEntry(_$ScreenWidgetAreaEnumMap[k], e)),
      'slotConfig': instance.slotConfig
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
      $enumDecode(_$ScreenWidgetAreaEnumMap, json['sectionComponent']),
      (json['uiCfgByApplicableRules'] as Map<String, dynamic>).map(
        (k, e) => MapEntry($enumDecode(_$VisualRuleTypeEnumMap, k),
            SlotOrAreaRuleCfg.fromJson(e as Map<String, dynamic>)),
      ),
    );

Map<String, dynamic> _$ScreenAreaCfgToJson(ScreenAreaCfg instance) =>
    <String, dynamic>{
      'sectionComponent': _$ScreenWidgetAreaEnumMap[instance.sectionComponent],
      'uiCfgByApplicableRules': instance.uiCfgByApplicableRules
          .map((k, e) => MapEntry(_$VisualRuleTypeEnumMap[k], e)),
    };

const _$VisualRuleTypeEnumMap = {
  VisualRuleType.sortCfg: 'sortCfg',
  VisualRuleType.groupCfg: 'groupCfg',
  VisualRuleType.filterCfg: 'filterCfg',
  VisualRuleType.styleOrFormat: 'styleOrFormat',
  VisualRuleType.showOrHide: 'showOrHide',
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
