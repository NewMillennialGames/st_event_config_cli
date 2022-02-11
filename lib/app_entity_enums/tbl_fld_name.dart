part of AppEntities;

@JsonEnum()
enum DbTableFieldName {
  teamName,
  playerName,
  conference,
  region,
  eventName,
  gameDate,
  gameLocation,
  imageUrl,
  assetOpenPrice,
  assetCurrentPrice,
  assetRank,
  assetPosition,
}

extension DbTableFieldNameExt1 on DbTableFieldName {
  //
  String get labelName {
    switch (this) {
      case DbTableFieldName.teamName:
        return 'Team';
      case DbTableFieldName.playerName:
        return 'Player';
      case DbTableFieldName.conference:
        return 'Conference';
      case DbTableFieldName.region:
        return 'Region';
      case DbTableFieldName.eventName:
        return 'Event Name';
      case DbTableFieldName.gameDate:
        return 'Date';
      case DbTableFieldName.gameLocation:
        return 'Location';
      case DbTableFieldName.imageUrl:
        return 'Avatar';
      case DbTableFieldName.assetOpenPrice:
        return 'Open Price';
      case DbTableFieldName.assetCurrentPrice:
        return 'Current Price';
      case DbTableFieldName.assetRank:
        return 'Rank';
      case DbTableFieldName.assetPosition:
        return 'Position';
    }
  }
}
