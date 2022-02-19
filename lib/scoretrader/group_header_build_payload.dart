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
    SortingRules sortAndGroupRules,
  ) {
    // returns a func that creates a GroupHeaderData
    CastRowToSortVal firstValFn = (AssetRowPropertyIfc row) {
      return row.valueExtractor(sortAndGroupRules.item1.colName);
    };

    TvSortCfg? col2Rule = sortAndGroupRules.item2;
    CastRowToSortVal secondValFn = (AssetRowPropertyIfc row) {
      if (col2Rule == null) return '';
      return row.valueExtractor(col2Rule.colName);
    };

    TvSortCfg? col3Rule = sortAndGroupRules.item3;
    CastRowToSortVal thirdValFn = (AssetRowPropertyIfc row) {
      if (col3Rule == null) return '';
      return row.valueExtractor(col3Rule.colName);
    };

    return (TableviewDataRowTuple row) {
      return GroupHeaderData(
        firstValFn(row.item1),
        secondValFn(row.item1),
        thirdValFn(row.item1),
      );
    };
  }

  static SectionSortComparator sortComparator(SortingRules sr) {
    //
    CastRowToSortVal firstValFn = (AssetRowPropertyIfc row) {
      return row.valueExtractor(sr.item1.colName);
    };

    TvSortCfg? col2Rule = sr.item2;
    CastRowToSortVal secondValFn = (AssetRowPropertyIfc row) {
      if (col2Rule == null) return '';
      return row.valueExtractor(col2Rule.colName);
    };

    TvSortCfg? col3Rule = sr.item3;
    CastRowToSortVal thirdValFn = (AssetRowPropertyIfc row) {
      if (col3Rule == null) return '';
      return row.valueExtractor(col3Rule.colName);
    };

    return (TableviewDataRowTuple rec1, TableviewDataRowTuple rec2) {
      //
      var r1v1 = firstValFn(rec1.item1);
      var r2v1 = firstValFn(rec2.item1);

      var r1v2 = secondValFn(rec1.item1);
      var r2v2 = secondValFn(rec2.item1);

      var r1v3 = thirdValFn(rec1.item1);
      var r2v3 = thirdValFn(rec2.item1);

      if (r1v1 != r2v1) return r1v1.compareTo(r2v1);
      if (r1v2 != r2v2) return r1v2.compareTo(r2v2);
      if (r1v3 != r2v3) return r1v3.compareTo(r2v3);
      // all values the same
      return 0;
    };
  }

  @override
  int compareTo(GroupHeaderData other) {
    // add natural sort order to this class
    return _sortKey.compareTo(other._sortKey);
  }

  // static GroupHeaderData get mockRow =>
  //     GroupHeaderData('first', 'second', 'third');
}
