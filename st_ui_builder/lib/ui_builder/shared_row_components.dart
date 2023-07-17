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
    final image = StCachedNetworkImage(
      imageUrl: imgUrl,
      height: imgSize * 1.2,
      width: hasBorder ? imgSize * .9 : imgSize,
      fit: fit,
    );
    // final image = Image.network(
    //   imgUrl,
    //   height: imgSize * 1.2,
    //   width: hasBorder ? imgSize * .9 : imgSize,
    //   fit: fit,
    //   errorBuilder: (context, error, stackTrace) => const Icon(
    //     Icons.egg_rounded,
    //     color: StColors.blue,
    //   ),
    // );

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
  final double? width;
  final double? fontSize;

  const TradeButton(
    this.assetStateUpdts,
    this.competitionStatus, {
    Key? key,
    this.width,
    this.fontSize,
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

    print(
      'Built trade btn for ${assetStateUpdts.assetKey} with state ${assetStateUpdts.assetState.name}',
    );

    return Container(
      height: UiSizes.tradeBtnHeight,
      width: (width ?? 75).w,
      // width: UiSizes.tradeBtnWidthPctScreen * size.width,
      alignment: Alignment.center,
      child: (assetStateUpdts.isTradable)
          ? TextButton(
              onPressed: () => tf.beginTradeFlow(
                AssetKey(assetStateUpdts.assetKey),
              ),
              style: _styleForAssetState(
                assetStateUpdts.assetState,
                competitionStatus,
              ),
              child: Text(
                assetStateUpdts.tradeButtonTitle,
                style: StTextStyles.h6.copyWith(
                  fontSize: assetStateUpdts.assetState ==
                          AssetState.assetTradeMarketGameOn
                      ? 13.sp
                      : 14.sp,
                ),
                textAlign: TextAlign.center,
              ),
            )
          : Text(
              tf.labelForAssetState(
                competitionStatus,
                assetStateUpdts.assetState,
              ),
              style: StTextStyles.h5.copyWith(
                fontSize: (fontSize ?? 15).sp,
                color: tf.colorForAssetState(competitionStatus),
              ),
              textAlign: TextAlign.center,
            ),
    );
  }

  ButtonStyle _styleForAssetState(
    AssetState assetState,
    CompetitionStatus compStatus,
  ) {
    return assetState == AssetState.assetTradeMarketGameOn
        ? StButtonStyles.tradeBtnWhileGameInProgress
        : StButtonStyles.tradeButtonCanTrade;
  }

  // bool _useTradeAndGameOnButton(
  //   AssetState assetState,
  //   CompetitionStatus compStatus,
  // ) {
  //   return assetState == AssetState.assetTradeMarketGameOn;
  // }
}

class PortfolioAssetRow extends StatelessWidget {
  final AssetRowPropertyIfc competitor;
  final bool isDriverVsField;
  final bool isTeamPlayerVsField;
  final bool isPlayerVsFieldRanked;
  final String? tradeSource;

  const PortfolioAssetRow({
    Key? key,
    required this.competitor,
    this.isDriverVsField = false,
    this.isTeamPlayerVsField = false,
    this.isPlayerVsFieldRanked = false,
    this.tradeSource,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    var lst = competitor.topName.split(' ');
    String firstName = lst[0];
    String lastName = lst.length >= 2 ? lst[1] : '';
    if (isDriverVsField) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: competitor.assetNameDisplayStyle.shouldWrap ? 28.h : 40.h,
            width: width *
                (competitor.assetNameDisplayStyle.shouldWrap ? 0.05 : 0.1),
            margin: EdgeInsets.only(
              right: competitor.assetNameDisplayStyle.shouldWrap ? 4.w : 8.w,
            ),
            child: FittedBox(
              fit: BoxFit.fitHeight,
              child: Text(
                competitor.displayNumberStr,
                style: StTextStyles.h3.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          ConstrainedBox(
            constraints: BoxConstraints.tightFor(
              width: width * .43,
              height: 52.h,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  firstName.toUpperCase(),
                  softWrap: true,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: StTextStyles.p2.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 12.sp,
                  ),
                  textAlign: TextAlign.start,
                ),
                Text(
                  lastName.toUpperCase(),
                  softWrap: true,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: StTextStyles.h3.copyWith(
                    fontWeight: FontWeight.w800,
                    fontSize: 15.sp,
                  ),
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),
          if (tradeSource != null) ...[
            const Spacer(),
            Text(
              tradeSource!,
              style: StTextStyles.p2,
            ),
          ],
        ],
      );
    }
    if (isTeamPlayerVsField) {
      return ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: width * 0.43,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              competitor.topName,
              softWrap: true,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: StTextStyles.h4,
            ),
            Wrap(
              children: [
                if (competitor.orgNameWhenTradingPlayers.isNotEmpty) ...{
                  Text(
                    competitor.orgNameWhenTradingPlayers,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    style: StTextStyles.p2.copyWith(color: StColors.coolGray),
                  ),
                  kSpacerTiny,
                },
                if (competitor.position.isNotEmpty) ...{
                  Text(
                    competitor.position,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    style: StTextStyles.p2.copyWith(color: StColors.coolGray),
                  ),
                }
              ],
            ),
          ],
        ),
      );
    }
    if (isPlayerVsFieldRanked) {
      return Row(
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: width * 0.43,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  competitor.topName,
                  style: StTextStyles.h5,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  competitor.rankStr,
                  style: StTextStyles.p2.copyWith(color: StColors.coolGray),
                ),
              ],
            ),
          ),
          if (tradeSource != null) ...[
            const Spacer(),
            Text(
              tradeSource!,
              style: StTextStyles.p2,
            ),
          ],
        ],
      );
    }
    return Row(
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.42,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                competitor.topName,
                maxLines: competitor.assetNameDisplayStyle.shouldWrap ? 2 : 1,
                overflow: TextOverflow.ellipsis,
                style: StTextStyles.h4,
              ),
              if (competitor.assetNameDisplayStyle.isStacked)
                Text(
                  competitor.subName,
                  style: StTextStyles.p3,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
        ),
        if (tradeSource != null) ...[
          const Spacer(),
          Text(
            tradeSource!,
            style: StTextStyles.p2,
          ),
        ],
      ],
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
              ? Icon(
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
        PortfolioAssetRow(
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

class AssetVsAssetHalfRow extends StatefulWidget {
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
  State<AssetVsAssetHalfRow> createState() => _AssetVsAssetHalfRowState();
}

class _AssetVsAssetHalfRowState extends State<AssetVsAssetHalfRow> {
  bool _doesTextWrap = false;

  void _computeTextSize() {
    final width = MediaQuery.of(context).size.width;
    final painter = TextPainter(
      textDirection: TextDirection.ltr,
      maxLines: 4,
      text: TextSpan(
        text: widget.competitor.topName,
        style: StTextStyles.h5,
      ),
    );

    painter.layout(maxWidth: width);

    setState(() {
      _doesTextWrap = painter.size.width >= width * 0.46;
    });
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(_computeTextSize);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        widget.assetHoldingsInterface.sharesOwned > 0
            ? Icon(Icons.work, color: StColors.green)
            : WatchButton(
                assetKey: widget.competitor.assetKey,
                isWatched:
                    widget.gameDetails.isWatched(widget.competitor.assetKey),
              ),
        kSpacerSm,
        CompetitorImage(
          widget.competitor.imgUrl,
          widget.showRank,
          shrinkRatio:
              widget.competitor.assetNameDisplayStyle.shouldWrap ? 0.7 : 0.75,
        ),
        kSpacerSm,
        if (widget.showRank) ...[
          Text(
            widget.competitor.rankStr,
            style: StTextStyles.h5,
          ),
          kSpacerSm,
        ],
        widget.competitor.assetNameDisplayStyle.shouldWrap
            ? ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width *
                      (widget.showRank ? 0.44 : 0.46),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.competitor.topName,
                      style: StTextStyles.h5,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (widget.competitor.assetNameDisplayStyle.isStacked)
                      Text(
                        widget.competitor.subName,
                        style: StTextStyles.p3,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              )
            : Expanded(
                child: Text(
                  widget.competitor.topName,
                  style: StTextStyles.h5,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
        const Spacer(),
        Text(
          widget.competitor.currPriceStr,
          style: StTextStyles.h5,
        ),
        kSpacerTiny,
        TradeButton(
          widget.competitor.assetStateUpdates,
          widget.competitor.competitionStatus,
          width: (_doesTextWrap &&
                  widget.competitor.assetNameDisplayStyle.shouldWrap)
              ? widget.showRank
                  ? 48
                  : 50
              : 75,
        ),
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
  final double _sizeHeightImage = 160;

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

    bool isTradable = gameDetails.assetId1 == competitor.assetKey.value
        ? gameDetails.isTradableAsset1
        : gameDetails.isTradableAsset2;
    return Container(
      height: _sizeHeightImage,
      width: size.width * 0.47,
      decoration: BoxDecoration(color: color, borderRadius: borderRadius),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          StCachedNetworkImage(
            imageUrl: competitor.imgUrl,
            height: _sizeHeightImage * .28,
            fit: BoxFit.fitHeight,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Text(
              competitor.topName,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: StTextStyles.h4.copyWith(
                fontSize: 18.sp,
                color: StColors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          if (competitor.assetNameDisplayStyle.isStacked)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Text(
                competitor.subName,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                style: StTextStyles.p3,
                textAlign: TextAlign.center,
              ),
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
    //handle division by 0 error
    try {
      percentageChange = competitor.percentageChange;
      // ((competitor.currPrice - competitor.openPrice) / competitor.openPrice)
      //     .toDecimal(scaleOnInfinitePrecision: 2);
    } catch (e) {
      percentageChange =
          ((competitor.currPrice - competitor.openPrice) / Decimal.one)
              .toDecimal(scaleOnInfinitePrecision: 2);
    }
    return Container(
      // height: (110 / 1.4) * 0.89,
      padding: const EdgeInsets.only(
        top: (110 / 2) * 0.08,
        bottom: (110 / 2) * 0.08,
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
        StCachedNetworkImage(
          imageUrl: asset.imgUrl,
          height: _sizeImageUrl,
          width: _sizeImageUrl - 10,
          fit: BoxFit.cover,
        ),
        // Image.network(
        //   asset.imgUrl,
        //   height: _sizeImageUrl,
        //   width: _sizeImageUrl - 10,
        //   fit: BoxFit.cover,
        //   // loadingBuilder: (context, child, loadingProgress) {
        //   //   if (loadingProgress == null) {
        //   //     return child;
        //   //   }
        //   //   return kSignUpScreenLogoImage;
        //   // },
        //   // errorBuilder: (context, error, stackTrace) => _assetImagePlaceholder,
        // ),
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

// class AssetTopRowNIU extends StatelessWidget {
//   //
//   final AssetRowPropertyIfc asset;
//   final ActiveGameDetails gameStatus;

//   const AssetTopRowNIU(
//     this.asset,
//     this.gameStatus, {
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     // final size = MediaQuery.of(context).size;
//     const double _rowLeftMargin = 8;
//     const double _rowRightMargin = 16;
//     return Expanded(
//       child: Row(
//         // top row
//         mainAxisSize: MainAxisSize.max,
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Flexible(
//             fit: FlexFit.loose,
//             child: Padding(
//               padding: const EdgeInsets.only(left: _rowLeftMargin),
//               child: Column(
//                 // player & team name
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     asset.topName,
//                     textAlign: TextAlign.left,
//                     style: asset.subName != ''
//                         ? StTextStyles.h2.copyWith(
//                             color: Colors.yellow,
//                           )
//                         : StTextStyles.h2.copyWith(
//                             color: Colors.pink,
//                           ),
//                   ),
//                   Text(
//                     asset.subName,
//                     style: StTextStyles.h5.copyWith(color: StColors.white),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           if (asset.assetStateUpdates.isTradable)
//             // trade button to right of player/team name
//             Padding(
//               padding: const EdgeInsets.only(right: _rowRightMargin),
//               child: TextButton(
//                 child: Text(
//                   StStrings.tradeUc,
//                   style: StTextStyles.h5,
//                 ),
//                 onPressed: () {},
//                 style: StButtonStyles.tradeButtonCanTrade,
//                 // style: size.height <= 568
//                 //     ? tradePlayerMarketLessWidthViewButtonStyle
//                 //     : tradePlayerMarketViewButtonStyle,
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }

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
                  '${_sharesHeld.toString()} ${StStrings.shares}',
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
                      // if (false)
                      //   TextSpan(
                      //     text: _formattedGainLoss,
                      //     style: StTextStyles.moneyDeltaPositive,
                      //   ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Column(
            children: [
              Text(
                asset.assetStateUpdates.isTradable
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
