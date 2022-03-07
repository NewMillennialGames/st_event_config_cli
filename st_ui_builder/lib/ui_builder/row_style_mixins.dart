part of StUiController;

mixin ShowsOneAsset on StBaseTvRowIfc {
  // each row shows ONE competitor
  AssetRowPropertyIfc get comp1 => assets.item1;
  ActiveGameDetails get gameState => assets.item3;
}

mixin ShowsTwoAssets on StBaseTvRowIfc {
  // only happens on MarketView screen
  // for TeamVsTeam and PlayerVsPlayer
  AssetRowPropertyIfc get comp1 => assets.item1;
  AssetRowPropertyIfc get comp2 => assets.item2!;

  // ActiveGameDetails get gameStatus => assets.item3;
}

mixin RequiresGameStatus on StBaseTvRowIfc {
  // row uses game details for state mgmt
  ActiveGameDetails get gameStatus => assets.item3;
}

// mixin ObservesTradability on StBaseTvRow {
//   // row has a tradable button that enables/disables
//   bool get canTrade => gameStatus.isTradable;
// }

mixin RequiresPriceChangeProps on StBaseTvRowIfc {
  // row needs price history data
  // not every asset has this data
  // notice the force-unpack of optional below
  AssetPriceFluxSummaryIfc get assetPriceSummary =>
      assets.item1.assetPriceFluxSummary!;
}

mixin RequiresUserPositionProps on StBaseTvRowIfc {
  // row needs price history data
  // not every asset has this data
  // notice the force-unpack of optional below
  AssetHoldingsSummaryIfc get assetHoldingsSummary =>
      assets.item1.assetHoldingsSummary!;
}



// screen areas
// mixin ForMarketView on StBaseTvRowIfc {
//   //
// }

// mixin ForLeaderboard on StBaseTvRowIfc {
//   //
// }

// mixin ForPortfolio on StBaseTvRowIfc {
//   //
// }

// mixin ForMarketResearch on StBaseTvRowIfc {
//   //
// }
