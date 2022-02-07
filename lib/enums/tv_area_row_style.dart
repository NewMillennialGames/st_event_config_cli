part of EvCfgEnums;

@JsonEnum()
enum TvAreaRowStyle {
  /*
  these are the tbl-view row style options on 3 main screens:
    MarketView
    Leaderboard
    Portfolio
    MarketResearch

    2 Assets Per row only shows up on the MarketView screen
    for these four types
        teamVsTeam,
        teamVsTeamRanked,
        playerVsPlayer
        playerVsPlayerRanked
  */
  teamVsTeam,
  teamVsTeamRanked,
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
        _Rs.teamVsTeam,
        _Rs.teamVsTeamRanked,
      ].contains(this);
}
