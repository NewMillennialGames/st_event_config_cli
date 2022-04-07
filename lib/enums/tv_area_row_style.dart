part of EvCfgEnums;

@JsonEnum()
enum TvAreaRowStyle {
  /*
  these are the tbl-view row style options on 4 main screens:
    MarketView
    Leaderboard
    Portfolio
    MarketResearch

    2 Assets Per row only shows up on the MarketView screen
    for these two row types
        assetVsAsset,
        assetVsAssetRanked,
  */
  assetVsAsset, // aka teamVsTeam & playerVsPlayer
  assetVsAssetRanked, // aka teamVsTeamRanked & playerVsPlayerRanked
  teamVsField,
  teamVsFieldRanked,
  teamDraft,
  teamLine,
  teamPlayerVsField,
  playerVsField,
  playerVsFieldRanked,
  playerDraft,
  driverVsField,
}

typedef _Rs = TvAreaRowStyle;

extension TvAreaRowStyleExt1 on TvAreaRowStyle {
  //
  bool get twoPerRowOnMarketViewScreen => [
        // applies only to MarketView
        _Rs.assetVsAsset,
        _Rs.assetVsAssetRanked,
      ].contains(this);

  bool get _participantBasedListview => this.name.contains('Field');
  // bool get _gameBasedListview => !_participantBasedListview;

  TvBasisForRow get rowFormatStyle => _participantBasedListview
      ? TvBasisForRow.participantBased
      : TvBasisForRow.gameBased;
}

enum TvBasisForRow { gameBased, participantBased }

// extension TvBasisForRowExt1 on TvBasisForRow {
//   //

// }
