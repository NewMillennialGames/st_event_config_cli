part of AppEntities;

@JsonEnum()
enum DbTableFieldName {
  assetName,
  assetShortName,
  assetOrgName,
  leagueGrouping,
  gameDate,
  gameTime,
  gameLocation,
  imageUrl,
  assetOpenPrice,
  assetCurrentPrice,
  assetRankOrScore,
  assetPosition,
  basedOnEventDelimiters, // aka tournament style (only for groupings)
}
