import 'dart:io';
import 'dart:core';
import 'package:args/args.dart';
import 'package:eventconfig/app_entity_enums/all.dart';
//
import 'dialog/all.dart';
import 'input_models/all.dart';
import 'output_models/all.dart';
import 'services/cli_quest_presenter.dart';
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

  final cliQuestPresenter = CliQuestionPresenter();
  // using DI to make it easy for web app to use same dialog runner
  final dialoger = DialogRunner(cliQuestPresenter);
  final succeeded = dialoger.loopUntilComplete();

  // now generate results into a config file
  createOutputFileFromResponses(dialoger.questionMgr, null);

  stdout.writeln("Done:\n");
  // stdout.writeln("$res");

  if (!succeeded) {
    exitCode = 2;
  }
}

void createOutputFileFromResponses(QuestListMgr questionMgr,
    [String? filename]) {
  //
  final List<Question> exportableQuestions = questionMgr.exportableQuestions;

  for (Question q in exportableQuestions) {
    print(q.questStr);
    print(q.response?.answers.toString());
    print('\n\n');
  }

  var eventConfigLevelAnswers = exportableQuestions.whereType<Question>().where(
        (q) => q.appScreen == AppScreen.eventConfiguration,
      );
  final evCfg = EventCfgTree.fromEventLevelConfig(eventConfigLevelAnswers);
  // create the per-area or per-slotArea rules
  evCfg.fillFromRuleAnswers(
    exportableQuestions.whereType<VisualRuleQuestion>(),
  );
  // now dump evCfg to file
  evCfg.dump(filename);
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
