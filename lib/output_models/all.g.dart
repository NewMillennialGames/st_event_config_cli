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
      evGameAgeOffRule: $enumDecodeNullable(
              _$EvGameAgeOffRuleEnumMap, json['evGameAgeOffRule']) ??
          EvGameAgeOffRule.byEvEliminationStrategy,
      hoursToWaitAfterGameEnds:
          (json['hoursToWaitAfterGameEnds'] as num?)?.toDouble() ?? 0,
      applyMktViewRowStyleToAllScreens:
          json['applyMktViewRowStyleToAllScreens'] as bool? ?? true,
      useAssetShortNameInFilters:
          json['useAssetShortNameInFilters'] as bool? ?? true,
      assetNameDisplayStyle: $enumDecodeNullable(
              _$EvAssetNameDisplayStyleEnumMap,
              json['assetNameDisplayStyle']) ??
          EvAssetNameDisplayStyle.showShortName,
    )..cancelAllRowGroupingLogic =
        json['cancelAllRowGroupingLogic'] as bool? ?? false;

Map<String, dynamic> _$TopEventCfgToJson(TopEventCfg instance) =>
    <String, dynamic>{
      'evTemplateName': instance.evTemplateName,
      'evTemplateDescription': instance.evTemplateDescription,
      'evType': _$EvTypeEnumMap[instance.evType]!,
      'evCompetitorType': _$EvCompetitorTypeEnumMap[instance.evCompetitorType]!,
      'evOpponentType': _$EvOpponentTypeEnumMap[instance.evOpponentType]!,
      'evDuration': _$EvDurationEnumMap[instance.evDuration]!,
      'evEliminationType':
          _$EvEliminationStrategyEnumMap[instance.evEliminationType]!,
      'evGameAgeOffRule': _$EvGameAgeOffRuleEnumMap[instance.evGameAgeOffRule]!,
      'hoursToWaitAfterGameEnds': instance.hoursToWaitAfterGameEnds,
      'applyMktViewRowStyleToAllScreens':
          instance.applyMktViewRowStyleToAllScreens,
      'cancelAllRowGroupingLogic': instance.cancelAllRowGroupingLogic,
      'useAssetShortNameInFilters': instance.useAssetShortNameInFilters,
      'assetNameDisplayStyle':
          _$EvAssetNameDisplayStyleEnumMap[instance.assetNameDisplayStyle]!,
    };

const _$EvTypeEnumMap = {
  EvType.fantasy: 'fantasy',
  EvType.standard: 'standard',
  EvType.future: 'future',
  EvType.future_repriced: 'future_repriced',
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
  EvDuration.calendarScoped: 'calendarScoped',
};

const _$EvEliminationStrategyEnumMap = {
  EvEliminationStrategy.singleGame: 'singleGame',
  EvEliminationStrategy.bestOfN: 'bestOfN',
  EvEliminationStrategy.roundRobin: 'roundRobin',
  EvEliminationStrategy.singleElim: 'singleElim',
  EvEliminationStrategy.doubeElim: 'doubeElim',
  EvEliminationStrategy.audienceVote: 'audienceVote',
  EvEliminationStrategy.never: 'never',
};

const _$EvGameAgeOffRuleEnumMap = {
  EvGameAgeOffRule.whenRoundChanges: 'whenRoundChanges',
  EvGameAgeOffRule.everyWeek: 'everyWeek',
  EvGameAgeOffRule.timeAfterGameEnds: 'timeAfterGameEnds',
  EvGameAgeOffRule.neverAgeOff: 'neverAgeOff',
  EvGameAgeOffRule.byEvEliminationStrategy: 'byEvEliminationStrategy',
  EvGameAgeOffRule.startOfNextGame: 'startOfNextGame',
};

const _$EvAssetNameDisplayStyleEnumMap = {
  EvAssetNameDisplayStyle.showShortName: 'showShortName',
  EvAssetNameDisplayStyle.showLongName: 'showLongName',
  EvAssetNameDisplayStyle.showBothStacked: 'showBothStacked',
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
          .map((k, e) => MapEntry(_$AppScreenEnumMap[k]!, e.toJson())),
    };

const _$AppScreenEnumMap = {
  AppScreen.eventConfiguration: 'eventConfiguration',
  AppScreen.eventSelection: 'eventSelection',
  AppScreen.poolSelection: 'poolSelection',
  AppScreen.marketView: 'marketView',
  AppScreen.socialPools: 'socialPools',
  AppScreen.news: 'news',
  AppScreen.leaderboardTraders: 'leaderboardTraders',
  AppScreen.leaderboardAssets: 'leaderboardAssets',
  AppScreen.portfolioPositions: 'portfolioPositions',
  AppScreen.portfolioHistory: 'portfolioHistory',
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
      'appScreen': _$AppScreenEnumMap[instance.appScreen]!,
      'areaConfig': instance.areaConfig
          .map((k, e) => MapEntry(_$ScreenWidgetAreaEnumMap[k]!, e.toJson())),
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
      'screenArea': _$ScreenWidgetAreaEnumMap[instance.screenArea]!,
      'visCfgForArea': instance.visCfgForArea
          .map((k, e) => MapEntry(_$VisualRuleTypeEnumMap[k]!, e.toJson())),
      'visCfgForSlotsByRuleType': instance.visCfgForSlotsByRuleType.map(
          (k, e) => MapEntry(
              _$VisualRuleTypeEnumMap[k]!,
              e.map((k, e) =>
                  MapEntry(_$ScreenAreaWidgetSlotEnumMap[k]!, e.toJson())))),
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

const _$ScreenAreaWidgetSlotEnumMap = {
  ScreenAreaWidgetSlot.header: 'header',
  ScreenAreaWidgetSlot.footer: 'footer',
  ScreenAreaWidgetSlot.slot1: 'slot1',
  ScreenAreaWidgetSlot.slot2: 'slot2',
  ScreenAreaWidgetSlot.slot3: 'slot3',
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
