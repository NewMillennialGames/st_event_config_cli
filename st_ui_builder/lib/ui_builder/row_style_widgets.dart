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
    return Container(
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: StColors.black,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MktRschAsset(rschAsset: assets.item1),
          MktRschAsset(rschAsset: assets.item2),
        ],
      ),
    );
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
    const double _sizeHeightCont = 60;
    const double _rowMargin = 8;
    return Container(
      height: (110 / 1.4) * 0.89,
      padding: const EdgeInsets.only(
        top: (110 / 2) * 0.08,
        left: (110 / 1) * 0.08,
      ),
      decoration: BoxDecoration(
        color: StColors.veryDarkGray,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            spreadRadius: 0,
            blurRadius: 1,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  assets.item1.topName +
                      '  ' +
                      assets.item1.shares.toStringAsFixed(2),
                  style: StTextStyles.textTeamNameMarketView.copyWith(
                    color: StColors.white,
                  ),
                ),
                Text(
                  '+' +
                      assets.item1.shares.toStringAsFixed(2) +
                      ' ' +
                      '(' +
                      assets.item1.percentage.toString() +
                      '%)',
                  style: StTextStyles.textTradeButtonTeamMarketView,
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: TextButton(
              child: Text(
                StStrings.portfolioPostionsRowTradeText,
                style: StTextStyles.textTradeButtonTeamMarketView,
              ),
              onPressed: () {},
              style: StButtonStyles.tradePlayerMarketView,
            ),
          ),
        ],
      ),
    );
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
    final size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: StColors.black,
        border: Border.symmetric(
          horizontal: BorderSide(
            color: StColors.borderTextField,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      assets.item1.icon,
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 10,
                          left: 3,
                          right: 3,
                        ),
                        child: Image.network(
                          assets.item1.imgUrl,
                          height: 60,
                          width: size.height <= 568 ? 40 : 50,
                          color: assets.item1.colorImage,
                          colorBlendMode: BlendMode.color,
                        ),
                      ),
                      Padding(
                        padding: size.height <= 568
                            ? const EdgeInsets.only(bottom: 20)
                            : const EdgeInsets.only(bottom: 30),
                        child: Text(
                          assets.item1.topName,
                          style: StTextStyles.textTeamNameMarketView.copyWith(
                            color: assets.item1.color,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                kTokensIcon,
                                height: 15,
                                width: 15,
                              ),
                              Text(
                                assets.item1.tokens.toStringAsFixed(2),
                                style:
                                    StTextStyles.textNameMarketTicker.copyWith(
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '${assets.item1.gain.isNegative ? assets.item1.gain.toStringAsFixed(2) : '+' + assets.item1.gain.toStringAsFixed(2)}',
                            style: StTextStyles.textGainPositiveTeamMarketView,
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      TextButton(
                        style: size.height <= 568
                            ? StButtonStyles.tradeTeamMarketLessWidthView
                            : StButtonStyles.tradeTeamMarketView,
                        onPressed: () {},
                        child: Text(
                          StStrings.tradeTextTeamWidget,
                          style: StTextStyles.textTradeButtonTeamMarketView,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                heightFactor: 5,
                child: Wrap(
                  spacing: 2,
                  children: [
                    Text(
                      StStrings.openTextTeamWidget,
                      style: StTextStyles.textOpenHighLowTeamMarketView,
                    ),
                    Text(
                      assets.item1.open.toStringAsPrecision(3),
                      style: StTextStyles.textValueMarketTicker.copyWith(
                        color: StColors.white,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      StStrings.highTextTeamWidget,
                      style: StTextStyles.textOpenHighLowTeamMarketView,
                    ),
                    Text(
                      assets.item1.high.toStringAsPrecision(3),
                      style: StTextStyles.textValueMarketTicker.copyWith(
                        color: StColors.white,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      StStrings.lowTextTeamWidget,
                      style: StTextStyles.textValueMarketTicker.copyWith(
                        color: StColors.white,
                      ),
                    ),
                    Text(
                      assets.item1.low.toStringAsPrecision(3),
                      style: StTextStyles.textValueMarketTicker.copyWith(
                        color: StColors.white,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
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
    final size = MediaQuery.of(context).size;
    const double _stdRowHeight = 110;
    return Container(
      height: _stdRowHeight,
      width: size.width,
      decoration: BoxDecoration(
        color: StColors.black,
        border: Border(
          bottom: BorderSide(
            color: StColors.borderTextField,
          ),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: Image.network(
              assets.item1.imgUrl,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            flex: 5,
            child: Column(
              // full height column to right of player image
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                AssetTopRow(player: assets.item1),
                HoldingsAndValueRow(player: assets.item1),
              ],
            ),
          ),
        ],
      ),
    );
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
    return Container(
      child: Text('Awaiting UX specs for <row-style-name>'),
    );
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
    const double _sizeHeightCont = 60;
    const double _rowMargin = 8;
    return Container(
      height: _sizeHeightCont,
      decoration: BoxDecoration(
        color: StColors.black,
        border: Border(
          bottom: BorderSide(
            color: StColors.borderTextField,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ObjectRankRow(
            position: assets.item1.positionStr,
            object: assets.item1.imgUrl,
            name: assets.item1.topName,
          ),
          Padding(
            padding: const EdgeInsets.only(
              right: _rowMargin,
            ),
            child: Row(
              children: [
                if (assets.item1.rank == true)
                  Text(
                    '＠',
                    style: StTextStyles.textLisTileTokens.copyWith(
                      fontSize: 17,
                      color: StColors.coolGray,
                    ),
                  ),
                Text(
                  assets.item1.priceStr,
                  style: StTextStyles.textLisTileTokens.copyWith(
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
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
    return Container(
      child: Text('Awaiting UX specs for <row-style-name>'),
    );
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
    return Container(
      child: Text('Awaiting UX specs for <row-style-name>'),
    );
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
    return Container(
      child: Text('Awaiting UX specs for <row-style-name>'),
    );
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
    return Container(
      child: Text('Awaiting UX specs for <row-style-name>'),
    );
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
    return Container(
      child: Text('Awaiting UX specs for <row-style-name>'),
    );
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
        height: 80,
        color: Colors.green[100],
        child: Row(
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                const Text('Rank:'),
                Container(
                  height: 26,
                  width: 26,
                  color: Colors.amber,
                  child: Text(
                    firstTeam.rankStr,
                    style: const TextStyle(
                      fontSize: 28,
                    ),
                  ),
                ),
              ],
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
