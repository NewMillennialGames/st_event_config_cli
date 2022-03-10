import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
//
import 'package:st_ev_cfg/st_ev_cfg.dart';
//
import 'mock_data.dart';
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

class MarketViewScreen extends StatefulWidget {
  // real MarketViewScreen will get assets list & StUiBuilderFactory
  // via a Riverpod Provider

  final List<MockAssetWrapper> assets = MockAsset.mockRows;

  MarketViewScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<MarketViewScreen> createState() => _MarketViewScreenState();
}

class _MarketViewScreenState extends State<MarketViewScreen> {
  //
  final StUiBuilderFactory stBldr = StUiBuilderFactory();
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
    // pretend asset data sent from server
    // and wrapped in Natalia's wrapper class
    // now use this data to construct the TableviewDataRowTuple
    // argument needed for the RowStyle constructors
    List<TableviewDataRowTuple> assetRows = widget.assets
        .map(
          (e) => TableviewDataRowTuple(e, e, ActiveGameDetails.mock()),
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
          if (tvMgr.hasColumnFilters) tvMgr.columnFilterBarWidget(),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => tvMgr.replaceGameStatusForRowRebuildTest(
          _getRandRound(),
        ),
      ),
    );
  }

  String _getRandRound() {
    var rounds = <String>[
      'rOne',
      'rTwo',
      'rThree',
      'rFour',
      'rFive',
      'rSix',
    ];
    int idx = Random().nextInt(5);
    return rounds[idx];
  }
}


        // child: Column(
        //   mainAxisAlignment: MainAxisAlignment.start,
        //   mainAxisSize: MainAxisSize.min,
        //   children: []