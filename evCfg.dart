import 'dart:io';
import 'dart:core';
import 'package:args/args.dart';
import 'package:logging/logging.dart';
import 'package:st_ev_cfg/util/config_logger.dart';
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
  Logger.root.level = Level.WARNING; // defaults to Level.INFO
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.message}');
  });

  exitCode = 0; // presume success

  final parser = setupOptions();
  argResults = parser.parse(cliArgs);
  // final paths = argResults.rest;

  // add empy lines befor starting dialog
  ConfigLogger.log(Level.WARNING, '\n' * 0);

  // assert(false, 'should fail instantly');

  final cliQuestPresenter = CliQuestionPresenter();
  // using DI to make it easy for web app to use same dialog runner
  final dialoger = DialogRunner(cliQuestPresenter);

  bool inDebugMode = argResults.wasParsed(DEBUG_LOAD_OPT);
  if (inDebugMode) {
    // dump a file to help debug
    String debugFileName = argResults[DEBUG_LOAD_OPT];
    dialoger.questionLstMgr.debugLoadFromFile(debugFileName);
  } else {
    final bool succeeded = dialoger.cliLoopUntilComplete();
    if (!succeeded) {
      exitCode = 2;
      ConfigLogger.log(Level.WARNING, 'Something went wrong!!');
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

  ConfigLogger.log(
    Level.INFO,
    'found ${eventConfigLevelData.length} event-cfg entries, and ${exportableRuleQuestions.length} rules to convert',
  );
  // for (QuestBase q in exportableRuleQuestions) {
  //   ConfigLogger.log(Level.FINER, q.firstPrompt.userPrompt);
  //   Iterable<CaptureAndCast> cac = q.qPromptCollection.listResponseCasters;
  //   List<String> allAnsw = cac.fold<List<String>>([],
  //       ((List<String> accumLst, CaptureAndCast cac) {
  //     accumLst.add(cac.answer);
  //     return accumLst;
  //   }));
  //   ConfigLogger.log(Level.FINER, allAnsw);
  //  ConfigLogger.log(Level.FINER, '\n\n');
  // }

  final evCfg = EventCfgTree.fromEventLevelConfig(eventConfigLevelData);
  // create the per-area or per-slot rules

  //ConfigLogger.log(Level.FINER, 'ruleResponse answer count: ${exportableRuleQuestions.length}');
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
