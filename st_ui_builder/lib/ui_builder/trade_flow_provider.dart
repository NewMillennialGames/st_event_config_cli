part of StUiController;

class TradeFlowBase {
  //
  String labelForGameState(CompetitionStatus status) =>
      throw UnimplementedError('should call subclass');

  Color colorForGameState(CompetitionStatus status) =>
      throw UnimplementedError('should call subclass');

  void beginTradeFlow(String assetId) {
    throw UnimplementedError('');
  }
}

final tradeFlowProvider = Provider<TradeFlowBase>(
    (ref) => throw UnimplementedError('should override with subclass'));
