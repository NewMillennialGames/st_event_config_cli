import 'dart:io';
import 'dart:core';
import 'package:args/args.dart';
//
import 'lib/questions/all.dart';
import 'lib/dialog/all.dart';
import 'lib/output_models/all.dart';
import 'lib/services/cli_quest_presenter.dart';
/*
  check ReadMe.MD
*/

const String DEBUG_LOAD_OPT = 'loadDebugData';
const String DEBUG_LOAD_FILENAME = 'one.json';
const String DEBUG_DUMP_ANSWERS = 'dumpAnswers';

late ArgResults argResults;

Future<void> main(List<String> cliArgs) async {
  exitCode = 0; // presume success

  final parser = setupOptions();
  argResults = parser.parse(cliArgs);
  // final paths = argResults.rest;

  // add empy lines befor starting dialog
  print('\n' * 0);

  // assert(false, 'should fail instantly');

  final cliQuestPresenter = CliQuestionPresenter();
  // using DI to make it easy for web app to use same dialog runner
  final dialoger = DialogRunner(cliQuestPresenter);

  bool inDebugMode = argResults.wasParsed(DEBUG_LOAD_OPT);
  if (inDebugMode) {
    String debugFileName = argResults[DEBUG_LOAD_OPT];
    dialoger.questionLstMgr.debugLoadFromFile(debugFileName);
  } else {
    final bool succeeded = dialoger.cliLoopUntilComplete();
    if (!succeeded) {
      exitCode = 2;
      print('Something went wrong!!');
    }

    if (argResults.wasParsed(DEBUG_DUMP_ANSWERS)) {
      dialoger.questionLstMgr.debugDumpToFile(argResults[DEBUG_DUMP_ANSWERS]);
    }
  }

  // now generate results into a config file
  createOutputFileFromResponses(dialoger.questionLstMgr, null);
  stdout.writeln("Done:\n");
}

void createOutputFileFromResponses(
  QuestListMgr questListMgr, [
  String? filename,
]) {
  //
  List<EventLevelCfgQuest> eventConfigLevelData =
      questListMgr.exportableTopLevelQuestions;
  List<VisualRuleDetailQuest> exportableRuleQuestions =
      questListMgr.exportableVisRuleQuestions.toList();

  print(
    'found ${eventConfigLevelData.length} event-cfg entries, and ${exportableRuleQuestions.length} rules to convert',
  );
  // for (QuestBase q in exportableRuleQuestions) {
  //   print(q.firstPrompt.userPrompt);
  //   Iterable<CaptureAndCast> cac = q.qPromptCollection.listResponseCasters;
  //   List<String> allAnsw = cac.fold<List<String>>([],
  //       ((List<String> accumLst, CaptureAndCast cac) {
  //     accumLst.add(cac.answer);
  //     return accumLst;
  //   }));
  //   print(allAnsw);
  //   print('\n\n');
  // }

  final evCfg = EventCfgTree.fromEventLevelConfig(eventConfigLevelData);
  // create the per-area or per-slot rules

  // print('ruleResponse answer count: ${exportableRuleQuestions.length}');
  assert(
    exportableRuleQuestions.length == exportableRuleQuestions.length,
    '???',
  );
  evCfg.fillFromVisualRuleAnswers(exportableRuleQuestions);
  // now dump evCfg to file
  evCfg.dumpCfgToFile(filename);

  evCfg.printSummary();
}

ArgParser setupOptions() {
  final parser = ArgParser();
  parser.addOption(
    DEBUG_DUMP_ANSWERS,
    abbr: 'd',
    defaultsTo: DEBUG_LOAD_FILENAME,
    help: 'pass -d to dump NEW answers to DEBUG_LOAD_FILENAME',
  );

  parser.addOption(
    DEBUG_LOAD_OPT,
    abbr: 'l',
    defaultsTo: DEBUG_LOAD_FILENAME,
    help:
        'pass -l plus filename to load existing (previously dumped) answers for testing',
  );
  return parser;
}
