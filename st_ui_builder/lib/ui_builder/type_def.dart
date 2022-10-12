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

typedef DynamicRowBuilder = Widget Function(
  BuildContext,
  TableviewDataRowTuple,
);

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

abstract class StKey {
  const StKey(this._value);

  final String _value;

  String get value => _value;

  @override
  String toString() => value;

  // int get hashCode;
  // bool operator ==(Object other);
  @override
  int get hashCode => value.hashCode;

  @override
  bool operator ==(Object other) {
    return other is StKey &&
        other.runtimeType == runtimeType &&
        other.value == value;
  }
}

// extension StKeyExt1 on StKey {
//   //
//   // @override
//   int get hashCode => value.hashCode;

//   @override
//   bool operator ==(Object other) {
//     return other.runtimeType == runtimeType && other.value == value;
//   }
// }

class AssetKey extends StKey {
  const AssetKey(String value) : super(value);

  @override
  int get hashCode => value.hashCode;

  @override
  bool operator ==(Object other) {
    return other is AssetKey &&
        other.runtimeType == runtimeType &&
        other.value == value;
  }
}

class GameKey extends StKey {
  const GameKey(String value) : super(value);

  @override
  int get hashCode => value.hashCode;

  @override
  bool operator ==(Object other) {
    return other is GameKey &&
        other.runtimeType == runtimeType &&
        other.value == value;
  }
}
