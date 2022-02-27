part of StUiController;

@immutable
class ActiveGameDetails with EquatableMixin {
  // simplified version of a Competition
  // must be immutable so Riverpod can detect changes

  final String competitionKey;
  final List<String> _participantAssetIds;
  // FIXME with Enum for CompStatus
  final int _gameStatus;
  final String _roundName;
  final DateTime _scheduledStartDtTm;

  ActiveGameDetails(
    this.competitionKey,
    this._gameStatus,
    this._roundName,
    this._scheduledStartDtTm,
    this._participantAssetIds,
  );

  ActiveGameDetails cloneWithUpdates(CompetitionInfo ci) {
    // _gameStatus = ci.competitionStatus.toInt();
    // _roundName = ci.currentRoundName;
    return ActiveGameDetails(
      competitionKey,
      ci.competitionStatus.toInt(),
      ci.currentRoundName,
      _scheduledStartDtTm,
      _participantAssetIds,
    );
  }

  // getters
  int get gameStatus {
    return _gameStatus;
  }

  // FIXME with Enum for CompStatus
  bool get isTradable => _gameStatus == 4;
  int get competitorCount => _participantAssetIds.length;
  String get roundName => _roundName;
  DateTime get scheduledStartDateOnly => _scheduledStartDtTm.truncateTime;
  DateTime get scheduledStartDtTm => _scheduledStartDtTm;
  String get assetId1 =>
      _participantAssetIds.length > 0 ? _participantAssetIds[0] : '_';
  String get assetId2 =>
      _participantAssetIds.length > 1 ? _participantAssetIds[1] : '_';

  // List<String> get participantAssetIds => _participantAssetIds;
  // String get _uniqueAssetKey => assetId1 + '-' + assetId2;

  bool includesParticipant(String assetId) =>
      _participantAssetIds.contains(assetId);

  @override
  List<Object?> get props =>
      [_scheduledStartDtTm.toIso8601String(), competitionKey];

  // only for testing
  factory ActiveGameDetails.mock() =>
      ActiveGameDetails('', 0, 'rZero', DateTime.now(), []);
}
