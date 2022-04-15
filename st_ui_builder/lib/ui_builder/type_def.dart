part of StUiController;

// factory function that takes in TableviewDataRowTuple
// and returns the TvRowWidget
typedef TvRowBuilder = Widget Function(TableviewDataRowTuple);
typedef GroupHeaderBuilder = Widget Function(TableviewDataRowTuple);
typedef GroupSepRowBuilder = Widget Function(GroupHeaderData);

typedef RedrawTvCallback = void Function();
typedef SelectedFilterSetter = void Function(String?);

typedef IndexedItemRowBuilder = Widget Function(
  BuildContext,
  TableviewDataRowTuple,
  int,
);

typedef GameKey = String;
// function to return provider
typedef DynRowStateFamProvBuilder = StateProvider<ActiveGameDetails> Function(
    GameKey);
// this is the data sent in to build every table-view row
// ActiveGameDetails controls when row stat changes and row rebuilds
typedef TableviewDataRowTuple = Tuple4<AssetRowPropertyIfc,
    AssetRowPropertyIfc?, GameKey, DynRowStateFamProvBuilder>;

// TODO:  consider passing TableviewDataRowTuple to group functions
// instead of first item in TableviewDataRowTuple.item1
// typedef CastRowToSortVal = String Function(AssetRowPropertyIfc);
typedef GetGroupHeaderLblsFromCompetitionRow = GroupHeaderData Function(
    TableviewDataRowTuple);

typedef SectionSortComparator = int Function(
    TableviewDataRowTuple, TableviewDataRowTuple);

typedef SortValFetcherFunc = Comparable<dynamic> Function(AssetRowPropertyIfc);
typedef SortKeyBuilderFunc = String Function(TableviewDataRowTuple);

typedef GroupComparatorCallback = int Function(
  GroupHeaderData,
  GroupHeaderData,
);
