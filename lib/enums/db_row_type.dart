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
}
