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

class AssetVsAssetRow_MktView extends StBaseTvRow
    with ShowsTwoAssets, RequiresGameStatus {
  //
  bool get showRank => false;
  //
  const AssetVsAssetRow_MktView(
    TableviewDataRowTuple assets, {
    Key? key,
  }) : super(assets, key: key);

  @override
  Widget rowBody(
    BuildContext context,
    ActiveGameDetails agd,
  ) {
    // print('AssetVsAssetRow_MktView is rebuilding');
    return Container(
      // margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: StColors.black,
        // borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          AssetVsAssetHalfRow(comp1, agd, showRank),
          AssetVsAssetHalfRow(comp2, agd, showRank),
        ],
      ),
    );
  }
}

class AssetVsAssetRowRanked_MktView extends AssetVsAssetRow_MktView {
  //
  @override
  bool get showRank => true;

  AssetVsAssetRowRanked_MktView(TableviewDataRowTuple assets) : super(assets);
}

class AssetVsAssetRow_MktResrch extends StBaseTvRow with ShowsOneAsset {
  //
  const AssetVsAssetRow_MktResrch(
    TableviewDataRowTuple assets, {
    Key? key,
  }) : super(assets, key: key);

  @override
  Widget rowBody(
    BuildContext context,
    ActiveGameDetails agd,
  ) {
    // bool hasIncreased = comp1.priceDelta > 0;
    // String sign = hasIncreased ? '+' : '-';

    String priceDeltaStr = comp1.recentDeltaStr;
    String pctIncrease =
        (comp1.recentPriceDelta / comp1.currPrice).toStringAsPrecision(1);

    return Container(
      padding: const EdgeInsets.all(5),
      // margin: const EdgeInsets.all(5),
      // decoration: BoxDecoration(
      //   color: StColors.black,
      //   borderRadius: BorderRadius.circular(15),
      // ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            children: [
              Text(
                comp1.topName + ' ' + comp1.currPriceStr,
                style: StTextStyles.h3,
              ),
              // Row(
              //   children: [
              //     Text(comp1.topName),
              //     Text(comp1.priceStr),
              //   ],
              // ),
              Text(
                '$priceDeltaStr ($pctIncrease%)',
                style: StTextStyles.h5,
              ),
            ],
          ),
          TradeButton(
            comp1.id,
            agd.gameStatus,
          ),
        ],
      ),
    );
  }
}

class AssetVsAssetRow_Portfolio extends StBaseTvRow
    with ShowsOneAsset, RequiresUserPositionProps {
  // almost identical to Portfolio History (1 word delta)
  bool get showProceeds => false;
  const AssetVsAssetRow_Portfolio(
    TableviewDataRowTuple assets, {
    Key? key,
  }) : super(assets, key: key);

  @override
  Widget rowBody(BuildContext context, ActiveGameDetails agd) {
    //
    bool hasIncreased = comp1.recentPriceDelta > 0;
    String sharePrice = comp1.currPriceStr;
    String sharePriceChange = comp1.recentDeltaStr;
    TextStyle gainLossTxtStyle = hasIncreased
        ? StTextStyles.moneyDeltaPositive
        : StTextStyles.moneyDeltaNegative;

    // FIXME:  get position
    // TODO:  mixin "RequiresUserPositionProps" will give these values
    String sharesOwned = assetHoldingsSummary.sharesOwnedStr;
    String positionValue = assetHoldingsSummary.positionEstValueStr;
    String positionGainLoss = assetHoldingsSummary.positionGainLossStr;

    // String sharesOwned = '11 shares';
    // String positionValue = '\$26.32';
    // String positionGainLoss = '\$133.32';

    return Row(
      children: [
        CompetitorImage(comp1.imgUrl),
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(comp1.topName),
                TradeButton(comp1.id, agd.gameStatus),
              ],
            ),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(sharesOwned),
                    Row(children: [
                      Text('@ $sharePrice'),
                      Text(
                        sharePriceChange,
                        style: gainLossTxtStyle,
                      ),
                    ]),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(showProceeds ? StStrings.proceeds : StStrings.value),
                    Text(positionValue),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(StStrings.gainLossAbbrev),
                    Text(positionGainLoss),
                  ],
                ),
              ],
            ),
          ],
        )
      ],
    );
  }
}

class AssetVsAssetRow_PortfolioHistory extends AssetVsAssetRow_Portfolio {
  //
  AssetVsAssetRow_PortfolioHistory(TableviewDataRowTuple assets)
      : super(assets);

  @override
  bool get showProceeds => true;
}
//

class TeamVsFieldRow_MktView extends StBaseTvRow
    with ShowsOneAsset, RequiresGameStatus {
  //
  bool get showRanked => false;
  const TeamVsFieldRow_MktView(
    TableviewDataRowTuple assets, {
    Key? key,
  }) : super(assets, key: key);

  @override
  Widget rowBody(BuildContext context, ActiveGameDetails agd) {
    //
    final size = MediaQuery.of(context).size;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (!showRanked) kStarIcon,
        if (showRanked) Text(comp1.rankStr),
        CompetitorImage(comp1.imgUrl),
        Column(
          children: [
            Row(
              children: [
                Text(
                  comp1.topName,
                  style: StTextStyles.h2,
                ),
                Column(
                  children: [
                    Text(comp1.currPriceStr),
                    Text(comp1.recentDeltaStr),
                  ],
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(StStrings.open),
                Text('3.00'),
                const Text(StStrings.high),
                Text('5.00'),
                const Text(StStrings.low),
                Text('3.00'),
              ],
            )
          ],
        ),
        Column(
          children: [
            TradeButton(
              comp1.id,
              agd.gameStatus,
            ),
            const SizedBox.expand(),
          ],
        ),
      ],
    );
  }
}

class TeamVsFieldRowRanked_MktView extends TeamVsFieldRow_MktView {
  //
  @override
  bool get showRanked => true;

  const TeamVsFieldRowRanked_MktView(
    TableviewDataRowTuple assets, {
    Key? key,
  }) : super(assets, key: key);
}

class TeamDraftRow extends StBaseTvRow with ShowsOneAsset {
  const TeamDraftRow(
    TableviewDataRowTuple assets, {
    Key? key,
  }) : super(assets, key: key);

  @override
  Widget rowBody(BuildContext context, ActiveGameDetails agd) {
    // paste row widget code here
    return Container(
      child: Text('Awaiting UX specs for <TeamDraftRow>'),
    );
  }
}

class TeamLineRow extends StBaseTvRow with ShowsOneAsset {
  const TeamLineRow(
    TableviewDataRowTuple assets, {
    Key? key,
  }) : super(assets, key: key);

  @override
  Widget rowBody(BuildContext context, ActiveGameDetails agd) {
    // paste row widget code here
    const double _sizeHeightCont = 60;
    const double _rowMargin = 8;
    return Container(
      height: _sizeHeightCont,
      decoration: const BoxDecoration(
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
            comp1,
            agd,
          ),
          Padding(
            padding: const EdgeInsets.only(
              right: _rowMargin,
            ),
            child: Row(
              children: [
                if (comp1.rank > 3)
                  Text(
                    '＠',
                    style: StTextStyles.textLisTileTokens.copyWith(
                      fontSize: 17,
                      color: StColors.coolGray,
                    ),
                  ),
                Text(
                  comp1.currPriceStr,
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
  const TeamPlayerVsFieldRow(
    TableviewDataRowTuple assets, {
    Key? key,
  }) : super(assets, key: key);

  @override
  Widget rowBody(BuildContext context, ActiveGameDetails agd) {
    // paste row widget code here
    return Container(
      child: Text('Awaiting UX specs for <TeamPlayerVsFieldRow>'),
    );
  }
}

class PlayerVsFieldRow extends StBaseTvRow with ShowsOneAsset {
  const PlayerVsFieldRow(
    TableviewDataRowTuple assets, {
    Key? key,
  }) : super(assets, key: key);

  @override
  Widget rowBody(BuildContext context, ActiveGameDetails agd) {
    // paste row widget code here
    return Container(
      child: Text('Awaiting UX specs for <PlayerVsFieldRow>'),
    );
  }
}

class PlayerVsFieldRankedRow extends StBaseTvRow with ShowsOneAsset {
  const PlayerVsFieldRankedRow(
    TableviewDataRowTuple assets, {
    Key? key,
  }) : super(assets, key: key);

  @override
  Widget rowBody(BuildContext context, ActiveGameDetails agd) {
    // paste row widget code here
    return Container(
      child: Text('Awaiting UX specs for <PlayerVsFieldRankedRow>'),
    );
  }
}

class PlayerDraftRow extends StBaseTvRow with ShowsOneAsset {
  const PlayerDraftRow(
    TableviewDataRowTuple assets, {
    Key? key,
  }) : super(assets, key: key);

  @override
  Widget rowBody(BuildContext context, ActiveGameDetails agd) {
    // paste row widget code here
    return Container(
      child: Text('Awaiting UX specs for <PlayerDraftRow>'),
    );
  }
}

class DriverVsFieldRow extends StBaseTvRow with ShowsOneAsset {
  const DriverVsFieldRow(
    TableviewDataRowTuple assets, {
    Key? key,
  }) : super(assets, key: key);

  @override
  Widget rowBody(BuildContext context, ActiveGameDetails agd) {
    // paste row widget code here
    return Container(
      child: Text('Awaiting UX specs for <DriverVsFieldRow>'),
    );
  }
}

// test classes only below
class TeamVsFieldRowTest extends StBaseTvRow with ShowsOneAsset {
  const TeamVsFieldRowTest(
    TableviewDataRowTuple assets, {
    Key? key,
  }) : super(assets, key: key);

  @override
  Widget rowBody(BuildContext context, ActiveGameDetails agd) {
    return Container(
        height: 40,
        color: Colors.blue[100],
        child: Row(
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(comp1.topName),
            Text('Round: ' + agd.roundName),
            Text(comp1.regionOrConference),
            Text(agd.scheduledStartDateOnly.asShortDtStr),
          ],
        ));
  }
}

class TeamVsFieldRankedRowTest extends StBaseTvRow with ShowsOneAsset {
  const TeamVsFieldRankedRowTest(
    TableviewDataRowTuple assets, {
    Key? key,
  }) : super(assets, key: key);

  @override
  Widget rowBody(BuildContext context, ActiveGameDetails agd) {
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
                  comp1.rankStr,
                  style: const TextStyle(
                    fontSize: 28,
                  ),
                ),
              ),
            ],
          ),
          Column(
            children: [
              Text(comp1.topName),
              Text(comp1.subName),
            ],
          ),
          Text(comp1.regionOrConference),
        ],
      ),
    );
  }
}


// @override
//   Widget rowBody(BuildContext context) {
//     // paste row widget code here
//     final size = MediaQuery.of(context).size;
//     const double _stdRowHeight = 110;
//     return Container(
//       height: _stdRowHeight,
//       width: size.width,
//       decoration: const BoxDecoration(
//         color: StColors.black,
//         border: Border(
//           bottom: BorderSide(
//             color: StColors.borderTextField,
//           ),
//         ),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.max,
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Expanded(
//             flex: 1,
//             child: Image.network(
//               comp1.imgUrl,
//               fit: BoxFit.cover,
//             ),
//           ),
//           Expanded(
//             flex: 5,
//             child: Column(
//               // full height column to right of player image
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,

//               children: [
//                 AssetTopRow(asset: comp1),
//                 HoldingsAndValueRow(asset: comp1),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

// class AssetVsAssetRankedRow extends StBaseTvRow with ShowsTwoAssets {
//   const AssetVsAssetRankedRow(
//     TableviewDataRowTuple assets, {
//     Key? key,
//   }) : super(assets, key: key);

//   @override
//   Widget rowBody(BuildContext context) {
//     // paste row widget code here
//     const double _sizeHeightCont = 60;
//     const double _rowMargin = 8;
//     return Container(
//       height: (110 / 1.4) * 0.89,
//       padding: const EdgeInsets.only(
//         top: (110 / 2) * 0.08,
//         left: (110 / 1) * 0.08,
//       ),
//       decoration: BoxDecoration(
//         color: StColors.veryDarkGray,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.5),
//             spreadRadius: 0,
//             blurRadius: 1,
//             offset: Offset(0, 1),
//           ),
//         ],
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.max,
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Flexible(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   comp1.topName + '  ' + '20 shares',
//                   style: StTextStyles.textTeamNameMarketView.copyWith(
//                     color: StColors.white,
//                   ),
//                 ),
//                 Text(
//                   '+' + 'first.shares' + ' ' + '(' + 'first.percentage' + '%)',
//                   style: StTextStyles.tradeButton,
//                   textAlign: TextAlign.left,
//                 ),
//               ],
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(right: 16),
//             child: TextButton(
//               child: Text(
//                 StStrings.trade,
//                 style: StTextStyles.tradeButton,
//               ),
//               onPressed: () {},
//               style: StButtonStyles.tradeButtonCanTrade,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


 // return Container(
    //   padding: const EdgeInsets.symmetric(horizontal: 5),
    //   decoration: const BoxDecoration(
    //     color: StColors.black,
    //     border: Border.symmetric(
    //       horizontal: BorderSide(
    //         color: StColors.borderTextField,
    //       ),
    //     ),
    //   ),
    //   child: Column(
    //     mainAxisSize: MainAxisSize.min,
    //     children: [
    //       Stack(
    //         children: [
    //           Row(
    //             mainAxisSize: MainAxisSize.max,
    //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //             children: [
    //               Row(
    //                 children: [
    //                   Image.network(comp1.imgUrl),
    //                   Padding(
    //                     padding: const EdgeInsets.only(
    //                       top: 10,
    //                       left: 3,
    //                       right: 3,
    //                     ),
    //                     child: Image.network(
    //                       comp1.imgUrl,
    //                       height: 60,
    //                       width: size.height <= 568 ? 40 : 50,
    //                       color: Colors.yellow,
    //                       colorBlendMode: BlendMode.color,
    //                     ),
    //                   ),
    //                   Padding(
    //                     padding: size.height <= 568
    //                         ? const EdgeInsets.only(bottom: 20)
    //                         : const EdgeInsets.only(bottom: 30),
    //                     child: Text(
    //                       assets.item1.topName,
    //                       style: StTextStyles.textTeamNameMarketView.copyWith(
    //                         color: Colors.yellow,
    //                       ),
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //               Row(
    //                 mainAxisAlignment: MainAxisAlignment.start,
    //                 crossAxisAlignment: CrossAxisAlignment.start,
    //                 children: [
    //                   Column(
    //                     crossAxisAlignment: CrossAxisAlignment.end,
    //                     children: [
    //                       Row(
    //                         mainAxisSize: MainAxisSize.min,
    //                         children: [
    //                           Image.asset(
    //                             kTokensIcon,
    //                             height: 15,
    //                             width: 15,
    //                           ),
    //                           Text(
    //                             'first.tokens',
    //                             style:
    //                                 StTextStyles.textNameMarketTicker.copyWith(
    //                               fontSize: 14,
    //                             ),
    //                           ),
    //                         ],
    //                       ),
    //                       Text(
    //                         '${comp1.priceDelta.isNegative ? comp1.priceDeltaStr : '+' + 'first.gain'}',
    //                         style: StTextStyles.moneyDeltaPositive,
    //                       ),
    //                     ],
    //                   ),
    //                   const SizedBox(
    //                     width: 10,
    //                   ),
    //                   TextButton(
    //                     style: size.height <= 568
    //                         ? StButtonStyles.tradeTeamMarketLessWidthView
    //                         : StButtonStyles.tradeTeamMarketView,
    //                     onPressed: () {},
    //                     child: Text(
    //                       StStrings.tradeUc,
    //                       style: StTextStyles.tradeButton,
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //             ],
    //           ),
    //           Align(
    //             alignment: Alignment.bottomCenter,
    //             heightFactor: 5,
    //             child: Wrap(
    //               spacing: 2,
    //               children: [
    //                 Text(
    //                   StStrings.open,
    //                   style: StTextStyles.textOpenHighLowTeamMarketView,
    //                 ),
    //                 Text(
    //                   comp1.priceStr,
    //                   style: StTextStyles.textValueMarketTicker.copyWith(
    //                     color: StColors.white,
    //                   ),
    //                 ),
    //                 const SizedBox(
    //                   width: 10,
    //                 ),
    //                 Text(
    //                   StStrings.high,
    //                   style: StTextStyles.textOpenHighLowTeamMarketView,
    //                 ),
    //                 Text(
    //                   'first.high',
    //                   style: StTextStyles.textValueMarketTicker.copyWith(
    //                     color: StColors.white,
    //                   ),
    //                 ),
    //                 const SizedBox(
    //                   width: 10,
    //                 ),
    //                 Text(
    //                   StStrings.low,
    //                   style: StTextStyles.textValueMarketTicker.copyWith(
    //                     color: StColors.white,
    //                   ),
    //                 ),
    //                 Text(
    //                   'first.low',
    //                   style: StTextStyles.textValueMarketTicker.copyWith(
    //                     color: StColors.white,
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           )
    //         ],
    //       ),
    //     ],
    //   ),
    // );