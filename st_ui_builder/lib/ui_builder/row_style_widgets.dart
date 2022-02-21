part of StUiController;

/*
  below are the tbl-view row style options on 4 main screens:
    MarketView
    Leaderboard
    Portfolio
    MarketResearch

we have one style for each value of:
    enum TvAreaRowStyle
  */

class AssetVsAssetRow extends StBaseTvRow with ShowsTwoAssets {
  AssetVsAssetRow(
    TableviewDataRowTuple assets, {
    Key? key,
  }) : super(assets, key: key);

  @override
  Widget rowBody(BuildContext context) {
    // paste row widget code here
    return Container();
  }
}

class AssetVsAssetRankedRow extends StBaseTvRow with ShowsTwoAssets {
  AssetVsAssetRankedRow(
    TableviewDataRowTuple assets, {
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
    TableviewDataRowTuple assets, {
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
    TableviewDataRowTuple assets, {
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
    TableviewDataRowTuple assets, {
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
    TableviewDataRowTuple assets, {
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
    TableviewDataRowTuple assets, {
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
    TableviewDataRowTuple assets, {
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
    TableviewDataRowTuple assets, {
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
    TableviewDataRowTuple assets, {
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
    TableviewDataRowTuple assets, {
    Key? key,
  }) : super(assets, key: key);

  @override
  Widget rowBody(BuildContext context) {
    // paste row widget code here
    return Container();
  }
}

// test classes only below
class TeamVsFieldRowTest extends StBaseTvRow with ShowsTwoAssets {
  TeamVsFieldRowTest(
    TableviewDataRowTuple assets, {
    Key? key,
  }) : super(assets, key: key);

  @override
  Widget rowBody(BuildContext context) {
    var firstTeam = assets.item1;
    return Container(
        height: 40,
        color: Colors.blue[100],
        child: Row(
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(firstTeam.topName),
            Text(firstTeam.subName),
            Text(firstTeam.regionOrConference),
            Text(firstTeam.gameDateStr),
          ],
        ));
  }
}

class TeamVsFieldRankedRowTest extends StBaseTvRow with ShowsTwoAssets {
  TeamVsFieldRankedRowTest(
    TableviewDataRowTuple assets, {
    Key? key,
  }) : super(assets, key: key);

  @override
  Widget rowBody(BuildContext context) {
    var firstTeam = assets.item1;
    return Container(
        height: 40,
        color: Colors.green[100],
        child: Row(
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 26,
              width: 26,
              color: Colors.amber,
              child: Text(
                firstTeam.rankStr,
                style: const TextStyle(
                  fontSize: 30,
                ),
              ),
            ),
            Column(
              children: [
                Text(firstTeam.topName),
                Text(firstTeam.subName),
              ],
            ),
            Text(firstTeam.regionOrConference),
          ],
        ));
  }
}
