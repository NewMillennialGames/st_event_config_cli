/*
  every displayable/tradable asset (wrapped in AssetRowPropertyIfc)
  passed to the ST row factory should follow the interface below

  these are the properties the row-factory needs to render
  all of our various types of rows
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
  String get location;
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
  // sensible defaults if not overridden
  String get groupKey => '';
  String get rankStr => '';
  String get priceStr => '';

  bool get canTrade => false;

  String valueExtractor(DbTableFieldName fldName) {
    switch (fldName) {
      case DbTableFieldName.teamName:
        return topName;
      case DbTableFieldName.playerName:
        return topName;
      case DbTableFieldName.conference:
        return regionOrConference;
      case DbTableFieldName.region:
        return regionOrConference;
      case DbTableFieldName.eventName:
        return topName;
      case DbTableFieldName.gameLocation:
        return location;
      case DbTableFieldName.imageUrl:
        return imgUrl;
      case DbTableFieldName.assetOpenPrice:
        return priceStr;
      case DbTableFieldName.assetCurrentPrice:
        return priceStr;
      default:
        return '_dfltProp';
    }
  }
}
