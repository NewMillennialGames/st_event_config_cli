part of StUiController;

class TradeFlowBase {
  // cannot be abstract due to riverpod??

  String labelForGameState(
    CompetitionStatus status, {
    bool eventIsStarted = false,
  }) =>
      throw UnimplementedError('should call subclass');

  Color colorForGameState(
    CompetitionStatus status, {
    bool eventIsStarted = false,
  }) =>
      throw UnimplementedError('should call subclass');

  void beginTradeFlow(String assetId) {
    throw UnimplementedError('should call subclass');
  }

  bool toggleWatchValue(String assetKey) =>
      throw UnimplementedError('should call subclass');
}

class TradeFlowForDemo extends TradeFlowBase {
  //
  @override
  String labelForGameState(
    CompetitionStatus status, {
    bool eventIsStarted = false,
  }) =>
      'demo label';

  @override
  Color colorForGameState(
    CompetitionStatus status, {
    bool eventIsStarted = false,
  }) =>
      Colors.blue;

  @override
  void beginTradeFlow(String assetId) {}

  @override
  bool toggleWatchValue(String assetKey) => true;
}
