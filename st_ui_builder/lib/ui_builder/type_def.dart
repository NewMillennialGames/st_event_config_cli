part of StUiController;

// factory function that takes in TableviewDataRowTuple
// and returns the TvRowWidget
typedef TvRowBuilder = Widget Function(TableviewDataRowTuple);
typedef GroupHeaderBuilder = Widget Function(TableviewDataRowTuple);
typedef GroupSepRowBuilder = Widget Function(GroupHeaderData);

typedef IndexedItemRowBuilder = Widget Function(
  BuildContext,
  TableviewDataRowTuple,
  int,
);
