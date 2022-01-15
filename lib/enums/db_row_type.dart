part of EventCfgEnums;

enum DbRowType {
  /*
    describes the DB entity types
    that are traded or
    that property mapping applies to
  */
  asset,
  player, // aka Player
  team,
  game,
  competition,
  event,
}

extension DbRowTypeExt1 on DbRowType {
  //
  String get friendlyName => this.name;
}
