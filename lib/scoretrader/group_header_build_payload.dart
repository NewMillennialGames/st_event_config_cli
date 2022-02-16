part of StUiController;

/*
  StdRowData is what to pass to every row to construct it

  two item rows will fill slots 1 & 2
  single items rows will just have 1st value

  third value is extra
*/

class GroupHeaderData implements Comparable<GroupHeaderData> {
  final String first;
  final String second;
  final String third;
  final String _sortKey;

  GroupHeaderData(
    this.first,
    this.second,
    this.third,
  ) : this._sortKey = '$first-$second-$third';

  static GetGroupKeyFromRow keyConstructorFromCfg(
    SortingRules groupingRules,
  ) {
    // returns a func that creates a GroupHeaderData
    CastRowToSortVal firstValFn = (AssetRowPropertyIfc row) {
      return row.valueExtractor(groupingRules.item1.colName);
    };

    CastRowToSortVal secondValFn = (AssetRowPropertyIfc row) {
      TvSortCfg? col2Rule = groupingRules.item2;
      if (col2Rule == null) return '';
      return row.valueExtractor(col2Rule.colName);
    };

    CastRowToSortVal thirdValFn = (AssetRowPropertyIfc row) {
      TvSortCfg? col3Rule = groupingRules.item3;
      if (col3Rule == null) return '';
      return row.valueExtractor(col3Rule.colName);
    };

    return (TableviewDataRowTuple row) {
      return GroupHeaderData(
          firstValFn(row.item1), secondValFn(row.item1), thirdValFn(row.item1));
    };
  }

  @override
  int compareTo(GroupHeaderData other) {
    // add natural sort order to this class
    return _sortKey.compareTo(other._sortKey);
  }

  static GroupHeaderData get mockRow =>
      GroupHeaderData('first', 'second', 'third');
}
