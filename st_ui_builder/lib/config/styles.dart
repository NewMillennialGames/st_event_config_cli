import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:st_ev_cfg/st_ev_cfg.dart';
import 'colors.dart';

class StTextStyles {
  //
  // Styles provided from the StylesMasterSpec file
  static var h1 = TextStyle(
    fontFamily: 'HelveticaNeue-Light',
    fontSize: 24.sp,
    color: StColors.white,
  );
  static var h2 = TextStyle(
    fontFamily: 'HelveticaNeue-Light',
    fontSize: 22.sp,
    color: StColors.white,
  );
  static var h3 = TextStyle(
    fontFamily: 'HelveticaNeue-Medium',
    fontSize: 20.sp,
    color: StColors.white,
  );
  static var h4 = TextStyle(
    fontFamily: 'HelveticaNeue-Condensedbold',
    fontSize: 18.sp,
    color: StColors.white,
    fontWeight: FontWeight.w500,
  );
  static var h5 = TextStyle(
    fontFamily: 'HelveticaNeue-Condensedbold',
    fontSize: 17.sp,
    color: StColors.white,
  );
  static var h6 = TextStyle(
    fontFamily: 'HelveticaNeue-Condensedbold',
    fontSize: 14.sp,
    color: StColors.white,
  );
  static var p1 = TextStyle(
    fontFamily: 'HelveticaNeue-Regular',
    fontSize: 16.sp,
    color: StColors.white,
  );
  static var p2 = TextStyle(
    fontFamily: 'HelveticaNeue-Medium',
    fontSize: 14.sp,
    color: StColors.white,
  );
  static var p3 = TextStyle(
    fontFamily: 'HelveticaNeue-Medium',
    fontSize: 12.sp,
    color: StColors.white,
  );

  static var p4 = TextStyle(
    fontFamily: 'HelveticaNeue-Medium',
    fontSize: 10.sp,
    color: StColors.white,
  );

  static TextStyle get moneyDeltaPositive => p1.copyWith(
        color: StColors.green,
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
  static var error = TextStyle(
    color: StColors.errorText,
    fontSize: 16.sp,
    fontFamily: 'Helvetica Neue',
  );

  static var title = TextStyle(
    color: StColors.white,
    fontSize: 40.sp,
    fontWeight: FontWeight.w300,
  );
  static var subtitle = TextStyle(
    color: StColors.white,
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
  );
  static var buttonLabel = TextStyle(
    fontSize: 18.sp,
  );

  // static const selectable = TextStyle(
  //   fontFamily: 'Helvetica Neue',
  //   fontSize: 15.sp,
  //   color: StColors.selectableText,
  // );
  // static const changeImage = TextStyle(
  //   fontFamily: 'Helvetica Neue',
  //   fontSize: 16.sp,
  //   color: StColors.selectableText,
  //   fontWeight: FontWeight.w500,
  // );

  // static const validate = TextStyle(
  //   color: StColors.validateText,
  //   fontSize: 16.sp,
  //   fontFamily: 'Helvetica Neue',
  // );
  // static const rich = TextStyle(
  //   color: StColors.textHint,
  //   fontFamily: 'Helvetica Neue',
  //   fontSize: 16.sp,
  // );
  // static const labelStylem320 = TextStyle(
  //   fontSize: 12.sp,
  // );
  // static const textStatus = TextStyle(
  //   fontSize: 30.sp,
  //   color: StColors.statusEventText,
  // );
  // static const textEventSectionStatus = TextStyle(
  //   fontSize: 18.sp,
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
  //   fontSize: 18.sp,
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
  //   fontSize: 20.sp,
  // );
  // static const textLisTileTokens = TextStyle(
  //   fontFamily: 'Helvetica Neue',
  //   color: StColors.white,
  //   fontWeight: FontWeight.w700,
  // );
  // static const titleAlertDialog = TextStyle(
  //   fontFamily: 'Helvetica Neue',
  //   fontSize: 18.sp,
  //   color: StColors.black,
  //   fontWeight: FontWeight.w700,
  // );
  // static const actionButtonAlertDialog = TextStyle(
  //   fontFamily: 'Helvetica Neue',
  //   fontSize: 18.sp,
  //   color: StColors.blue,
  //   fontWeight: FontWeight.w700,
  // );
  // static const textFieldAlertDialogPromoCode = TextStyle(
  //   fontFamily: 'Helvetica Neue',
  //   fontSize: 24.sp,
  //   color: StColors.black,
  // );
  // static const durationTextAppBar = TextStyle(
  //   fontFamily: 'Helvetica Neue',
  //   fontSize: 14.sp,
  //   color: StColors.white,
  //   fontWeight: FontWeight.w500,
  // );
  // static const nameEventAppbar = TextStyle(
  //   fontFamily: 'Helvetica Neue',
  //   fontWeight: FontWeight.w500,
  // );
  // static const textPortfolio = TextStyle(
  //   color: StColors.blue,
  //   fontSize: 12.sp,
  // );
  // static const textClearDisable = TextStyle(
  //   color: StColors.textHint,
  //   fontSize: 15.sp,
  //   fontWeight: FontWeight.normal,
  // );
  // static const textNameMarketTicker = TextStyle(
  //   fontFamily: 'Helvetica Neue',
  //   fontSize: 12.sp,
  //   color: StColors.white,
  //   fontWeight: FontWeight.w700,
  // );
  // static const textValueMarketTicker = TextStyle(
  //   fontFamily: 'Helvetica Neue',
  //   fontSize: 11.sp,
  //   color: StColors.valuePositiveMarketTicker,
  //   fontWeight: FontWeight.w700,
  // );
  // static const textTeamNameMarketView = TextStyle(
  //   fontFamily: 'Helvetica Neue',
  //   fontSize: 18.sp,
  //   color: StColors.teamNameMarketView,
  //   fontWeight: FontWeight.w700,
  // );
  // static const textGainPositiveTeamMarketView = TextStyle(
  //   fontFamily: 'Helvetica Neue',
  //   fontSize: 14.sp,
  //   color: StColors.teamGainPositiveMarketView,
  //   fontWeight: FontWeight.w700,
  // );
  // static const textOpenHighLowTeamMarketView = TextStyle(
  //   fontFamily: 'Helvetica Neue',
  //   fontSize: 11.sp,
  //   color: StColors.teamOpenHighLowMarketView,
  // );
  // static const textTradeButtonTeamMarketView = TextStyle(
  //   fontFamily: 'Helvetica Neue',
  //   fontSize: 14.sp,
  //   color: StColors.teamNameMarketView,
  //   fontWeight: FontWeight.w700,
  // );
  // static const textRichPlayerTradeView = TextStyle(
  //   fontFamily: 'Helvetica Neue',
  //   fontSize: 14.sp,
  //   color: StColors.teamOpenHighLowMarketView,
  // );
  // static const textSellReviewOrder = TextStyle(
  //   fontFamily: 'Helvetica Neue',
  //   fontSize: 24.sp,
  //   color: StColors.white,
  // );
  // static const textTimeReviewOrder = TextStyle(
  //   fontFamily: 'Helvetica Neue',
  //   fontSize: 18.sp,
  //   color: StColors.textEvents,
  // );
  // static const textTimeValueReviewOrder = TextStyle(
  //   fontFamily: 'Helvetica Neue',
  //   fontSize: 20.sp,
  //   color: StColors.timeValueReviewOrder,
  // );
  // static const textClearButtonReviewOrderInputform = TextStyle(
  //   fontFamily: 'Helvetica Neue',
  //   fontSize: 16.sp,
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

  static ButtonStyle tradeBtnWhileGameInProgress = TextButton.styleFrom(
    backgroundColor: StColors.darkGreen,
    shape: const BeveledRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(4),
      ),
    ),
    side: const BorderSide(color: StColors.red, width: 4),
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
    padding: EdgeInsets.symmetric(horizontal: 25.w),
  );
  static ButtonStyle getTokensLessWidth = ElevatedButton.styleFrom(
    primary: StColors.defaultBackgroundGray,
    side: const BorderSide(
      color: StColors.blue,
    ),
    padding: EdgeInsets.symmetric(horizontal: 18.w),
  );
  static ButtonStyle getTokensOnTapLessWith = ElevatedButton.styleFrom(
    primary: StColors.blue,
    padding: EdgeInsets.symmetric(horizontal: 18.w),
  );

  static ButtonStyle tradePlayerMarketView = TextButton.styleFrom(
    backgroundColor: StColors.darkGreen,
    padding: EdgeInsets.symmetric(
      vertical: 10.h,
      horizontal: 15.w,
    ),
  );
  static ButtonStyle tradeTeamMarketLessWidthView = TextButton.styleFrom(
    backgroundColor: StColors.darkGreen,
    padding: EdgeInsets.symmetric(
      vertical: 20.h,
      horizontal: 10.w,
    ),
  );
  static ButtonStyle tradePlayerMarketLessWidthView = TextButton.styleFrom(
    backgroundColor: StColors.darkGreen,
    padding: EdgeInsets.symmetric(
      vertical: 10.h,
      horizontal: 10.w,
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
