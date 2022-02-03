part of StUiController;

mixin ShowsOneAsset on StBaseTvRowAbs {
  //
  AssetRowPropertyIfc get first => assets.item1;
}

mixin ShowsTwoAssets on StBaseTvRowAbs {
  //
  AssetRowPropertyIfc get first => assets.item1;
  AssetRowPropertyIfc get second => assets.item2!;
}

mixin IsTradeable on StBaseTvRowAbs {
  //
  bool canTrade = false;
}
