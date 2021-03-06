part of StUiController;

/*
  GroupHeaderData contains values to:
    Create distinct groups of rows in the table view
    Sort those groups within the table-view
    provide data to build the header-row Widgets in the table-view
*/

class GroupHeaderData
    with EquatableMixin
    implements Comparable<GroupHeaderData> {
  final String h1Displ;
  final String h2Displ;
  final String h3Displ;
  final String _sortKey;
  final bool isAscending;

  GroupHeaderData(
    this.h1Displ,
    this.h2Displ,
    this.h3Displ,
    String sortKey, {
    this.isAscending = true,
  }) : _sortKey = sortKey.toLowerCase();

  static GetGroupHeaderLblsFromCompetitionRow groupHeaderPayloadConstructor(
    SortingRules sortAndGroupRules,
  ) {
    // returns a func that creates a GroupHeaderData
    // NOT the sort values (comparables) used in sortComparator below

    firstLabelFn(AssetRowPropertyIfc row) {
      return row.labelExtractor(sortAndGroupRules.item1.colName);
    }

    TvSortCfg? col2Rule = sortAndGroupRules.item2;
    // CastRowToSortVal
    secondLabelFn(AssetRowPropertyIfc row) {
      if (col2Rule == null) return '';
      return row.labelExtractor(col2Rule.colName);
    }

    TvSortCfg? col3Rule = sortAndGroupRules.item3;
    // CastRowToSortVal
    thirdLabelFn(AssetRowPropertyIfc row) {
      if (col3Rule == null) return '';
      return row.labelExtractor(col3Rule.colName);
    }

    // sorting functions
    firstValFn(AssetRowPropertyIfc row) {
      return row.sortValueExtractor(sortAndGroupRules.item1.colName);
    }

    // CastRowToSortVal
    secondValFn(AssetRowPropertyIfc row) {
      if (col2Rule == null) return '';
      return row.sortValueExtractor(col2Rule.colName);
    }

    // CastRowToSortVal
    thirdValFn(AssetRowPropertyIfc row) {
      if (col3Rule == null) return '';
      return row.sortValueExtractor(col3Rule.colName);
    }

    // sorting happens from vals on Game or first asset (2nd asset ignored)
    SortKeyBuilderFunc sortKeyFunction = _sortKeyBuilderFnc(
      firstValFn,
      secondValFn,
      thirdValFn,
    );

    return (TableviewDataRowTuple row) {
      return GroupHeaderData(
        firstLabelFn(row.item1),
        col2Rule == null ? '' : secondLabelFn(row.item1),
        col3Rule == null ? '' : thirdLabelFn(row.item1),
        sortKeyFunction(row),
      );
    };
  }

  static SortKeyBuilderFunc _sortKeyBuilderFnc(
    SortValFetcherFunc sVal1,
    SortValFetcherFunc sVal2,
    SortValFetcherFunc sVal3,
  ) {
    return (TableviewDataRowTuple r) {
      // temp debug code to see values
      Comparable<dynamic> cd1 = sVal1(r.item1);
      var cd2 = sVal2(r.item1);
      var cd3 = sVal3(r.item1);

      Comparable<dynamic> v1 =
          (cd1 is DateTime) ? cd1.truncateTime.microsecondsSinceEpoch : cd1;
      var v2 =
          (cd2 is DateTime) ? cd2.truncateTime.microsecondsSinceEpoch : cd2;
      var v3 =
          (cd3 is DateTime) ? cd3.truncateTime.microsecondsSinceEpoch : cd3;

      String _sortKey =
          v1.toString() + '_' + v2.toString() + '_' + v3.toString();

      // print(
      //   '${cd1.runtimeType} ${cd1 is DateTime}  ${cd1 is Comparable<DateTime>}',
      // );
      // print('_sortKey: $_sortKey');
      return _sortKey;

      // use this after debug completed
      // return sVal1(r.item1).toString() +
      //     '_' +
      //     sVal2(r.item1).toString() +
      //     '_' +
      //     sVal3(r.item1).toString();
    };
  }

  static SectionSortComparator sortComparator(
    SortingRules sr, [
    bool sortAsc = false,
  ]) {
    // return the function that performs the sorting logic
    // WITHIN groups;  this does NOT sort-order the groups
    // GroupHeaderData (comparable._sortKey) controls groups
    firstValFn(AssetRowPropertyIfc row) {
      return row.sortValueExtractor(sr.item1.colName);
    }

    TvSortCfg? col2Rule = sr.item2;
    // CastRowToSortVal
    secondValFn(AssetRowPropertyIfc row) {
      if (col2Rule == null) return '';
      return row.sortValueExtractor(col2Rule.colName);
    }

    TvSortCfg? col3Rule = sr.item3;
    // CastRowToSortVal
    thirdValFn(AssetRowPropertyIfc row) {
      if (col3Rule == null) return '';
      return row.sortValueExtractor(col3Rule.colName);
    }

    return (TableviewDataRowTuple rec1, TableviewDataRowTuple rec2) {
      // works off the 1st asset or game (2nd asset is ignored)
      Comparable row1SortVal1 = firstValFn(rec1.item1);
      var r2v1 = firstValFn(rec2.item1);
      int comp1;
      if (sortAsc) {
        comp1 = row1SortVal1.compareTo(r2v1);
      } else {
        comp1 = r2v1.compareTo(row1SortVal1);
      }
      if (comp1 != 0 || col2Rule == null) return comp1;

      Comparable r1v2 = secondValFn(rec1.item1);
      Comparable r2v2 = secondValFn(rec2.item1);
      int comp2;
      if (sortAsc) {
        comp2 = r1v2.compareTo(r2v2);
      } else {
        comp2 = r2v2.compareTo(r1v2);
      }
      if (comp2 != 0 || col3Rule == null) return comp2;

      Comparable r1v3 = thirdValFn(rec1.item1);
      Comparable r2v3 = thirdValFn(rec2.item1);
      if (sortAsc) {
        return r1v3.compareTo(r2v3);
      } else {
        return r2v3.compareTo(r1v3);
      }
    };
  }

  @override
  int compareTo(GroupHeaderData other) {
    // add natural sort order to this class
    if (isAscending) {
      return _sortKey.compareTo(other._sortKey);
    } else {
      return other._sortKey.compareTo(_sortKey);
    }
  }

  @override
  List<Object?> get props => [_sortKey];

  // static GroupHeaderData get mockRow =>
  //     GroupHeaderData('first', 'second', 'third');
}
