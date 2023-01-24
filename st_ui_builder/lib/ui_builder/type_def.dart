part of StUiController;

// factory function that takes in TableviewDataRowTuple
// and returns the TvRowWidget
typedef TvRowBuilder = Widget Function(
  TvRowDataContainer, {
  Function(TvRowDataContainer)? onTap,
});
typedef GroupHeaderWidgetBuilder = Widget Function(TvRowDataContainer);
typedef GroupSepRowBuilder = Widget Function(GroupHeaderData);

typedef RedrawTvCallback = void Function();
typedef SelectedFilterSetter = void Function(String?);

typedef IndexedItemRowBuilder = Widget Function(
  BuildContext,
  TvRowDataContainer,
  int, {
  Function(TvRowDataContainer)? onTap,
});

typedef NoAssetsIndexedItemRowBuilder = Widget Function(
  BuildContext,
  int, {
  Function(TvRowDataContainer)? onTap,
});

typedef DynamicRowBuilder = Widget Function(
  BuildContext,
  TvRowDataContainer, {
  Function(TvRowDataContainer)? onTap,
});

// function to return provider
typedef DynRowStateFamProvBuilder = StateProvider<ActiveGameDetails> Function(
    GameKey);
// this is the data sent in to build every table-view row
// ActiveGameDetails controls when row stat changes and row rebuilds
// typedef TvRowDataContainer = Tuple4<AssetRowPropertyIfc, AssetRowPropertyIfc?,
//     GameKey, DynRowStateFamProvBuilder>;

class TvRowDataContainer {
  /* replace of Tuple4 w actual class

  */
  AssetRowPropertyIfc team1;
  AssetRowPropertyIfc? team2;
  GameKey gameKey;
  DynRowStateFamProvBuilder rowStateProvBuilder;
  TvRowDataContainer(
    this.team1,
    this.team2,
    this.gameKey,
    this.rowStateProvBuilder,
  );

  // temp leaving old property names in case host app uses them
  // AssetRowPropertyIfc get item1 => team1;
  // AssetRowPropertyIfc? get item2 => team2;
  // GameKey get item3 => gameKey;
  // DynRowStateFamProvBuilder get item4 => rowStateProvBuilder;
}

// TODO:  consider passing TableviewDataRowTuple to group functions
// instead of first item in TableviewDataRowTuple.item1
// typedef CastRowToSortVal = String Function(AssetRowPropertyIfc);
typedef GetGroupHeaderLblsFromAssetGameData = GroupHeaderData Function(
    TvRowDataContainer);

typedef ConfigDefinedSortComparator = int Function(
    TvRowDataContainer, TvRowDataContainer);

typedef SortValFetcherFunc = Comparable<dynamic> Function(AssetRowPropertyIfc);
typedef SortKeyBuilderFunc = String Function(TvRowDataContainer);

typedef GroupHeaderSortCompareCallback = int Function(
  GroupHeaderData,
  GroupHeaderData,
);

abstract class StKey {
  const StKey(this._value);

  final String _value;

  String get value => _value;

  @override
  String toString() => value;

  @override
  int get hashCode => value.hashCode;

  @override
  bool operator ==(Object other) {
    return other is StKey &&
        other.runtimeType == runtimeType &&
        other.value == value;
  }
}

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
