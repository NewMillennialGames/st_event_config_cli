part of AppEntities;

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
  digitalAssetScored,
}

//
extension TvAreaRowStyleExt1 on TvAreaRowStyle {
  //
  bool get twoPerRowOnMarketViewScreen => [
        // applies only to MarketView
        TvAreaRowStyle.assetVsAsset,
        TvAreaRowStyle.assetVsAssetRanked,
      ].contains(this);

  bool get participantBasedListview => ![
        TvAreaRowStyle.assetVsAsset,
        TvAreaRowStyle.assetVsAssetRanked,
      ].contains(this);
  bool get gameBasedListview => !participantBasedListview;

  TvBasisForRow get rowFormatStyle => participantBasedListview
      ? TvBasisForRow.participantBased
      : TvBasisForRow.gameBased;
}

enum TvBasisForRow { gameBased, participantBased }

extension TvBasisForRowExt1 on TvBasisForRow {
  //

}
