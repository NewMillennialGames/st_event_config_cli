import 'package:intl/intl.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
//
import 'package:stclient/stclient.dart';
//
import 'ui_builder/all.dart';

/*
  creating fake data for testing
*/

final _today = DateTime.now();

final DateFormat dtFmtr = DateFormat('yyyy-MM-dd');

class MockAsset {
  // mock example of what comes from the server API
  String id = '333';
  String name;
  String region;
  String teamName;
  String imgUrl = 'https://ui-avatars.com/api/?name=John+Doe';
  String displayNumer;
  // reall assets DO NOT have game key
  String gameKey;

  DateTime get gameDt => _today;
  String get key => id;

  MockAsset(
      this.name, this.region, this.teamName, this.gameKey, this.displayNumer);

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
  DateTime get gameDate => asset.gameDt;

  @override
  AssetKey get assetKey => AssetKey(asset.id);

  @override
  String get imgUrl => asset.imgUrl;

  @override
  String get location => 'Austin';

  @override
  String get position => 'p-Quarterback';

  @override
  int get rank => 3;
  String get rankStr => '$rank';

  @override
  String get regionOrConference => asset.region;

  @override
  String get subName => asset.teamName;

  @override
  String get topName => asset.name;

  @override
  String get displayNumer => asset.displayNumer;
  @override
  String get groupKey => 'niu';

  @override
  bool get isTeam => throw UnimplementedError();

  @override
  AssetStateUpdates get assetStateUpdates =>
      AssetStateUpdates.fromAsset(Asset()); // throw UnimplementedError();

  @override
  AssetHoldingsSummaryIfc get assetHoldingsSummary =>
      throw UnimplementedError();

  @override
  // should be on the game
  String get roundName => throw UnimplementedError();

  @override
  CompetitionStatus get gameStatus => CompetitionStatus.compUninitialized;

  @override
  CompetitionType get gameType => CompetitionType.game;

  @override
  String get searchText =>
      (topName + '-' + subName + '-' + teamNameWhenTradingPlayers)
          .toUpperCase();

  @override
  String get teamImgUrlWhenTradingPlayers => '';

  @override
  String get teamNameWhenTradingPlayers => '';

  @override
  String get ticker => 'ticker';

  @override
  double get openPrice => 2.33;
}

List<MockAsset> _fakeData = [
  MockAsset('Frankf Collin', 'Reg3', 'Dukes', '1', '3'),
  MockAsset('Gil', 'Reg2', 'Dukes', '2', '9'),
  MockAsset('Abe', 'Reg1', 'Cowboys', '3', '4'),
  MockAsset('David', 'Reg1', 'N. England', '4', '6'),
  MockAsset('Ed', 'Reg2', 'Redskins', '5', '7'),
  MockAsset('Frank', 'Reg2', 'Redskins', '6', '8'),
  // MockAsset('Gil', 'Reg2', 'Redskins', '7'),
  // MockAsset('Bob', 'Reg1', 'Cowboys', '8'),
  // MockAsset('Hank', 'Reg2', 'Saints', '9'),
  // MockAsset('Charlie', 'Reg1', 'Cowboys', '10'),
  // MockAsset('Ive', 'Reg2', 'Saints', '11'),
  // MockAsset('Hank', 'Reg3', 'Jeeps', '12'),
  // MockAsset('Jake', 'Reg2', 'Saints', '13'),
  // MockAsset('Ive', 'Reg3', 'Jeeps', '14'),
  // MockAsset('Jake', 'Reg3', 'Ford', '15'),
];
