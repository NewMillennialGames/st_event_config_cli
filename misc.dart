


// enum EvDataSource {
//   manual,
//   externalApi,
//   scraper,
// }

// enum EvCurrency {
//   oneOff,
//   convertible,
//   redeemable,
// }


// // constituent type
// struct EvTournamentConfig {
// 	final EvTourneyType tournamentType
// 	final EvTourneyCompetition competitionType
// 	final EvTourneySize size
// 	final int totalGameCount
// 	final int completedGameCount
// }



// // constituent type
// struct EvDataSourceConfig {
// 	final EvDataSource dataSource
// 	final String baseUrl
// 	final String key
// 	final Object loadScheduler
// }

// struct EvStateTransitionConfig {
// 	// TODO
// }


// struct EvStatePattern {
// 	final EvTournamentConfig tournamentConfig;
// 	final EvDataSourceConfig dataSourceCfg;
// 	final EvStateTransitionConfig stateTransitionConfig;
	
// }

// struct EventConfig {
// 	//
// 	final EvStatePattern statePattern
// 	final EvCurrency currency
// 	final EvStyling styling
// }
// 	- Event Cadence
// 		- One game (eg Cotton Bowl)
// 		- One Tournament (eg March Madness)
// 		- One Season (NFL)
// 	- Event Competion
// 		- Team vs Team
// 		- Player vs Player
// 		- Player vs Field
// 	- Event Currency
// 		- One-off (win or balance evaporates)
// 		- Convertible (can exchange your remaining balance for other events)
// 		- Redeemable (Primary ST currency that can be used to purchase merchandise, or convert back to cash)
// 	- Event Styling and Display
// 		- Sorting Key
// 		- Grouping Key
// 		- Event Banner
// 		- Competition Left and Right icon (eg teams or players)
// 	- Event Data Source & State Transition Pattern
// 		- Manual Input
// 		- Via API Triggers
// 			- API #1
// 			- API #2
// 		- Random (will we be running any Vegas style games of chance)