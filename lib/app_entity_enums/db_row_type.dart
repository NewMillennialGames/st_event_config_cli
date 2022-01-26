part of AppEntities;

@JsonEnum()
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

  List<RowPropertylName> get associatedProperties {
    switch (this) {
      case DbRowType.asset:
        return [RowPropertylName.openPrice, RowPropertylName.currentPrice];
      case DbRowType.player:
        return [RowPropertylName.name, RowPropertylName.url];
      case DbRowType.team:
        return [RowPropertylName.name, RowPropertylName.url];
      case DbRowType.game:
        return [RowPropertylName.name, RowPropertylName.url];
      case DbRowType.competition:
        return [RowPropertylName.name, RowPropertylName.url];
      case DbRowType.event:
        return [RowPropertylName.name, RowPropertylName.url];
    }
  }
}
