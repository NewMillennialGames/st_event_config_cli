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

const kSpacerSm = SizedBox(
  width: 6,
);
const kVerticalSpacerSm = SizedBox(
  height: 3,
);
const kSpacerLarge = SizedBox(
  width: 20,
);

class CompetitorImage extends StatelessWidget {
  // just the image or placeholder
  final String imgUrl;
  final bool shrinkForRank;

  const CompetitorImage(
    this.imgUrl,
    this.shrinkForRank, {
    Key? key,
  }) : super(key: key);

  double get imgSize =>
      shrinkForRank ? (UiSizes.teamImgSide * 0.84) : UiSizes.teamImgSide;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imgUrl,
      height: imgSize,
      width: imgSize,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => const Icon(
        Icons.egg_rounded,
        color: StColors.blue,
      ),
    );
  }
}

class TradeButton extends ConsumerWidget {
  //
  final AssetKey assetId;
  final CompetitionStatus status;

  const TradeButton(
    this.assetId,
    this.status, {
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
    Event? optCurEvent = ref.watch(currEventStateProvider.notifier).state;
    if (optCurEvent == null) {
      print('No event loaded??');
    }
    print(
      '********* event.state is: ${optCurEvent?.state.name ?? 'missing'}',
    );
    bool eventHasStarted = true;
    // (optCurEvent?.state ?? EventState.unpublished) == EventState.inProgress;

    return Container(
      height: UiSizes.tradeBtnHeight,
      width: 80,
      // width: UiSizes.tradeBtnWidthPctScreen * size.width,
      alignment: Alignment.center,
      child: (eventHasStarted && status.isTradable)
          ? TextButton(
              child: const Text(
                StStrings.tradeUc,
                // tf.labelForState(status),
                style: StTextStyles.h6,
                textAlign: TextAlign.center,
              ),
              onPressed: () => tf.beginTradeFlow(assetId),
              style: StButtonStyles.tradeButtonCanTrade,
            )
          : Text(
              tf.labelForGameState(status),
              style: StTextStyles.h5.copyWith(
                fontSize: 13,
                color: tf.colorForGameState(status),
              ),
              textAlign: TextAlign.center,
            ),
    );
  }
}

class CheckAssetType extends StatelessWidget {
  final AssetRowPropertyIfc competitor;
  final bool? isDriverVsField;
  final bool? isTeamPlayerVsField;
  final bool? isPlayerVsFieldRanked;

  const CheckAssetType(
      {Key? key,
      required this.competitor,
      this.isDriverVsField = false,
      this.isTeamPlayerVsField = false,
      this.isPlayerVsFieldRanked = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var lst = competitor.topName.split(' ');
    String lastName;
    lst.length >= 2 ? lastName = lst[1] : lastName = '';
    String firstName = lst[0];
    if (isDriverVsField!) {
      return Row(
        children: [
          Text(
            competitor.rankStr,
            style: StTextStyles.h1
                .copyWith(fontWeight: FontWeight.w900, fontSize: 40),
          ),
          kSpacerSm,
          ConstrainedBox(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * .3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(firstName.toUpperCase(),
                    overflow: TextOverflow.ellipsis, style: StTextStyles.p2),
                Text(lastName.toUpperCase(),
                    overflow: TextOverflow.ellipsis,
                    style:
                        StTextStyles.h3.copyWith(fontWeight: FontWeight.w700))
              ],
            ),
          )
        ],
      );
    }
    if (isTeamPlayerVsField!) {
      return ConstrainedBox(
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * .3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(competitor.topName, style: StTextStyles.h4),
            Row(
              children: [
                Text(competitor.teamNameWhenTradingPlayers,
                    overflow: TextOverflow.ellipsis,
                    style: StTextStyles.p2.copyWith(color: StColors.coolGray)),
                kSpacerSm,
                Text(competitor.position,
                    overflow: TextOverflow.ellipsis,
                    style: StTextStyles.p2.copyWith(color: StColors.coolGray))
              ],
            ),
          ],
        ),
      );
    }
    if (isPlayerVsFieldRanked!) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(competitor.topName, style: StTextStyles.h4),
          Text(
            competitor.rankStr,
            style: StTextStyles.p2.copyWith(color: StColors.coolGray),
          ),
        ],
      );
    }
    return ConstrainedBox(
      constraints:
          BoxConstraints(maxWidth: MediaQuery.of(context).size.width * .3),
      child: Text(
        competitor.topName,
        overflow: TextOverflow.ellipsis,
        style: StTextStyles.h4,
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
          isDriverVsField: isDriverVsField,
          isTeamPlayerVsField: isTeamPlayerVsField,
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
  final AssetRowPropertyIfc competitor;
  final ActiveGameDetails gameDetails;
  final bool showRank;

  const AssetVsAssetHalfRow(
    this.competitor,
    this.gameDetails,
    this.showRank, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        WatchButton(
          assetKey: competitor.assetKey,
          isWatched: gameDetails.isWatched(competitor.assetKey),
        ),
        kSpacerSm,
        CompetitorImage(competitor.imgUrl, showRank),
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
            style: StTextStyles.h5.copyWith(fontSize: 15),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            // textScaleFactor: 0.96,
            // textWidthBasis: TextWidthBasis.longestLine,
          ),
        ),
        Text(
          competitor.currPriceStr,
          style: StTextStyles.h6.copyWith(fontSize: 13),
        ),
        const SizedBox(
          width: 4,
        ),
        TradeButton(
          competitor.assetKey,
          gameDetails.gameStatus,
        ),
      ],
    );
  }
}

// class MktRschAsset extends StatelessWidget {
//   //
//   final AssetRowPropertyIfc competitor;
//   final ActiveGameDetails gameStatus;

//   //
//   const MktRschAsset(
//     this.competitor,
//     this.gameStatus, {
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     // paste row widget code here
//     final size = MediaQuery.of(context).size;
//     const double _sizeHeightImage = 150;
//     return Stack(
//       children: [
//         ClipRRect(
//           borderRadius: BorderRadius.circular(15),
//           child: Image.asset(
//             competitor.rank > 3 ? kImageVsBgRightOn : kImageVsBgLeftOn,
//             height: _sizeHeightImage,
//             width: size.width * 0.47,
//             fit: BoxFit.fill,
//           ),
//         ),
//         SizedBox(
//           height: _sizeHeightImage,
//           width: size.width * 0.47,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               DottedBorder(
//                 color: StColors.white,
//                 child: const Padding(
//                   padding: EdgeInsets.all(10),
//                   child: Text(
//                     StStrings.mktRschAssetVsAssetTeamImgText,
//                     style: StTextStyles.textFormField,
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//               ),
//               Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Text(
//                     competitor.topName,
//                     style: StTextStyles.h4.copyWith(
//                       fontSize: 18,
//                       color: gameStatus._isTradableGame
//                           ? StColors.coolGray
//                           : StTextStyles.h4.color,
//                     ),
//                   ),
//                   Text(
//                     competitor.subName,
//                     style: StTextStyles.textFormField.copyWith(
//                       color: gameStatus._isTradableGame
//                           ? StColors.coolGray
//                           : StTextStyles.textFormField.color,
//                     ),
//                   ),
//                 ],
//               ),
//               Icon(
//                 Icons.star_border,
//                 color:
//                     gameStatus._isTradableGame ? StColors.gray : StColors.blue,
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

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
                child: const Text(
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

  double get _sharePrice => asset.assetStateUpdates.curPrice; // ?? 0;
  int get _sharesHeld => asset.assetHoldingsSummary.sharesOwned; // ?? 0;
  double get _gainLoss => asset.assetHoldingsSummary.positionGainLoss; // ?? 0;

  String get _formattedGainLoss => _sharePrice.isNegative
      ? _sharePrice.toStringAsFixed(2)
      : '+' + _sharePrice.toStringAsFixed(2);

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
                  _gainLoss.isNegative
                      ? _gainLoss.toStringAsFixed(2)
                      : '+' + _gainLoss.toStringAsFixed(2),
                  style: _gainLoss.isNegative
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

// return Container(
//   height: UiSizes.tradeBtnHeight,
//   alignment: Alignment.center,
//   child: Text(
//     tf.labelForGameState(status),
//     style: StTextStyles.h5.copyWith(
//       color: tf.colorForGameState(status),
//     ),
//   ),
// );
// }
