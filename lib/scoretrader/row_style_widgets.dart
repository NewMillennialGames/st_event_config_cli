part of StUiController;

/*
  below are the tbl-view row style options on 4 main screens:
    MarketView
    Leaderboard
    Portfolio
    MarketResearch

need one for each of:

enum TvAreaRowStyle {
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
  */

class TeamVsTeamRow extends StBaseTvRow with ShowsTwoAssets {
  TeamVsTeamRow(
    StdRowData assets, {
    Key? key,
  }) : super(assets, key: key);

  @override
  Widget rowBody(BuildContext context) {
    return Container();
  }
}

class TeamVsTeamRankedRow extends StBaseTvRow with ShowsTwoAssets {
  TeamVsTeamRankedRow(
    StdRowData assets, {
    Key? key,
  }) : super(assets, key: key);

  @override
  Widget rowBody(BuildContext context) {
    return Container();
  }
}

class TeamVsFieldRow extends StBaseTvRow with ShowsOneAsset {
  TeamVsFieldRow(
    StdRowData assets, {
    Key? key,
  }) : super(assets, key: key);

  @override
  Widget rowBody(BuildContext context) {
    return Container();
  }
}
