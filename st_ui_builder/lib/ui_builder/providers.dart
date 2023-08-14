part of StUiController;

final tradeFlowProvider = Provider<TradeFlowBase>(
  (ref) => throw UnimplementedError('should override with subclass'),
);

final currEventProvider = Provider<Event?>((ref) {
  throw UnimplementedError('should override with selectedEventProvider');
});

///Override this for AssetVsAssetRowMktResearchView to dictate
///which asset should be selected.
final showMarketResearchSecondAssetProvider = StateProvider<bool>((ref) {
  throw UnimplementedError('should override with selectedEventProvider');
});

final currentAppScreenNotifier = ValueNotifier<AppScreen>(AppScreen.marketView);
