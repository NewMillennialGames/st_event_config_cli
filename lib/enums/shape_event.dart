part of EventCfgEnums;

// describe event at high level
enum EvType {
  fantasy,
  standard,
}

enum EvDuration {
  // cadence of competitions
  oneGame, // aka once
  tournament, // short period
  season, // long period
  ongoing, // unending
}

// type of gameplay
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
enum EvCompetitorType {
  // EvCompetitionStyle will tell you how they face-off each other
  team,
  teamPlayer, // aka player
  soloPlayer,
  other,
}

enum EvOpponentType {
  sameAsCompetitorType,
  field,
  personalBest,
}

// enum EvStyling { sortKey, groupKey, bannerUrl, assetIconUrlTemplate }
