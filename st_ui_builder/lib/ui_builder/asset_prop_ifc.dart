/*
  every displayable/tradable asset (wrapped in AssetRowPropertyIfc)
  passed to the ST row factory should follow the interface below

  these are the properties the row-factory needs to render
  all of our various types of rows
*/

part of StUiController;

abstract class AssetRowPropertyIfc {
  // must have a value for each name on:
  // enum DbTableFieldName()
  String get groupKey; // for grouping and sorting
  String get id; // for unique comparison
  String get topName;
  String get subName;
  String get imgUrl;
  String get regionOrConference;
  String get location;
  String get position;
  DateTime get gameDate; // rounded to midnight for row grouping
  DateTime get gameTime; // sort order within groups
  //
  double get price;
  // String get priceStr;
  double get priceDelta;
  // String get priceDeltaStr;
  //
  int get rank;
  bool get isTeam;

  String get roundName;

  // String get rankStr;
  // Widget get icon;
  // Color get colorImage;
  // Color get color;
  // double get tokens;
  // double get gain;
  // double get open;
  // double get high;
  // double get low;
  // String get teamName;
  // double get percentage;
  // double get shares;
}

extension AssetRowPropertyIfcExt1 on AssetRowPropertyIfc {
  // sensible defaults if not overridden
  bool get isTeam => true;
  String get groupKey => gameDateStr;

  String get gameDateStr => DateFormat().format(gameDate);
  String get gameTimeStr => '_to fmt actual value';

  String get priceStr => '_to fmt actual value';
  String get priceDeltaStr => '_to fmt actual value';
  String get rankStr => '$rank';

  bool get canTrade => false;

  int get positionStr => int.parse(this.position);

  String valueExtractor(DbTableFieldName fldName) {
    /* need to coordinate with Natalia
      to make sure values below match
      what she sets in the Asset wrapper
    */
    switch (fldName) {
      case DbTableFieldName.assetName:
        return topName;
      case DbTableFieldName.assetOrgName:
        return subName;
      case DbTableFieldName.conference:
        return regionOrConference;
      case DbTableFieldName.region:
        return regionOrConference;
      case DbTableFieldName.gameDate:
        return gameDateStr;
      case DbTableFieldName.gameTime:
        return gameTimeStr;
      case DbTableFieldName.eventName:
        return topName;
      case DbTableFieldName.gameLocation:
        return location;
      case DbTableFieldName.imageUrl:
        return imgUrl;
      case DbTableFieldName.assetOpenPrice:
        return priceStr;
      case DbTableFieldName.assetCurrentPrice:
        return priceDeltaStr;
      case DbTableFieldName.assetRank:
        return rankStr;
      case DbTableFieldName.assetPosition:
        return position;
      // default:
      //   return '_dfltProp';
    }
  }
}
