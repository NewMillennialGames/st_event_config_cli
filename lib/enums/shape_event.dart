part of EvCfgEnums;

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
  // EvCompetitionStyle will tell you how they face-off each other
  team,
  teamPlayer, // aka player
  soloPlayer,
  other,
}

@JsonEnum()
enum EvOpponentType {
  sameAsCompetitorType,
  field,
  personalBest,
}

// enum EvStyling { sortKey, groupKey, bannerUrl, assetIconUrlTemplate }
