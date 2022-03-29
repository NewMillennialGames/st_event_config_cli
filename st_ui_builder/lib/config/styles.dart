import 'package:flutter/material.dart';
import 'colors.dart';

class StTextStyles {
  //
  // Styles provided from the StylesMasterSpec file
  static const h1 = TextStyle(
    fontFamily: 'HelveticaNeue-Light',
    fontSize: 24,
    color: StColors.white,
  );
  static const h2 = TextStyle(
    fontFamily: 'HelveticaNeue-Light',
    fontSize: 22,
    color: StColors.white,
  );
  static const h3 = TextStyle(
    fontFamily: 'HelveticaNeue-Medium',
    fontSize: 20,
    color: StColors.white,
  );
  static const h4 = TextStyle(
    fontFamily: 'HelveticaNeue-Condensedbold',
    fontSize: 18,
    color: StColors.white,
    fontWeight: FontWeight.w500,
  );
  static const h5 = TextStyle(
    fontFamily: 'HelveticaNeue-Condensedbold',
    fontSize: 16,
    color: StColors.white,
  );
  static const h6 = TextStyle(
    fontFamily: 'HelveticaNeue-Condensedbold',
    fontSize: 14,
    color: StColors.white,
  );
  static const p1 = TextStyle(
    fontFamily: 'HelveticaNeue-Regular',
    fontSize: 16,
    color: StColors.white,
  );
  static const p2 = TextStyle(
    fontFamily: 'HelveticaNeue-Medium',
    fontSize: 14,
    color: StColors.white,
  );
  static const p3 = TextStyle(
    fontFamily: 'HelveticaNeue-Medium',
    fontSize: 12,
    color: StColors.white,
  );

  static const p4 = TextStyle(
    fontFamily: 'HelveticaNeue-Medium',
    fontSize: 10,
    color: StColors.white,
  );

  static get moneyDeltaPositive => p1.copyWith(
        color: StColors.green,
        fontSize: 14,
      );

  //     static const moneyDeltaPositive = TextStyle(
  //   color: StColors.white,
  //   fontFamily: 'Helvetica Neue',
  // );

  // old styles
  static const textFormField = TextStyle(
    color: StColors.white,
    fontFamily: 'Helvetica Neue',
  );
  static const error = TextStyle(
    color: StColors.errorText,
    fontSize: 16,
    fontFamily: 'Helvetica Neue',
  );

  static const title = TextStyle(
    color: StColors.white,
    fontSize: 40,
    fontWeight: FontWeight.w300,
  );
  static const subtitle = TextStyle(
    color: StColors.white,
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );
  static const buttonLabel = TextStyle(
    fontSize: 18,
  );

  // static const selectable = TextStyle(
  //   fontFamily: 'Helvetica Neue',
  //   fontSize: 15,
  //   color: StColors.selectableText,
  // );
  // static const changeImage = TextStyle(
  //   fontFamily: 'Helvetica Neue',
  //   fontSize: 16,
  //   color: StColors.selectableText,
  //   fontWeight: FontWeight.w500,
  // );

  // static const validate = TextStyle(
  //   color: StColors.validateText,
  //   fontSize: 16,
  //   fontFamily: 'Helvetica Neue',
  // );
  // static const rich = TextStyle(
  //   color: StColors.textHint,
  //   fontFamily: 'Helvetica Neue',
  //   fontSize: 16,
  // );
  // static const labelStylem320 = TextStyle(
  //   fontSize: 12,
  // );
  // static const textStatus = TextStyle(
  //   fontSize: 30,
  //   color: StColors.statusEventText,
  // );
  // static const textEventSectionStatus = TextStyle(
  //   fontSize: 18,
  //   color: StColors.white,
  // );
  // static const textScoresEvent = TextStyle(
  //   fontWeight: FontWeight.w500,
  //   fontFamily: 'Helvetica Neue',
  //   color: StColors.textEvents,
  // );
  // static const textNameEvent = TextStyle(
  //   color: StColors.black,
  //   fontWeight: FontWeight.w700,
  //   fontSize: 18,
  // );
  // static const textListTileDrawer = TextStyle(
  //   color: StColors.white,
  //   fontWeight: FontWeight.w500,
  // );
  // static const kTextValuesDrawer = TextStyle(
  //   color: StColors.validateText,
  // );
  // static const textNameUserDrawer = TextStyle(
  //   color: StColors.white,
  //   fontWeight: FontWeight.w500,
  //   fontSize: 20,
  // );
  // static const textLisTileTokens = TextStyle(
  //   fontFamily: 'Helvetica Neue',
  //   color: StColors.white,
  //   fontWeight: FontWeight.w700,
  // );
  // static const titleAlertDialog = TextStyle(
  //   fontFamily: 'Helvetica Neue',
  //   fontSize: 18,
  //   color: StColors.black,
  //   fontWeight: FontWeight.w700,
  // );
  // static const actionButtonAlertDialog = TextStyle(
  //   fontFamily: 'Helvetica Neue',
  //   fontSize: 18,
  //   color: StColors.blue,
  //   fontWeight: FontWeight.w700,
  // );
  // static const textFieldAlertDialogPromoCode = TextStyle(
  //   fontFamily: 'Helvetica Neue',
  //   fontSize: 24,
  //   color: StColors.black,
  // );
  // static const durationTextAppBar = TextStyle(
  //   fontFamily: 'Helvetica Neue',
  //   fontSize: 14,
  //   color: StColors.white,
  //   fontWeight: FontWeight.w500,
  // );
  // static const nameEventAppbar = TextStyle(
  //   fontFamily: 'Helvetica Neue',
  //   fontWeight: FontWeight.w500,
  // );
  // static const textPortfolio = TextStyle(
  //   color: StColors.blue,
  //   fontSize: 12,
  // );
  // static const textClearDisable = TextStyle(
  //   color: StColors.textHint,
  //   fontSize: 15,
  //   fontWeight: FontWeight.normal,
  // );
  // static const textNameMarketTicker = TextStyle(
  //   fontFamily: 'Helvetica Neue',
  //   fontSize: 12,
  //   color: StColors.white,
  //   fontWeight: FontWeight.w700,
  // );
  // static const textValueMarketTicker = TextStyle(
  //   fontFamily: 'Helvetica Neue',
  //   fontSize: 11,
  //   color: StColors.valuePositiveMarketTicker,
  //   fontWeight: FontWeight.w700,
  // );
  // static const textTeamNameMarketView = TextStyle(
  //   fontFamily: 'Helvetica Neue',
  //   fontSize: 18,
  //   color: StColors.teamNameMarketView,
  //   fontWeight: FontWeight.w700,
  // );
  // static const textGainPositiveTeamMarketView = TextStyle(
  //   fontFamily: 'Helvetica Neue',
  //   fontSize: 14,
  //   color: StColors.teamGainPositiveMarketView,
  //   fontWeight: FontWeight.w700,
  // );
  // static const textOpenHighLowTeamMarketView = TextStyle(
  //   fontFamily: 'Helvetica Neue',
  //   fontSize: 11,
  //   color: StColors.teamOpenHighLowMarketView,
  // );
  // static const textTradeButtonTeamMarketView = TextStyle(
  //   fontFamily: 'Helvetica Neue',
  //   fontSize: 14,
  //   color: StColors.teamNameMarketView,
  //   fontWeight: FontWeight.w700,
  // );
  // static const textRichPlayerTradeView = TextStyle(
  //   fontFamily: 'Helvetica Neue',
  //   fontSize: 14,
  //   color: StColors.teamOpenHighLowMarketView,
  // );
  // static const textSellReviewOrder = TextStyle(
  //   fontFamily: 'Helvetica Neue',
  //   fontSize: 24,
  //   color: StColors.white,
  // );
  // static const textTimeReviewOrder = TextStyle(
  //   fontFamily: 'Helvetica Neue',
  //   fontSize: 18,
  //   color: StColors.textEvents,
  // );
  // static const textTimeValueReviewOrder = TextStyle(
  //   fontFamily: 'Helvetica Neue',
  //   fontSize: 20,
  //   color: StColors.timeValueReviewOrder,
  // );
  // static const textClearButtonReviewOrderInputform = TextStyle(
  //   fontFamily: 'Helvetica Neue',
  //   fontSize: 16,
  //   color: StColors.darkBlue,
  //   fontWeight: FontWeight.w500,
  // );

}

class StButtonStyles {
  //
  // keep
  static ButtonStyle tradeButtonCanTrade = TextButton.styleFrom(
    backgroundColor: StColors.darkGreen,
    // padding: const EdgeInsets.symmetric(
    //   vertical: 20,
    //   horizontal: 15,
    // ),
  );

  // replace
  static ButtonStyle getTokens = ElevatedButton.styleFrom(
    primary: StColors.defaultBackgroundGray,
    side: const BorderSide(
      color: StColors.blue,
    ),
    // padding: const EdgeInsets.symmetric(
    //   horizontal: 25,
    // ),
  );
  static ButtonStyle getTokensOnTap = ElevatedButton.styleFrom(
    primary: StColors.blue,
    padding: const EdgeInsets.symmetric(horizontal: 25),
  );
  static ButtonStyle getTokensLessWidth = ElevatedButton.styleFrom(
    primary: StColors.defaultBackgroundGray,
    side: const BorderSide(
      color: StColors.blue,
    ),
    padding: const EdgeInsets.symmetric(horizontal: 18),
  );
  static ButtonStyle getTokensOnTapLessWith = ElevatedButton.styleFrom(
    primary: StColors.blue,
    padding: const EdgeInsets.symmetric(horizontal: 18),
  );

  static ButtonStyle tradePlayerMarketView = TextButton.styleFrom(
    backgroundColor: StColors.darkGreen,
    padding: const EdgeInsets.symmetric(
      vertical: 10,
      horizontal: 15,
    ),
  );
  static ButtonStyle tradeTeamMarketLessWidthView = TextButton.styleFrom(
    backgroundColor: StColors.darkGreen,
    padding: const EdgeInsets.symmetric(
      vertical: 20,
      horizontal: 10,
    ),
  );
  static ButtonStyle tradePlayerMarketLessWidthView = TextButton.styleFrom(
    backgroundColor: StColors.darkGreen,
    padding: const EdgeInsets.symmetric(
      vertical: 10,
      horizontal: 10,
    ),
  );
  static ButtonStyle reviewOrder = ElevatedButton.styleFrom(
    primary: StColors.backgroundColorButtonReviewOrder,
  );
  static ButtonStyle clearActiveForm = ElevatedButton.styleFrom(
    primary: StColors.transparentColor,
    side: const BorderSide(
      color: StColors.darkBlue,
      width: 1,
    ),
  );
}
