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

extension DbTableFieldNameExt1 on DbTableFieldName {
  //
  String get labelName {
    switch (this) {
      case DbTableFieldName.assetName:
        return 'Team/Player';
      case DbTableFieldName.assetShortName:
        return 'Team/Player';
      case DbTableFieldName.assetOrgName:
        return 'Org';
      case DbTableFieldName.conference:
        return 'Conference';
      case DbTableFieldName.region:
        return 'All Regions';
      // case DbTableFieldName.eventName:
      //   return 'Event Name';
      case DbTableFieldName.gameDate:
        return 'All Dates';
      case DbTableFieldName.gameTime:
        return 'Game Time';
      case DbTableFieldName.gameLocation:
        return 'Location';
      case DbTableFieldName.imageUrl:
        return 'Avatar (select this to hide filter bar)';
      case DbTableFieldName.assetOpenPrice:
        return 'Open Price';
      case DbTableFieldName.assetCurrentPrice:
        return 'Current Price';
      case DbTableFieldName.assetRankOrScore:
        return 'Rank';
      case DbTableFieldName.assetPosition:
        return 'Position';
    }
  }
}
