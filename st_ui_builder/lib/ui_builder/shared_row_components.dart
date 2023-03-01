part of StUiController;

class WatchButton extends ConsumerWidget {
  const WatchButton({Key? key, required this.assetKey, this.isWatched = false})
      : super(key: key);

  final AssetKey assetKey;
  final bool isWatched;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tradeFlow = ref.read(tradeFlowProvider);

    return InkWell(
      onTap: () => tradeFlow.toggleWatchValue(assetKey),
      child: Icon(
        isWatched ? Icons.star_outlined : Icons.star_border,
        color: isWatched ? StColors.yellow : StColors.blue,
      ),
    );
  }
}

var kSpacerSm = SizedBox(
  width: 8.w,
);
var kSpacerTiny = SizedBox(
  width: 4.w,
);
var kVerticalSpacerSm = SizedBox(
  height: 3.h,
);
var kSpacerLarge = SizedBox(
  width: 20.w,
);

class ChrysalisAssetRiskGuage extends StatelessWidget {
  final int rank;

  const ChrysalisAssetRiskGuage({
    Key? key,
    required this.rank,
  }) : super(key: key);

  double get _needleAngle {
    if (rank <= 20) return 15;
    if (rank <= 40) return 45;
    if (rank <= 60) return 75;
    if (rank <= 80) return 105;
    return 135;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60.h,
      width: 90.w,
      child: SfRadialGauge(
        axes: [
          RadialAxis(
            startAngle: 180,
            endAngle: 0,
            minimum: 0,
            maximum: 150,
            ranges: [
              GaugeRange(
                startValue: 0,
                endValue: 30,
                color: Colors.red,
                startWidth: 10,
                endWidth: 10,
              ),
              GaugeRange(
                startValue: 30,
                endValue: 60,
                color: Colors.orange,
                startWidth: 10,
                endWidth: 10,
              ),
              GaugeRange(
                startValue: 60,
                endValue: 90,
                color: Colors.yellow,
                startWidth: 10,
                endWidth: 10,
              ),
              GaugeRange(
                startValue: 90,
                endValue: 120,
                color: Colors.greenAccent,
                startWidth: 10,
                endWidth: 10,
              ),
              GaugeRange(
                startValue: 120,
                endValue: 150,
                color: Colors.green,
                startWidth: 10,
                endWidth: 10,
              ),
            ],
            pointers: [
              NeedlePointer(
                needleEndWidth: 4,
                needleLength: 0.8,
                value: _needleAngle,
                needleColor: Colors.white,
              )
            ],
          ),
        ],
      ),
    );
  }
}

class CompetitorImage extends StatelessWidget {
  // just the image or placeholder
  final String imgUrl;
  final bool shrinkForRank;
  final bool isTwoAssetRow;
  final double shrinkRatio;
  final bool hasBorder;
  final BoxFit fit;

  const CompetitorImage(
    this.imgUrl,
    this.shrinkForRank, {
    this.isTwoAssetRow = false,
    this.hasBorder = false,
    this.shrinkRatio = 1,
    this.fit = BoxFit.cover,
    Key? key,
  }) : super(key: key);

  double get _shrinkSize => shrinkForRank
      ? (isTwoAssetRow ? 0.44 : 0.70)
      : (isTwoAssetRow ? 0.66 : 0.88);

  double get imgSize => UiSizes.teamImgSide * _shrinkSize * shrinkRatio;

  @override
  Widget build(BuildContext context) {
    final image = Image.network(
      imgUrl,
      height: imgSize * 1.2,
      width: hasBorder ? imgSize * .9 : imgSize,
      fit: fit,
      errorBuilder: (context, error, stackTrace) => const Icon(
        Icons.egg_rounded,
        color: StColors.blue,
      ),
    );

    if (hasBorder) {
      return Container(
        padding: EdgeInsets.all(2.5.w),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.red),
        ),
        child: image,
      );
    }
    return image;
  }
}

class TradeButton extends ConsumerWidget {
  //
  final AssetStateUpdates assetStateUpdts;
  final CompetitionStatus competitionStatus;

  const TradeButton(
    this.assetStateUpdts,
    this.competitionStatus, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    // trade button to right of player/team name
    // or simple text label if not tradable
    // final size = MediaQuery.of(context).size;
    TradeFlowBase tf = ref.read(tradeFlowProvider);

    return Container(
      height: UiSizes.tradeBtnHeight,
      width: 75.w,
      // width: UiSizes.tradeBtnWidthPctScreen * size.width,
      alignment: Alignment.center,
      child: (assetStateUpdts.isTradable)
          ? TextButton(
              onPressed: () =>
                  tf.beginTradeFlow(AssetKey(assetStateUpdts.assetKey)),
              style: StButtonStyles.tradeButtonCanTrade,
              child: Text(
                assetStateUpdts.tradeButtonTitle,
                style: StTextStyles.h6.copyWith(color: StColors.lightGreen),
                textAlign: TextAlign.center,
              ),
            )
          : Text(
              tf.labelForAssetState(
                competitionStatus,
                assetStateUpdts.assetState,
              ),
              style: StTextStyles.h5.copyWith(
                fontSize: 15.sp,
                color: tf.colorForAssetState(competitionStatus),
              ),
              textAlign: TextAlign.center,
            ),
    );
  }
}

class CheckAssetType extends StatelessWidget {
  final AssetRowPropertyIfc competitor;
  final bool isDriverVsField;
  final bool isTeamPlayerVsField;
  final bool isPlayerVsFieldRanked;
  final String? tradeSource;

  const CheckAssetType(
      {Key? key,
      required this.competitor,
      this.isDriverVsField = false,
      this.isTeamPlayerVsField = false,
      this.isPlayerVsFieldRanked = false,
      this.tradeSource})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var lst = competitor.topName.split(' ');
    String firstName = lst[0];
    String lastName = lst.length >= 2 ? lst[1] : '';
    if (isDriverVsField) {
      return Expanded(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 40.h,
              width: MediaQuery.of(context).size.width * .1,
              margin: const EdgeInsets.only(right: 8),
              child: FittedBox(
                fit: BoxFit.fitHeight,
                child: Text(
                  competitor.displayNumberStr,
                  style: StTextStyles.h3.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
            ),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * .26,
                minHeight: 50.h,
                maxHeight: 50.h,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    firstName.toUpperCase(),
                    overflow: TextOverflow.ellipsis,
                    style: StTextStyles.p2
                        .copyWith(fontWeight: FontWeight.w500, fontSize: 12.sp),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    lastName.toUpperCase(),
                    overflow: TextOverflow.ellipsis,
                    style: StTextStyles.h3
                        .copyWith(fontWeight: FontWeight.w800, fontSize: 18.sp),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
            if (tradeSource != null) ...[
              const Spacer(),
              kSpacerLarge,
              Text(
                tradeSource!,
                style: StTextStyles.p2,
              ),
            ],
          ],
        ),
      );
    }
    if (isTeamPlayerVsField) {
      return Expanded(
        // constraints:
        //     BoxConstraints(maxWidth: MediaQuery.of(context).size.width * .3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (tradeSource == null)
              Text(competitor.topName,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  style: StTextStyles.h4)
            else
              Text(tradeSource!,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  style: StTextStyles.h4),
            Wrap(
              children: [
                Text(competitor.orgNameWhenTradingPlayers,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    style: StTextStyles.p2.copyWith(color: StColors.coolGray)),
                kSpacerTiny,
                Text(competitor.position,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    style: StTextStyles.p2.copyWith(color: StColors.coolGray))
              ],
            ),
          ],
        ),
      );
    }
    if (isPlayerVsFieldRanked) {
      return Expanded(
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(competitor.topName, style: StTextStyles.h4),
                Text(
                  competitor.rankStr,
                  style: StTextStyles.p2.copyWith(color: StColors.coolGray),
                ),
              ],
            ),
            if (tradeSource != null) ...[
              const Spacer(),
              kSpacerLarge,
              Text(
                tradeSource!,
                style: StTextStyles.p2,
              ),
            ],
          ],
        ),
      );
    }
    return Expanded(
      child: Row(
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * .4),
            child: Text(
              competitor.topName,
              overflow: TextOverflow.ellipsis,
              style: StTextStyles.h4,
            ),
          ),
          if (tradeSource != null) ...[
            const Spacer(),
            kSpacerLarge,
            Text(
              tradeSource!,
              style: StTextStyles.p2,
            ),
          ],
        ],
      ),
    );
  }
}

class LeaderboardHalfRow extends StatelessWidget {
  //
  final AssetRowPropertyIfc competitor;
  final bool? showLeaderBoardIcon;
  final bool? isDriverVsField;
  final bool? isTeamPlayerVsField;

  const LeaderboardHalfRow(
      {Key? key,
      required this.competitor,
      this.showLeaderBoardIcon = false,
      this.isDriverVsField = false,
      this.isTeamPlayerVsField = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        kSpacerSm,
        SizedBox(
          width: 10,
          child: showLeaderBoardIcon!
              ? const Icon(
                  Icons.leaderboard,
                  color: StColors.green,
                )
              : null,
        ),
        kSpacerLarge,
        CompetitorImage(competitor.imgUrl, true),
        kSpacerSm,
        CompetitorImage(competitor.imgUrl, true),
        kSpacerLarge,
        CheckAssetType(
          competitor: competitor,
          isDriverVsField: isDriverVsField ?? false,
          isTeamPlayerVsField: isTeamPlayerVsField ?? false,
        ),
        const Spacer(),
        Text(
          competitor.currPriceStr,
          style: StTextStyles.h6,
        ),
        kSpacerSm
      ],
    );
  }
}

class AssetVsAssetHalfRow extends StatelessWidget {
  //
  final AssetHoldingsSummaryIfc assetHoldingsInterface;
  final AssetRowPropertyIfc competitor;
  final ActiveGameDetails gameDetails;
  final bool showRank;

  const AssetVsAssetHalfRow(
    this.competitor,
    this.gameDetails,
    this.showRank,
    this.assetHoldingsInterface, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        assetHoldingsInterface.sharesOwned > 0
            ? const Icon(Icons.work, color: StColors.green)
            : WatchButton(
                assetKey: competitor.assetKey,
                isWatched: gameDetails.isWatched(competitor.assetKey),
              ),
        kSpacerSm,
        CompetitorImage(
          competitor.imgUrl,
          showRank,
          shrinkRatio: 0.75,
        ),
        kSpacerSm,
        if (showRank) ...[
          Text(
            competitor.rankStr,
            style: StTextStyles.h5,
          ),
          kSpacerSm,
        ],
        Expanded(
          child: Text(
            competitor.topName,
            style: StTextStyles.h5,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            // textScaleFactor: 0.96,
            // textWidthBasis: TextWidthBasis.longestLine,
          ),
        ),
        Text(
          competitor.currPriceStr,
          style: StTextStyles.h5,
        ),
        const SizedBox(
          width: 4,
        ),
        TradeButton(competitor.assetStateUpdates, competitor.competitionStatus),
      ],
    );
  }
}

class MktRschAsset extends ConsumerWidget {
  //

  final AssetRowPropertyIfc competitor;
  final ActiveGameDetails gameDetails;
  final Color color;
  final BorderRadiusGeometry borderRadius;
  final double _sizeHeightImage = 150;

  //
  const MktRschAsset(
    this.competitor,
    this.color,
    this.gameDetails,
    this.borderRadius, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //
    final size = MediaQuery.of(context).size;

    bool isTradable = gameDetails.assetId1 == competitor.assetKey
        ? gameDetails.isTradableAsset1
        : gameDetails.isTradableAsset2;
    return Container(
      height: _sizeHeightImage,
      width: size.width * 0.47,
      decoration: BoxDecoration(color: color, borderRadius: borderRadius),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            height: _sizeHeightImage * .28,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(competitor.imgUrl),
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                competitor.topName,
                style: StTextStyles.h4.copyWith(
                  fontSize: 18.sp,
                  color: isTradable ? StColors.coolGray : StTextStyles.h4.color,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                competitor.subName,
                style: StTextStyles.textFormField.copyWith(
                  color: isTradable
                      ? StColors.coolGray
                      : StTextStyles.textFormField.color,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          Icon(
            Icons.star_border,
            color: isTradable ? StColors.gray : StColors.blue,
          ),
        ],
      ),
    );
  }
}

class RowControl extends StatelessWidget {
  final AssetRowPropertyIfc competitor;
  final ActiveGameDetails gameDetails;

  const RowControl({
    Key? key,
    required this.competitor,
    required this.gameDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Decimal percentageChange;
    try {
      percentageChange =
          ((competitor.currPrice - competitor.openPrice) / competitor.openPrice)
              .toDecimal(scaleOnInfinitePrecision: 2);
    } catch (e) {
      percentageChange = Decimal.zero;
    }
    return Container(
      height: (110 / 1.4) * 0.89,
      padding: const EdgeInsets.only(
        top: (110 / 2) * 0.08,
        left: (110 / 1) * 0.08,
      ),
      decoration: BoxDecoration(
        color: StColors.primaryDarkGray,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            spreadRadius: 0,
            blurRadius: 1,
            offset: const Offset(0, 1),
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
                  "${competitor.topName} ${competitor.currPriceStr}",
                  style: StTextStyles.h4,
                ),
                Text(
                  '${competitor.recentDeltaStr} (${percentageChange.toStringAsFixed(2)}%)',
                  style: StTextStyles.p2
                      .copyWith(color: competitor.priceFluxColor),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: TradeButton(
              competitor.assetStateUpdates,
              gameDetails.gameStatus,
            ),
          ),
        ],
      ),
    );
  }
}

class ObjectRankRow extends StatelessWidget {
  //
  final AssetRowPropertyIfc asset;
  final ActiveGameDetails gameStatus;

  const ObjectRankRow(
    this.asset,
    this.gameStatus, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double _sizeImageUrl = 50;
    const double _rowMargin = 8;
    const double _rowMarginTop = 25;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          width: _rowMargin,
        ),
        _PositionRankRow(
          asset,
          gameStatus,
        ),
        const SizedBox(
          width: _rowMargin,
        ),
        Image.network(
          asset.imgUrl,
          height: _sizeImageUrl,
          width: _sizeImageUrl - 10,
          fit: BoxFit.cover,
          // loadingBuilder: (context, child, loadingProgress) {
          //   if (loadingProgress == null) {
          //     return child;
          //   }
          //   return kSignUpScreenLogoImage;
          // },
          // errorBuilder: (context, error, stackTrace) => _assetImagePlaceholder,
        ),
        const SizedBox(
          width: _rowMargin,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!asset.isTeam)
              const SizedBox(
                height: _rowMargin,
              ),
            if (asset.isTeam)
              const SizedBox(
                height: _rowMarginTop,
              ),
            Text(
              asset.topName,
              style: StTextStyles.h3,
            ),
            if (!asset.isTeam)
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Text(
                  asset.subName,
                  style: StTextStyles.h4,
                ),
              )
          ],
        )
      ],
    );
  }
}

class _PositionRankRow extends StatelessWidget {
  /*
  */
  final AssetRowPropertyIfc asset;
  final ActiveGameDetails gameStatus;

  const _PositionRankRow(
    this.asset,
    this.gameStatus, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double _sizeIconRank = 40;
    Widget positionWidget = const SizedBox();
    switch (asset.rank) {
      case 1:
        positionWidget = Image.asset(
          kIconWiner1st,
          height: _sizeIconRank,
          width: _sizeIconRank,
        );
        break;
      case 2:
        positionWidget = Image.asset(
          kIconWiner2nd,
          height: _sizeIconRank,
          width: _sizeIconRank,
        );
        break;
      case 3:
        positionWidget = Image.asset(
          kIconWiner3st,
          height: _sizeIconRank,
          width: _sizeIconRank,
        );
        break;
      case 4:
        positionWidget = Container(
          width: _sizeIconRank,
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: StColors.selectableText,
                width: 2,
              ),
            ),
          ),
          child: Text(
            asset.rankStr,
            style: StTextStyles.h2,
            textAlign: TextAlign.center,
          ),
        );
        break;
      default:
        positionWidget = SizedBox(
          width: _sizeIconRank,
          child: Text(
            asset.rankStr,
            style: StTextStyles.h2,
            textAlign: TextAlign.center,
          ),
        );
    }
    return positionWidget;
  }
}

class AssetTopRow extends StatelessWidget {
  //
  final AssetRowPropertyIfc asset;
  final ActiveGameDetails gameStatus;

  const AssetTopRow(
    this.asset,
    this.gameStatus, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.of(context).size;
    const double _rowLeftMargin = 8;
    const double _rowRightMargin = 16;
    return Expanded(
      child: Row(
        // top row
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            fit: FlexFit.loose,
            child: Padding(
              padding: const EdgeInsets.only(left: _rowLeftMargin),
              child: Column(
                // player & team name
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    asset.topName,
                    textAlign: TextAlign.left,
                    style: asset.subName != ''
                        ? StTextStyles.h2.copyWith(
                            color: Colors.yellow,
                          )
                        : StTextStyles.h2.copyWith(
                            color: Colors.pink,
                          ),
                  ),
                  Text(
                    asset.subName,
                    style: StTextStyles.h5.copyWith(color: StColors.white),
                  ),
                ],
              ),
            ),
          ),
          if (gameStatus._isTradableGame)
            // trade button to right of player/team name
            Padding(
              padding: const EdgeInsets.only(right: _rowRightMargin),
              child: TextButton(
                child: Text(
                  StStrings.tradeUc,
                  style: StTextStyles.h5,
                ),
                onPressed: () {},
                style: StButtonStyles.tradeButtonCanTrade,
                // style: size.height <= 568
                //     ? tradePlayerMarketLessWidthViewButtonStyle
                //     : tradePlayerMarketViewButtonStyle,
              ),
            ),
        ],
      ),
    );
  }
}

class HoldingsAndValueRow extends StatelessWidget {
  //
  final AssetRowPropertyIfc asset;
  final ActiveGameDetails gameStatus;

  const HoldingsAndValueRow(
    this.asset,
    this.gameStatus, {
    Key? key,
  }) : super(key: key);

  Decimal get _sharePrice => asset.assetStateUpdates.curPrice; // ?? 0;
  int get _sharesHeld => asset.assetHoldingsSummary.sharesOwned; // ?? 0;
  Decimal get _gainLoss => asset.assetHoldingsSummary.positionGainLoss; // ?? 0;

  String get _formattedGainLoss => _sharePrice < Decimal.zero
      ? _sharePrice.toStringAsFixed(2)
      : '+${_sharePrice.toStringAsFixed(2)}';

  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.of(context).size;
    const double _stdRowHeight = 110;
    const double _rowLeftMargin = 8;
    const double _rowRightMargin = 16;
    return Container(
      height: (_stdRowHeight / 2) * 0.89,
      padding: const EdgeInsets.only(
        top: (_stdRowHeight / 2) * 0.08,
      ),
      color: StColors.primaryDarkGray,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: _rowLeftMargin),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _sharesHeld.toString() + ' ' + StStrings.shares,
                  style: StTextStyles.h5,
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '＠',
                        style: StTextStyles.p3,
                      ),
                      TextSpan(
                        text: '${'asset.shares'} ',
                        style: StTextStyles.p2,
                      ),
                      if (false)
                        TextSpan(
                          text: _formattedGainLoss,
                          style: StTextStyles.moneyDeltaPositive,
                        ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Column(
            children: [
              Text(
                gameStatus._isTradableGame
                    ? StStrings.value
                    : StStrings.proceeds,
                style: StTextStyles.h5.copyWith(),
              ),
              Text(
                _sharePrice.toString(),
                style: StTextStyles.h6.copyWith(),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(right: _rowRightMargin),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  StStrings.gainLossAbbrev,
                  style: StTextStyles.h6.copyWith(),
                ),
                Text(
                  _gainLoss < Decimal.zero
                      ? _gainLoss.toStringAsFixed(2)
                      : '+${_gainLoss.toStringAsFixed(2)}',
                  style: _gainLoss < Decimal.zero
                      ? StTextStyles.moneyDeltaPositive.copyWith(
                          color: StColors.errorText,
                        )
                      : StTextStyles.moneyDeltaPositive,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
