import 'package:grouped_list/sliver_grouped_list.dart';
import 'package:st_ev_cfg/st_ev_cfg.dart';
import 'package:test/test.dart';

// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';

import 'package:st_ui_builder/st_ui_builder.dart';
import 'util.dart';

void main() {
  //
  late StUiBuilderFactory builderFactory;

  group('various methods on the ui factory', () {
    test('validate loading json succeds to build factory', () async {
      //
      builderFactory = await loadFactory('assets/test.json');
      expect(builderFactory.marketViewIsGameCentricAndTwoPerRow, true);
      expect(builderFactory.marketViewRowsAreSingleAssetOnly, false);
    });
    test('confirm list view config settings', () async {
      //
      builderFactory = await loadFactory('assets/test.json');
      TableRowDataMgr trdm = builderFactory.listTvConfigForScreen(
        AppScreen.marketView,
        [],
        () {},
      );
      expect(
        trdm.rowStyle,
        TvAreaRowStyle.driverVsField,
        reason: 'json specifies driverVsField',
      );
      expect(
        trdm.filterRules?.disableFiltering ?? true,
        false,
        reason: 'json HAS filtering rules',
      );
      expect(
        trdm.filterRules?.item1.colName,
        DbTableFieldName.assetName,
        reason: 'json specifies 1 filter menu on assetName',
      );
      expect(
        trdm.groupingRules?.item1.colName,
        DbTableFieldName.assetOrgName,
        reason: 'json specifies grouping on 2 fields; first is assetOrgName',
      );
      expect(
        trdm.groupingRules?.item2?.colName,
        DbTableFieldName.conference,
        reason: 'json specifies grouping on 2 fields; 2nd is conference',
      );
    });
    test('', () async {
      //
      builderFactory = await loadFactory('assets/test.json');
    });
  });
}

Future<StUiBuilderFactory> loadFactory(String filePath) async {
  //
  var builderFactory = StUiBuilderFactory();
  Map<String, dynamic> eCfgJsonMap = await readJsonFile(filePath);
  builderFactory.setConfigForCurrentEvent(eCfgJsonMap);
  return builderFactory;
}
