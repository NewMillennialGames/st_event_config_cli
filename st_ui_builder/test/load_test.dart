import 'package:test/test.dart';

// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';

import 'package:st_ui_builder/st_ui_builder.dart';
import 'util.dart';

void main() {
  //
  late StUiBuilderFactory builderFactory;

  group('various methods on the ui factory', () {
    test('validate loading json', () async {
      //
      builderFactory = StUiBuilderFactory();
      Map<String, dynamic> eCfgJsonMap = await readJsonFile('assets/one.json');
      builderFactory.setConfigForCurrentEvent(eCfgJsonMap);
      expect(builderFactory.marketViewIsGameCentricAndTwoPerRow, true);
      expect(builderFactory.marketViewRowsAreSingleAssetOnly, false);
    });
    test('', () {});
    test('', () {});
  });
}
