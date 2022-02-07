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
    // paste row widget code here
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
    // paste row widget code here
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
    // paste row widget code here
    return Container();
  }
}

class TeamVsFieldRankedRow extends StBaseTvRow with ShowsOneAsset {
  TeamVsFieldRankedRow(
    StdRowData assets, {
    Key? key,
  }) : super(assets, key: key);

  @override
  Widget rowBody(BuildContext context) {
    // paste row widget code here
    return Container();
  }
}

class TeamDraftRow extends StBaseTvRow with ShowsOneAsset {
  TeamDraftRow(
    StdRowData assets, {
    Key? key,
  }) : super(assets, key: key);

  @override
  Widget rowBody(BuildContext context) {
    // paste row widget code here
    return Container();
  }
}

class TeamLineRow extends StBaseTvRow with ShowsOneAsset {
  TeamLineRow(
    StdRowData assets, {
    Key? key,
  }) : super(assets, key: key);

  @override
  Widget rowBody(BuildContext context) {
    // paste row widget code here
    return Container();
  }
}

class TeamPlayerVsFieldRow extends StBaseTvRow with ShowsOneAsset {
  TeamPlayerVsFieldRow(
    StdRowData assets, {
    Key? key,
  }) : super(assets, key: key);

  @override
  Widget rowBody(BuildContext context) {
    // paste row widget code here
    return Container();
  }
}

class PlayerVsFieldRow extends StBaseTvRow with ShowsOneAsset {
  PlayerVsFieldRow(
    StdRowData assets, {
    Key? key,
  }) : super(assets, key: key);

  @override
  Widget rowBody(BuildContext context) {
    // paste row widget code here
    return Container();
  }
}

class PlayerVsFieldRankedRow extends StBaseTvRow with ShowsOneAsset {
  PlayerVsFieldRankedRow(
    StdRowData assets, {
    Key? key,
  }) : super(assets, key: key);

  @override
  Widget rowBody(BuildContext context) {
    // paste row widget code here
    return Container();
  }
}

class PlayerDraftRow extends StBaseTvRow with ShowsOneAsset {
  PlayerDraftRow(
    StdRowData assets, {
    Key? key,
  }) : super(assets, key: key);

  @override
  Widget rowBody(BuildContext context) {
    // paste row widget code here
    return Container();
  }
}

class DriverVsFieldRow extends StBaseTvRow with ShowsOneAsset {
  DriverVsFieldRow(
    StdRowData assets, {
    Key? key,
  }) : super(assets, key: key);

  @override
  Widget rowBody(BuildContext context) {
    // paste row widget code here
    return Container();
  }
}
