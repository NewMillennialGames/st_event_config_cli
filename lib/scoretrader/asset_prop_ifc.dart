/*
  every asset (probably wrapped) passed to the
  ST row factory should follow the interface below

  these are the properties the row-factory needs to render a row
*/

part of StUiController;

abstract class AssetRowPropertyIfc {
  //
  String get id; // for unique comparison
  String get topName;
  String get subName;
  String get imgUrl;
  String get regionOrConference;
  String get groupKey; // for grouping and sorting
  //
  double get price;
  String get priceStr;
  double get priceDelta;
  String get priceDeltaStr;
  //
  int get rank;
  String get rankStr;
}

extension AssetRowPropertyIfcExt1 on AssetRowPropertyIfc {
  // sensible defaults
  String get groupKey => '';
  String get rankStr => '';
  String get priceStr => '';

  bool get canTrade => false;
}
