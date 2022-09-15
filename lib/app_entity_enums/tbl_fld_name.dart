part of AppEntities;

@JsonEnum()
enum DbTableFieldName {
  assetName,
  assetShortName,
  assetOrgName,
  conference,
  region,
  // this is an error;  we dont have event name on assets
  // eventName,
  gameDate,
  gameTime,
  gameLocation,
  imageUrl,
  assetOpenPrice,
  assetCurrentPrice,
  assetRankOrScore,
  assetPosition,
}
