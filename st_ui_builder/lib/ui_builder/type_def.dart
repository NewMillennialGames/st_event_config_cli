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

// NIU
typedef GroupComparatorCallback = int Function(
  GroupHeaderData,
  GroupHeaderData,
);
