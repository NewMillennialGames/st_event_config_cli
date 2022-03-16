part of StUiController;

final tradeFlowProvider = Provider<TradeFlowBase>(
  (ref) => throw UnimplementedError('should override with subclass'),
);

final currEventStateProvider = StateProvider<Event?>((ref) {
  throw UnimplementedError('should override with selectedEventStateProvider');
});
