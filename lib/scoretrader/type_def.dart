part of StUiController;

// all VisualRuleQuestion should come in with these generic types
typedef VisRuleStyleQuest = VisualRuleQuestion<String, RuleResponseBase>;

typedef AddQuestChkCallbk = bool Function(RuleResponseWrapperIfc);
typedef SortingRules = Tuple3<TvSortCfg, TvSortCfg?, TvSortCfg?>;

typedef FilterRules = Tuple3<TvFilterCfg, TvFilterCfg?, TvFilterCfg?>;

//

typedef RuleQuestTypTup = Tuple2<VisualRuleType, VisRuleQuestType>;
