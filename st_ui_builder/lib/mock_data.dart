import 'package:intl/intl.dart';
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

  DateTime get gameDt => _today;

  MockAsset(
    this.name,
    this.region,
    this.teamName,
    // this.imgUrl,
  );

  static List<MockAssetWrapper> get mockRows => _fakeData
      .map(
        (e) => MockAssetWrapper(
          e,
          ActiveGameDetails.mock(),
        ),
      )
      .toList();
}

class MockAssetWrapper implements AssetRowPropertyIfc {
  // example of what Natalia should create
  // should return properties from asset
  // that are required by AssetRowPropertyIfc
  MockAsset asset;
  ActiveGameDetails gameStatus;

  MockAssetWrapper(
    this.asset,
    this.gameStatus,
  );

  @override
  DateTime get gameDate => asset.gameDt;

  @override
  String get gameDateStr => dtFmtr.format(gameDate);

  @override
  DateTime get gameTime => asset.gameDt;

  @override
  String get gameTimeStr => dtFmtr.format(gameTime);

  @override
  String get id => asset.id;

  @override
  String get imgUrl => asset.imgUrl;

  @override
  String get location => 'Austin';

  String get position => 'p-Quarterback';

  @override
  double get price => 4.33;

  @override
  double get priceDelta => -0.25;

  @override
  String get priceDeltaStr => '$priceDelta';

  @override
  String get priceStr => '\$$price';

  @override
  int get rank => 3;

  @override
  String get rankStr => '$rank';

  @override
  String get regionOrConference => asset.region;

  @override
  String get subName => asset.teamName;

  @override
  String get topName => asset.name;

  @override
  String get groupKey => 'niu';

  @override
  bool get isTeam => throw UnimplementedError();

  @override
  String get roundName => gameStatus.roundName;
}

List<MockAsset> _fakeData = [
  MockAsset('Frank', 'Reg3', 'Dukes'),
  MockAsset('Gil', 'Reg2', 'Dukes'),
  MockAsset('Abe', 'Reg1', 'Cowboys'),
  MockAsset('David', 'Reg1', 'N. England'),
  MockAsset('Ed', 'Reg2', 'Redskins'),
  MockAsset('Frank', 'Reg2', 'Redskins'),
  MockAsset('Gil', 'Reg2', 'Redskins'),
  MockAsset('Bob', 'Reg1', 'Cowboys'),
  MockAsset('Hank', 'Reg2', 'Saints'),
  MockAsset('Charlie', 'Reg1', 'Cowboys'),
  MockAsset('Ive', 'Reg2', 'Saints'),
  MockAsset('Hank', 'Reg3', 'Jeeps'),
  MockAsset('Jake', 'Reg2', 'Saints'),
  MockAsset('Ive', 'Reg3', 'Jeeps'),
  MockAsset('Jake', 'Reg3', 'Ford'),
];
