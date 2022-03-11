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
  Color get posGainSymbolColor => returnIsPositive ? Colors.green : Colors.red;
}

abstract class AssetPriceFluxSummaryIfc {
/*
  may travel with asset for some screens
  to describe recent price changes on this asset
*/
  double get currPrice;
  double get recentPriceDelta;
  //
  double get openPrice;
  double get lowPrice;
  double get hiPrice;
  // int get tradeVolume;
}

extension AssetPriceFluxSummaryIfcExt1 on AssetPriceFluxSummaryIfc {
  // UI values for this
  String get currPriceStr => '\$$currPrice';
  String get recentDeltaStr => '\$$recentPriceDelta';
  //
  String get openPriceStr => '\$$openPrice';
  String get lowPriceStr => '\$$lowPrice';
  String get hiPriceStr => '\$$hiPrice';

  bool get stockIsUp => currPrice > openPrice;
  Color get priceFluxColor => stockIsUp ? Colors.green : Colors.red;
}

abstract class AssetRowPropertyIfc {
  // must have a value for each name on:
  // enum DbTableFieldName()
  String get groupKey; // for grouping and sorting
  String get assetKey; // for unique comparison
  String get topName;
  String get subName;
  String get imgUrl;
  String get position;
  int get rank;
  bool get isTeam;

  AssetPriceFluxSummaryIfc? get assetPriceFluxSummary;
  AssetHoldingsSummaryIfc? get assetHoldingsSummary;

  // next 3 properties are game props but needed for sorting and grouping
  DateTime get gameDate; // rounded to midnight for row grouping
  String get regionOrConference;
  String get roundName;
  String get location;
}

extension AssetRowPropertyIfcExt1 on AssetRowPropertyIfc {
  // sensible defaults if not overridden
  bool get isTeam => true;
  int get rank => 0;
  String get rankStr => '$rank';
  String get gameDateStr => gameDate.asDtwMmDyStr;
  // String get gameTimeStr => gameDate.asTimeOnlyStr;

  // from assetHoldingsSummary
  double get positionGainLoss => assetHoldingsSummary?.positionGainLoss ?? 0;
  String get sharesOwnedStr => assetHoldingsSummary?.sharesOwnedStr ?? '0';
  String get positionCostStr => assetHoldingsSummary?.positionCostStr ?? '\$0';
  String get positionEstValueStr =>
      assetHoldingsSummary?.positionEstValueStr ?? '\$0';
  String get positionGainLossStr =>
      assetHoldingsSummary?.positionGainLossStr ?? '\$0';
  bool get returnIsPositive => assetHoldingsSummary?.returnIsPositive ?? false;
  Color get posGainSymbolColor =>
      assetHoldingsSummary?.posGainSymbolColor ?? Colors.grey;

  // assetPriceFluxSummary
  double get currPrice => assetPriceFluxSummary?.currPrice ?? 0;
  double get recentPriceDelta => assetPriceFluxSummary?.recentPriceDelta ?? 0;
  String get currPriceStr => assetPriceFluxSummary?.currPriceStr ?? '\$0';
  String get recentDeltaStr => assetPriceFluxSummary?.recentDeltaStr ?? '\$0';
  String get openPriceStr => assetPriceFluxSummary?.openPriceStr ?? '\$0';
  String get lowPriceStr => assetPriceFluxSummary?.openPriceStr ?? '\$0';
  String get hiPriceStr => assetPriceFluxSummary?.hiPriceStr ?? '\$0';

  bool get stockIsUp => assetPriceFluxSummary?.stockIsUp ?? false;
  Color get priceFluxColor =>
      assetPriceFluxSummary?.priceFluxColor ?? Colors.grey;

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
        return gameDate.truncateTime.asTimeOnlyStr;
      case DbTableFieldName.eventName:
        return topName;
      case DbTableFieldName.gameLocation:
        return location;
      case DbTableFieldName.imageUrl:
        return imgUrl;
      case DbTableFieldName.assetOpenPrice:
        return openPriceStr;
      case DbTableFieldName.assetCurrentPrice:
        return recentDeltaStr;
      case DbTableFieldName.assetRank:
        return rankStr;
      case DbTableFieldName.assetPosition:
        return position;
      // default:
      //   return '_dfltProp';
    }
  }
}
