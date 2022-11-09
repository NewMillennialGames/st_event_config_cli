part of StUiController;

/*
NOTE:
  please do not subclass these, UNLESS something is different
  we don't need different class names for different screens
  when the superclass is identical to the base class

  below are the tbl-view row style options on 4 main screens:
    MarketView
    Leaderboard
    Portfolio
    MarketResearch
we have one style for each value of:
    enum TvAreaRowStyle with values of:

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
        distressedAssetRanked,

    and there can be up-to one of each of the above style-classes
    for each screen in the app
    class names below should append the intended
    screen-name so it's clear where the row should
    be rendered
  */

class AssetVsAssetRowMktView extends StBaseTvRow
    with ShowsTwoAssets, RequiresGameStatus {
  //
  bool get showRank => false;

  //
  const AssetVsAssetRowMktView(
    TableviewDataRowTuple assets, {
    this.onTap,
    Key? key,
  }) : super(assets, key: key);

  final Function(TableviewDataRowTuple)? onTap;

  @override
  double get bottomMargin => 12.h;

  @override
  Widget rowBody(
    BuildContext ctx,
    ActiveGameDetails agd,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            ProviderScope.containerOf(ctx)
                .read(showMarketResearchSecondAssetProvider.notifier)
                .state = false;
            onTap?.call(assets);
          },
          child: AssetVsAssetHalfRow(
              comp1, agd, showRank, comp1.assetHoldingsSummary),
        ),
        SizedBox(height: UiSizes.spaceBtwnRows),
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            ProviderScope.containerOf(ctx)
                .read(showMarketResearchSecondAssetProvider.notifier)
                .state = true;
            onTap?.call(assets);
          },
          child: AssetVsAssetHalfRow(
              comp2, agd, showRank, comp2.assetHoldingsSummary),
        ),
      ],
    );
  }
}

class AssetVsAssetRowLeaderBoardView extends StBaseTvRow with ShowsTwoAssets {
  //
  const AssetVsAssetRowLeaderBoardView(
    TableviewDataRowTuple assets, {
    this.onTap,
    Key? key,
  }) : super(assets, key: key);

  final Function(TableviewDataRowTuple)? onTap;

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
    this.onTap,
    Key? key,
  }) : super(assets, key: key);

  final Function(TableviewDataRowTuple)? onTap;

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
    this.onTap,
    Key? key,
  }) : super(assets, key: key);

  final Function(TableviewDataRowTuple)? onTap;

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
    Function(TableviewDataRowTuple)? onTap,
    Key? key,
  }) : super(assets, key: key, onTap: onTap);
}

//
// Begin custom Market Research classes

class DraftPlayerRowMktResearchView extends StBaseTvRow with ShowsOneAsset {
  const DraftPlayerRowMktResearchView(
    TableviewDataRowTuple assets, {
    this.onTap,
    Key? key,
  }) : super(assets, key: key);

  final Function(TableviewDataRowTuple)? onTap;

  @override
  Widget rowBody(
    BuildContext ctx,
    ActiveGameDetails agd,
  ) {
    // paste row widget code here
    return const SizedBox(
      child: Text(
        'Awaiting UX specs for <DraftPlayerRowMktResearchView>',
        textAlign: TextAlign.center,
      ),
    );
  }
}

class DraftTeamRowMktResearchView extends StBaseTvRow with ShowsOneAsset {
  const DraftTeamRowMktResearchView(
    TableviewDataRowTuple assets, {
    this.onTap,
    Key? key,
  }) : super(assets, key: key);

  final Function(TableviewDataRowTuple)? onTap;

  @override
  Widget rowBody(
    BuildContext ctx,
    ActiveGameDetails agd,
  ) {
    // paste row widget code here
    return const SizedBox(
      child: Text(
        'Awaiting UX specs for <DraftTeamRowMktResearchView>',
        textAlign: TextAlign.center,
      ),
    );
  }
}

class TeamLineRowMktResearchView extends StBaseTvRow with ShowsOneAsset {
  const TeamLineRowMktResearchView(
    TableviewDataRowTuple assets, {
    this.onTap,
    Key? key,
  }) : super(assets, key: key);

  final Function(TableviewDataRowTuple)? onTap;

  @override
  Widget rowBody(
    BuildContext ctx,
    ActiveGameDetails agd,
  ) {
    return const SizedBox(
      child: Text(
        'Awaiting UX specs for <TeamLineRowMktResearchView>',
        textAlign: TextAlign.center,
      ),
    );
  }
}

class AssetVsAssetRowMktResearchView extends StBaseTvRow with ShowsTwoAssets {
  //
  const AssetVsAssetRowMktResearchView(
    TableviewDataRowTuple assets, {
    this.onTap,
    Key? key,
  }) : super(assets, key: key);

  final Function(TableviewDataRowTuple)? onTap;

  @override
  Widget rowBody(
    BuildContext ctx,
    ActiveGameDetails agd,
  ) {
    const Radius radius = Radius.circular(20);
    return Consumer(builder: (
      BuildContext context,
      WidgetRef ref,
      Widget? child,
    ) {
      void _assetTapHandler(
        bool showFirst,
      ) {
        //
        ref.read(showMarketResearchSecondAssetProvider.notifier).state =
            showFirst;
        onTap?.call(assets);
      }

      bool show2ndAsset = ref.watch(showMarketResearchSecondAssetProvider)!;
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
                            topLeft: radius,
                            bottomLeft: radius,
                          ),
                        ),
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
                            topRight: radius,
                            bottomRight: radius,
                          ),
                        ),
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
                        color: StColors.darkGreen,
                      ),
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

// class TeamVsFieldRowMktResearchView extends TeamVsFieldRowMktView {
//   const TeamVsFieldRowMktResearchView(
//     TableviewDataRowTuple assets, {
//     Key? key,
//   }) : super(assets, key: key);
// }

// class TeamVsFieldRankedRowMktResearchView extends TeamVsFieldRowMktView {
//   const TeamVsFieldRankedRowMktResearchView(
//     TableviewDataRowTuple assets, {
//     Key? key,
//   }) : super(assets, key: key);
// }

// class PlayerVsFieldRankedMktResearchView extends TeamVsFieldRowMktView {
//   const PlayerVsFieldRankedMktResearchView(
//     TableviewDataRowTuple assets, {
//     Key? key,
//   }) : super(assets, key: key);
// }

// class PlayerVsFieldRowMktResearchView extends TeamVsFieldRowMktView {
//   const PlayerVsFieldRowMktResearchView(
//     TableviewDataRowTuple assets, {
//     Key? key,
//   }) : super(assets, key: key);
// }

// class DriverVsFieldRowMktResearchView extends DriverVsFieldRowMktView {
//   const DriverVsFieldRowMktResearchView(
//     TableviewDataRowTuple assets, {
//     Key? key,
//   }) : super(assets, key: key);
// }

// class TeamPlayerVsFieldRowMktResearchView extends TeamPlayerVsFieldRowMktView {
//   const TeamPlayerVsFieldRowMktResearchView(
//     TableviewDataRowTuple assets, {
//     Key? key,
//   }) : super(assets, key: key);
// }

// class AssetVsAssetRankedRowMktResearchView
//     extends AssetVsAssetRowMktResearchView {
//   const AssetVsAssetRankedRowMktResearchView(
//     TableviewDataRowTuple assets, {
//     Key? key,
//   }) : super(assets, key: key);
// }

// End Market Research classes

class AssetVsAssetRowRankedPortfolioView extends AssetVsAssetRowPortfolioView {
  const AssetVsAssetRowRankedPortfolioView(
    TableviewDataRowTuple assets, {
    Function(TableviewDataRowTuple)? onTap,
    Key? key,
  }) : super(assets, key: key, onTap: onTap);
}

class TeamVsFieldRowPortfolioView extends AssetVsAssetRowPortfolioView {
  const TeamVsFieldRowPortfolioView(
    TableviewDataRowTuple assets, {
    Function(TableviewDataRowTuple)? onTap,
    Key? key,
  }) : super(assets, key: key, onTap: onTap);
}

class TeamVsFieldRankedRowPortfolioView extends AssetVsAssetRowPortfolioView {
  const TeamVsFieldRankedRowPortfolioView(
    TableviewDataRowTuple assets, {
    Function(TableviewDataRowTuple)? onTap,
    Key? key,
  }) : super(assets, key: key, onTap: onTap);
}

class PlayerVsFieldRankedPortfolioView extends AssetVsAssetRowPortfolioView {
  const PlayerVsFieldRankedPortfolioView(
    TableviewDataRowTuple assets, {
    Function(TableviewDataRowTuple)? onTap,
    Key? key,
  }) : super(assets, key: key, onTap: onTap);
}

class PlayerVsFieldRowPortfolioView extends AssetVsAssetRowPortfolioView {
  const PlayerVsFieldRowPortfolioView(
    TableviewDataRowTuple assets, {
    Function(TableviewDataRowTuple)? onTap,
    Key? key,
  }) : super(assets, key: key, onTap: onTap);
}

class AssetVsAssetRowPortfolioView extends StBaseTvRow
    with ShowsOneAsset, RequiresUserPositionProps {
  // almost identical to Portfolio History (1 word delta)

  bool get isDriverVsField => false;

  bool get isTeamPlayerVsField => false;

  bool get isPlayerVsFieldRanked => false;

  // proceeds apply to a SALE
  bool get showProceeds => false;

  // holdings apply to what you currently own
  bool get showHoldingsValue => !showProceeds;

  const AssetVsAssetRowPortfolioView(
    TableviewDataRowTuple assets, {
    this.onTap,
    Key? key,
  }) : super(assets, key: key);

  final Function(TableviewDataRowTuple)? onTap;

  @override
  Widget rowBody(
    BuildContext ctx,
    ActiveGameDetails agd,
  ) {
    late String sharePrice;
    late String sharePriceChange;
    late String sharesOwned;
    late String positionValue;
    late String tradeSource;
    late Decimal positionGainLoss;
    Decimal shareCostBasis = Decimal.zero;
    if (showProceeds) {
      final order = comp1.assetHoldingsSummary.order ?? Order.getDefault();
      tradeSource = order.tradeSource;
      final price =
          (Decimal.fromInt(order.pricePer.toInt()) / Decimal.fromInt(100))
              .toDecimal();
      sharePrice = price.toStringAsFixed(2);
      sharePriceChange = '';
      sharesOwned = order.shares.toString();
      positionValue =
          (price * Decimal.fromInt(order.shares.toInt())).toStringAsFixed(2);
      positionGainLoss =
          (Decimal.fromInt(order.gainLoss.toInt()) / Decimal.fromInt(100))
              .toDecimal();
      tradeSource = order.tradeSource;
    } else {
      final holdings = comp1.assetHoldingsSummary;
      tradeSource = '';
      shareCostBasis =
          (holdings.positionCost / Decimal.fromInt(holdings.sharesOwned))
              .toDecimal(scaleOnInfinitePrecision: 2);
      sharePrice = shareCostBasis.toStringAsFixed(2);
      sharePriceChange = (comp1.currPrice - shareCostBasis).toStringAsFixed(2);
      sharesOwned = holdings.sharesOwnedStr;
      positionValue = holdings.positionEstValueStr;
      positionGainLoss = holdings.positionGainLoss;
    }

    String positionGainLossStr = positionGainLoss.toStringAsFixed(2);
    bool isPositiveGainLoss = positionGainLoss > Decimal.zero;
    Color priceFluxColor = isPositiveGainLoss ? StColors.green : StColors.red;
    Color sharePriceChangeColor =
        (comp1.currPrice - shareCostBasis) > Decimal.zero
            ? StColors.green
            : StColors.red;

    //
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        onTap?.call(assets);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.h),
        width: MediaQuery.of(ctx).size.width,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CompetitorImage(comp1.imgUrl, false),
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
                          isPlayerVsFieldRanked: isPlayerVsFieldRanked,
                          isTeamPlayerVsField: isTeamPlayerVsField,
                          tradeSource: tradeSource,
                        ),
                        if (showHoldingsValue)
                          // this is a portfolio positions row; show trade
                          TradeButton(
                              comp1.assetStateUpdates, comp1.gameStatus),
                      ]),
                  kVerticalSpacerSm,
                  Expanded(
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
                      color: StColors.veryDarkGray,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '$sharesOwned shares',
                                style: StTextStyles.p1.copyWith(
                                  color: StColors.coolGray,
                                ),
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
                                          style: StTextStyles.moneyDeltaPositive
                                              .copyWith(
                                            color: sharePriceChangeColor,
                                          ))
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
                                (isPositiveGainLoss ? "+" : "") +
                                    positionGainLossStr.replaceAllMapped(
                                        RegexFunctions()
                                            .formatNumberStringsWithCommas,
                                        RegexFunctions().mathFunc),
                                style: StTextStyles.moneyDeltaPositive.copyWith(
                                  color: priceFluxColor,
                                ),
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
      ),
    );
  }
}

class DriverVsFieldRowPortfolio extends AssetVsAssetRowPortfolioView {
  // this is portfolio POSITIONS
  const DriverVsFieldRowPortfolio(
    TableviewDataRowTuple assets, {
    Function(TableviewDataRowTuple)? onTap,
    Key? key,
  }) : super(assets, key: key, onTap: onTap);

  @override
  bool get isDriverVsField => true;

  @override
  bool get showProceeds => false;
}

class TeamPlayerVsFieldRowPortfolio extends AssetVsAssetRowPortfolioView {
  const TeamPlayerVsFieldRowPortfolio(
    TableviewDataRowTuple assets, {
    Function(TableviewDataRowTuple)? onTap,
    Key? key,
  }) : super(assets, key: key, onTap: onTap);

  @override
  bool get isTeamPlayerVsField => true;
}

class AssetVsAssetRowPortfolioHistory extends AssetVsAssetRowPortfolioView {
  //
  const AssetVsAssetRowPortfolioHistory(
    TableviewDataRowTuple assets, {
    Function(TableviewDataRowTuple)? onTap,
    Key? key,
  }) : super(assets, key: key, onTap: onTap);

  @override
  bool get showProceeds => true;
}

class AssetVsAssetRankedRowPortfolioHistory
    extends AssetVsAssetRowPortfolioHistory {
  //
  const AssetVsAssetRankedRowPortfolioHistory(
    TableviewDataRowTuple assets, {
    Function(TableviewDataRowTuple)? onTap,
    Key? key,
  }) : super(assets, key: key, onTap: onTap);
}

class TeamVsFieldRowPortfolioHistoryView
    extends AssetVsAssetRowPortfolioHistory {
  //
  const TeamVsFieldRowPortfolioHistoryView(
    TableviewDataRowTuple assets, {
    Function(TableviewDataRowTuple)? onTap,
    Key? key,
  }) : super(assets, key: key, onTap: onTap);
}

class TeamVsFieldRankedRowPortfolioHistoryView
    extends AssetVsAssetRowPortfolioHistory {
  //
  const TeamVsFieldRankedRowPortfolioHistoryView(
    TableviewDataRowTuple assets, {
    Function(TableviewDataRowTuple)? onTap,
    Key? key,
  }) : super(assets, key: key, onTap: onTap);
}

class PlayerVsFieldRowPortfolioHistoryView
    extends AssetVsAssetRowPortfolioHistory {
  //
  const PlayerVsFieldRowPortfolioHistoryView(
    TableviewDataRowTuple assets, {
    Function(TableviewDataRowTuple)? onTap,
    Key? key,
  }) : super(assets, key: key, onTap: onTap);
}

class PlayerVsFieldRankedPortfolioHistoryView
    extends AssetVsAssetRowPortfolioHistory {
  //
  const PlayerVsFieldRankedPortfolioHistoryView(
    TableviewDataRowTuple assets, {
    Function(TableviewDataRowTuple)? onTap,
    Key? key,
  }) : super(assets, key: key, onTap: onTap);

  @override
  bool get isPlayerVsFieldRanked => true;
}

//
class DriverVsFieldRowPortfolioHistory extends AssetVsAssetRowPortfolioView {
  //
  const DriverVsFieldRowPortfolioHistory(
    TableviewDataRowTuple assets, {
    Function(TableviewDataRowTuple)? onTap,
    Key? key,
  }) : super(assets, key: key, onTap: onTap);

  @override
  bool get isDriverVsField => true;

  @override
  bool get showProceeds => true;
}

class TeamPlayerVsFieldRowPortfolioHistory
    extends AssetVsAssetRowPortfolioView {
  const TeamPlayerVsFieldRowPortfolioHistory(
    TableviewDataRowTuple assets, {
    Function(TableviewDataRowTuple)? onTap,
    Key? key,
  }) : super(assets, key: key, onTap: onTap);

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
    this.onTap,
    Key? key,
  }) : super(assets, key: key);

  final Function(TableviewDataRowTuple)? onTap;

  @override
  Widget rowBody(
    BuildContext ctx,
    ActiveGameDetails agd,
  ) {
    //
    final size = MediaQuery.of(ctx).size;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        onTap?.call(assets);
      },
      child: Row(
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
          kSpacerSm,
          Expanded(
            // width: size.width * .53,
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
                    kSpacerTiny,
                    Text(
                      comp1.openPriceStr,
                      style: StTextStyles.p3,
                    ),
                    const Spacer(),
                    Text(
                      StStrings.high,
                      style: StTextStyles.p3.copyWith(color: StColors.coolGray),
                    ),
                    kSpacerTiny,
                    Text(
                      comp1.hiPriceStr,
                      style: StTextStyles.p3,
                    ),
                    const Spacer(),
                    Text(
                      StStrings.low,
                      style: StTextStyles.p3.copyWith(color: StColors.coolGray),
                    ),
                    kSpacerTiny,
                    Text(
                      comp1.lowPriceStr,
                      style: StTextStyles.p3,
                    ),
                  ],
                )
              ],
            ),
          ),
          TradeButton(comp1.assetStateUpdates, comp1.gameStatus),
        ],
      ),
    );
  }
}

class TeamVsFieldRowRankedMktView extends TeamVsFieldRowMktView {
  //
  @override
  bool get isPlayerVsFieldRanked => true;

  const TeamVsFieldRowRankedMktView(
    TableviewDataRowTuple assets, {
    Function(TableviewDataRowTuple)? onTap,
    Key? key,
  }) : super(assets, key: key, onTap: onTap);
}

class TeamPlayerVsFieldRowMktView extends TeamVsFieldRowMktView {
  @override
  bool get isTeamPlayerVsField => true;

  const TeamPlayerVsFieldRowMktView(
    TableviewDataRowTuple assets, {
    Function(TableviewDataRowTuple)? onTap,
    Key? key,
  }) : super(assets, key: key);
}

class PlayerVsFieldRankedRowMktView extends TeamVsFieldRowMktView {
  @override
  bool get isPlayerVsFieldRanked => true;

  const PlayerVsFieldRankedRowMktView(
    TableviewDataRowTuple assets, {
    Function(TableviewDataRowTuple)? onTap,
    Key? key,
  }) : super(assets, key: key, onTap: onTap);
}

class PlayerVsFieldRowMktView extends TeamVsFieldRowMktView {
  const PlayerVsFieldRowMktView(
    TableviewDataRowTuple assets, {
    Function(TableviewDataRowTuple)? onTap,
    Key? key,
  }) : super(assets, key: key, onTap: onTap);
}

class DriverVsFieldRowMktView extends TeamVsFieldRowMktView {
  @override
  bool get isDriverVsField => true;

  @override
  bool get showRanked => true;

  const DriverVsFieldRowMktView(
    TableviewDataRowTuple assets, {
    Function(TableviewDataRowTuple)? onTap,
    Key? key,
  }) : super(assets, key: key, onTap: onTap);
}

class DraftPlayerRowMktView extends StBaseTvRow with ShowsOneAsset {
  const DraftPlayerRowMktView(
    TableviewDataRowTuple assets, {
    this.onTap,
    Key? key,
  }) : super(assets, key: key);

  final Function(TableviewDataRowTuple)? onTap;

  @override
  Widget rowBody(
    BuildContext ctx,
    ActiveGameDetails agd,
  ) {
    // paste row widget code here
    return const SizedBox(
      child: Text(
        'Awaiting UX specs for <DraftPlayerRow>',
      ),
    );
  }
}

class DraftTeamRowMktView extends StBaseTvRow with ShowsOneAsset {
  const DraftTeamRowMktView(
    TableviewDataRowTuple assets, {
    this.onTap,
    Key? key,
  }) : super(assets, key: key);

  final Function(TableviewDataRowTuple)? onTap;

  @override
  Widget rowBody(
    BuildContext ctx,
    ActiveGameDetails agd,
  ) {
    // paste row widget code here
    return const SizedBox(
      child: Text(
        'Awaiting UX specs for <DraftTeamRow>',
      ),
    );
  }
}

class TeamLineRowMktView extends StBaseTvRow with ShowsOneAsset {
  const TeamLineRowMktView(
    TableviewDataRowTuple assets, {
    this.onTap,
    Key? key,
  }) : super(assets, key: key);

  final Function(TableviewDataRowTuple)? onTap;

  @override
  Widget rowBody(
    BuildContext ctx,
    ActiveGameDetails agd,
  ) {
    return const SizedBox(
      child: Text(
        'Awaiting UX specs for <TeamLineRow>',
      ),
    );
  }
}

class DraftPlayerRowPortfolioView extends StBaseTvRow with ShowsOneAsset {
  const DraftPlayerRowPortfolioView(
    TableviewDataRowTuple assets, {
    this.onTap,
    Key? key,
  }) : super(assets, key: key);

  final Function(TableviewDataRowTuple)? onTap;

  @override
  Widget rowBody(
    BuildContext ctx,
    ActiveGameDetails agd,
  ) {
    // paste row widget code here
    return const SizedBox(
      child: Text(
        'Awaiting UX specs for <DraftPlayerRow>',
      ),
    );
  }
}

class DraftTeamRowPortfolioView extends StBaseTvRow with ShowsOneAsset {
  const DraftTeamRowPortfolioView(
    TableviewDataRowTuple assets, {
    this.onTap,
    Key? key,
  }) : super(assets, key: key);

  final Function(TableviewDataRowTuple)? onTap;

  @override
  Widget rowBody(
    BuildContext ctx,
    ActiveGameDetails agd,
  ) {
    // paste row widget code here
    return const SizedBox(
      child: Text(
        'Awaiting UX specs for <DraftTeamRow>',
      ),
    );
  }
}

class TeamLineRowPortfolioView extends StBaseTvRow with ShowsOneAsset {
  const TeamLineRowPortfolioView(
    TableviewDataRowTuple assets, {
    this.onTap,
    Key? key,
  }) : super(assets, key: key);

  final Function(TableviewDataRowTuple)? onTap;

  @override
  Widget rowBody(
    BuildContext ctx,
    ActiveGameDetails agd,
  ) {
    return const SizedBox(
      child: Text(
        'Awaiting UX specs for <TeamLineRow>',
      ),
    );
  }
}

class TeamLineRowPortfolioHistoryView extends TeamLineRowPortfolioView {
  //
  const TeamLineRowPortfolioHistoryView(
    TableviewDataRowTuple assets, {
    Function(TableviewDataRowTuple)? onTap,
    Key? key,
  }) : super(assets, key: key, onTap: onTap);
}

// test classes only below
class DraftTeamRowPortfolioHistoryView extends DraftTeamRowPortfolioView {
  //
  const DraftTeamRowPortfolioHistoryView(
    TableviewDataRowTuple assets, {
    Function(TableviewDataRowTuple)? onTap,
    Key? key,
  }) : super(assets, key: key, onTap: onTap);
}

class DraftPlayerRowPortfolioHistoryView extends DraftPlayerRowPortfolioView {
  //
  const DraftPlayerRowPortfolioHistoryView(
    TableviewDataRowTuple assets, {
    Function(TableviewDataRowTuple)? onTap,
    Key? key,
  }) : super(assets, key: key, onTap: onTap);
}

class DistressedAssetRanked extends StBaseTvRow {
  // TODO for Chrysalis

  bool get showRank => false;

  const DistressedAssetRanked(
    TableviewDataRowTuple assets, {
    this.onTap,
    Key? key,
  }) : super(assets, key: key);

  final Function(TableviewDataRowTuple)? onTap;

  @override
  Widget rowBody(
    BuildContext ctx,
    ActiveGameDetails agd,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // AssetVsAssetHalfRow(comp1, agd, showRank, comp1.assetHoldingsSummary),
        SizedBox(height: UiSizes.spaceBtwnRows),
        // AssetVsAssetHalfRow(comp2, agd, showRank, comp2.assetHoldingsSummary)
      ],
    );
  }
}

class ChysalisAssetRowPortfolioView extends StBaseTvRow
    with ShowsOneAsset, RequiresGameStatus, RequiresUserPositionProps {
  const ChysalisAssetRowPortfolioView(
    TableviewDataRowTuple assets, {
    this.onTap,
    Key? key,
  }) : super(assets, key: key);

  final Function(TableviewDataRowTuple)? onTap;

  @override
  Widget rowBody(
    BuildContext ctx,
    ActiveGameDetails agd,
  ) {
    late String sharePrice;
    late String sharePriceChange;
    late String sharesOwned;
    late String positionValue;
    late Decimal positionGainLoss;

    final holdings = comp1.assetHoldingsSummary;
    sharePrice = comp1.currPriceStr;
    sharePriceChange = comp1.recentDeltaStr;
    sharesOwned = holdings.sharesOwnedStr;
    positionValue = holdings.positionEstValueStr;
    positionGainLoss =
        (holdings.positionGainLoss / Decimal.fromInt(100)).toDecimal();

    String positionGainLossStr = positionGainLoss.toStringAsFixed(2);
    bool isPositiveGainLoss = positionGainLoss > Decimal.zero;
    Color priceFluxColor = isPositiveGainLoss ? StColors.green : StColors.red;
    final assetDetails = ChrysalisAssetDetails.fromJson(
      jsonDecode(comp1.extAtts),
    );
    final size = MediaQuery.of(ctx).size;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        onTap?.call(assets);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
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
                true,
                isTwoAssetRow: false,
                fit: BoxFit.fitWidth,
              ),
              kSpacerSm,
              SizedBox(
                width: size.width * .75,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 4.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                minWidth: size.width * 0.4,
                                maxWidth: size.width * 0.4,
                              ),
                              child: Text(
                                "${comp1.position}: ${comp1.assetStateUpdates.name.substring(0, 6)}...",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: StTextStyles.h5,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                minWidth: size.width * 0.4,
                                maxWidth: size.width * 0.4,
                              ),
                              child: Text(
                                "Issue: ${assetDetails.accessibilityIssue}",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: StTextStyles.h5,
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
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
                              ),
                              const Spacer(),
                              TradeButton(
                                comp1.assetStateUpdates,
                                comp1.gameStatus,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          kVerticalSpacerSm,
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 92.w),
              padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
              color: StColors.veryDarkGray,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$sharesOwned units',
                        style: StTextStyles.p1.copyWith(
                          color: StColors.coolGray,
                        ),
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
                                  style:
                                      StTextStyles.moneyDeltaPositive.copyWith(
                                    color: comp1.priceFluxColor,
                                  ))
                            ]),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        StStrings.proceeds,
                        style: StTextStyles.p1.copyWith(
                          color: StColors.coolGray,
                        ),
                      ),
                      kVerticalSpacerSm,
                      Text(
                        positionValue.replaceAllMapped(
                            RegexFunctions().formatNumberStringsWithCommas,
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
                        (isPositiveGainLoss ? "+" : "") +
                            positionGainLossStr.replaceAllMapped(
                                RegexFunctions().formatNumberStringsWithCommas,
                                RegexFunctions().mathFunc),
                        style: StTextStyles.moneyDeltaPositive.copyWith(
                          color: priceFluxColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              SizedBox(width: 32.w),
              Image.asset(
                "assets/digital-wallet.png",
                height: UiSizes.teamImgSide * 0.70,
                width: UiSizes.teamImgSide * 0.70,
              ),
              kSpacerSm,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: size.width * .42),
                    child: Text(
                      assetDetails.custodyType,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: StTextStyles.p2.copyWith(color: StColors.blue),
                    ),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: size.width * .42),
                    child: Text(
                      "${assetDetails.walletType} wallet",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: StTextStyles.p2.copyWith(color: StColors.blue),
                    ),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: size.width * .42),
                    child: Text(
                      "Provider: ${assetDetails.walletProvider}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: StTextStyles.p2.copyWith(color: StColors.blue),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: 60.h,
                  maxHeight: 60.h,
                  maxWidth: 90.w,
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: 5.h,
                      child: ChrysalisAssetRiskGuage(rank: comp1.rank),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 8.w,
                      child: Text("Accessibility", style: StTextStyles.h6),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ChysalisAssetRowMktView extends StBaseTvRow
    with ShowsOneAsset, RequiresGameStatus, RequiresUserPositionProps {
  const ChysalisAssetRowMktView(
    TableviewDataRowTuple assets, {
    this.onTap,
    Key? key,
  }) : super(assets, key: key);

  final Function(TableviewDataRowTuple)? onTap;

  @override
  Widget rowBody(
    BuildContext ctx,
    ActiveGameDetails agd,
  ) {
    final assetDetails = ChrysalisAssetDetails.fromJson(
      jsonDecode(comp1.extAtts),
    );
    final size = MediaQuery.of(ctx).size;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        onTap?.call(assets);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
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
                true,
                isTwoAssetRow: false,
                hasBorder: assetDetails.isDistressed,
                fit: BoxFit.fitWidth,
              ),
              kSpacerSm,
              SizedBox(
                width: size.width * .75,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 4.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                minWidth: size.width *
                                    (assetDetails.isDistressed ? 0.4 : 0.72),
                                maxWidth: size.width *
                                    (assetDetails.isDistressed ? 0.4 : 0.72),
                              ),
                              child: Text(
                                "${comp1.position}: ${comp1.assetStateUpdates.name.substring(0, 6)}...",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: StTextStyles.h5,
                                // textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(
                              height: 2.h,
                            ),
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                minWidth: size.width *
                                    (assetDetails.isDistressed ? 0.4 : 0.72),
                                maxWidth: size.width *
                                    (assetDetails.isDistressed ? 0.4 : 0.72),
                              ),
                              child: Text(
                                "Units: ${assetDetails.units}",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: StTextStyles.h5,
                              ),
                            ),
                            SizedBox(
                              height: 2.h,
                            ),
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                  minWidth: size.width *
                                      (assetDetails.isDistressed ? 0.4 : 0.72),
                                  maxWidth: size.width *
                                      (assetDetails.isDistressed ? 0.4 : 0.72)),
                              child: Text(
                                "Issue: ${assetDetails.accessibilityIssue}",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: StTextStyles.h5,
                              ),
                            ),
                          ],
                        ),
                        if (assetDetails.isDistressed) ...{
                          Expanded(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      comp1.currPriceStr,
                                      style: StTextStyles.h5,
                                    ),
                                    Text(
                                      comp1.recentDeltaStr,
                                      style: StTextStyles.h5.copyWith(
                                          color: comp1.priceFluxColor),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                TradeButton(
                                  comp1.assetStateUpdates,
                                  comp1.gameStatus,
                                ),
                              ],
                            ),
                          ),
                        },
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              SizedBox(width: 32.w),
              Image.asset(
                "assets/digital-wallet.png",
                height: UiSizes.teamImgSide * 0.70,
                width: UiSizes.teamImgSide * 0.70,
              ),
              kSpacerSm,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: size.width * .42),
                    child: Text(
                      assetDetails.custodyType,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: StTextStyles.p2.copyWith(color: StColors.blue),
                    ),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: size.width * .42),
                    child: Text(
                      "${assetDetails.walletType} wallet",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: StTextStyles.p2.copyWith(color: StColors.blue),
                    ),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: size.width * .42),
                    child: Text(
                      "Provider: ${assetDetails.walletProvider}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: StTextStyles.p2.copyWith(color: StColors.blue),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: 60.h,
                  maxHeight: 60.h,
                  maxWidth: 90.w,
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: 5.h,
                      child: ChrysalisAssetRiskGuage(rank: comp1.rank),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 8.w,
                      child: Text("Accessibility", style: StTextStyles.h6),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
