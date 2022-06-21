part of AppEntities;

// describe event at high level
@JsonEnum()
enum EvType {
  fantasy,
  standard,
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
enum EvAgeOffGameRule {
  whenRoundChanges,
  everyWeek,
  oneDayAfterEnds,
  byEvEliminationStrategy,
}

// enum EvStyling { sortKey, groupKey, bannerUrl, assetIconUrlTemplate }
