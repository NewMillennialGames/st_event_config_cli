part of StUiController;

/*
  GroupHeaderData contains values to:
    Create distinct groups of rows in the table view
    Sort those groups within the table-view
    provide data to build the header-row Widgets in the table-view
*/
class GroupHeaderMetaCfg {
  // meta-data for ALL grouped header rows
  final int groupLevelCount;
  final bool topIsCollapsible;
  final GroupedListOrder topSortOrder;
  final DisplayJustification h1DisplayJust;
  final DisplayJustification? h2DisplayJust;
  final DisplayJustification? h3DisplayJust;

  GroupHeaderMetaCfg(
    this.topIsCollapsible,
    this.topSortOrder, {
    this.h1DisplayJust = DisplayJustification.center,
    this.h2DisplayJust,
    this.h3DisplayJust,
  }) : groupLevelCount = 1;

  static GroupHeaderMetaCfg noop() {
    return GroupHeaderMetaCfg(
      false,
      GroupedListOrder.ASC,
      h1DisplayJust: DisplayJustification.center,
    );
  }
}

class GroupHeaderData
    with EquatableMixin
    implements Comparable<GroupHeaderData> {
  //
  final GroupHeaderMetaCfg metaCfg;
  final String h1Displ;
  final String h2Displ;
  final String h3Displ;
  final String _sortKey;
  final bool topSortAscending;

  GroupHeaderData._(
    this.metaCfg,
    this.h1Displ,
    this.h2Displ,
    this.h3Displ,
    String sortKey, {
    this.topSortAscending = true,
  }) : _sortKey = sortKey.toLowerCase();

  // metaCfg property getters
  int get groupLevelCount => metaCfg.groupLevelCount;
  bool get topIsCollapsible => metaCfg.topIsCollapsible;
  GroupedListOrder get topSortOrder => metaCfg.topSortOrder;
  DisplayJustification get h1DisplayJust => metaCfg.h1DisplayJust;
  DisplayJustification? get h2DisplayJust => metaCfg.h2DisplayJust;
  DisplayJustification? get h3DisplayJust => metaCfg.h3DisplayJust;

  static GroupHeaderData noop() {
    return GroupHeaderData._(GroupHeaderMetaCfg.noop(), '', '', '', '',
        topSortAscending: false);
  }

  static GetGroupHeaderLblsFromAssetGameData groupHeaderPayloadConstructor(
      TvGroupCfg groupingRules,
      GroupHeaderMetaCfg metaCfg,
      bool assetTypeIsTeam) {
    // returns a func that creates a GroupHeaderData
    // NOT the sort values (comparables) used in sortComparator below

    String firstHeaderLblFn(AssetRowPropertyIfc row) {
      if (groupingRules.item1 == null) return 'H1';
      return row.valueExtractor(groupingRules.item1!.colName);
    }

    GroupCfgEntry? col2Rule = groupingRules.item2;
    assert(col2Rule != null || metaCfg.groupLevelCount < 2, "oops");
    // CastRowToSortVal
    String secondLabelFn(AssetRowPropertyIfc row) {
      if (col2Rule == null) return 'H2';
      return row.valueExtractor(col2Rule.colName);
    }

    GroupCfgEntry? col3Rule = groupingRules.item3;
    assert(col3Rule != null || metaCfg.groupLevelCount < 3, "oops");
    // CastRowToSortVal
    String thirdLabelFn(AssetRowPropertyIfc row) {
      if (col3Rule == null) return 'H3';
      return row.valueExtractor(col3Rule.colName);
    }

    // sorting functions
    firstValFn(AssetRowPropertyIfc row) {
      if (groupingRules.item1 == null) return '';
      return row.sortValueExtractor(groupingRules.item1!.colName);
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

    // sorting happens from vals on Game or first asset (2nd asset ignored when 2)
    SortKeyBuilderFunc sortKeyGenFunction = _sortKeyBuilderFnc(
      firstValFn,
      secondValFn,
      thirdValFn,
    );

    return (TableviewDataRowTuple assetDataRow) {
      // build data payload to use in group header sorting & display
      // ui builder supports up to 3 levels of grouping
      return GroupHeaderData._(
        metaCfg,
        firstHeaderLblFn(assetDataRow.item1),
        col2Rule == null ? '' : secondLabelFn(assetDataRow.item1),
        col3Rule == null ? '' : thirdLabelFn(assetDataRow.item1),
        sortKeyGenFunction(assetDataRow),
      );
    };
  }

  static SortKeyBuilderFunc _sortKeyBuilderFnc(
    SortValFetcherFunc sVal1,
    SortValFetcherFunc sVal2,
    SortValFetcherFunc sVal3,
  ) {
    // return function to generate sort-key for GroupHeaderData
    return (TableviewDataRowTuple r) {
      // temp debug code to see values
      Comparable<dynamic> cd1 = sVal1(r.item1);
      Comparable<dynamic> cd2 = sVal2(r.item1);
      Comparable<dynamic> cd3 = sVal3(r.item1);

      Comparable<dynamic> v1 =
          (cd1 is DateTime) ? cd1.truncateTime.microsecondsSinceEpoch : cd1;
      Comparable<dynamic> v2 =
          (cd2 is DateTime) ? cd2.truncateTime.microsecondsSinceEpoch : cd2;
      Comparable<dynamic> v3 =
          (cd3 is DateTime) ? cd3.truncateTime.microsecondsSinceEpoch : cd3;

      String sortKey = '${v1}_${v2}_$v3';

      // print(
      //   '${cd1.runtimeType} ${cd1 is DateTime}  ${cd1 is Comparable<DateTime>}',
      // );
      // print('_sortKey: $_sortKey');
      return sortKey;

      // use this after debug completed
      // return sVal1(r.item1).toString() +
      //     '_' +
      //     sVal2(r.item1).toString() +
      //     '_' +
      //     sVal3(r.item1).toString();
    };
  }

  static ConfigDefinedSortComparator rowSortComparatorFromCfg(TvSortCfg stCfg) {
    // return the function that performs the sorting logic
    // WITHIN groups;  even if only one (eg no grouping) group
    // this does NOT sort-order the groups
    // GroupHeaderData (comparable._sortKey) controls groups

    if (stCfg.disableSorting) return (rec1, rec2) => 0;

    bool l1SortAsc = stCfg.item1?.asc ?? true;
    Comparable firstValFn(AssetRowPropertyIfc row) {
      if (stCfg.item1 == null) return '';
      return row.sortValueExtractor(stCfg.item1!.colName);
    }

    SortFilterEntry? col2Rule = stCfg.item2;
    // CastRowToSortVal
    Comparable secondValFn(AssetRowPropertyIfc row) {
      if (col2Rule == null) return '';
      return row.sortValueExtractor(col2Rule.colName);
    }

    SortFilterEntry? col3Rule = stCfg.item3;
    // CastRowToSortVal
    Comparable thirdValFn(AssetRowPropertyIfc row) {
      if (col3Rule == null) return '';
      return row.sortValueExtractor(col3Rule.colName);
    }

    return (TableviewDataRowTuple rec1, TableviewDataRowTuple rec2) {
      /* function to handle row sorting based on config rules
      works off the 1st asset or game (2nd asset is ignored)

      */
      Comparable row1SortVal1 = firstValFn(rec1.item1);
      var r2v1 = firstValFn(rec2.item1);
      int compResultsLvl1;
      if (l1SortAsc) {
        compResultsLvl1 = row1SortVal1.compareTo(r2v1);
      } else {
        compResultsLvl1 = r2v1.compareTo(row1SortVal1);
      }
      if (compResultsLvl1 != 0 || col2Rule == null) return compResultsLvl1;

      Comparable r1v2 = secondValFn(rec1.item1);
      Comparable r2v2 = secondValFn(rec2.item1);
      int comp2;
      if (stCfg.item2?.asc ?? true) {
        comp2 = r1v2.compareTo(r2v2);
      } else {
        comp2 = r2v2.compareTo(r1v2);
      }
      if (comp2 != 0 || col3Rule == null) return comp2;

      Comparable r1v3 = thirdValFn(rec1.item1);
      Comparable r2v3 = thirdValFn(rec2.item1);
      if (stCfg.item3?.asc ?? true) {
        return r1v3.compareTo(r2v3);
      } else {
        return r2v3.compareTo(r1v3);
      }
    };
  }

  @override
  int compareTo(GroupHeaderData other) {
    // add natural sort order to this class
    if (topSortAscending) {
      return _sortKey.compareTo(other._sortKey);
    } else {
      return other._sortKey.compareTo(_sortKey);
    }
  }

  @override
  List<Object?> get props => [_sortKey];

  // static GroupHeaderData get mockRow =>
  //     GroupHeaderData._('first', 'second', 'third');
}
