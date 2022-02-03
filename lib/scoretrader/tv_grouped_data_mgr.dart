part of StUiController;

/*  GroupHeaderData is an important struct
    it's used for unique ID, sort-order
    and arguments needed to build the Widget UI

    todo: replace Tuple3 with a reall class
*/

class GroupedTableDataMgr {
  /*
    this is the object returned when you want to build
    a table-view with custom grouping, sorting and row-styles

    produces the arguments needed to use the "GroupedListView" package

  designed specifically to work with:
    GroupedListView<RowPropertyInterface, GroupKeyTuple>

  TODO:  all the getters below must be completed to return real methods
  */

  final List<AssetRowPropertyIfc> _elements;
  final TableviewConfigPayload _cfg;
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

  IndexedItemRowBuilder get indexedItemBuilder => (
        BuildContext ctx,
        StdRowData assets,
        int i,
      ) {
        return _cfg.rowConstructor(assets);
      };
  // for sorting sections
  SectionSortComparator get itemComparator => (i1, i2) => 0;
}
