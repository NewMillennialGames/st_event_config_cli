/*
  every displayable/tradable asset (wrapped in AssetRowPropertyIfc)
  passed to the ST row factory should follow the interface below

  these are the properties the row-factory needs to render
  all of our various types of rows
*/

part of StUiController;

abstract class AssetHoldingsSummaryIfc {
  /*  per-user asset holdings summary

  */
  int get sharesOwned;
  double get positionCost;
  double get positionEstValue; // current estimate

}

extension AssetHoldingsSummaryIfcExt1 on AssetHoldingsSummaryIfc {
  //
  double get positionGainLoss => positionEstValue - positionCost;
  // UI values for this
  String get sharesOwnedStr => '$sharesOwned';
  String get positionCostStr => '\$$positionCost';
  String get positionEstValueStr => '\$$positionEstValue';
  String get positionGainLossStr => '\$$positionGainLoss';

  bool get returnIsPositive => positionGainLoss > 0;
  Color get fontColor => returnIsPositive ? Colors.green : Colors.red;
}

abstract class AssetPriceFluxSummaryIfc {
/*
  may travel with asset for some screens
  to describe recent price changes on this asset
*/
  double get currPrice;
  double get recentDelta;
  //
  double get openPrice;
  double get lowPrice;
  double get hiPrice;
  // int get tradeVolume;
}

extension AssetPriceFluxSummaryIfcExt1 on AssetPriceFluxSummaryIfc {
  // UI values for this
  String get currPriceStr => '\$$currPrice';
  String get recentDeltaStr => '\$$recentDelta';
  //
  String get openPriceStr => '\$$openPrice';
  String get lowPriceStr => '\$$lowPrice';
  String get hiPriceStr => '\$$hiPrice';

  bool get stockIsUp => currPrice > openPrice;
  Color get fontColor => stockIsUp ? Colors.green : Colors.red;
}

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

  AssetPriceFluxSummaryIfc? get assetPriceFluxSummary;
  AssetHoldingsSummaryIfc? get assetHoldingsSummary;

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

  String get gameDateStr => gameDate.asDtwMmDyStr;
  String get gameTimeStr => gameDate.asTimeOnlyStr;

  String get priceStr => '\$$price';
  String get priceDeltaStr => '\$$priceDelta';
  String get rankStr => '$rank';

  bool get canTrade => false;

  int get positionStr => int.parse(position);

  String valueExtractor(DbTableFieldName fldName) {
    /* need to coordinate with Natalia
      to make sure values below match
      what she sets in the Asset wrapper

      FIXME: for sorting will need special format
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
