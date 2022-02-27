part of StUiController;

class MktRschAsset extends StatelessWidget {
  final AssetRowPropertyIfc asset;
  const MktRschAsset({
    Key? key,
    required this.asset,
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
            asset.rank > 3 ? kImageVsBgRightOn : kImageVsBgLeftOn,
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
                    asset.topName,
                    style: StTextStyles.h4.copyWith(
                      fontSize: 18,
                      color: asset.canTrade
                          ? StColors.coolGray
                          : StTextStyles.h4.color,
                    ),
                  ),
                  Text(
                    asset.subName,
                    style: StTextStyles.textFormField.copyWith(
                      color: asset.canTrade
                          ? StColors.coolGray
                          : StTextStyles.textFormField.color,
                    ),
                  ),
                ],
              ),
              Icon(
                Icons.star_border,
                color: asset.canTrade ? StColors.gray : StColors.blue,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ObjectRankRow extends StatelessWidget {
  final int position;
  final AssetRowPropertyIfc asset;

  const ObjectRankRow({
    Key? key,
    required this.asset,
    required this.position,
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
          rankPos: position,
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
  final int rankPos;
  const _PositionRankRow({
    Key? key,
    required this.rankPos,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double _sizeIconRank = 40;
    Widget positionWidget = const SizedBox();
    switch (rankPos) {
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
            rankPos.toString(),
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
            rankPos.toString(),
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
  const AssetTopRow({
    Key? key,
    required this.asset,
  }) : super(key: key);

  final AssetRowPropertyIfc asset;

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
                    style: StTextStyles.textTradeButtonTeamMarketView.copyWith(
                      fontSize: 16,
                      color: StColors.teamOpenHighLowMarketView,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (asset.canTrade)
            // trade button to right of player/team name
            Padding(
              padding: const EdgeInsets.only(right: _rowRightMargin),
              child: TextButton(
                child: Text(
                  StStrings.portfolioPostionsRowTradeText,
                  style: StTextStyles.textTradeButtonTeamMarketView,
                ),
                onPressed: () {},
                style: StButtonStyles.tradePlayerMarketView,
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
  const HoldingsAndValueRow({
    Key? key,
    required this.asset,
  }) : super(key: key);

  final AssetRowPropertyIfc asset;

  int get _sharesHeld => 100;
  double get _sharePrice => asset.price;
  double get _gainLoss => asset.priceDelta;
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
                  '${_sharesHeld.toString() + ' ' + StStrings.portfolioPostionsRowSharesText}',
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
                          style: StTextStyles.textGainPositiveTeamMarketView,
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
                asset.canTrade
                    ? StStrings.portfolioPostionsRowValueText
                    : StStrings.portfolioPostionsRowProceedsText,
                style: StTextStyles.textRichPlayerTradeView.copyWith(
                  fontSize: 16,
                ),
              ),
              Text(
                asset.priceStr,
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
                  StStrings.portfolioPostionsRowGLText,
                  style: StTextStyles.textRichPlayerTradeView.copyWith(
                    fontSize: 16,
                  ),
                ),
                Text(
                  '${_gainLoss.isNegative ? _gainLoss.toStringAsFixed(2) : '+' + _gainLoss.toStringAsFixed(2)}',
                  style: _gainLoss.isNegative
                      ? StTextStyles.textGainPositiveTeamMarketView.copyWith(
                          color: StColors.errorText,
                        )
                      : StTextStyles.textGainPositiveTeamMarketView,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
