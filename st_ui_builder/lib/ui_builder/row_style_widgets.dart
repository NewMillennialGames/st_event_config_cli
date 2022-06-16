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

final _redrawAssetRowProvider = StateProvider<bool>((ref) => false);

class AssetVsAssetRowMktView extends StBaseTvRow
    with ShowsTwoAssets, RequiresGameStatus {
  //
  bool get showRank => false;

  //
  const AssetVsAssetRowMktView(
    TableviewDataRowTuple assets, {
    Key? key,
  }) : super(assets, key: key);

  @override
  Widget rowBody(
    BuildContext ctx,
    ActiveGameDetails agd,
  ) {
    // print('AssetVsAssetRow_MktView is rebuilding');
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AssetVsAssetHalfRow(comp1, agd, showRank, comp1.assetHoldingsSummary),
        SizedBox(height: UiSizes.spaceBtwnRows),
        AssetVsAssetHalfRow(comp2, agd, showRank, comp2.assetHoldingsSummary)
      ],
    );
  }
}

class AssetVsAssetRowLeaderBoardView extends StBaseTvRow with ShowsTwoAssets {
  //
  const AssetVsAssetRowLeaderBoardView(
    TableviewDataRowTuple assets, {
    Key? key,
  }) : super(assets, key: key);

  @override
  Widget rowBody(
    BuildContext ctx,
    ActiveGameDetails agd,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        LeaderboardHalfRow(
          competitor: comp1,
          showLeaderBoardIcon: true,
        ),
        SizedBox(height: UiSizes.spaceBtwnRows),
        LeaderboardHalfRow(competitor: comp2)
      ],
    );
  }
}

class DriverVsFieldRowLeaderBoardView extends StBaseTvRow with ShowsTwoAssets {
  //
  const DriverVsFieldRowLeaderBoardView(
    TableviewDataRowTuple assets, {
    Key? key,
  }) : super(assets, key: key);

  @override
  Widget rowBody(
    BuildContext ctx,
    ActiveGameDetails agd,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        LeaderboardHalfRow(
          competitor: comp1,
          showLeaderBoardIcon: true,
          isDriverVsField: true,
        ),
        SizedBox(height: UiSizes.spaceBtwnRows),
        LeaderboardHalfRow(competitor: comp2, isDriverVsField: true)
      ],
    );
  }
}

class TeamPlayerVsFieldLeaderBoardView extends StBaseTvRow with ShowsTwoAssets {
  //
  const TeamPlayerVsFieldLeaderBoardView(
    TableviewDataRowTuple assets, {
    Key? key,
  }) : super(assets, key: key);

  @override
  Widget rowBody(
    BuildContext ctx,
    ActiveGameDetails agd,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        LeaderboardHalfRow(
          competitor: comp1,
          showLeaderBoardIcon: true,
          isTeamPlayerVsField: true,
        ),
        SizedBox(height: UiSizes.spaceBtwnRows),
        LeaderboardHalfRow(competitor: comp2, isTeamPlayerVsField: true)
      ],
    );
  }
}

class AssetVsAssetRowRankedMktView extends AssetVsAssetRowMktView {
  //
  @override
  bool get showRank => true;

  const AssetVsAssetRowRankedMktView(
    TableviewDataRowTuple assets, {
    Key? key,
  }) : super(assets, key: key);
}

class TeamVsFieldRowMktResearchView extends TeamVsFieldRowMktView {
  const TeamVsFieldRowMktResearchView(
    TableviewDataRowTuple assets, {
    Key? key,
  }) : super(assets, key: key);
}

class PlayerVsFieldRankedMktResearchView extends TeamVsFieldRowMktView {
  const PlayerVsFieldRankedMktResearchView(
    TableviewDataRowTuple assets, {
    Key? key,
  }) : super(assets, key: key);
}

class PlayerVsFieldRowMktResearchView extends TeamVsFieldRowMktView {
  const PlayerVsFieldRowMktResearchView(
    TableviewDataRowTuple assets, {
    Key? key,
  }) : super(assets, key: key);
}

class DriverVsFieldRowMktResearchView extends DriverVsFieldRowMktView {
  const DriverVsFieldRowMktResearchView(
    TableviewDataRowTuple assets, {
    Key? key,
  }) : super(assets, key: key);
}

class TeamPlayerVsFieldRowMktResearchView extends TeamPlayerVsFieldRowMktView {
  const TeamPlayerVsFieldRowMktResearchView(
    TableviewDataRowTuple assets, {
    Key? key,
  }) : super(assets, key: key);
}

class AssetVsAssetRowRankedPortfolioView extends AssetVsAssetRowPortfolioView {
  const AssetVsAssetRowRankedPortfolioView(
    TableviewDataRowTuple assets, {
    Key? key,
  }) : super(assets, key: key);
}

class TeamVsFieldRowPortfolioView extends AssetVsAssetRowPortfolioView {
  const TeamVsFieldRowPortfolioView(
    TableviewDataRowTuple assets, {
    Key? key,
  }) : super(assets, key: key);
}

class PlayerVsFieldRankedPortfolioView extends AssetVsAssetRowPortfolioView {
  const PlayerVsFieldRankedPortfolioView(
    TableviewDataRowTuple assets, {
    Key? key,
  }) : super(assets, key: key);
}

class PlayerVsFieldRowPortfolioView extends AssetVsAssetRowPortfolioView {
  const PlayerVsFieldRowPortfolioView(
    TableviewDataRowTuple assets, {
    Key? key,
  }) : super(assets, key: key);
}

class AssetVsAssetRowMktResearchView extends StBaseTvRow with ShowsTwoAssets {
  //
  const AssetVsAssetRowMktResearchView(
    TableviewDataRowTuple assets, {
    Key? key,
  }) : super(assets, key: key);

  @override
  Widget rowBody(
    BuildContext ctx,
    ActiveGameDetails agd,
  ) {
    const Radius radius = Radius.circular(20);
    return Consumer(
        builder: (BuildContext context, WidgetRef ref, Widget? child) {
      void _assetTapHandler(
        bool showFirst,
      ) {
        //
        ref.read(_redrawAssetRowProvider.notifier).state = showFirst;
      }

      bool show2ndAsset = ref.watch(_redrawAssetRowProvider)!;
      AssetRowPropertyIfc selectedCompetitor = show2ndAsset ? comp2 : comp1;

      return Container(
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: StColors.black,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        child: MktRschAsset(
                            comp1,
                            show2ndAsset
                                ? StColors.veryDarkGray
                                : StColors.primaryDarkGray,
                            agd,
                            const BorderRadius.only(
                                topLeft: radius, bottomLeft: radius)),
                        onTap: () => _assetTapHandler(false),
                      ),
                      GestureDetector(
                        child: MktRschAsset(
                            comp2,
                            show2ndAsset
                                ? StColors.primaryDarkGray
                                : StColors.veryDarkGray,
                            agd,
                            const BorderRadius.only(
                                topRight: radius, bottomRight: radius)),
                        onTap: () => _assetTapHandler(true),
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                          border: Border.all(color: StColors.black, width: 3),
                          shape: BoxShape.circle,
                          color: StColors.darkGreen),
                      child: Center(
                          child: Text(
                        StStrings.versus,
                        style: StTextStyles.p2,
                      )),
                    ),
                  )
                ],
              ),
            ),
            RowControl(
              competitor: selectedCompetitor,
              gameDetails: agd,
            ),
          ],
        ),
      );
    });
  }
}

class AssetVsAssetRowPortfolioView extends StBaseTvRow
    with ShowsOneAsset, RequiresUserPositionProps {
  // almost identical to Portfolio History (1 word delta)

  bool get isDriverVsField => false;

  bool get isTeamPlayerVsField => false;

  // proceeds apply to a SALE
  bool get showProceeds => false;

  // holdings apply to what you currently own
  bool get showHoldingsValue => !showProceeds;

  const AssetVsAssetRowPortfolioView(
    TableviewDataRowTuple assets, {
    Key? key,
  }) : super(assets, key: key);

  @override
  Widget rowBody(
    BuildContext ctx,
    ActiveGameDetails agd,
  ) {
    //
    bool hasIncreased = comp1.recentPriceDelta >= Decimal.zero;
    String sharePrice = comp1.currPriceStr;
    String sharePriceChange = comp1.recentDeltaStr;
    TextStyle gainLossTxtStyle = hasIncreased
        ? StTextStyles.moneyDeltaPositive
        : StTextStyles.moneyDeltaPositive.copyWith(
            color: StColors.errorText,
          );
    // FIXME:  get position
    // TODO:  mixin "RequiresUserPositionProps" will give these values
    String sharesOwned = assetHoldingsSummary.sharesOwnedStr;
    String positionValue = assetHoldingsSummary.positionEstValueStr;
    String positionGainLoss = assetHoldingsSummary.positionGainLossStr;
    bool isGainLossPositive =
        assetHoldingsSummary.positionGainLoss >= Decimal.zero;
    Color gainLossColor =
        isGainLossPositive ? StColors.green : StColors.errorText;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      width: MediaQuery.of(ctx).size.width,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CompetitorImage(
            comp1.imgUrl,
            false,
            isTwoAssetRow: this is ShowsTwoAssets,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CheckAssetType(
                      competitor: comp1,
                      isDriverVsField: isDriverVsField,
                      isTeamPlayerVsField: isTeamPlayerVsField,
                    ),
                    if (showHoldingsValue)
                      // this is a portfolio positions row; show trade
                      TradeButton(comp1.assetStateUpdates, agd.gameStatus),
                  ],
                ),
                kVerticalSpacerSm,
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(top: 5, left: 10, right: 10),
                    color: StColors.veryDarkGray,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '$sharesOwned shares',
                              style: StTextStyles.p1
                                  .copyWith(color: StColors.coolGray),
                            ),
                            kVerticalSpacerSm,
                            RichText(
                              text: TextSpan(
                                  text: '@ ',
                                  style: StTextStyles.p1
                                      .copyWith(color: StColors.coolGray),
                                  children: [
                                    TextSpan(
                                      text: sharePrice.replaceAllMapped(
                                          RegexFunctions()
                                              .formatNumberStringsWithCommas,
                                          RegexFunctions().mathFunc),
                                      style: StTextStyles.p1,
                                    ),
                                    TextSpan(
                                      text:
                                          " ${sharePriceChange.replaceAllMapped(RegexFunctions().formatNumberStringsWithCommas, RegexFunctions().mathFunc)}",
                                      style: gainLossTxtStyle,
                                    )
                                  ]),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              showProceeds
                                  ? StStrings.proceeds
                                  : StStrings.value,
                              style: StTextStyles.p1.copyWith(
                                color: StColors.coolGray,
                              ),
                            ),
                            kVerticalSpacerSm,
                            Text(
                              positionValue.replaceAllMapped(
                                  RegexFunctions()
                                      .formatNumberStringsWithCommas,
                                  RegexFunctions().mathFunc),
                              style: StTextStyles.p1,
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(StStrings.gainLossAbbrev,
                                style: StTextStyles.p1
                                    .copyWith(color: StColors.coolGray)),
                            kVerticalSpacerSm,
                            Text(
                              (isGainLossPositive ? "+" : "") +
                                  positionGainLoss.replaceAllMapped(
                                      RegexFunctions()
                                          .formatNumberStringsWithCommas,
                                      RegexFunctions().mathFunc),
                              style: StTextStyles.p1
                                  .copyWith(color: gainLossColor),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class DriverVsFieldRowPortfolio extends AssetVsAssetRowPortfolioView {
  // this is portfolio POSITIONS
  const DriverVsFieldRowPortfolio(
    TableviewDataRowTuple assets, {
    Key? key,
  }) : super(assets, key: key);

  @override
  bool get isDriverVsField => true;

  @override
  bool get showProceeds => false;
}

class TeamPlayerVsFieldRowPortfolio extends AssetVsAssetRowPortfolioView {
  const TeamPlayerVsFieldRowPortfolio(
    TableviewDataRowTuple assets, {
    Key? key,
  }) : super(assets, key: key);

  @override
  bool get isTeamPlayerVsField => true;
}

class AssetVsAssetRowPortfolioHistory extends AssetVsAssetRowPortfolioView {
  //
  const AssetVsAssetRowPortfolioHistory(
    TableviewDataRowTuple assets, {
    Key? key,
  }) : super(assets, key: key);

  @override
  bool get showProceeds => true;
}

//
class DriverVsFieldRowPortfolioHistory extends AssetVsAssetRowPortfolioView {
  //
  const DriverVsFieldRowPortfolioHistory(
    TableviewDataRowTuple assets, {
    Key? key,
  }) : super(assets, key: key);

  @override
  bool get isDriverVsField => true;

  @override
  bool get showProceeds => true;
}

class TeamPlayerVsFieldRowPortfolioHistory
    extends AssetVsAssetRowPortfolioView {
  const TeamPlayerVsFieldRowPortfolioHistory(
    TableviewDataRowTuple assets, {
    Key? key,
  }) : super(assets, key: key);

  @override
  bool get isTeamPlayerVsField => true;

  @override
  bool get showProceeds => true;
}

class TeamVsFieldRowMktView extends StBaseTvRow
    with ShowsOneAsset, RequiresGameStatus, RequiresUserPositionProps {
  //
  bool get showRanked => false;

  bool get isDriverVsField => false;

  bool get isTeamPlayerVsField => false;

  // FIXME:  should be:
  // bool get isPlayerVsFieldRanked => isPlayerVsField && showRanked;
  // thats more flexible since you already have a showRanked boolean
  // rename property below to isPlayerVsField
  bool get isPlayerVsFieldRanked => false;

  bool get shouldShrinkParticipantImage => showRanked || isDriverVsField;

  const TeamVsFieldRowMktView(
    TableviewDataRowTuple assets, {
    Key? key,
  }) : super(assets, key: key);

  @override
  Widget rowBody(
    BuildContext ctx,
    ActiveGameDetails agd,
  ) {
    //
    final size = MediaQuery.of(ctx).size;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        assetHoldingsSummary.sharesOwned > 0
            ? const Icon(Icons.work, color: StColors.green)
            : WatchButton(
                assetKey: comp1.assetKey,
                isWatched: comp1.assetStateUpdates.isWatched,
              ),
        kSpacerSm,
        CompetitorImage(
          comp1.imgUrl,
          shouldShrinkParticipantImage,
          isTwoAssetRow: this is ShowsTwoAssets,
        ),
        const SizedBox(
          width: 12,
        ),
        SizedBox(
          width: size.width * .52,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 4,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CheckAssetType(
                    competitor: comp1,
                    isDriverVsField: isDriverVsField,
                    isTeamPlayerVsField: isTeamPlayerVsField,
                    isPlayerVsFieldRanked: isPlayerVsFieldRanked,
                  ),
                  Column(
                    children: [
                      Text(
                        comp1.currPriceStr,
                        style: StTextStyles.h5,
                      ),
                      Text(
                        comp1.recentDeltaStr,
                        style: StTextStyles.h5
                            .copyWith(color: comp1.priceFluxColor),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(
                height: 4,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    StStrings.open,
                    style: StTextStyles.p3.copyWith(color: StColors.coolGray),
                  ),
                  kSpacerSm,
                  Text(
                    comp1.openPriceStr,
                    style: StTextStyles.p3,
                  ),
                  const Spacer(),
                  Text(
                    StStrings.high,
                    style: StTextStyles.p3.copyWith(color: StColors.coolGray),
                  ),
                  kSpacerSm,
                  Text(
                    comp1.hiPriceStr,
                    style: StTextStyles.p3,
                  ),
                  const Spacer(),
                  Text(
                    StStrings.low,
                    style: StTextStyles.p3.copyWith(color: StColors.coolGray),
                  ),
                  kSpacerSm,
                  Text(
                    comp1.lowPriceStr,
                    style: StTextStyles.p3,
                  ),
                ],
              )
            ],
          ),
        ),
        TradeButton(comp1.assetStateUpdates, agd.gameStatus),
      ],
    );
  }
}

class TeamVsFieldRowRankedMktView extends TeamVsFieldRowMktView {
  //
  @override
  bool get showRanked => true;

  const TeamVsFieldRowRankedMktView(
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
  Widget rowBody(
    BuildContext ctx,
    ActiveGameDetails agd,
  ) {
    // paste row widget code here
    return const SizedBox(
      child: Text(
        'Awaiting UX specs for <TeamDraftRow>',
      ),
    );
  }
}

class TeamLineRow extends StBaseTvRow with ShowsOneAsset {
  const TeamLineRow(
    TableviewDataRowTuple assets, {
    Key? key,
  }) : super(assets, key: key);

  @override
  Widget rowBody(
    BuildContext ctx,
    ActiveGameDetails agd,
  ) {
    // paste row widget code here
    const double _sizeHeightCont = 60;
    const double _rowMargin = 8;
    return Container(
      height: _sizeHeightCont,
      decoration: kRowBoxDecor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
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
                    style: StTextStyles.h4.copyWith(
                      color: StColors.coolGray,
                    ),
                  ),
                Text(
                  comp1.currPriceStr,
                  style: StTextStyles.h3.copyWith(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TeamPlayerVsFieldRowMktView extends TeamVsFieldRowMktView {
  @override
  bool get isTeamPlayerVsField => true;

  const TeamPlayerVsFieldRowMktView(
    TableviewDataRowTuple assets, {
    Key? key,
  }) : super(assets, key: key);
}

class PlayerVsFieldRow extends StBaseTvRow with ShowsOneAsset {
  const PlayerVsFieldRow(
    TableviewDataRowTuple assets, {
    Key? key,
  }) : super(assets, key: key);

  @override
  Widget rowBody(
    BuildContext ctx,
    ActiveGameDetails agd,
  ) {
    // paste row widget code here
    return Container(
      child: const Text('Awaiting UX specs for <PlayerVsFieldRow>'),
      decoration: kRowBoxDecor,
    );
  }
}

class PlayerVsFieldRankedRowMktView extends TeamVsFieldRowMktView {
  @override
  bool get isPlayerVsFieldRanked => true;

  const PlayerVsFieldRankedRowMktView(
    TableviewDataRowTuple assets, {
    Key? key,
  }) : super(assets, key: key);
}

class PlayerVsFieldRowMktView extends TeamVsFieldRowMktView {
  const PlayerVsFieldRowMktView(
    TableviewDataRowTuple assets, {
    Key? key,
  }) : super(assets, key: key);
}

class PlayerDraftRow extends StBaseTvRow with ShowsOneAsset {
  const PlayerDraftRow(
    TableviewDataRowTuple assets, {
    Key? key,
  }) : super(assets, key: key);

  @override
  Widget rowBody(
    BuildContext ctx,
    ActiveGameDetails agd,
  ) {
    // paste row widget code here
    return Container(
      child: const Text('Awaiting UX specs for <PlayerDraftRow>'),
      decoration: kRowBoxDecor,
    );
  }
}

class DriverVsFieldRowMktView extends TeamVsFieldRowMktView {
  @override
  bool get isDriverVsField => true;

  @override
  bool get showRanked => true;

  const DriverVsFieldRowMktView(
    TableviewDataRowTuple assets, {
    Key? key,
  }) : super(assets, key: key);
}

// test classes only below
class TeamVsFieldRowTest extends StBaseTvRow with ShowsOneAsset {
  const TeamVsFieldRowTest(
    TableviewDataRowTuple assets, {
    Key? key,
  }) : super(assets, key: key);

  @override
  Widget rowBody(
    BuildContext ctx,
    ActiveGameDetails agd,
  ) {
    return Container(
        height: 40,
        color: Colors.blue[100],
        decoration: kRowBoxDecor,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
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
  Widget rowBody(
    BuildContext ctx,
    ActiveGameDetails agd,
  ) {
    return Container(
      height: 80.h,
      decoration: kRowBoxDecor,
      child: Row(
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              const Text('Rank:'),
              Container(
                height: 26.h,
                width: 26.h,
                color: Colors.amber,
                child: Text(
                  comp1.rankStr,
                  style: TextStyle(
                    fontSize: 28.sp,
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
//                               fontSize: 14.sp,
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
