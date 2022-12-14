import 'dart:math';
import 'package:decimal/decimal.dart';
import 'package:intl/intl.dart';
//
import 'package:st_ev_cfg/st_ev_cfg.dart';
import 'package:stclient/stclient.dart';
//
import 'ui_builder/all.dart';

/*
  creating fake data for testing
*/

// var d = DateTime.now();
DateTime _today = DateTime.now();

final days = <DateTime>[
  _today.subtract(Duration(days: 8)),
  _today.subtract(Duration(days: 5)),
  _today.subtract(Duration(days: 3))
];

DateTime getRandDate() {
  int idx = Random().nextInt(2);
  return days[idx];
}

final DateFormat dtFmtr = DateFormat('yyyy-MM-dd');

class MockAsset {
  // mock example of what comes from the server API
  String id = '333';
  String name;
  String region;
  String teamName;
  String imgUrl = 'https://ui-avatars.com/api/?name=John+Doe';
  DateTime? gameDt;

  // reall assets DO NOT have game key
  String gameKey;
  String displayNumber;

  // DateTime get gameDt => getRandDate(); // _today;

  String get key => id;

  String get extAtts => '';

  MockAsset(
    this.name,
    this.region,
    this.teamName,
    this.gameKey,
    this.displayNumber,
    // {this.gameDt = _today}
  ) {
    gameDt = getRandDate();
    imgUrl = 'https://ui-avatars.com/api/?$name';
  }

  static List<MockAssetWrapper> get mockRows =>
      _fakeData.map(MockAssetWrapper.new).toList();
}

class MockAssetWrapper implements AssetRowPropertyIfc {
  // example of what Natalia should create
  // should return properties from asset
  // that are required by AssetRowPropertyIfc
  MockAsset asset;

  MockAssetWrapper(
    this.asset,
  );

  void updateDynamicState(ActiveGameDetails agd) {
    //
  }

  @override
  DateTime get gameDate => asset.gameDt!;

  @override
  AssetKey get assetKey => AssetKey(asset.id);

  @override
  String get imgUrl => asset.imgUrl;

  @override
  String get location => 'Austin';

  @override
  String get position => 'p-Quarterback';

  @override
  int get rank => int.tryParse(asset.displayNumber) ?? 3;

  String get rankStr => '$rank';

  @override
  String get leagueGrouping => asset.region;

  @override
  String get subName => asset.teamName;

  @override
  String get topName => asset.name;

  @override
  String get liveStatsUrl => "https://google.com";

  @override
  String get marketResearchUrl => "https://google.com";

  @override
  String get groupKey => 'niu';

  @override
  bool get isTeam => true;

  @override
  AssetStateUpdates get assetStateUpdates =>
      AssetStateUpdates.fromAsset(Asset()); // throw UnimplementedError();

  @override
  AssetHoldingsSummaryIfc get assetHoldingsSummary => MockAssetHoldings();

  @override
  UserEventSummaryIfc get userEventSummary => MockEventSummary();

  @override
  // should be on the game
  String get roundName => throw UnimplementedError();

  @override
  CompetitionStatus get gameStatus => CompetitionStatus.compUninitialized;

  @override
  CompetitionType get gameType => CompetitionType.game;

  @override
  String get searchText =>
      (topName + '-' + subName + '-' + orgNameWhenTradingPlayers).toUpperCase();

  @override
  String get orgImgUrlWhenTradingPlayers => '';

  @override
  String get orgNameWhenTradingPlayers => asset.teamName;

  @override
  EvAssetNameDisplayStyle get assetNameDisplayStyle =>
      EvAssetNameDisplayStyle.showShortName;

  @override
  String get ticker => 'ticker';

  @override
  Decimal get openPrice => Decimal.parse('2.33');

  @override
  int get displayNumber => int.tryParse(asset.displayNumber) ?? 5;

  @override
  // extra properties
  String get extAtts => asset.extAtts;

  @override
  String? get groupName => null;
}

List<MockAsset> _fakeData = [
  MockAsset('Frankf Collin', 'Reg3', 'Dukes', '1', '4'),
  MockAsset('Gil', 'Reg2', 'Dukes', '2', '3'),
  MockAsset('Abe', 'Reg1', 'Cowboys', '3', '2'),
  MockAsset('David', 'Reg1', 'Cowboys', '4', '1'),
  MockAsset('Ed', 'Reg2', 'Redskins', '5', '5'),
  MockAsset('Frank', 'Reg2', 'Redskins', '6', '7'),
  MockAsset('Gil', 'Reg2', 'Redskins', '7', '2'),
  MockAsset('Bob', 'Reg1', 'Cowboys', '8', '2'),
  MockAsset('Hank', 'Reg2', 'Saints', '9', '2'),
  // MockAsset('Charlie', 'Reg1', 'Cowboys', '10'),
  // MockAsset('Ive', 'Reg2', 'Saints', '11'),
  // MockAsset('Hank', 'Reg3', 'Jeeps', '12'),
  // MockAsset('Jake', 'Reg2', 'Saints', '13'),
  // MockAsset('Ive', 'Reg3', 'Jeeps', '14'),
  // MockAsset('Jake', 'Reg3', 'Ford', '15'),
];

class MockAssetHoldings implements AssetHoldingsSummaryIfc {
  @override
  Decimal get positionCost => Decimal.fromInt(20);

  @override
  Decimal get positionEstValue => Decimal.fromInt(30);

  @override
  int get sharesOwned => 10;

  @override
  int get tokensAvail => 200;

  @override
  Order? get order => null;

  @override
  Decimal get currentAssetPrice => Decimal.fromInt(30);
}

class MockEventSummary implements UserEventSummaryIfc {
  @override
  int get currentPortfolioValue => 2000;

  @override
  String get eventKey => '';

  @override
  String get key => '';

  @override
  int get positionCount => 2;

  @override
  int get unrealizedGainLoss => 4;

  @override
  String get userID => '';
}
