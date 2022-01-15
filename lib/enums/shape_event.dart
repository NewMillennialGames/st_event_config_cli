part of EventCfgEnums;

// describe event at high level
enum EvType {
  fantasy,
  standard,
}

enum EvDuration {
  // cadence of competitions
  game, // aka once
  tournament, // short period
  season, // long period
  ongoing, // unending
}

// type of gameplay
enum EvCompetitionType {
  // how do you get promoted or eliminated
  singleGame,
  bestOfN,
  roundRobin,
  singleElim,
  doubeElim,
  general,
}

// define assets
enum EvCompetitorType {
  // EvCompetitionStyle will tell you how they face-off each other
  team,
  teamMember, // aka player
  solo,
  other,
}

// enum EvStyling { sortKey, groupKey, bannerUrl, assetIconUrlTemplate }
