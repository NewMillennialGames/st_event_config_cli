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

  final List<TableviewDataRowTuple> _assetRows;
  final TableviewConfigPayload _cfg;
  GroupedListOrder order = GroupedListOrder.ASC;

  GroupedTableDataMgr(
    this._assetRows,
    this._cfg, {
    bool ascending = true,
  }) : this.order = ascending ? GroupedListOrder.ASC : GroupedListOrder.DESC;

  GetGroupKeyFromRow get groupBy {
    return GroupHeaderData.keyConstructorFromCfg(_cfg.groupByRules);
  }

  //
  GroupSepRowBuilder get groupSeparatorBuilder {
    //
    return (GroupHeaderData _) => TvGroupHeaderSep(GroupHeaderData.mockRow);
  }

  // defining groupHeaderBuilder will cause groupSeparatorBuilder to be ignored
  GroupHeaderBuilder? get groupHeaderBuilder =>
      (AssetRowPropertyIfc _) => TvGroupHeader(GroupHeaderData.mockRow);

  IndexedItemRowBuilder get indexedItemBuilder => (
        BuildContext ctx,
        TableviewDataRowTuple assets,
        int i,
      ) {
        return _cfg.rowConstructor(assets);
      };
  // for sorting sections
  SectionSortComparator get itemComparator => (i1, i2) => 0;
}
