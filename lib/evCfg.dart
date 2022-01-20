import 'dart:io';
import 'dart:core';
import 'package:args/args.dart';
//
import 'dialog_cli/all.dart';
import 'services/cli_quest_presenter.dart';
/*
  check ReadMe.MD
*/

late ArgResults argResults;

Future<void> main(List<String> arguments) async {
  exitCode = 0; // presume success

  final parser = setupOptions();
  argResults = parser.parse(arguments);
  final paths = argResults.rest;
  // final cmd = paths[0] ?? login;

//   if (argResults['help']) {
//     print("""
// ** HELP **
// ${parser.usage}
//     """);
//     return Void;
//   }

  // add clear lines
  print('\n' * 0);

  final cliQuestPresenter = CliQuestionPresenter();
  // using DI to make it easy for web app to use same runner
  final dialoger = DialogRunner(cliQuestPresenter);
  final succeeded = dialoger.loopUntilComplete();

  stdout.writeln("Done:\n");
  // stdout.writeln("$res");

  if (!succeeded) {
    exitCode = 2;
  }
}

ArgParser setupOptions() {
  final parser = ArgParser()
    ..addFlag('create', abbr: 'c', help: 'pass -c to create new user')
    ..addFlag('withprospect', abbr: 'p', help: 'pass -p to add a prospect')
    ..addFlag('data', abbr: 'd', help: 'pass -d to add data to prospect');
  // ..addOption('help', abbr: 'h');

  parser.addOption('email',
      abbr: 'e',
      defaultsTo: 'dg100@pathoz.com',
      help: 'pass -e to set user email');
  parser.addOption(
    'pw',
    abbr: 'w',
    defaultsTo: '123456',
    help: 'pass -w to set user pw',
  );
  return parser;
}
