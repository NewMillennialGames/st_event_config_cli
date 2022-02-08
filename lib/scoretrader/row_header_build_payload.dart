part of StUiController;

/*
  StdRowData is what to pass to every row to construct it

  two item rows will fill slots 1 & 2
  single items rows will just have 1st value

  third value is extra
*/

class GroupHeaderData {
  String first;
  String second;
  String third;

  GroupHeaderData(
    this.first,
    this.second,
    this.third,
  );

  static GetGroupKeyFromRow keyConstructorFromCfg(
    GroupingRules groupingRules,
  ) {
    // returns a func that creates a GroupHeaderData
    CastRowToSortVal firstValFn = (AssetRowPropertyIfc row) {
      return row.valueExtractor(groupingRules.item1.colName);
    };

    CastRowToSortVal secondValFn = (AssetRowPropertyIfc row) {
      TvGroupCfg? col2Rule = groupingRules.item2;
      if (col2Rule == null) return '';
      return row.valueExtractor(col2Rule.colName);
    };

    CastRowToSortVal thirdValFn = (AssetRowPropertyIfc row) {
      TvGroupCfg? col3Rule = groupingRules.item3;
      if (col3Rule == null) return '';
      return row.valueExtractor(col3Rule.colName);
    };

    return (AssetRowPropertyIfc row) {
      return GroupHeaderData(
          firstValFn(row), secondValFn(row), thirdValFn(row));
    };
  }

  static GroupHeaderData get mockRow =>
      GroupHeaderData('first', 'second', 'third');
}
