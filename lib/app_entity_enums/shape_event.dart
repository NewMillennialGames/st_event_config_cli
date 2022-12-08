part of AppEntities;

// describe event at high level
@JsonEnum()
enum EvType {
  fantasy,
  standard,
  future,
  future_repriced,
}

@JsonEnum()
enum EvDuration {
  // cadence of competitions
  oneGame, // aka once
  tournament, // short period
  season, // long period
  ongoing, // unending
}

// type of gameplay
@JsonEnum()
enum EvEliminationStrategy {
  // how do you get promoted or eliminated
  singleGame,
  bestOfN,
  roundRobin,
  singleElim,
  doubeElim,
  audienceVote,
  never,
}

// define assets
@JsonEnum()
enum EvCompetitorType {
  // aka participant
  // EvCompetitionStyle will tell you how they face-off each other
  team,
  teamPlayer, // aka player & fantasy
  soloPlayer,
  other,
}

extension EvCompetitorTypeExt1 on EvCompetitorType {
  // temp code for Nascar
  bool get skipGroupingOnMarketView => this == EvCompetitorType.soloPlayer;
}

@JsonEnum()
enum EvOpponentType {
  sameAsCompetitorType,
  field,
  personalBest,
}

@JsonEnum()
enum EvGameAgeOffRule {
  /* governs behavior of the:
      Event Round Manager (ERM)
      ERM decides when to hide old games
      on the ST UI
  */
  whenRoundChanges, // via the competition stream
  everyWeek, // via the clock compared to game-end-dttm
  oneDayAfterEnds, // via the clock
  neverAgeOff,
  byEvEliminationStrategy, // see EvEliminationStrategy above
  startOfNextGame,
}

@JsonEnum()
enum EvAssetNameDisplayStyle {
  // in all app rows which respect this property
  showShortName,
  showLongName,
  showBothStacked,
}
