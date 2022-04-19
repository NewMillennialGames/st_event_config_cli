part of StUiController;

final tradeFlowProvider = Provider<TradeFlowBase>(
  (ref) => throw UnimplementedError('should override with subclass'),
);

final currEventProvider = Provider<Event?>((ref) {
  throw UnimplementedError('should override with selectedEventProvider');
});
