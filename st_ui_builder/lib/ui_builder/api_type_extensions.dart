part of StUiController;

extension CompetitionStatusExt5 on CompetitionStatus {
  //
  bool get isTradable => [
        CompetitionStatus.compInFuture,
      ].contains(this);

  bool get hasEnded => [
        CompetitionStatus.compFinished,
        CompetitionStatus.compFinal
      ].contains(this);
}

extension AssetStateExt1 on AssetState {
  //
  bool get isTradable => AssetState.assetTrade == this;

  String get tradeButtonTitle => "";
}

extension OrderExt1 on Order {
  String get tradeSource {
    switch (execMode) {
      case ExecutionMode.executionLiquidate:
        return "Liquidated";
      // if (gainLoss > 0) {
      //   return StStrings.proceedsOnGameOver;
      // }
      // return StStrings.liquidatedOnGameOver;
      case ExecutionMode.executionSell:
        return StStrings.sharesSold;
      default:
        return '';
    }
  }
}
