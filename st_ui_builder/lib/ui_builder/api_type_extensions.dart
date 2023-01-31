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

  String get tradeButtonTitle {
    /*  overriden in ST codebase with:
        tradeButtonTitleLive
      but many widgets here use "TradeButton" (in this lib)
      and not StTradeButton (in host project)

      StStrings file here is incomplete!
    */
    String label = "PreTrade";
    switch (this) {
      case AssetState.assetPretrade:
        label = "PreTrade";
        break;
      case AssetState.assetEliminated:
        label = "Out";
        break;
      case AssetState.assetTrade:
        label = StStrings.tradeUc;
        break;
      case AssetState.assetGameOn:
        label = "Game On";
        break;
      case AssetState.assetGameOver:
        label = "Game Over";
        break;
      case AssetState.assetClosed:
        label = "Closed";
        break;
      case AssetState.assetReprice:
        label = "Reprice";
        break;
    }
    return label;
  }
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
