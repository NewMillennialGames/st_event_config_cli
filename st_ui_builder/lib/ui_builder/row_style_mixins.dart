part of StUiController;

mixin ShowsOneAsset on StBaseTvRowIfc {
  // each row shows ONE competitor
  AssetRowPropertyIfc get comp1 => assets.team1;
// StateProvider<ActiveGameDetails> get gameState => assets.item4(assets.item3);
}

mixin ShowsTwoAssets on StBaseTvRowIfc {
  // only happens on MarketView screen
  // for TeamVsTeam and PlayerVsPlayer
  AssetRowPropertyIfc get comp1 => assets.team1;

  AssetRowPropertyIfc get comp2 => assets.team1!;

// ActiveGameDetails get gameStatus => assets.item3;
}

mixin RequiresGameStatus on StBaseTvRowIfc {
  // row uses game details for state mgmt
  // StateProvider<ActiveGameDetails> get gameStatus => assets.item4(assets.item3);
}

// mixin ObservesTradability on StBaseTvRow {
//   // row has a tradable button that enables/disables
//   bool get canTrade => gameStatus.isTradable;
// }

mixin RequiresPriceChangeProps on StBaseTvRowIfc {
  // row needs price history data
  // not every asset has this data
  // notice the force-unpack of optional below
  // AssetStateUpdates get assetPriceSummary => assets.item1.assetStateUpdates;
}

mixin RequiresUserPositionProps on StBaseTvRowIfc {
  // row needs price history data
  // not every asset has this data
  // notice the force-unpack of optional below
  AssetHoldingsSummaryIfc get assetHoldingsSummary =>
      assets.team1.assetHoldingsSummary;

  UserEventSummaryIfc get userEventSummary => assets.team1.userEventSummary;
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
