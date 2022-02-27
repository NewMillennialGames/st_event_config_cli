part of StUiController;

@immutable
class ActiveGameDetails with EquatableMixin {
  // simplified version of a Competition
  // must be immutable so Riverpod can detect changes

  final String competitionKey;
  final List<String> participantAssetIds;
  // FIXME with Enum for CompStatus
  final int gameStatus;
  final String roundName;
  final DateTime scheduledStartDtTm;

  ActiveGameDetails(
    this.competitionKey,
    this.gameStatus,
    this.roundName,
    this.scheduledStartDtTm,
    this.participantAssetIds,
  );

  ActiveGameDetails cloneWithUpdates(CompetitionInfo ci) {
    // _gameStatus = ci.competitionStatus.toInt();
    // _roundName = ci.currentRoundName;
    return ActiveGameDetails(
      competitionKey,
      ci.competitionStatus.toInt(),
      ci.currentRoundName,
      scheduledStartDtTm,
      participantAssetIds,
    );
  }

  // getters

  // FIXME with Enum for CompStatus
  bool get isTradable => gameStatus == 4;
  int get competitorCount => participantAssetIds.length;
  DateTime get scheduledStartDateOnly => scheduledStartDtTm.truncateTime;
  // DateTime get scheduledStartDtTm => scheduledStartDtTm;
  String get assetId1 =>
      participantAssetIds.length > 0 ? participantAssetIds[0] : '_';
  String get assetId2 =>
      participantAssetIds.length > 1 ? participantAssetIds[1] : '_';

  // List<String> get participantAssetIds => _participantAssetIds;
  // String get _uniqueAssetKey => assetId1 + '-' + assetId2;

  bool includesParticipant(String assetId) =>
      participantAssetIds.contains(assetId);

  @override
  List<Object?> get props =>
      [scheduledStartDtTm.toIso8601String(), competitionKey];

  // only for testing
  factory ActiveGameDetails.mock() =>
      ActiveGameDetails('', 0, 'rZero', DateTime.now(), []);
}
