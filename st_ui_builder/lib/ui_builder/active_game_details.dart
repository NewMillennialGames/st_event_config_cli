part of StUiController;

@freezed
class AssetStateUpdates with _$AssetStateUpdates {
  /* 
  state info for each specific asset is always
  carried by their NEXT/CURRENT game/competition
  */
  const AssetStateUpdates._();

  const factory AssetStateUpdates(
    String assetKey, {
    @Default(AssetState.assetNew) AssetState assetState,
    @Default(TradeMode.tradeMarket) TradeMode tradeMode,
    @Default(0) double curPrice,
    @Default(false) bool isWatched,
    @Default(false) bool isOwned,
  }) = _AssetStateUpdates;

  bool get isTradable => assetState.isTradable;
}

@freezed
class ActiveGameDetails with _$ActiveGameDetails {
  /*
  Row UI must update when any of the below changes:
  Game CompetitionStatus
  Asset State (either of participants)
  currentPrice
  isWatched
  isOwned
  */
  const ActiveGameDetails._();

  const factory ActiveGameDetails(
    String competitionKey,
    DateTime scheduledStartDtTm, {
    @Default(CompetitionStatus.compUninitialized) CompetitionStatus gameStatus,
    // @Default(CompetitionType.game) CompetitionType gameType,
    @Default('') String roundName,
    @Default('') String regionOrConference,
    @Default('') String location,
    @Default([]) List<AssetStateUpdates> participantAssetInfo,
  }) = _ActiveGameDetails;

  factory ActiveGameDetails.createNew(
    String competitionKey,
    DateTime scheduledStartDtTm,
    CompetitionStatus gameStatus,
    AssetStateUpdates asu1,
    AssetStateUpdates asu2,
  ) {
    return ActiveGameDetails(
      competitionKey,
      scheduledStartDtTm,
      gameStatus: gameStatus,
      participantAssetInfo: [asu1, asu2],
    );
  }

  ActiveGameDetails copyFromGameUpdates(
    CompetitionInfo ci,
  ) {
    // there are 1000000 (1 mill) nanoseconds in 1 millisecond
    return copyWith(
      gameStatus: ci.competitionStatus,
      roundName: ci.currentRoundName,
      scheduledStartDtTm: ci.scheduledStartTime.asDtTm,
      // regionOrConference: ci.region
    );
  }

  ActiveGameDetails copyFromAssetStateUpdates(
    AssetInfo info,
  ) {
    /* called when server stream changes state
    */
    int rowIdx =
        participantAssetInfo.indexWhere((ai) => ai.assetKey == info.key);
    if (rowIdx < 0) return this;
    //
    AssetStateUpdates newAsu = participantAssetInfo[rowIdx].copyWith(
      curPrice: info.price.asPrice2d,
      tradeMode: info.mode,
      assetState: info.state,
    );
    List<AssetStateUpdates> lstCopy = participantAssetInfo.toList();
    lstCopy[rowIdx] = newAsu;
    return copyWith(participantAssetInfo: lstCopy);
  }

  ActiveGameDetails copyFromUserUpdates(
    String assetKey, {
    bool? isWatched,
    bool? isOwned,
  }) {
    /* called when user changes state
        dont change owned or watched state unless explicitly set
    */
    int rowIdx =
        participantAssetInfo.indexWhere((ai) => ai.assetKey == assetKey);
    if (rowIdx < 0) return this;
    //
    AssetStateUpdates newAsu = participantAssetInfo[rowIdx];
    newAsu = newAsu.copyWith(
      isOwned: isOwned ?? newAsu.isOwned,
      isWatched: isWatched ?? newAsu.isWatched,
    );
    List<AssetStateUpdates> lstCopy = participantAssetInfo.toList();
    lstCopy[rowIdx] = newAsu;
    return copyWith(participantAssetInfo: lstCopy);
  }

  // getters
  String get assetId1 => participantAssetInfo.isNotEmpty
      ? participantAssetInfo.first.assetKey
      : '_';
  String get assetId2 =>
      participantAssetInfo.length > 1 ? participantAssetInfo[1].assetKey : '_';
  bool get isTradableAsset1 => participantAssetInfo.isNotEmpty
      ? participantAssetInfo.first.isTradable && _isTradableGame
      : false;

  bool get isTradableAsset2 => participantAssetInfo.length > 1
      ? participantAssetInfo[1].isTradable && _isTradableGame
      : false;
  bool get _isTradableGame => gameStatus.isTradable;
  //
  int get competitorCount => participantAssetInfo.length;
  //
  String get gameDateStr => scheduledStartDtTm.asDtwMmDyStr;
  String get gameTimeStr => scheduledStartDtTm.asTimeOnlyStr;
  DateTime get scheduledStartDateOnly => scheduledStartDtTm.truncateTime;
  //

  Set<String> get _participantAssetIds =>
      participantAssetInfo.map((ai) => ai.assetKey).toSet();
  bool includesParticipant(String assetId) =>
      _participantAssetIds.contains(assetId);

  Set<String> get _ownedAssetIds => participantAssetInfo
      .where((ai) => ai.isOwned)
      .map((ai) => ai.assetKey)
      .toSet();
  Set<String> get _watchedAssetIds => participantAssetInfo
      .where((ai) => ai.isWatched)
      .map((ai) => ai.assetKey)
      .toSet();

  bool isOwned(String assetId) => _ownedAssetIds.contains(assetId);
  bool isWatched(String assetId) => _watchedAssetIds.contains(assetId);

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
      participantAssetInfo: [],
    );
  }
}


  // List<String> _makeLst(
  //   bool first,
  //   bool second,
  // ) {
  //       // List<String> watchedAssetIds = _makeLst(
  //   //   comp1IsWatched ?? isWatched(assetId1),
  //   //   comp2IsWatched ?? isWatched(assetId2),
  //   // );
  //   // List<String> ownedAssetIds = _makeLst(
  //   //   comp1IsOwned ?? isOwned(assetId1),
  //   //   comp2IsOwned ?? isOwned(assetId2),
  //   // );
  //   List<String> l = [];
  //   if (first) l.add(assetId1);
  //   if (second) l.add(assetId2);
  //   return l;
  // }



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
