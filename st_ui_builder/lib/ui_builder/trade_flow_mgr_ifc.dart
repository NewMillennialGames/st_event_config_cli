part of StUiController;

class TradeFlowBase {
  // cannot be abstract due to riverpod??

  String labelForAssetState(
    CompetitionStatus status,
    AssetState assetState, {
    bool eventIsStarted = false,
    // bool isBeingRepriced = false,
  }) {
    throw UnimplementedError('should call subclass');
    return assetState.tradeButtonTitle;
  }

  Color colorForAssetState(
    CompetitionStatus status, {
    bool eventIsStarted = false,
  }) =>
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
  String labelForAssetState(
    CompetitionStatus status,
    AssetState assetState, {
    bool eventIsStarted = false,
  }) =>
      assetState.tradeButtonTitle;

  @override
  Color colorForAssetState(
    CompetitionStatus status, {
    bool eventIsStarted = false,
  }) =>
      Colors.blue;

  @override
  void beginTradeFlow(AssetKey assetId) {}

  @override
  bool toggleWatchValue(AssetKey assetKey) => true;
}
