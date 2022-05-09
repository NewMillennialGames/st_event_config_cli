part of StUiController;

// all VisualRuleQuestion should come in with these generic types
typedef VisRuleStyleQuest = VisualRuleQuestion<String, RuleResponseBase>;

// R&D
typedef CastStrToAnswTypCallback<T> = T Function(String);

typedef AddQuestChkCallbk = bool Function(dynamic);
typedef GroupingRules = Tuple3<TvGroupCfg, TvGroupCfg?, TvGroupCfg?>;
typedef SortingRules = Tuple3<TvSortCfg, TvSortCfg?, TvSortCfg?>;
typedef FilterRules = Tuple3<TvFilterCfg, TvFilterCfg?, TvFilterCfg?>;

//

typedef RuleQuestTypTup = Tuple2<VisualRuleType, VisRuleQuestType>;
