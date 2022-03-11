part of StUiController;

const kStarIcon = Icon(
  Icons.star_border,
  color: StColors.blue,
);

const kSpacerSm = SizedBox(
  width: 6,
);

class CompetitorImage extends StatelessWidget {
  // just the image or placeholder
  final String imgUrl;
  const CompetitorImage(
    this.imgUrl, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imgUrl,
      height: 20,
      width: 20,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => const Icon(
        Icons.egg_rounded,
        color: StColors.blue,
      ),
    );
  }
}

class TradeButton extends ConsumerWidget {
  final CompetitionStatus status;
  final String assetId;

  const TradeButton(
    this.assetId,
    this.status, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // trade button to right of player/team name
    // final tf = ref.read(tradeFlowProvider);
    return TextButton(
      child: const Text(
        StStrings.tradeUc,
        style: StTextStyles.tradeButtonText,
      ),
      onPressed: null,
      // onPressed: canTrade ? () => tf.beginTradeFlow(assetId) : null,
      style: status.isTradable
          ? StButtonStyles.tradeButtonCanTrade
          : StButtonStyles.tradeButtonCannotTrade,
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
      children: [
        Icon(
          Icons.star_border,
          color: gameDetails.isWatched(competitor.id)
              ? StColors.gray
              : StColors.blue,
        ),
        kSpacerSm,
        CompetitorImage(competitor.imgUrl),
        kSpacerSm,
        if (showRank) Text(competitor.rankStr),
        Expanded(
          child: Text(
            competitor.topName,
            style: StTextStyles.h3,
          ),
        ),
        Text(
          competitor.currPriceStr,
          style: StTextStyles.h3,
        ),
        kSpacerSm,
        TradeButton(
          competitor.id,
          gameDetails.gameStatus,
        ),
      ],
    );
  }
}

class MktRschAsset extends StatelessWidget {
  //
  final AssetRowPropertyIfc competitor;
  final ActiveGameDetails gameStatus;
  //
  const MktRschAsset(
    this.competitor,
    this.gameStatus, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // paste row widget code here
    final size = MediaQuery.of(context).size;
    const double _sizeHeightImage = 150;
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.asset(
            competitor.rank > 3 ? kImageVsBgRightOn : kImageVsBgLeftOn,
            height: _sizeHeightImage,
            width: size.width * 0.47,
            fit: BoxFit.fill,
          ),
        ),
        Container(
          height: _sizeHeightImage,
          width: size.width * 0.47,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              DottedBorder(
                color: StColors.white,
                child: const Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    StStrings.mktRschAssetVsAssetTeamImgText,
                    style: StTextStyles.textFormField,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    competitor.topName,
                    style: StTextStyles.h4.copyWith(
                      fontSize: 18,
                      color: gameStatus.isTradable
                          ? StColors.coolGray
                          : StTextStyles.h4.color,
                    ),
                  ),
                  Text(
                    competitor.subName,
                    style: StTextStyles.textFormField.copyWith(
                      color: gameStatus.isTradable
                          ? StColors.coolGray
                          : StTextStyles.textFormField.color,
                    ),
                  ),
                ],
              ),
              Icon(
                Icons.star_border,
                color: gameStatus.isTradable ? StColors.gray : StColors.blue,
              ),
            ],
          ),
        ),
      ],
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
              style: StTextStyles.textLisTileTokens.copyWith(
                fontSize: 20,
              ),
            ),
            if (!asset.isTeam)
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Text(
                  asset.subName,
                  style: StTextStyles.textScoresEvent.copyWith(
                    fontSize: 16,
                  ),
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
            style: StTextStyles.textLisTileTokens.copyWith(
              fontSize: 25,
            ),
            textAlign: TextAlign.center,
          ),
        );
        break;
      default:
        positionWidget = Container(
          width: _sizeIconRank,
          child: Text(
            asset.rankStr,
            style: StTextStyles.textLisTileTokens.copyWith(
              fontSize: 25,
            ),
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
                        ? StTextStyles.textTeamNameMarketView.copyWith(
                            color: Colors.yellow,
                          )
                        : StTextStyles.textNameMarketTicker.copyWith(
                            color: Colors.pink,
                            fontSize: 24,
                          ),
                  ),
                  Text(
                    asset.subName,
                    style: StTextStyles.tradeButtonText.copyWith(
                      fontSize: 16,
                      color: StColors.teamOpenHighLowMarketView,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (gameStatus.isTradable)
            // trade button to right of player/team name
            Padding(
              padding: const EdgeInsets.only(right: _rowRightMargin),
              child: TextButton(
                child: const Text(
                  StStrings.tradeUc,
                  style: StTextStyles.tradeButtonText,
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

  double get _sharePrice => asset.assetPriceFluxSummary?.currPrice ?? 0;
  int get _sharesHeld => asset.assetHoldingsSummary?.sharesOwned ?? 0;
  double get _gainLoss => asset.assetHoldingsSummary?.positionGainLoss ?? 0;

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
      color: StColors.veryDarkGray,
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
                  '${_sharesHeld.toString() + ' ' + StStrings.shares}',
                  style: StTextStyles.textRichPlayerTradeView.copyWith(
                    fontSize: 16,
                  ),
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '＠',
                        style: StTextStyles.textNameMarketTicker.copyWith(
                          fontSize: 10,
                        ),
                      ),
                      TextSpan(
                        text: '${'asset.shares'} ',
                        style: StTextStyles.textNameMarketTicker.copyWith(
                          fontSize: 14,
                        ),
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
                gameStatus.isTradable ? StStrings.value : StStrings.proceeds,
                style: StTextStyles.textRichPlayerTradeView.copyWith(
                  fontSize: 16,
                ),
              ),
              Text(
                _sharePrice.toString(),
                style: StTextStyles.textNameMarketTicker.copyWith(
                  fontSize: 14,
                ),
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
                  style: StTextStyles.textRichPlayerTradeView.copyWith(
                    fontSize: 16,
                  ),
                ),
                Text(
                  '${_gainLoss.isNegative ? _gainLoss.toStringAsFixed(2) : '+' + _gainLoss.toStringAsFixed(2)}',
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
