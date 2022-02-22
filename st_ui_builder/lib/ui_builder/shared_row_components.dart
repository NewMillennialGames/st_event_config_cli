part of StUiController;


class MktRschAsset extends StatelessWidget {
  final rschAsset;
  const MktRschAsset({
    Key? key,
    required this.rschAsset,
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
            rschAsset.isOff && rschAsset.isRight
                ? kImageVsBgRightOff
                : rschAsset.isOff && !rschAsset.isRight
                    ? kImageVsBgLeftOff
                    : !rschAsset.isOff && rschAsset.isRight
                        ? kImageVsBgRightOn
                        : kImageVsBgLeftOn,
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
                child: Padding(
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
                    rschAsset.team.name,
                    style: StTextStyles.h4.copyWith(
                      fontSize: 18,
                      color: rschAsset.isOff
                          ? StColors.coolGray
                          : StTextStyles.h4.color,
                    ),
                  ),
                  Text(
                    rschAsset.record,
                    style: StTextStyles.textFormField.copyWith(
                      color: rschAsset.isOff
                          ? StColors.coolGray
                          : StTextStyles.textFormField.color,
                    ),
                  ),
                ],
              ),
              Icon(
                Icons.star_border,
                color: rschAsset.isOff ? StColors.gray : StColors.blue,
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
  final object;
  final String name;
  const ObjectRankRow({
    Key? key,
    required this.object,
    required this.position,
    required this.name,
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
          position: position,
        ),
        const SizedBox(
          width: _rowMargin,
        ),
        Image.network(
          object.urlImage,
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
            if (name == 'Player Name')
              const SizedBox(
                height: _rowMargin,
              ),
            if (name == 'TeamName')
              const SizedBox(
                height: _rowMarginTop,
              ),
            Text(
              object.name,
              style: StTextStyles.textLisTileTokens.copyWith(
                fontSize: 20,
              ),
            ),
            if (name == 'Player Name')
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Text(
                  object.team,
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
  final int position;
  const _PositionRankRow({
    Key? key,
    required this.position,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double _sizeIconRank = 40;
    Widget positionWidget = const SizedBox();
    switch (position) {
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
            position.toString(),
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
            position.toString(),
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
  const AssetTopRow({
    Key? key,
    required this.player,
  }) : super(key: key);

  final player;

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
                    player.name,
                    textAlign: TextAlign.left,
                    style: player.team != ''
                        ? StTextStyles.textTeamNameMarketView.copyWith(
                            color: player.color,
                          )
                        : StTextStyles.textNameMarketTicker.copyWith(
                            color: player.color,
                            fontSize: 24,
                          ),
                  ),
                  Text(
                    player.team,
                    style: StTextStyles.textTradeButtonTeamMarketView.copyWith(
                      fontSize: 16,
                      color: StColors.teamOpenHighLowMarketView,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (player.showButton)
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
  const HoldingsAndValueRow({
    Key? key,
    required this.player,
  }) : super(key: key);

  final player;

  int get _sharesHeld => player.sharesHeld;
  double get _sharePrice => player.shares[1];
  double get _gainLoss => player.GL;
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
                        text: '${player.shares[0].toStringAsFixed(2)} ',
                        style: StTextStyles.textNameMarketTicker.copyWith(
                          fontSize: 14,
                        ),
                      ),
                      if (player.shares.length > 1)
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
                player.showButton
                    ? StStrings.portfolioPostionsRowValueText
                    : StStrings.portfolioPostionsRowProceedsText,
                style: StTextStyles.textRichPlayerTradeView.copyWith(
                  fontSize: 16,
                ),
              ),
              Text(
                player.value.toStringAsFixed(2),
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