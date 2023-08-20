part of StUiController;

extension DisplayJustificationExt1 on DisplayJustification {
  //
  TextAlign get toTextAlign {
    switch (this) {
      case DisplayJustification.center:
        return TextAlign.center;
      case DisplayJustification.left:
        return TextAlign.left;
      case DisplayJustification.right:
        return TextAlign.right;
    }
  }
}

extension AssetRowPropertyIfcExt on AssetRowPropertyIfc {
  bool isTradable(AppScreen screen) {
    if ([AppScreen.marketView, AppScreen.marketResearch].contains(screen)) {
      return currentSharesAvailable > Decimal.zero &&
          assetStateUpdates.isTradable;
    }
    return assetStateUpdates.isTradable;
  }
}
