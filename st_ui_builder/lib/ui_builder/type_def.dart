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

// this is the data sent in to build every table-view row
typedef TableviewDataRowTuple
    = Tuple3<AssetRowPropertyIfc, AssetRowPropertyIfc?, ActiveGameDetails>;

// TODO:  consider passing TableviewDataRowTuple to group functions
// instead of first item in TableviewDataRowTuple.item1
typedef CastRowToSortVal = String Function(AssetRowPropertyIfc);
typedef GetGroupKeyFromRow = GroupHeaderData Function(TableviewDataRowTuple);

typedef SectionSortComparator = int Function(
    TableviewDataRowTuple, TableviewDataRowTuple);

// NIU
typedef GroupComparatorCallback = int Function(
  GroupHeaderData,
  GroupHeaderData,
);
