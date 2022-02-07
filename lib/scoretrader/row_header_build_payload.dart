part of StUiController;

/*
  StdRowData is what to pass to every row to construct it

  two item rows will fill slots 1 & 2
  single items rows will just have 1st value

  third value is extra
*/
typedef StdRowData = Tuple3<AssetRowPropertyIfc, AssetRowPropertyIfc?, String?>;

class GroupHeaderData {
  String first;
  String second;
  String third;

  GroupHeaderData(
    this.first,
    this.second,
    this.third,
  );

  static GroupHeaderData get mockRow =>
      GroupHeaderData('first', 'second', 'third');
}
