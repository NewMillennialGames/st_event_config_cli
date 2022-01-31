part of StUiController;

typedef GetGroupKeyFromRow = String Function(RowPropertyInterface);
typedef GroupHeaderData = Tuple3<String, String, String>;
typedef GroupHeaderBuilder = Widget Function(RowPropertyInterface);
typedef GroupSepRowBuilder = Widget Function(GroupHeaderData);

typedef IndexedItemRowBuilder = Widget Function(
    BuildContext, RowPropertyInterface, int);
typedef SectionSortComparator = int Function(
    RowPropertyInterface, RowPropertyInterface);

class GroupedListDataContainer {
  /*
  designed to work with:
    GroupedListView<RowPropertyInterface, GroupKeyTuple>

  */

  List<RowPropertyInterface> _elements;
  GroupedListOrder order = GroupedListOrder.ASC;

  GroupedListDataContainer(
    this._elements, {
    bool asc = true,
  }) : this.order = asc ? GroupedListOrder.ASC : GroupedListOrder.DESC;

  GetGroupKeyFromRow get groupBy => (RowPropertyInterface row) => '';
  GroupSepRowBuilder get groupSeparatorBuilder =>
      (GroupHeaderData _) => Widget();
  GroupHeaderBuilder get groupHeaderBuilder =>
      (RowPropertyInterface _) => Widget();

  IndexedItemRowBuilder get itemBuilder =>
      (BuildContext ctx, RowPropertyInterface row, int i) => Widget();
  // for sorting sections
  SectionSortComparator get itemComparator => (i1, i2) => 0;
}
