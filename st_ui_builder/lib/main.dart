import 'dart:convert';
import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
//
import 'package:st_ui_builder/st_ui_builder.dart';
import 'package:stclient/stclient.dart';

//
import 'package:st_ev_cfg/st_ev_cfg.dart';

//
import 'mock_data.dart';
/*
this is a Flutter project
but it's built as a dependency (ui builder factory) 
for Scoretrader & Chrysalis
It only renders UI of it's own (main.dart) for testing & validation
of the UI factory which renders builder functions for:
    Filter Bar and TableView (sorting, grouping & rowstyles)
*/

// demo example config data
const String cfgEmpl1 = 'assetVsAsset.json';
// cfgEmpl2 seems to be invalid json; replace it to continue testing
const String cfgEmpl2 = 'teamVsFieldRanked.json';
const String cfgEmpl3 = 'driverVsField.json';
const String cfgEmpl4 = 'demo2.json';

// evCfgDataFromServer contains the JSON payload produced by the CLI configurator
Map<String, dynamic> evCfgDataFromServer = {};

Future<void> readExampleEventConfig({String filename = cfgEmpl4}) async {
  final String response = await rootBundle.loadString('assets/$filename');
  evCfgDataFromServer = json.decode(response);
}

final _dynGameStateFamProv =
    StateProviderFamily<ActiveGameDetails, StKey>((ref, gameKey) {
  // doesnt really propogate state changes;  just a mock to get packages building
  return ActiveGameDetails(gameKey.value, DateTime.now());
});

final _redrawUiFlagProvider = StateProvider<bool>((ref) => false);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // pretend were loading Event from server
  await readExampleEventConfig();
  runApp(
    ProviderScope(
      overrides: [
        currEventProvider.overrideWithValue(Event()),
        tradeFlowProvider.overrideWithValue(TradeFlowForDemo()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(390, 844),
        builder: (BuildContext context, Widget? child) {
          return const Scoretrader();
        },
      ),
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
    // setState(() {});
    // flip this bool to force a redraw
    ref.read(_redrawUiFlagProvider.notifier).state =
        !ref.read(_redrawUiFlagProvider);
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
    // get TableView configurator from the UI Factory
    tvMgr = stBldr.groupedTvConfigForScreen(
      AppScreen.marketView,
      assetRows,
      _redrawCallback,
    );
    super.initState();
  }

  List<TableviewDataRowTuple> get assetRows => widget.assets
      .map(
        (e) => TableviewDataRowTuple(
          e,
          e,
          GameKey(e.asset.gameKey),
          _dynGameStateFamProv,
        ),
      )
      .toList();

  @override
  Widget build(BuildContext context) {
    bool hasColumnFilters = tvMgr.hasColumnFilters;
    ref.watch(_redrawUiFlagProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Market View w grouped-list & opt filter-bar',
        ),
      ),
      body: ListView(
        children: [
          if (hasColumnFilters) ...{
            tvMgr.columnFilterBarWidget(
              totAvailWidth: MediaQuery.of(context).size.width,
              backColor: StColors.primaryDarkGray,
            ),
            if (!tvMgr.disableAllGrouping && tvMgr.groupBy != null)
              SizedBox(
                height: 520.h,
                child: GroupedListView<TableviewDataRowTuple, GroupHeaderData>(
                  elements: tvMgr.listData,
                  groupBy: tvMgr.groupBy!,
                  groupHeaderBuilder: tvMgr.groupHeaderBuilder,
                  indexedItemBuilder: tvMgr.indexedItemBuilder,
                  sort: true,
                  useStickyGroupSeparators: true,
                  // next line should not be needed??
                  groupComparator: tvMgr.groupComparator,
                ),
              ),
            if (tvMgr.disableAllGrouping || tvMgr.groupBy == null)
              // TODO:  should return a normal listView;  not GroupedListView
              SizedBox(
                height: 520.h,
                child: null,
              )
          },
          Container(
            height: 30,
          ),
          DemoRow(
            label: "AssetVsAsset Row Market View",
            row: AssetVsAssetRowMktView(assetRows.first),
          ),
          DemoRow(
            label: "AssetVsAsset Row Ranked Market View",
            row: AssetVsAssetRowRankedMktView(assetRows.first),
          ),
          DemoRow(
            label: "TeamVsField Row Market View",
            row: TeamVsFieldRowMktView(assetRows.first),
          ),
          DemoRow(
            label: "TeamVsField Row Ranked Market View",
            row: TeamVsFieldRowRankedMktView(assetRows.first),
          ),
          DemoRow(
            label: "PlayerVsField Row Market View",
            row: PlayerVsFieldRowMktView(assetRows.first),
          ),
          DemoRow(
            label: "PlayerVsField Ranked Row Market View",
            row: PlayerVsFieldRankedRowMktView(assetRows.first),
          ),
          DemoRow(
            label: "DriverVsField Row Market View",
            row: DriverVsFieldRowMktView(assetRows.first),
          ),
          DemoRow(
            label: "TeamplayerVsField Row Market View",
            row: TeamPlayerVsFieldRowMktView(assetRows.first),
          ),
          DemoRow(
            label: "AssetVsAsset Row Market Research View",
            row: AssetVsAssetRowMktResearchView(assetRows.first),
          ),
          DemoRow(
            label: "AssetVsAssetRanked Row Market Research View",
            row: AssetVsAssetRowMktResearchView(assetRows.first),
          ),
          DemoRow(
            label: "TeamVsField Row Market Reasearch View",
            row: TeamVsFieldRowMktView(assetRows.first),
          ),
          DemoRow(
            label: "PlayerVsField Row Market Reasearch View",
            row: TeamVsFieldRowMktView(assetRows.first),
          ),
          DemoRow(
            label: "PlayerVsField Ranked Row Market Reasearch View",
            row: TeamVsFieldRowMktView(assetRows.first),
          ),
          DemoRow(
            label: "AssetVsAsset Row Portfolio View",
            row: AssetVsAssetRowPortfolioView(assetRows.first),
          ),
          DemoRow(
            label: "DriverVsField Row Portfolio View",
            row: DriverVsFieldRowPortfolio(assetRows.first),
          ),
          DemoRow(
            label: "TeamPlayerVsField Row Portfolio View",
            row: TeamPlayerVsFieldRowPortfolio(assetRows.first),
          ),
          DemoRow(
            label: "AssetVsAsset Row Portfolio History View",
            row: AssetVsAssetRowPortfolioHistory(assetRows.first),
          ),
          DemoRow(
            label: "DriverVsField Row Portfolio History View",
            row: DriverVsFieldRowPortfolioHistory(assetRows.first),
          ),
          DemoRow(
            label: "TeamPlayerVsField Row Portfolio History View",
            row: TeamPlayerVsFieldRowPortfolioHistory(assetRows.first),
          ),
          DemoRow(
            label: "AssetVsAsset Row Leaderboard View",
            row: AssetVsAssetRowLeaderBoardView(assetRows.first),
          ),
          DemoRow(
            label: "DriverVsField Row Leaderboard View",
            row: DriverVsFieldRowLeaderBoardView(assetRows.first),
          ),
          DemoRow(
            label: "TeamplayerVsField Row Leaderboard View",
            row: TeamPlayerVsFieldLeaderBoardView(assetRows.first),
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton(onPressed: _updateGameStatus),
      floatingActionButton:
          FloatingActionButton(onPressed: _toggleLoadedConfigAndRedraw),
    );
  }

  void _toggleLoadedConfigAndRedraw() {
    //
    bool redrawBool = ref.read(_redrawUiFlagProvider);
    readExampleEventConfig(filename: redrawBool ? cfgEmpl1 : cfgEmpl2).then(
      (_) {
        stBldr.setConfigForCurrentEvent(evCfgDataFromServer);
        tvMgr = stBldr.groupedTvConfigForScreen(
          AppScreen.marketView,
          assetRows,
          _redrawCallback,
        );
        _redrawCallback();
      },
    );
  }

  void _updateGameStatus() {
    //
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

class DemoRow extends StatelessWidget {
  final String label;
  final Widget row;
  const DemoRow({
    required this.label,
    required this.row,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          textAlign: TextAlign.center,
          style: StTextStyles.h4.copyWith(color: Colors.black),
        ),
        SizedBox(
          height: 15.h,
        ),
        row,
        SizedBox(
          height: 15.h,
        ),
      ],
    );
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
