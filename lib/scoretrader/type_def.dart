part of StUiController;

typedef TvRowBuilder = Widget Function(StdRowData);

typedef GetGroupKeyFromRow = GroupHeaderData Function(AssetRowPropertyIfc);
typedef GroupHeaderBuilder = Widget Function(AssetRowPropertyIfc);
typedef GroupSepRowBuilder = Widget Function(GroupHeaderData);

typedef IndexedItemRowBuilder = Widget Function(BuildContext, StdRowData, int);
typedef SectionSortComparator = int Function(
    AssetRowPropertyIfc, AssetRowPropertyIfc);

typedef GroupingRules
    = Tuple3<TvSortOrGroupCfg, TvSortOrGroupCfg?, TvSortOrGroupCfg?>;

typedef SortingRules
    = Tuple3<TvSortOrGroupCfg, TvSortOrGroupCfg?, TvSortOrGroupCfg?>;
