// GENERATED CODE - DO NOT MODIFY BY HAND

part of OutputModels;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TopEventCfg _$TopEventCfgFromJson(Map<String, dynamic> json) => $checkedCreate(
      'TopEventCfg',
      json,
      ($checkedConvert) {
        final val = TopEventCfg(
          $checkedConvert('evTemplateName', (v) => v as String),
          $checkedConvert('evTemplateDescription', (v) => v as String),
          $checkedConvert('evType', (v) => $enumDecode(_$EvTypeEnumMap, v)),
          evCompetitorType: $checkedConvert(
              'evCompetitorType',
              (v) =>
                  $enumDecodeNullable(_$EvCompetitorTypeEnumMap, v) ??
                  EvCompetitorType.team),
          evOpponentType: $checkedConvert(
              'evOpponentType',
              (v) =>
                  $enumDecodeNullable(_$EvOpponentTypeEnumMap, v) ??
                  EvOpponentType.sameAsCompetitorType),
          evDuration: $checkedConvert(
              'evDuration',
              (v) =>
                  $enumDecodeNullable(_$EvDurationEnumMap, v) ??
                  EvDuration.oneGame),
          evEliminationType: $checkedConvert(
              'evEliminationType',
              (v) =>
                  $enumDecodeNullable(_$EvEliminationStrategyEnumMap, v) ??
                  EvEliminationStrategy.roundRobin),
        );
        $checkedConvert('applySameRowStyleToAllScreens',
            (v) => val.applySameRowStyleToAllScreens = v as bool);
        return val;
      },
    );

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

EventCfgTree _$EventCfgTreeFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'EventCfgTree',
      json,
      ($checkedConvert) {
        final val = EventCfgTree(
          $checkedConvert('eventCfg',
              (v) => TopEventCfg.fromJson(v as Map<String, dynamic>)),
        );
        $checkedConvert(
            'screenConfigMap',
            (v) => val.screenConfigMap = (v as Map<String, dynamic>).map(
                  (k, e) => MapEntry($enumDecode(_$AppScreenEnumMap, k),
                      ScreenCfgByArea.fromJson(e as Map<String, dynamic>)),
                ));
        return val;
      },
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
    $checkedCreate(
      'ScreenCfgByArea',
      json,
      ($checkedConvert) {
        final val = ScreenCfgByArea(
          $checkedConvert(
              'appScreen', (v) => $enumDecode(_$AppScreenEnumMap, v)),
          $checkedConvert(
              'areaConfig',
              (v) => (v as Map<String, dynamic>).map(
                    (k, e) => MapEntry(
                        $enumDecode(_$ScreenWidgetAreaEnumMap, k),
                        CfgForAreaAndNestedSlots.fromJson(
                            e as Map<String, dynamic>)),
                  )),
        );
        return val;
      },
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
    $checkedCreate(
      'CfgForAreaAndNestedSlots',
      json,
      ($checkedConvert) {
        final val = CfgForAreaAndNestedSlots(
          $checkedConvert(
              'screenArea', (v) => $enumDecode(_$ScreenWidgetAreaEnumMap, v)),
          $checkedConvert(
              'visCfgForArea',
              (v) => (v as Map<String, dynamic>).map(
                    (k, e) => MapEntry($enumDecode(_$VisualRuleTypeEnumMap, k),
                        SlotOrAreaRuleCfg.fromJson(e as Map<String, dynamic>)),
                  )),
          $checkedConvert(
              'visCfgBySlotInArea',
              (v) => (v as Map<String, dynamic>).map(
                    (k, e) => MapEntry(
                        $enumDecode(_$ScreenAreaWidgetSlotEnumMap, k),
                        SlotOrAreaRuleCfg.fromJson(e as Map<String, dynamic>)),
                  )),
        );
        return val;
      },
    );

Map<String, dynamic> _$CfgForAreaAndNestedSlotsToJson(
        CfgForAreaAndNestedSlots instance) =>
    <String, dynamic>{
      'screenArea': _$ScreenWidgetAreaEnumMap[instance.screenArea],
      'visCfgForArea': instance.visCfgForArea
          .map((k, e) => MapEntry(_$VisualRuleTypeEnumMap[k], e.toJson())),
      'visCfgBySlotInArea': instance.visCfgForSlotsByRuleType.map(
          (k, e) => MapEntry(_$ScreenAreaWidgetSlotEnumMap[k], e.toJson())),
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
    $checkedCreate(
      'SlotOrAreaRuleCfg',
      json,
      ($checkedConvert) {
        final val = SlotOrAreaRuleCfg(
          $checkedConvert(
              'visRuleType', (v) => $enumDecode(_$VisualRuleTypeEnumMap, v)),
          $checkedConvert(
              'visRuleList',
              (v) => (v as List<dynamic>)
                  .map((e) =>
                      RuleResponseBase.fromJson(e as Map<String, dynamic>))
                  .toList()),
        );
        return val;
      },
    );

Map<String, dynamic> _$SlotOrAreaRuleCfgToJson(SlotOrAreaRuleCfg instance) =>
    <String, dynamic>{
      'visRuleType': _$VisualRuleTypeEnumMap[instance.visRuleType],
      'visRuleList': instance.visRuleList.map((e) => e.toJson()).toList(),
    };
