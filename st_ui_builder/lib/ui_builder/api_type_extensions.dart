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
  bool get isTradable => AssetState.assetOpen == this;
}

extension OrderExt1 on Order {
  String get tradeSource {
    switch (execMode) {
      case ExecutionMode.executionBuy:
        return '';
      case ExecutionMode.executionLiquidate:
        if (gainLoss > 0) {
          return StStrings.proceedsOnGameOver;
        }
        return StStrings.liquidatedOnGameOver;
      case ExecutionMode.executionSell:
        return StStrings.sharesSold;
    }

    // Unreachable
    return '';
  }
}