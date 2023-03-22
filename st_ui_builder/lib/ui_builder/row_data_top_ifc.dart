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
  String get orgNameWhenTradingPlayers;

  String get orgImgUrlWhenTradingPlayers;

  void setAssetNameDisplayStyle(EvAssetNameDisplayStyle ads);
  EvAssetNameDisplayStyle get assetNameDisplayStyle;

  // holds asset price history
  AssetStateUpdates get assetStateUpdates;

  // holds user ownership state
  AssetHoldingsSummaryIfc get assetHoldingsSummary;

  UserEventSummaryIfc get userEventSummary;

  // next 3 properties are game props but needed for sorting and grouping
  // shows values off the game record
  DateTime get competitionDate; // rounded to midnight for row grouping
  String get leagueGrouping;

  String get roundName;

  String get location;

  int get displayNumber;

  CompetitionStatus get competitionStatus;

  CompetitionType get competitionType;

  // extra asset fields that don't fit within the DB-model
  String get extAtts; // extended attributes as JSON

  void updateDynamicState(ActiveGameDetails agd);

  String? get groupName;
}

extension AssetRowPropertyIfcExt1 on AssetRowPropertyIfc {
  // sensible defaults if not overridden
  String get searchText =>
      (topName + '-' + subName + '-' + orgNameWhenTradingPlayers).toUpperCase();

  String get rankStr => '$rank';

  String get displayNumberStr => '$displayNumber';

  String get gameDateDtwStr => competitionDate.asDtwMmDyStr;

  String get gameDateAppStr => competitionDate.asShortDtStr;

  String get gameTimeStr => competitionDate.asTimeOnlyStr;

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

  EvAssetNameDisplayStyle get assetNameDisplayStyle =>
      EvAssetNameDisplayStyle.showShortName;

  CompetitionType get competitionType => CompetitionType.game;

  Decimal get percentageChange => ((currPrice - openPrice) / openPrice)
      .toDecimal(scaleOnInfinitePrecision: 2);

  Map<String, dynamic>? get extAttsAsMap {
    // extended attributes as dict
    return extAtts.isNotEmpty
        ? jsonDecode(extAtts) as Map<String, dynamic>?
        : null;
  }

  String valueExtractor(
    DbTableFieldName fldName, {
    String? compName,
  }) {
    /* header labels in list groups
    */
    switch (fldName) {
      case DbTableFieldName.assetName:
        return topName;
      case DbTableFieldName.assetShortName:
        return subName;
      case DbTableFieldName.assetOrgName:
        return orgNameWhenTradingPlayers;
      case DbTableFieldName.leagueGrouping:
        return leagueGrouping;

      case DbTableFieldName.competitionDate:
        return gameDateDtwStr;
      case DbTableFieldName.competitionTime:
        return competitionDate.timeOnly.asTimeOnlyStr;

      case DbTableFieldName.competitionLocation:
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
      case DbTableFieldName.basedOnEventDelimiters:
        return groupName ?? "";
      case DbTableFieldName.competitionName:
        return compName ?? "competitionName";
    }
  }

  Comparable sortValueExtractor(
    DbTableFieldName fldName, {
    String? compName,
  }) {
    /* comparible values used for the actual sort
    */
    switch (fldName) {
      case DbTableFieldName.assetName:
        return topName;
      case DbTableFieldName.assetShortName:
        return subName;
      case DbTableFieldName.assetOrgName:
        return orgNameWhenTradingPlayers;
      case DbTableFieldName.leagueGrouping:
        return leagueGrouping;

      case DbTableFieldName.competitionDate:
        return competitionDate.truncateTime;
      case DbTableFieldName.competitionTime:
        return competitionDate.timeOnly;

      case DbTableFieldName.competitionLocation:
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
      case DbTableFieldName.basedOnEventDelimiters:
        return groupName ?? "basedOnEventDelimiters";
      case DbTableFieldName.competitionName:
        return compName ?? "competitionName";
    }
  }
}
