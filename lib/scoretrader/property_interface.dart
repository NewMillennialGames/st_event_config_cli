/*
  every asset (probably wrapped) passed to the
  ST row factory should follow the interface below

  these are the properties the row-factory needs to render a row


*/

part of StUiController;

abstract class RowPropertyInterface {
  //
  String get topName;
  String get subName;
  String get imgUrl;
  //
  double get price;
  String get priceStr;
  double get delta;
  String get deltaStr;
  //
  int get rank;
  String get rankStr;
}
