part of StUiController;

abstract class TradeFlowProvIfc {
  //
  String labelForState(CompetitionStatus status);
  void beginTradeFlow(String assetId);
}

final tradeFlowProvider =
    Provider<TradeFlowProvIfc>((ref) => throw UnimplementedError(''));
