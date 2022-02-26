part of StUiController;

mixin ShowsOneAsset on StBaseTvRowIfc {
  // competitors
  AssetRowPropertyIfc get comp1 => assets.item1;
}

mixin ShowsTwoAssets on StBaseTvRowIfc {
  // only happens on MarketView screen
  // for TeamVsTeam and PlayerVsPlayer
  AssetRowPropertyIfc get comp1 => assets.item1;
  AssetRowPropertyIfc get comp2 => assets.item2!;
}

mixin IsTradeable on StBaseTvRowIfc {
  //
  bool get canTrade => gameStatus.isTradable;
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
