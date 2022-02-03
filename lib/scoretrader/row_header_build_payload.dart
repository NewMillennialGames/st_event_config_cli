part of StUiController;

/*
  StdRowData is what to pass to every row to construct it

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
}
