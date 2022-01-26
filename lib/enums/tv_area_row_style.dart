part of EvCfgEnums;

@JsonEnum()
enum TvAreaRowStyle {
  /*
  these are the tbl-view row style options on 3 main screens:
    MarketView
    Leaderboard
    Portfolio

  */
  teamVsTeam,
  teamVsTeamRanked,
  teamVsField,
  teamVsFieldRanked,
  playerVsField,
  playerVsFieldRanked,
  teamPlayerVsField,
  driverVsField,
}

typedef _Rs = TvAreaRowStyle;

extension TvAreaRowStyleExt1 on TvAreaRowStyle {
  //
  bool get twoPerRowOnMarketScreens => [
        // applies to both MarketView and MarketResearch
        _Rs.teamVsTeam,
        _Rs.teamVsTeamRanked,
      ].contains(this);
}
