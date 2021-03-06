part of StUiController;

abstract class AssetHoldingsSummaryIfc {
  /*  per-user asset holdings summary

  */
  int get sharesOwned;

  Decimal get positionCost;

  Decimal get positionEstValue; // current estimate

  Order? get order;

  int get tokensAvail;
}

extension AssetHoldingsSummaryIfcExt1 on AssetHoldingsSummaryIfc {
  //
  Decimal get positionGainLoss => positionEstValue - positionCost;

  // UI values for this
  int get tokensAvail => 0;

  String get sharesOwnedStr => '$sharesOwned';

  String get positionCostStr => positionCost.toStringAsFixed(2);

  String get positionEstValueStr => positionEstValue.toStringAsFixed(2);

  String get positionGainLossStr => positionGainLoss.toStringAsFixed(2);

  bool get returnIsPositive => positionGainLoss >= Decimal.zero;

  Color get posGainSymbolColor => returnIsPositive ? Colors.green : Colors.red;
}

abstract class UserEventSummaryIfc {
  String get key;

  String get userID;

  String get eventKey;

  int get positionCount;

  int get unrealizedGainLoss;

  int get currentPortfolioValue;
}

// abstract class AssetPriceFluxSummaryIfc {
// /*
//   may travel with asset for some screens
//   to describe recent price changes on this asset
// */
//   double get currPrice;
//   double get priceDeltaSinceOpen;
//   //
//   double get openPrice;
//   double get lowPrice;
//   double get hiPrice;
//   // int get tradeVolume;
// }

// extension AssetPriceFluxSummaryIfcExt1 on AssetPriceFluxSummaryIfc {
//   // UI values for this
//   String get currPriceStr => currPrice.toStringAsFixed(2);
//   double get priceDeltaSinceOpen => currPrice - openPrice;
//   String get recentDeltaStr => priceDeltaSinceOpen.toStringAsFixed(2);
//   //
//   String get openPriceStr => openPrice.toStringAsFixed(2);
//   String get lowPriceStr => lowPrice.toStringAsFixed(2);
//   String get hiPriceStr => hiPrice.toStringAsFixed(2);

//   bool get stockIsUp => currPrice > openPrice;
//   Color get priceFluxColor => stockIsUp ? Colors.green : Colors.red;
// }
