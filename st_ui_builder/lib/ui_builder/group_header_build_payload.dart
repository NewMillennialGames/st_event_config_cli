part of StUiController;

/*
  StdRowData is what to pass to every row to construct it

  two item rows will fill slots 1 & 2
  single items rows will just have 1st value

  third value is extra
*/

class GroupHeaderData
    with EquatableMixin
    implements Comparable<GroupHeaderData> {
  final String h1Displ;
  final String h2Displ;
  final String h3Displ;
  final String _sortKey;

  GroupHeaderData(
    this.h1Displ,
    this.h2Displ,
    this.h3Displ,
  ) : _sortKey =
            '${h1Displ.toLowerCase()}-${h2Displ.toLowerCase()}-${h3Displ.toLowerCase()}';

  static GetGroupKeyFromRow groupKeyDataConstructorFromCfg(
    SortingRules sortAndGroupRules,
  ) {
    // returns a func that creates a GroupHeaderData
    // CastRowToSortVal
    firstValFn(AssetRowPropertyIfc row) {
      return row.valueExtractor(sortAndGroupRules.item1.colName);
    }

    ;

    TvSortCfg? col2Rule = sortAndGroupRules.item2;
    // CastRowToSortVal
    secondValFn(AssetRowPropertyIfc row) {
      if (col2Rule == null) return '';
      return row.valueExtractor(col2Rule.colName);
    }

    ;

    TvSortCfg? col3Rule = sortAndGroupRules.item3;
    // CastRowToSortVal
    thirdValFn(AssetRowPropertyIfc row) {
      if (col3Rule == null) return '';
      return row.valueExtractor(col3Rule.colName);
    }

    ;

    return (TableviewDataRowTuple row) {
      return GroupHeaderData(
        firstValFn(row.item1),
        col2Rule == null ? '' : secondValFn(row.item1),
        col3Rule == null ? '' : thirdValFn(row.item1),
      );
    };
  }

  static SectionSortComparator sortComparator(
    SortingRules sr, [
    bool sortAsc = false,
  ]) {
    //
    // CastRowToSortVal
    firstValFn(AssetRowPropertyIfc row) {
      return row.valueExtractor(sr.item1.colName);
    }

    TvSortCfg? col2Rule = sr.item2;
    // CastRowToSortVal
    secondValFn(AssetRowPropertyIfc row) {
      if (col2Rule == null) return '';
      return row.valueExtractor(col2Rule.colName);
    }

    TvSortCfg? col3Rule = sr.item3;
    // CastRowToSortVal
    thirdValFn(AssetRowPropertyIfc row) {
      if (col3Rule == null) return '';
      return row.valueExtractor(col3Rule.colName);
    }

    return (TableviewDataRowTuple rec1, TableviewDataRowTuple rec2) {
      //
      var row1SortVal1 = firstValFn(rec1.item1);
      var r2v1 = firstValFn(rec2.item1);
      int comp1;
      if (sortAsc) {
        comp1 = r2v1.compareTo(row1SortVal1);
      } else {
        comp1 = row1SortVal1.compareTo(r2v1);
      }
      if (comp1 != 0 || col2Rule == null) return comp1;

      var r1v2 = secondValFn(rec1.item1);
      var r2v2 = secondValFn(rec2.item1);
      int comp2;
      if (sortAsc) {
        comp2 = r2v2.compareTo(r1v2);
      } else {
        comp2 = r1v2.compareTo(r2v2);
      }
      if (comp2 != 0 || col3Rule == null) return comp2;

      var r1v3 = thirdValFn(rec1.item1);
      var r2v3 = thirdValFn(rec2.item1);
      if (sortAsc) {
        return r2v3.compareTo(r1v3);
      } else {
        return r1v3.compareTo(r2v3);
      }
    };
  }

  @override
  int compareTo(GroupHeaderData other) {
    // add natural sort order to this class
    // var ct = _sortKey.compareTo(other._sortKey);
    // print(
    //   '### calling GroupHeaderData compareTo ...$ct from $_sortKey vs ${other._sortKey}',
    // );
    return _sortKey.compareTo(other._sortKey);
  }

  @override
  List<Object?> get props => [_sortKey];

  // static GroupHeaderData get mockRow =>
  //     GroupHeaderData('first', 'second', 'third');
}
