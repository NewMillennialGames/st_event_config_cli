part of StUiController;

/*  GroupHeaderData is an important struct
    it's used for unique ID, sort-order
    and arguments needed to build the Widget UI

    todo: replace Tuple3 with a reall class
*/
typedef GroupHeaderData = Tuple3<String, String, String>;

typedef GetGroupKeyFromRow = GroupHeaderData Function(AssetRowPropertyIfc);
typedef GroupHeaderBuilder = Widget Function(AssetRowPropertyIfc);
typedef GroupSepRowBuilder = Widget Function(GroupHeaderData);

typedef IndexedItemRowBuilder = Widget Function(
    BuildContext, AssetRowPropertyIfc, int);
typedef SectionSortComparator = int Function(
    AssetRowPropertyIfc, AssetRowPropertyIfc);

class GroupedTableDataMgr {
  /*
    this is the object returned when you want to build
    a table-view with custom grouping, sorting and row-styles

  designed specifically to work with:
    GroupedListView<RowPropertyInterface, GroupKeyTuple>

  TODO:  all the getters below must be completed to return real methods
  */

  List<AssetRowPropertyIfc> _elements;
  TableConfigPayload _cfg;
  GroupedListOrder order = GroupedListOrder.ASC;

  GroupedTableDataMgr(
    this._elements,
    this._cfg, {
    bool asc = true,
  }) : this.order = asc ? GroupedListOrder.ASC : GroupedListOrder.DESC;

  GetGroupKeyFromRow get groupBy =>
      (AssetRowPropertyIfc row) => GroupHeaderData('', '', '');
  //
  GroupSepRowBuilder get groupSeparatorBuilder =>
      (GroupHeaderData _) => Widget();

  // defining groupHeaderBuilder will cause groupSeparatorBuilder to be ignored
  GroupHeaderBuilder? get groupHeaderBuilder =>
      (AssetRowPropertyIfc _) => Widget();

  IndexedItemRowBuilder get indexedItemBuilder =>
      (BuildContext ctx, AssetRowPropertyIfc row, int i) => Widget();
  // for sorting sections
  SectionSortComparator get itemComparator => (i1, i2) => 0;
}
