part of StUiController;

class ActiveGameDetails with EquatableMixin {
  // simplified version of a Competition
  // Equatable so Riverpod can detect changes
  // perhaps move this to models after cleanup?

  final String competitionKey;
  final List<String> _participantAssetIds;
  int _gameStatus;
  String _roundName;
  DateTime _scheduledStartDtTm;

  ActiveGameDetails(
    this.competitionKey,
    this._gameStatus,
    this._roundName,
    this._scheduledStartDtTm,
    this._participantAssetIds,
  );

  ActiveGameDetails cloneWithUpdates(CompetitionInfo ci) {
    _gameStatus = ci.competitionStatus.toInt();
    _roundName = ci.currentRoundName;
    return ActiveGameDetails(
      this.competitionKey,
      _gameStatus,
      _roundName,
      this._scheduledStartDtTm,
      this._participantAssetIds,
    );
  }

  // getters
  int get gameStatus {
    return _gameStatus;
  }

  bool get isTradable => _gameStatus == 4;

  String get roundName => _roundName;
  DateTime get scheduledStartDateOnly => _scheduledStartDtTm.truncateTime;
  DateTime get scheduledStartDtTm => _scheduledStartDtTm;

  List<String> get participantAssetIds => _participantAssetIds;
  String get assetId1 =>
      _participantAssetIds.length > 0 ? _participantAssetIds[0] : '_';
  String get assetId2 =>
      _participantAssetIds.length > 1 ? _participantAssetIds[1] : '_';

  // String get _uniqueAssetKey => assetId1 + '-' + assetId2;

  bool includesParticipant(String assetId) =>
      _participantAssetIds.contains(assetId);

  @override
  List<Object?> get props =>
      [_scheduledStartDtTm.toIso8601String(), competitionKey];

  factory ActiveGameDetails.mock() =>
      ActiveGameDetails('', 0, '', DateTime.now(), []);
}
