part of StUiController;

mixin ShowsOneAsset on StBaseTvRowIfc {
  //
  AssetRowPropertyIfc get first => assets.item1;
}

mixin ShowsTwoAssets on StBaseTvRowIfc {
  // only happens on MarketView screen
  // for TeamVsTeam and PlayerVsPlayer
  AssetRowPropertyIfc get first => assets.item1;
  AssetRowPropertyIfc get second => assets.item2!;
}

mixin IsTradeable on StBaseTvRowIfc {
  //
  bool canTrade = false;
}

// screen areas
mixin ForMarketView on StBaseTvRowIfc {
  //
}

mixin ForLeaderboard on StBaseTvRowIfc {
  //
}

mixin ForPortfolio on StBaseTvRowIfc {
  //
}

mixin ForMarketResearch on StBaseTvRowIfc {
  //
}
