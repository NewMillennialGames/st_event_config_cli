/*
  every displayable/tradable asset (wrapped in AssetRowPropertyIfc)
  passed to the ST row factory should follow the interface below

  these are the properties the row-factory needs to render
  all of our various types of rows
*/

part of StUiController;

const String kMissingPrice = '0.00';

abstract class AssetRowPropertyIfc {
  // must have a value for each name on:
  // enum DbTableFieldName()
  AssetKey get assetKey; // for unique comparison
  String get topName; // aka longName

  String get subName; // aka orgName or shortName

  String get ticker; // symbol or shortName

  String get marketResearchUrl;

  String get liveStatsUrl;

  String get imgUrl;

  String get position;

  int get rank;

  bool get isTeam;

  String get searchText;

  Decimal get openPrice;

  //
  String get teamNameWhenTradingPlayers;

  String get teamImgUrlWhenTradingPlayers;

  // holds asset price history
  AssetStateUpdates get assetStateUpdates;

  // holds user ownership state
  AssetHoldingsSummaryIfc get assetHoldingsSummary;

  UserEventSummaryIfc get userEventSummary;

  // next 3 properties are game props but needed for sorting and grouping
  // shows values off the game record
  DateTime get gameDate; // rounded to midnight for row grouping
  String get leagueGrouping;

  String get roundName;

  String get location;

  int get displayNumber;

  CompetitionStatus get gameStatus;

  CompetitionType get gameType;

  // extra asset fields that don't fit within the DB-model
  String get extAtts; // extended attributes as JSON

  void updateDynamicState(ActiveGameDetails agd);

  String? get groupName;
}

extension AssetRowPropertyIfcExt1 on AssetRowPropertyIfc {
  // sensible defaults if not overridden
  String get searchText =>
      (topName + '-' + subName + '-' + teamNameWhenTradingPlayers)
          .toUpperCase();

  String get rankStr => '$rank';

  String get displayNumberStr => '$displayNumber';

  String get gameDateDtwStr => gameDate.asDtwMmDyStr;

  String get gameDateAppStr => gameDate.asShortDtStr;

  String get gameTimeStr => gameDate.asTimeOnlyStr;

  // from assetHoldingsSummary
  Decimal get positionGainLoss =>
      assetHoldingsSummary.positionGainLoss; // ?? 0;
  String get sharesOwnedStr => assetHoldingsSummary.sharesOwnedStr; // ?? '0';
  int get sharesOwnedInt => assetHoldingsSummary.sharesOwned;
  bool get isOwned => sharesOwnedInt > 0;

  String get positionCostStr =>
      assetHoldingsSummary.positionCostStr; // ?? kMissingPrice;
  String get positionEstValueStr =>
      assetHoldingsSummary.positionEstValueStr; // ?? kMissingPrice;
  String get positionGainLossStr =>
      assetHoldingsSummary.positionGainLossStr; // ?? kMissingPrice;
  bool get returnIsPositive =>
      assetHoldingsSummary.returnIsPositive; // ?? false;
  Color get posGainSymbolColor =>
      assetHoldingsSummary.posGainSymbolColor; // ?? Colors.grey;

  // assetPriceFluxSummary
  Decimal get currPrice => assetStateUpdates.curPrice; // ?? 0;
  Decimal get recentPriceDelta =>
      assetStateUpdates.priceDeltaSinceOpen; // ?? 0;
  String get currPriceStr => assetStateUpdates.curPriceStr; // ?? kMissingPrice;
  String get recentDeltaStr =>
      assetStateUpdates.formattedChangeStr; // ?? kMissingPrice;
  String get openPriceStr => assetStateUpdates.openPrice.toStringAsFixed(2);

  String get lowPriceStr => assetStateUpdates.lowPrice.toStringAsFixed(2);

  String get hiPriceStr => assetStateUpdates.hiPrice.toStringAsFixed(2);

  bool get stockIsUp => assetStateUpdates.stockIsUp;

  Color get priceFluxColor => assetStateUpdates.priceFluxColor;

  CompetitionType get gameType => CompetitionType.game;

  Map<String, dynamic>? get extAttsAsMap {
    // extended attributes as dict
    return extAtts.isNotEmpty
        ? jsonDecode(extAtts) as Map<String, dynamic>?
        : null;
  }

  String labelExtractor(DbTableFieldName fldName) {
    /* header labels in list groups
    */
    switch (fldName) {
      case DbTableFieldName.assetName:
        return topName;
      case DbTableFieldName.assetShortName:
        return subName;
      case DbTableFieldName.assetOrgName:
        return teamNameWhenTradingPlayers;
      case DbTableFieldName.leagueGrouping:
        return leagueGrouping;
      // case DbTableFieldName.leagueGrouping:
      //   return leagueGrouping;
      case DbTableFieldName.gameDate:
        return gameDateDtwStr;
      case DbTableFieldName.gameTime:
        return gameDate.timeOnly.asTimeOnlyStr;
      // case DbTableFieldName.eventName:
      // // this is an error;  we dont have event name on assets
      //   return topName;
      case DbTableFieldName.gameLocation:
        return location;
      case DbTableFieldName.imageUrl:
        return imgUrl;
      case DbTableFieldName.assetOpenPrice:
        return openPriceStr;
      case DbTableFieldName.assetCurrentPrice:
        return recentDeltaStr;
      case DbTableFieldName.assetRankOrScore:
        return rankStr;
      case DbTableFieldName.assetPosition:
        return position;
      default:
        return '_dfltProp';
    }
  }

  Comparable sortValueExtractor(DbTableFieldName fldName) {
    /* comparible values used for the actual sort
    */
    switch (fldName) {
      case DbTableFieldName.assetName:
        return topName;
      case DbTableFieldName.assetShortName:
        return subName;
      case DbTableFieldName.assetOrgName:
        return teamNameWhenTradingPlayers;
      case DbTableFieldName.leagueGrouping:
        return leagueGrouping;
      // case DbTableFieldName.region:
      //   return leagueGrouping;
      case DbTableFieldName.gameDate:
        return gameDate.truncateTime;
      case DbTableFieldName.gameTime:
        return gameDate.timeOnly;
      // case DbTableFieldName.eventName:
      //   // this is an error;  we dont have event name on assets
      //   return topName;
      case DbTableFieldName.gameLocation:
        return location;
      case DbTableFieldName.imageUrl:
        return imgUrl;
      case DbTableFieldName.assetOpenPrice:
        return openPrice;
      case DbTableFieldName.assetCurrentPrice:
        return currPrice;
      case DbTableFieldName.assetRankOrScore:
        return rank;
      case DbTableFieldName.assetPosition:
        return position;
      default:
        return '_dfltProp';
    }
  }
}
