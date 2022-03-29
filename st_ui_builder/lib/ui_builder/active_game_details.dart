part of StUiController;

@freezed
class AssetStateUpdates with _$AssetStateUpdates {
  /* 
  carries Asset vals that may change & cause row-redraw

  state info for each specific asset is always
  carried by their NEXT/CURRENT game/competition

    AssetState vals are:
      assetNew,
      assetPretrade,
      assetOpen,
      assetClosed,
      assetArchived,
      assetFinished,
  */

  const AssetStateUpdates._();

  const factory AssetStateUpdates(
    String assetKey,
    String name,
    String ticker, {
    @Default(AssetState.assetNew) AssetState assetState,
    @Default(TradeMode.tradeMarket) TradeMode tradeMode,
    @Default(false) bool isWatched,
    @Default(false) bool isOwned,
    @Default(0) double curPrice,
    @Default(0) double hiPrice,
    @Default(0) double lowPrice,
    @Default(0) double openPrice,
  }) = _AssetStateUpdates;

  factory AssetStateUpdates.fromAsset(Asset a) {
    return AssetStateUpdates(
      a.key,
      a.name,
      a.ticker,
      assetState: a.state,
      tradeMode: a.tradeMode,
      openPrice: a.openingPrice.asPrice2d,
      curPrice: a.currentPrice > 0
          ? a.currentPrice.asPrice2d
          : a.openingPrice.asPrice2d,
    );
  }

  AssetStateUpdates replaceFromPriceUpdate(AssetInfo ai) {
    //
    return copyWith(
      curPrice: ai.price.asPrice2d,
      assetState: ai.state,
      tradeMode: ai.mode,
    );
  }

  bool get isTradable => assetState.isTradable;
  bool get stockIsUp => curPrice > openPrice;
  bool get isDecreasing => !stockIsUp;

  String get formattedChangeStr =>
      (isDecreasing ? '' : '+') + priceDeltaSinceOpenStr;

  double get priceDeltaSinceOpen => curPrice - openPrice;
  String get priceDeltaSinceOpenStr => priceDeltaSinceOpen.toStringAsFixed(2);
  String get curPriceStr => curPrice.toStringAsFixed(2);
  Color get priceFluxColor => stockIsUp ? Colors.green : Colors.red;
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
    // FIXME:  need to update participants
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

        really just changes a sub-rec (AssetStateUpdates) in the list
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

  ActiveGameDetails updateAsset(AssetStateUpdates asu) {
    //
    List<AssetStateUpdates> pLst = participantAssetInfo.toList();
    int idx = pLst.indexWhere((a) => a.assetKey == asu.assetKey);
    if (idx < 0) {
      pLst.add(asu);
    } else {
      pLst[idx] = asu;
    }
    return copyWith(participantAssetInfo: pLst);
  }

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
