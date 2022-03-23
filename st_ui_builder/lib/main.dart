import 'dart:convert';
import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stclient/stclient.dart';
//
import 'package:st_ev_cfg/st_ev_cfg.dart';
//
import 'mock_data.dart';
import 'config/colors.dart';
import './ui_builder/all.dart';
/*
this is a Flutter project
but it's built as a dependency for 
Scoretrader
It only renders UI of it's own for testing
the UI factory   (Filter Bar and TableView)
*/

// demo example config data
const String cfgEmpl1 = 'blueRow.json';
const String cfgEmpl2 = 'greenRow.json';

Map<String, dynamic> evCfgDataFromServer = {};

Future<void> readExampleEventConfig({String filename = cfgEmpl1}) async {
  final String response = await rootBundle.loadString('assets/$filename');
  evCfgDataFromServer = json.decode(response);
}

final _dynGameStateFamProv =
    StateProviderFamily<ActiveGameDetails, String>((ref, gameKey) {
  // doesnt work;  just mock to get packages building
  return ActiveGameDetails(gameKey, DateTime.now());
});

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // pretend were loading Event from server
  await readExampleEventConfig();
  runApp(
    const ProviderScope(
      child: Scoretrader(),
    ),
  );
}

class Scoretrader extends StatelessWidget {
  //
  const Scoretrader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'St Tv Cfg Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MarketViewScreen(),
    );
  }
}

class MarketViewScreen extends ConsumerStatefulWidget {
  // real MarketViewScreen will get assets list & StUiBuilderFactory
  // via a Riverpod Provider

  final List<MockAssetWrapper> assets = MockAsset.mockRows;

  MarketViewScreen({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<MarketViewScreen> createState() => _MarketViewScreenState();
}

class _MarketViewScreenState extends ConsumerState<MarketViewScreen> {
  //
  final StUiBuilderFactory stBldr = StUiBuilderFactory();
  final Map<String, StateProvider<ActiveGameDetails>> _gameDetailsProviders =
      {};
  final List<String> gameKeys = [];
  //
  late GroupedTableDataMgr tvMgr;

  void _redrawCallback() {
    //
    setState(() {});
  }

  @override
  void initState() {
    // get event cfg data from api calls

    // call setConfigForCurrentEvent each time user changes current event
    stBldr.setConfigForCurrentEvent(evCfgDataFromServer);

    for (MockAssetWrapper a in widget.assets) {
      var gmkey = a.asset.gameKey;
      gameKeys.add(gmkey);
      _gameDetailsProviders[gmkey] = StateProvider<ActiveGameDetails>(
        (ref) {
          return ActiveGameDetails(
            gmkey,
            DateTime.now(),
            gameStatus: _getRandStatus(),
            roundName: _getRandRound(),
            regionOrConference: _getRandRegion(),
            location: 'location',
          );
        },
      );
    }
    // pretend asset data sent from server
    // and wrapped in Natalia's wrapper class
    // now use this data to construct the TableviewDataRowTuple
    // argument needed for the RowStyle constructors
    List<TableviewDataRowTuple> assetRows = widget.assets
        .map(
          (e) => TableviewDataRowTuple(
            e,
            e,
            e.asset.gameKey,
            _dynGameStateFamProv,
          ),
        )
        .toList();

    // get TableView configurator
    tvMgr = stBldr.tableviewConfigForScreen(
      AppScreen.marketView,
      assetRows,
      _redrawCallback,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Market View w grouped-list & opt filter-bar',
        ),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          if (tvMgr.hasColumnFilters)
            tvMgr.columnFilterBarWidget(
              backColor: StColors.primaryDarkGray,
            ),
          Container(
            height: 30,
          ),
          Container(
            height: 740,
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
            child: GroupedListView<TableviewDataRowTuple, GroupHeaderData>(
              elements: tvMgr.listData,
              groupBy: tvMgr.groupBy,
              groupHeaderBuilder: tvMgr.groupHeaderBuilder,
              indexedItemBuilder: tvMgr.indexedItemBuilder,
              sort: true,
              useStickyGroupSeparators: true,
              // next line should not be needed??
              // groupComparator: tvMgr.groupComparator,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: _updateGameStatus),
    );
  }

  void _updateGameStatus() {
    //
    //    => tvMgr.replaceGameStatusForRowRebuildTest(
    //   _getRandRound(),
    // ),
    int idx = Random().nextInt(gameKeys.length);
    String gKey = gameKeys[idx];
    var gd = ref.read(_gameDetailsProviders[gKey]!);

    var ci = CompetitionInfo(
      key: gKey,
      competitionStatus: _getRandStatus(),
      currentRoundName: _getRandRound(),
    );

    bool comp1IsOwned = Random().nextBool();
    bool comp2IsWatched = Random().nextBool();

    ref.read(_gameDetailsProviders[gKey]!.notifier).state =
        gd.copyFromGameUpdates(
      ci,
      // comp1IsOwned: comp1IsOwned,
      // comp2IsWatched: comp2IsWatched,
    );
  }

  String _getRandRound() {
    int idx = Random().nextInt(6);
    return rounds[idx];
  }

  CompetitionStatus _getRandStatus() {
    int idx = Random().nextInt(6);
    return CompetitionStatus.values[idx];
  }

  String _getRandRegion() {
    int idx = Random().nextInt(6);
    return rounds[idx];
  }
}

const rounds = <String>[
  'rOne',
  'rTwo',
  'rThree',
  'rFour',
  'rFive',
  'rSix',
];

        // child: Column(
        //   mainAxisAlignment: MainAxisAlignment.start,
        //   mainAxisSize: MainAxisSize.min,
        //   children: []