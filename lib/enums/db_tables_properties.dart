part of EventCfgEnums;

enum DbRowType {
  /*
    describes the Server DB entity types
    that are traded or
    that property mapping applies to
  */
  asset,
  player,
  team,
  game,
  competition,
  event,
}

extension DbRowTypeExt1 on DbRowType {
  //
  String get friendlyName => this.name;

  List<RowTypeColNames> get associatedProperties {
    switch (this) {
      case DbRowType.asset:
        return [RowTypeColNames.openPrice, RowTypeColNames.currentPrice];
      case DbRowType.player:
        return [RowTypeColNames.name, RowTypeColNames.url];
      case DbRowType.team:
        return [RowTypeColNames.name, RowTypeColNames.url];
      case DbRowType.game:
        return [RowTypeColNames.name, RowTypeColNames.url];
      case DbRowType.competition:
        return [RowTypeColNames.name, RowTypeColNames.url];
      case DbRowType.event:
        return [RowTypeColNames.name, RowTypeColNames.url];
    }
  }
}

enum RowTypeColNames {
  name,
  openPrice,
  currentPrice,
  url,
  // title,
}
