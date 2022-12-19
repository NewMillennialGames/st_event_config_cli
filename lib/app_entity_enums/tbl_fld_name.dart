part of AppEntities;

@JsonEnum()
enum DbTableFieldName {
  assetName,
  assetShortName,
  assetOrgName,
  leagueGrouping,
  competitionDate,
  competitionTime,
  competitionLocation,
  competitionName,
  imageUrl,
  assetOpenPrice,
  assetCurrentPrice,
  assetRankOrScore,
  assetPosition,
  basedOnEventDelimiters, // aka tournament style (only for groupings)
}
