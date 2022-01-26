/*
  every asset (probably wrapped) passed to the
  ST row factory should follow the interface below

  these are the properties the row-factory needs to render a row


*/

abstract class RowPropertyInterface {
  //
  String get topName;
  String get subName;
  String get imgUrl;
}
