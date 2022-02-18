import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grouped_list/grouped_list.dart';
import 'dart:convert';
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

Map<String, dynamic> evCfgDataFromServer = {};

Future<void> readExampleEventConfig({String filename = 'three.json'}) async {
  final String response = await rootBundle.loadString('assets/$filename');
  evCfgDataFromServer = await json.decode(response);
}

void main() async {
  // pretend were loading Event from server
  await readExampleEventConfig();
  runApp(const Scoretrader());
}

class Scoretrader extends StatelessWidget {
  //
  const Scoretrader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<MockAssetWrapper> assetRows = MockAsset.mockRows;
    return MaterialApp(
      title: 'St Tv Cfg Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MarketViewScreen(assetRows),
    );
  }
}

class MarketViewScreen extends StatefulWidget {
  // real MarketViewScreen will get assets list & StUiBuilderFactory
  // via a Riverpod Provider
  final StUiBuilderFactory stBldr = StUiBuilderFactory();
  final List<MockAssetWrapper> assets;

  MarketViewScreen(
    this.assets, {
    Key? key,
  }) : super(key: key);

  @override
  State<MarketViewScreen> createState() => _MarketViewScreenState();
}

class _MarketViewScreenState extends State<MarketViewScreen> {
  //
  late GroupedTableDataMgr tvMgr;

  @override
  void initState() {
    // get event cfg data from api calls

    // call setConfigForCurrentEvent each time user changes current event
    widget.stBldr.setConfigForCurrentEvent(evCfgDataFromServer);
    // pretend asset data sent from server
    // and wrapped in Natalia's wrapper class
    // now use this data to construct the TableviewDataRowTuple
    // argument needed for the RowStyle constructors
    List<TableviewDataRowTuple> assetRows = widget.assets
        .map((e) => TableviewDataRowTuple(e, null, 'test data'))
        .toList();

    // get TableView configurator
    tvMgr = widget.stBldr.tableviewConfigForScreen(
      AppScreen.marketView,
      assetRows,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Market View')),
      body: Container(
        padding: const EdgeInsets.only(top: 30),
        child: GroupedListView<TableviewDataRowTuple, GroupHeaderData>(
          elements: tvMgr.listData,
          groupBy: tvMgr.groupBy,
          groupHeaderBuilder: tvMgr.groupHeaderBuilder,
          indexedItemBuilder: tvMgr.indexedItemBuilder,
          sort: true,
        ),
      ),
    );
  }
}
