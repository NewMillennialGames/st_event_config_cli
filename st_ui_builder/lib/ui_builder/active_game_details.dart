part of StUiController;

extension CompetitionStatusExt5 on CompetitionStatus {
  //
  bool get isTradable => [
        CompetitionStatus.compInFuture,
      ].contains(this);
}

@freezed
class ActiveGameDetails with _$ActiveGameDetails {
  //
  // const constructor needed to implement ifc
  const ActiveGameDetails._();

  const factory ActiveGameDetails(
    String competitionKey,
    DateTime scheduledStartDtTm, {
    @Default(CompetitionStatus.compUninitialized) CompetitionStatus gameStatus,
    @Default('') String roundName,
    @Default('') String regionOrConference,
    @Default('') String location,
    @Default([]) List<String> participantAssetIds,
    @Default([]) List<String> ownedAssetIds,
    @Default([]) List<String> watchedAssetIds,
  }) = _ActiveGameDetails;

  ActiveGameDetails cloneWithUpdates(
    CompetitionInfo ci, {
    bool? comp1IsWatched,
    bool? comp2IsWatched,
    bool? comp1IsOwned,
    bool? comp2IsOwned,
  }) {
    // dont change owned or watched state unless explicitly set
    List<String> watchedAssetIds = _makeLst(
      comp1IsWatched ?? isWatched(assetId1),
      comp2IsWatched ?? isWatched(assetId2),
    );
    List<String> ownedAssetIds = _makeLst(
      comp1IsOwned ?? isOwned(assetId1),
      comp2IsOwned ?? isOwned(assetId2),
    );

    return copyWith(
      gameStatus: ci.competitionStatus,
      roundName: ci.currentRoundName,
      // regionOrConference: regionOrConference,
      // location: location,
      // participantAssetIds: participantAssetIds,
      ownedAssetIds: ownedAssetIds,
      watchedAssetIds: watchedAssetIds,
    );
  }

  List<String> _makeLst(
    bool first,
    bool second,
  ) {
    List<String> l = [];
    if (first) l.add(assetId1);
    if (second) l.add(assetId2);
    return l;
  }

  // getters
  bool get isTradable => gameStatus.isTradable;
  int get competitorCount => participantAssetIds.length;
  //
  String get gameDateStr => scheduledStartDtTm.asDtwMmDyStr;
  String get gameTimeStr => scheduledStartDtTm.asTimeOnlyStr;
  DateTime get scheduledStartDateOnly => scheduledStartDtTm.truncateTime;
  //
  String get assetId1 =>
      participantAssetIds.isNotEmpty ? participantAssetIds[0] : '_';
  String get assetId2 =>
      participantAssetIds.length > 1 ? participantAssetIds[1] : '_';

  bool isOwned(String assetId) => ownedAssetIds.contains(assetId);
  bool isWatched(String assetId) => watchedAssetIds.contains(assetId);

  bool includesParticipant(String assetId) =>
      participantAssetIds.contains(assetId);

  // only testing & error handling
  factory ActiveGameDetails.mockOrMissingAgd([String assetId = '_mock']) {
    print('Warn:  creating ActiveGameDetails (mockOrMissing) ');
    return ActiveGameDetails(
      '_missingCompRec',
      DateTime.now(),
      gameStatus: CompetitionStatus.compUninitialized,
      roundName: '_roundName',
      regionOrConference: '_region',
      location: '_location',
      participantAssetIds: [assetId],
    );
  }
}

// @immutable
// class old_ActiveGameDetails {
//   // with EquatableMixin
//   // simplified version of a Competition
//   // to update rows with status changes
//   // must be immutable so Riverpod can detect changes

//   final String competitionKey;
//   final CompetitionStatus gameStatus;
//   final String roundName;
//   final String regionOrConference;
//   final String location;
//   final DateTime scheduledStartDtTm;
//   final List<String> participantAssetIds;
//   final List<String> ownedAssetIds;
//   final List<String> watchedAssetIds;

//   const old_ActiveGameDetails(
//     this.competitionKey,
//     this.gameStatus,
//     this.roundName,
//     this.regionOrConference,
//     this.location,
//     this.scheduledStartDtTm,
//     this.participantAssetIds, {
//     this.ownedAssetIds = const [],
//     this.watchedAssetIds = const [],
//   });

//   old_ActiveGameDetails cloneWithUpdates(
//     CompetitionInfo ci, {
//     bool? comp1IsWatched,
//     bool? comp2IsWatched,
//     bool? comp1IsOwned,
//     bool? comp2IsOwned,
//   }) {
//     // dont change owned or watched state unless explicitly set
//     List<String> watchedAssetIds = _makeLst(
//       comp1IsWatched ?? isWatched(assetId1),
//       comp2IsWatched ?? isWatched(assetId2),
//     );
//     List<String> ownedAssetIds = _makeLst(
//       comp1IsOwned ?? isOwned(assetId1),
//       comp2IsOwned ?? isOwned(assetId2),
//     );

//     return old_ActiveGameDetails(
//       competitionKey,
//       ci.competitionStatus,
//       ci.currentRoundName,
//       regionOrConference,
//       location,
//       scheduledStartDtTm,
//       participantAssetIds,
//       ownedAssetIds: ownedAssetIds,
//       watchedAssetIds: watchedAssetIds,
//     );
//   }

//   List<String> _makeLst(
//     bool first,
//     bool second,
//   ) {
//     List<String> l = [];
//     if (first) l.add(assetId1);
//     if (second) l.add(assetId2);
//     return l;
//   }

//   // getters
//   bool get isTradable => gameStatus.isTradable;
//   int get competitorCount => participantAssetIds.length;
//   //
//   String get gameDateStr => scheduledStartDtTm.asDtwMmDyStr;
//   String get gameTimeStr => scheduledStartDtTm.asTimeOnlyStr;
//   DateTime get scheduledStartDateOnly => scheduledStartDtTm.truncateTime;
//   //
//   String get assetId1 =>
//       participantAssetIds.length > 0 ? participantAssetIds[0] : '_';
//   String get assetId2 =>
//       participantAssetIds.length > 1 ? participantAssetIds[1] : '_';

//   bool isOwned(String assetId) => ownedAssetIds.contains(assetId);
//   bool isWatched(String assetId) => watchedAssetIds.contains(assetId);

//   bool includesParticipant(String assetId) =>
//       participantAssetIds.contains(assetId);

//   // List<String> get participantAssetIds => _participantAssetIds;
//   // String get _uniqueAssetKey => assetId1 + '-' + assetId2;

//   // @override
//   // List<Object?> get props =>
//   //     [scheduledStartDtTm.toIso8601String(), competitionKey];

//   // only testing & error handling
//   factory old_ActiveGameDetails.mockOrMissingAgd([String assetId = '_mock']) {
//     print('Warn:  creating ActiveGameDetails (mockOrMissing) ');
//     return old_ActiveGameDetails(
//       '_missingCompRec',
//       CompetitionStatus.compInFuture,
//       '_roundName',
//       '_region',
//       '_location',
//       DateTime.now(),
//       [assetId],
//     );
//   }
// }
