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
      builderFactory = await loadFactory('assets/driverVsField.json');
      // marketViewIsGameCentricAndTwoPerRow would not normally be true for driverVsField
      // but we created this test JSON by editing assetVsAsset so below is correct
      expect(builderFactory.marketViewIsGameCentricAndTwoPerRow, true);
      expect(builderFactory.marketViewRowsAreSingleAssetOnly, false);
    });
    test('confirm list view config settings', () async {
      //
      builderFactory = await loadFactory('assets/driverVsField.json');
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
        trdm.filterRules?.item1?.colName,
        DbTableFieldName.assetName,
        reason: 'json specifies 1 filter menu on assetName',
      );
      expect(
        trdm.groupingRules?.item1?.colName,
        DbTableFieldName.assetOrgName,
        reason: 'json specifies grouping on 2 fields; first is assetOrgName',
      );
      expect(
        trdm.groupingRules?.item2?.colName,
        DbTableFieldName.conference,
        reason: 'json specifies grouping on 2 fields; 2nd is conference',
      );
    });
    test(
      'empty placeholder for future test (currently skipped)',
      () async {
        //
        builderFactory = await loadFactory('assets/driverVsField.json');
      },
      skip: true,
    );
  });
}

Future<StUiBuilderFactory> loadFactory(String filePath) async {
  //
  var builderFactory = StUiBuilderFactory();
  Map<String, dynamic> eCfgJsonMap = await readJsonFile(filePath);
  builderFactory.setConfigForCurrentEvent(eCfgJsonMap);
  return builderFactory;
}
