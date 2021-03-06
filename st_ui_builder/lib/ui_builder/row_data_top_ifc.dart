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
  String get topName;

  String get subName;

  String get ticker;

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
  String get regionOrConference;

  String get roundName;

  String get location;

  int get displayNumber;

  CompetitionStatus get gameStatus;

  CompetitionType get gameType;

  void updateDynamicState(ActiveGameDetails agd);
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

  String labelExtractor(DbTableFieldName fldName) {
    /* header labels in list groups
    */
    switch (fldName) {
      case DbTableFieldName.assetName:
        return topName;
      case DbTableFieldName.assetOrgName:
        return subName;
      case DbTableFieldName.conference:
        return regionOrConference;
      case DbTableFieldName.region:
        return regionOrConference;
      case DbTableFieldName.gameDate:
        return gameDateDtwStr;
      case DbTableFieldName.gameTime:
        return gameDate.timeOnly.asTimeOnlyStr;
      case DbTableFieldName.eventName:
        return topName;
      case DbTableFieldName.gameLocation:
        return location;
      case DbTableFieldName.imageUrl:
        return imgUrl;
      case DbTableFieldName.assetOpenPrice:
        return openPriceStr;
      case DbTableFieldName.assetCurrentPrice:
        return recentDeltaStr;
      case DbTableFieldName.assetRank:
        return rankStr;
      case DbTableFieldName.assetPosition:
        return position;
      // default:
      //   return '_dfltProp';
    }
  }

  Comparable sortValueExtractor(DbTableFieldName fldName) {
    /* comparible values used for the actual sort
    */
    switch (fldName) {
      case DbTableFieldName.assetName:
        return topName;
      case DbTableFieldName.assetOrgName:
        return subName;
      case DbTableFieldName.conference:
        return regionOrConference;
      case DbTableFieldName.region:
        return regionOrConference;
      case DbTableFieldName.gameDate:
        return gameDate.truncateTime;
      case DbTableFieldName.gameTime:
        return gameDate.timeOnly;
      case DbTableFieldName.eventName:
        return topName;
      case DbTableFieldName.gameLocation:
        return location;
      case DbTableFieldName.imageUrl:
        return imgUrl;
      case DbTableFieldName.assetOpenPrice:
        return openPrice;
      case DbTableFieldName.assetCurrentPrice:
        return currPrice;
      case DbTableFieldName.assetRank:
        return rank;
      case DbTableFieldName.assetPosition:
        return position;
      // default:
      //   return '_dfltProp';
    }
  }
}
