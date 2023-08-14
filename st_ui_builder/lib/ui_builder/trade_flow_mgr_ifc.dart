part of StUiController;

class TradeFlowBase {
  // cannot be abstract due to riverpod??

  String labelForAsset(AssetRowPropertyIfc asset) {
    throw UnimplementedError('should call subclass');
  }

  Color colorForAsset(AssetRowPropertyIfc asset) =>
      throw UnimplementedError('should call subclass');

  void beginTradeFlow(AssetKey assetId) {
    throw UnimplementedError('should call subclass');
  }

  bool toggleWatchValue(AssetKey assetKey) =>
      throw UnimplementedError('should call subclass');
}

class TradeFlowForDemo extends TradeFlowBase {
  //
  @override
  String labelForAsset(AssetRowPropertyIfc asset) =>
      asset.assetStateUpdates.assetState.tradeButtonTitle;

  @override
  Color colorForAsset(AssetRowPropertyIfc asset) => Colors.blue;

  @override
  void beginTradeFlow(AssetKey assetId) {}

  @override
  bool toggleWatchValue(AssetKey assetKey) => true;
}
