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
    TvRowDataContainer assets, {
    this.onTap,
    Key? key,
  }) : super(assets, key: key);

  final Function(TvRowDataContainer)? onTap;

  @override
  double get bottomMargin => 12.h;

  @override
  Widget rowBody(
    BuildContext ctx,
    ActiveGameDetails agd,
  ) {
    AssetRowPropertyIfc firstAsset = comp1;
    AssetRowPropertyIfc secondAsset = comp2;

    if (showRank) {
      if (secondAsset.rank < firstAsset.rank) {
        firstAsset = comp2;
        secondAsset = comp1;
      }
    }

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
            firstAsset,
            agd,
            showRank,
            firstAsset.assetHoldingsSummary,
          ),
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
            secondAsset,
            agd,
            showRank,
            secondAsset.assetHoldingsSummary,
          ),
        ),
      ],
    );
  }
}

class AssetVsAssetRowLeaderBoardView extends StBaseTvRow with ShowsTwoAssets {
  //
  const AssetVsAssetRowLeaderBoardView(
    TvRowDataContainer assets, {
    this.onTap,
    Key? key,
  }) : super(assets, key: key);

  final Function(TvRowDataContainer)? onTap;

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
    TvRowDataContainer assets, {
    this.onTap,
    Key? key,
  }) : super(assets, key: key);

  final Function(TvRowDataContainer)? onTap;

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
    TvRowDataContainer assets, {
    this.onTap,
    Key? key,
  }) : super(assets, key: key);

  final Function(TvRowDataContainer)? onTap;

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
    TvRowDataContainer assets, {
    Function(TvRowDataContainer)? onTap,
    Key? key,
  }) : super(assets, key: key, onTap: onTap);
}

//
// Begin custom Market Research classes

class DraftPlayerRowMktResearchView extends StBaseTvRow with ShowsOneAsset {
  const DraftPlayerRowMktResearchView(
    TvRowDataContainer assets, {
    this.onTap,
    Key? key,
  }) : super(assets, key: key);

  final Function(TvRowDataContainer)? onTap;

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

class DraftTeamRowMktResearchView extends DraftTeamRowMktView {
  const DraftTeamRowMktResearchView(
    TvRowDataContainer assets, {
    Function(TvRowDataContainer)? onTap,
    Key? key,
  }) : super(assets, key: key, onTap: onTap);
}

class TeamLineRowMktResearchView extends StBaseTvRow with ShowsOneAsset {
  const TeamLineRowMktResearchView(
    TvRowDataContainer assets, {
    this.onTap,
    Key? key,
  }) : super(assets, key: key);

  final Function(TvRowDataContainer)? onTap;

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
    TvRowDataContainer assets, {
    this.onTap,
    Key? key,
  }) : super(assets, key: key);

  final Function(TvRowDataContainer)? onTap;

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
      void assetTapHandler(
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
                        onTap: () => assetTapHandler(false),
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
                        onTap: () => assetTapHandler(true),
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: 28,
                      width: 28,
                      decoration: BoxDecoration(
                        border: Border.all(color: StColors.black, width: 1.5),
                        shape: BoxShape.circle,
                        color: StColors.green,
                      ),
                      child: Center(
                        child: Text(
                          StStrings.versus,
                          style: StTextStyles.p4,
                        ),
                      ),
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

// End Market Research classes

class AssetVsAssetRowRankedPortfolioView extends AssetVsAssetRowPortfolioView {
  const AssetVsAssetRowRankedPortfolioView(
    TvRowDataContainer assets, {
    Function(TvRowDataContainer)? onTap,
    Key? key,
  }) : super(assets, key: key, onTap: onTap);
}

class TeamVsFieldRowPortfolioView extends AssetVsAssetRowPortfolioView {
  const TeamVsFieldRowPortfolioView(
    TvRowDataContainer assets, {
    Function(TvRowDataContainer)? onTap,
    Key? key,
  }) : super(assets, key: key, onTap: onTap);
}

class TeamVsFieldRankedRowPortfolioView extends AssetVsAssetRowPortfolioView {
  const TeamVsFieldRankedRowPortfolioView(
    TvRowDataContainer assets, {
    Function(TvRowDataContainer)? onTap,
    Key? key,
  }) : super(assets, key: key, onTap: onTap);
}

class PlayerVsFieldRankedPortfolioView extends AssetVsAssetRowPortfolioView {
  const PlayerVsFieldRankedPortfolioView(
    TvRowDataContainer assets, {
    Function(TvRowDataContainer)? onTap,
    Key? key,
  }) : super(assets, key: key, onTap: onTap);
}

class PlayerVsFieldRowPortfolioView extends AssetVsAssetRowPortfolioView {
  const PlayerVsFieldRowPortfolioView(
    TvRowDataContainer assets, {
    Function(TvRowDataContainer)? onTap,
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
    TvRowDataContainer assets, {
    this.onTap,
    Key? key,
  }) : super(assets, key: key);

  final Function(TvRowDataContainer)? onTap;

  @override
  Widget rowBody(
    BuildContext ctx,
    ActiveGameDetails agd,
  ) {
    late String sharePrice;
    late String sharePriceChange;
    late String sharesOwned;
    late String positionValue;
    String? tradeSource;
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

    final width = MediaQuery.of(ctx).size.width;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        onTap?.call(assets);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.h),
        width: width,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CompetitorImage(
              comp1.imgUrl,
              false,
              shrinkRatio: comp1.assetNameDisplayStyle.shouldWrap ? 0.75 : 1,
            ),
            kSpacerSm,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: width * (showHoldingsValue ? 0.61 : 0.8),
                        ),
                        child: PortfolioAssetRow(
                          competitor: comp1,
                          isDriverVsField: isDriverVsField,
                          isPlayerVsFieldRanked: isPlayerVsFieldRanked,
                          isTeamPlayerVsField: isTeamPlayerVsField,
                          tradeSource: tradeSource,
                        ),
                      ),
                      if (showHoldingsValue) ...{
                        const Spacer(),
                        // this is a portfolio positions row; show trade
                        TradeButton(comp1),
                      },
                    ],
                  ),
                  kVerticalSpacerSm,
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 5.h,
                        horizontal: 10.w,
                      ),
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
                                          " ${sharePriceChange.replaceAllMapped(
                                        RegexFunctions()
                                            .formatNumberStringsWithCommas,
                                        RegexFunctions().mathFunc,
                                      )}",
                                      style: StTextStyles.moneyDeltaPositive
                                          .copyWith(
                                        color: sharePriceChangeColor,
                                      ),
                                    )
                                  ],
                                ),
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
                                  RegexFunctions().mathFunc,
                                ),
                                style: StTextStyles.p1,
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                StStrings.gainLossAbbrev,
                                style: StTextStyles.p1.copyWith(
                                  color: StColors.coolGray,
                                ),
                              ),
                              kVerticalSpacerSm,
                              Text(
                                (isPositiveGainLoss ? "+" : "") +
                                    positionGainLossStr.replaceAllMapped(
                                      RegexFunctions()
                                          .formatNumberStringsWithCommas,
                                      RegexFunctions().mathFunc,
                                    ),
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
            ),
          ],
        ),
      ),
    );
  }
}

class DriverVsFieldRowPortfolio extends AssetVsAssetRowPortfolioView {
  // this is portfolio POSITIONS
  const DriverVsFieldRowPortfolio(
    TvRowDataContainer assets, {
    Function(TvRowDataContainer)? onTap,
    Key? key,
  }) : super(assets, key: key, onTap: onTap);

  @override
  bool get isDriverVsField => true;

  @override
  bool get showProceeds => false;
}

class TeamPlayerVsFieldRowPortfolio extends AssetVsAssetRowPortfolioView {
  const TeamPlayerVsFieldRowPortfolio(
    TvRowDataContainer assets, {
    Function(TvRowDataContainer)? onTap,
    Key? key,
  }) : super(assets, key: key, onTap: onTap);

  @override
  bool get isTeamPlayerVsField => true;
}

class AssetVsAssetRowPortfolioHistory extends AssetVsAssetRowPortfolioView {
  //
  const AssetVsAssetRowPortfolioHistory(
    TvRowDataContainer assets, {
    Function(TvRowDataContainer)? onTap,
    Key? key,
  }) : super(assets, key: key, onTap: onTap);

  @override
  bool get showProceeds => true;
}

class AssetVsAssetRankedRowPortfolioHistory
    extends AssetVsAssetRowPortfolioHistory {
  //
  const AssetVsAssetRankedRowPortfolioHistory(
    TvRowDataContainer assets, {
    Function(TvRowDataContainer)? onTap,
    Key? key,
  }) : super(assets, key: key, onTap: onTap);
}

class TeamVsFieldRowPortfolioHistoryView
    extends AssetVsAssetRowPortfolioHistory {
  //
  const TeamVsFieldRowPortfolioHistoryView(
    TvRowDataContainer assets, {
    Function(TvRowDataContainer)? onTap,
    Key? key,
  }) : super(assets, key: key, onTap: onTap);
}

class TeamVsFieldRankedRowPortfolioHistoryView
    extends AssetVsAssetRowPortfolioHistory {
  //
  const TeamVsFieldRankedRowPortfolioHistoryView(
    TvRowDataContainer assets, {
    Function(TvRowDataContainer)? onTap,
    Key? key,
  }) : super(assets, key: key, onTap: onTap);
}

class PlayerVsFieldRowPortfolioHistoryView
    extends AssetVsAssetRowPortfolioHistory {
  //
  const PlayerVsFieldRowPortfolioHistoryView(
    TvRowDataContainer assets, {
    Function(TvRowDataContainer)? onTap,
    Key? key,
  }) : super(assets, key: key, onTap: onTap);
}

class PlayerVsFieldRankedPortfolioHistoryView
    extends AssetVsAssetRowPortfolioHistory {
  //
  const PlayerVsFieldRankedPortfolioHistoryView(
    TvRowDataContainer assets, {
    Function(TvRowDataContainer)? onTap,
    Key? key,
  }) : super(assets, key: key, onTap: onTap);

  @override
  bool get isPlayerVsFieldRanked => true;
}

//
class DriverVsFieldRowPortfolioHistory extends AssetVsAssetRowPortfolioView {
  //
  const DriverVsFieldRowPortfolioHistory(
    TvRowDataContainer assets, {
    Function(TvRowDataContainer)? onTap,
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
    TvRowDataContainer assets, {
    Function(TvRowDataContainer)? onTap,
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
    TvRowDataContainer assets, {
    this.onTap,
    Key? key,
  }) : super(assets, key: key);

  final Function(TvRowDataContainer)? onTap;

  @override
  Widget rowBody(
    BuildContext ctx,
    ActiveGameDetails agd,
  ) {
    final width = MediaQuery.of(ctx).size.width;

    final rowHeight = comp1.assetNameDisplayStyle.isStacked
        ? 92
        : isTeamPlayerVsField
            ? comp1.position.isNotEmpty
                ? 100
                : 88
            : isPlayerVsFieldRanked
                ? 81
                : 73;

    final rowWidth = isTeamPlayerVsField
        ? width * .61
        : isPlayerVsFieldRanked
            ? width * .63
            : (!isDriverVsField &&
                    !isPlayerVsFieldRanked &&
                    !isTeamPlayerVsField)
                ? width * .52
                : width * .65;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        onTap?.call(assets);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          assetHoldingsSummary.sharesOwned > 0
              ? Icon(Icons.work, color: StColors.green)
              : WatchButton(
                  assetKey: comp1.assetKey,
                  isWatched: comp1.assetStateUpdates.isWatched,
                ),
          kSpacerSm,
          CompetitorImage(
            comp1.imgUrl,
            shouldShrinkParticipantImage,
            isTwoAssetRow: this is ShowsTwoAssets,
            shrinkRatio: comp1.assetNameDisplayStyle.isStacked ? .7 : 1,
          ),
          kSpacerSm,
          ConstrainedBox(
            constraints: BoxConstraints.tightFor(
              height: rowHeight.h,
              width: rowWidth,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                kVerticalSpacerSm,
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    PortfolioAssetRow(
                      competitor: comp1,
                      isDriverVsField: isDriverVsField,
                      isTeamPlayerVsField: isTeamPlayerVsField,
                      isPlayerVsFieldRanked: isPlayerVsFieldRanked,
                    ),
                    const Spacer(),
                    Column(
                      children: [
                        Text(
                          comp1.currPriceStr,
                          style: StTextStyles.h5,
                        ),
                        Text(
                          comp1.recentDeltaStr,
                          style: StTextStyles.h5.copyWith(
                            color: comp1.priceFluxColor,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                kVerticalSpacerSm,
                Row(
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
          kSpacerTiny,
          TradeButton(
            comp1,
            width: comp1.assetNameDisplayStyle.isStacked ? 50 : 72,
            fontSize: comp1.assetNameDisplayStyle.isStacked ? 10 : 15,
          ),
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
    TvRowDataContainer assets, {
    Function(TvRowDataContainer)? onTap,
    Key? key,
  }) : super(assets, key: key, onTap: onTap);
}

class TeamPlayerVsFieldRowMktView extends TeamVsFieldRowMktView {
  @override
  bool get isTeamPlayerVsField => true;

  const TeamPlayerVsFieldRowMktView(
    TvRowDataContainer assets, {
    Function(TvRowDataContainer)? onTap,
    Key? key,
  }) : super(assets, key: key, onTap: onTap);
}

class PlayerVsFieldRankedRowMktView extends TeamVsFieldRowMktView {
  @override
  bool get isPlayerVsFieldRanked => true;

  const PlayerVsFieldRankedRowMktView(
    TvRowDataContainer assets, {
    Function(TvRowDataContainer)? onTap,
    Key? key,
  }) : super(assets, key: key, onTap: onTap);
}

class PlayerVsFieldRowMktView extends TeamVsFieldRowMktView {
  const PlayerVsFieldRowMktView(
    TvRowDataContainer assets, {
    Function(TvRowDataContainer)? onTap,
    Key? key,
  }) : super(assets, key: key, onTap: onTap);
}

class DriverVsFieldRowMktView extends TeamVsFieldRowMktView {
  @override
  bool get isDriverVsField => true;

  @override
  bool get showRanked => true;

  const DriverVsFieldRowMktView(
    TvRowDataContainer assets, {
    Function(TvRowDataContainer)? onTap,
    Key? key,
  }) : super(assets, key: key, onTap: onTap);
}

class DraftPlayerRowMktView extends StBaseTvRow with ShowsOneAsset {
  const DraftPlayerRowMktView(
    TvRowDataContainer assets, {
    this.onTap,
    Key? key,
  }) : super(assets, key: key);

  final Function(TvRowDataContainer)? onTap;

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

class DraftTeamRowMktView extends StBaseTvRow
    with ShowsOneAsset, RequiresUserPositionProps {
  const DraftTeamRowMktView(
    TvRowDataContainer assets, {
    this.onTap,
    Key? key,
  }) : super(assets, key: key);

  final Function(TvRowDataContainer)? onTap;

  bool get isPortfolioHistory => false;
  bool get isPortfolioPosition => false;

  @override
  Widget rowBody(
    BuildContext ctx,
    ActiveGameDetails agd,
  ) {
    final width = MediaQuery.of(ctx).size.width;

    bool isSoldOutInMarket = !isPortfolioHistory &&
        !isPortfolioPosition &&
        comp1.currentSharesAvailable == Decimal.zero &&
        assetHoldingsSummary.sharesOwned > 0 &&
        [AssetState.assetTradeMarketGameOn, AssetState.assetTradeMarket]
            .contains(comp1.assetStateUpdates.assetState);

    bool isOpenToTradeInPortfolio = isPortfolioPosition &&
        comp1.currentSharesAvailable == Decimal.zero &&
        assetHoldingsSummary.sharesOwned > 0 &&
        [AssetState.assetTradeMarketGameOn, AssetState.assetTradeMarket]
            .contains(comp1.assetStateUpdates.assetState);

    final rowHeight = comp1.assetNameDisplayStyle.isStacked ? 92 : 73;

    final rowWidth = isPortfolioPosition
        ? width * .59
        : isPortfolioHistory
            ? width * .77
            : width * .52;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        onTap?.call(assets);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (!isPortfolioHistory && !isPortfolioPosition) ...{
            assetHoldingsSummary.sharesOwned > 0
                ? Icon(Icons.work, color: StColors.green)
                : WatchButton(
                    assetKey: comp1.assetKey,
                    isWatched: comp1.assetStateUpdates.isWatched,
                  ),
          },
          kSpacerSm,
          CompetitorImage(
            comp1.imgUrl,
            false,
            isTwoAssetRow: this is ShowsTwoAssets,
            shrinkRatio: comp1.assetNameDisplayStyle.isStacked ? .7 : .9,
          ),
          kSpacerSm,
          ConstrainedBox(
            constraints: BoxConstraints.tightFor(
              height: rowHeight.h,
              width: rowWidth,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                kVerticalSpacerSm,
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: rowWidth * 0.77,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            comp1.topName,
                            softWrap: true,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: StTextStyles.h4,
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          comp1.currPriceStr,
                          style: StTextStyles.h5,
                        ),
                        if (isPortfolioHistory)
                          Text(
                            comp1.recentDeltaStr,
                            style: StTextStyles.h5.copyWith(
                              color: comp1.priceFluxColor,
                            ),
                          ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
          if (!isPortfolioHistory) ...{
            kSpacerTiny,
            TradeButton(
              comp1,
              width: comp1.assetNameDisplayStyle.isStacked ? 50 : 75,
              fontSize: comp1.assetNameDisplayStyle.isStacked ? 10 : 15,
              buttonText: isSoldOutInMarket
                  ? StStrings.soldOut
                  : isOpenToTradeInPortfolio
                      ? StStrings.tradeUc
                      : null,
              disabled: isSoldOutInMarket,
              textColor: StColors.white,
            ),
          },
        ],
      ),
    );
  }
}

class TeamLineRowMktView extends StBaseTvRow with ShowsOneAsset {
  const TeamLineRowMktView(
    TvRowDataContainer assets, {
    this.onTap,
    Key? key,
  }) : super(assets, key: key);

  final Function(TvRowDataContainer)? onTap;

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
    TvRowDataContainer assets, {
    this.onTap,
    Key? key,
  }) : super(assets, key: key);

  final Function(TvRowDataContainer)? onTap;

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

class DraftTeamRowPortfolioView extends DraftTeamRowMktView {
  const DraftTeamRowPortfolioView(
    TvRowDataContainer assets, {
    Function(TvRowDataContainer)? onTap,
    Key? key,
  }) : super(assets, key: key, onTap: onTap);

  @override
  bool get isPortfolioPosition => true;
}

class TeamLineRowPortfolioView extends StBaseTvRow with ShowsOneAsset {
  const TeamLineRowPortfolioView(
    TvRowDataContainer assets, {
    this.onTap,
    Key? key,
  }) : super(assets, key: key);

  final Function(TvRowDataContainer)? onTap;

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
    TvRowDataContainer assets, {
    Function(TvRowDataContainer)? onTap,
    Key? key,
  }) : super(assets, key: key, onTap: onTap);
}

// test classes only below
class DraftTeamRowPortfolioHistoryView extends DraftTeamRowPortfolioView {
  //
  const DraftTeamRowPortfolioHistoryView(
    TvRowDataContainer assets, {
    Function(TvRowDataContainer)? onTap,
    Key? key,
  }) : super(assets, key: key, onTap: onTap);

  @override
  bool get isPortfolioHistory => true;

  @override
  bool get isPortfolioPosition => false;
}

class DraftPlayerRowPortfolioHistoryView extends DraftPlayerRowPortfolioView {
  //
  const DraftPlayerRowPortfolioHistoryView(
    TvRowDataContainer assets, {
    Function(TvRowDataContainer)? onTap,
    Key? key,
  }) : super(assets, key: key, onTap: onTap);
}

class DistressedAssetRanked extends StBaseTvRow {
  // TODO for Chrysalis

  bool get showRank => false;

  const DistressedAssetRanked(
    TvRowDataContainer assets, {
    this.onTap,
    Key? key,
  }) : super(assets, key: key);

  final Function(TvRowDataContainer)? onTap;

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
    TvRowDataContainer assets, {
    this.onTap,
    Key? key,
  }) : super(assets, key: key);

  final Function(TvRowDataContainer)? onTap;

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
                  ? Icon(Icons.work, color: StColors.green)
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
                              TradeButton(comp1),
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
    TvRowDataContainer assets, {
    this.onTap,
    Key? key,
  }) : super(assets, key: key);

  final Function(TvRowDataContainer)? onTap;

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
                  ? Icon(Icons.work, color: StColors.green)
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
                                TradeButton(comp1),
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
