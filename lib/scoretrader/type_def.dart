part of StUiController;

// all VisualRuleQuestion should come in with these generic types
typedef VisRuleStyleQuest = VisualRuleQuestion<String, RuleResponseBase>;

// this is the data sent in to build every table-view row
typedef TableviewDataRowTuple
    = Tuple3<AssetRowPropertyIfc, AssetRowPropertyIfc?, String?>;

// TODO:  consider passing TableviewDataRowTuple to group functions
// instead of first item in TableviewDataRowTuple.item1
typedef CastRowToSortVal = String Function(AssetRowPropertyIfc);
typedef GetGroupKeyFromRow = GroupHeaderData Function(TableviewDataRowTuple);

typedef SectionSortComparator = int Function(
    TableviewDataRowTuple, TableviewDataRowTuple);

// typedef GroupingRules = Tuple3<TvGroupCfg, TvGroupCfg?, TvGroupCfg?>;

typedef SortingRules = Tuple3<TvSortCfg, TvSortCfg?, TvSortCfg?>;

typedef FilterRules = Tuple3<TvFilterCfg, TvFilterCfg?, TvFilterCfg?>;

//
typedef AddQuestChkCallbk = bool Function(RuleResponseWrapperIfc);
