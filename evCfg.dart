import 'dart:io';
import 'dart:core';
import 'package:args/args.dart';
//
// import 'lib/scoretrader/all.dart';
// import 'lib/questions/all.dart';
import 'lib/r_and_d/all.dart';
import 'lib/dialog/all.dart';
import 'lib/output_models/all.dart';
import 'lib/services/cli_quest_presenter.dart';
/*
  check ReadMe.MD
*/

late ArgResults argResults;

Future<void> main(List<String> arguments) async {
  exitCode = 0; // presume success

  // final parser = setupOptions();
  // argResults = parser.parse(arguments);
  // final paths = argResults.rest;

  // add empy lines befor starting dialog
  print('\n' * 0);

  final cliQuestPresenter = CliQuest2Presenter();
  // using DI to make it easy for web app to use same dialog runner
  final dialoger = DialogRunner(cliQuestPresenter);
  final succeeded = dialoger.cliLoopUntilComplete();
  if (!succeeded) {
    exitCode = 2;
    print('Something went wrong!!');
  }

  // now generate results into a config file
  createOutputFileFromResponses(dialoger.Quest2Mgr, null);
  stdout.writeln("Done:\n");
}

void createOutputFileFromResponses(
  QuestListMgr Quest2Mgr, [
  String? filename,
]) {
  //
  final List<QuestBase> exportableQuest2s = Quest2Mgr.exportableQuest2s;

  print('found ${exportableQuest2s.length} exportable answers to convert');
  // for (Quest2 q in exportableQuest2s) {
  //   print(q.questStr);
  //   print(q.response?.answers.toString());
  //   print('\n\n');
  // }

  print('Now building Event Config rules...');

  Iterable<QuestBase> eventConfigLevelData = exportableQuest2s.where(
    (q) => q.isTopLevelConfigOrScreenQuest2,
  );
  final evCfg = EventCfgTree.fromEventLevelConfig(eventConfigLevelData);
  // create the per-area or per-slot rules
  var ruleResponses = exportableQuest2s.whereType<Quest1Prompt>();
  // print('ruleResponse answer count: ${ruleResponses.length}');
  evCfg.fillFromVisualRuleAnswers(ruleResponses);
  // now dump evCfg to file
  evCfg.dumpCfgToFile(filename);
}

// ArgParser setupOptions() {
//   final parser = ArgParser()
//     ..addFlag('create', abbr: 'c', help: 'pass -c to create new user')
//     ..addFlag('withprospect', abbr: 'p', help: 'pass -p to add a prospect')
//     ..addFlag('data', abbr: 'd', help: 'pass -d to add data to prospect');
//   // ..addOption('help', abbr: 'h');

//   parser.addOption('email',
//       abbr: 'e',
//       defaultsTo: 'dg100@pathoz.com',
//       help: 'pass -e to set user email');
//   parser.addOption(
//     'pw',
//     abbr: 'w',
//     defaultsTo: '123456',
//     help: 'pass -w to set user pw',
//   );
//   return parser;
// }
