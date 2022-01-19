part of InputModels;

class FlutterQuestionFormatter {
  // TODO:  future
  // to render widget views of the question
  // move this class to the parent flutter project
}

class CliQuestionFormatter {
  // formatter for command-line IO
  CliQuestionFormatter();

  bool askSectionQuestionAndWaitForUserResponse(
    DialogRunner dialoger,
    DialogSectionCfg sectionCfg,
  ) {
    if (sectionCfg.appSection == AppSection.eventConfiguration) return true;

    return sectionCfg.askIfNeeded();
  }

  void askAndWaitForUserResponse(
    DialogRunner dialoger,
    Question quest,
  ) {
    _printQuestion(quest);
    _printOptions(quest);
    _printInstructions(quest);
    // now capture user answer

    bool validAnswerProvided = true;
    try {
      // bad user input or incomplete cast function can throw exception
      quest.askAndWait(dialoger);
    } catch (e) {
      validAnswerProvided = false;
      // just rethrow until error handling is implemented
      rethrow;
      // throw UnimplementedError('quest.askAndWait has thrown $e');
      //  try asking again x times?
      // while (true) {
      //   quest.askAndWait(dialoger);
      // }
    } finally {
      // code that should always execute; irrespective of the exception
      if (!validAnswerProvided) {
        // config may be corrupt??
      }
    }
  }

  void _printQuestion(Question quest) {
    // show the question
    print(quest.question);
  }

  void _printOptions(Question quest) {
    //
    if (!quest.hasChoices) return;

    print('Select from these options:\n');
    quest.choices?.forEachIndexed((idx, opt) {
      String forDflt =
          quest.defaultAnswerIdx == idx ? '  (default: just press return)' : '';
      print('\t$idx) $opt $forDflt');
    });
  }

  void _printInstructions(Question quest) {
    //
    if (quest.capturesScalarValues) {
      // user will enter string or comma delimited list of ints
    } else if (quest.addsOrDeletesFutureQuestions) {
      // causes questions to be added or removed from future queue
      // user may enter int or comma delimited list of ints
    } else if (quest.producesVisualRules) {
      // needs to produce visual formatting rules
      // user will select a widget display option
    } else if (quest.producesBehavioralRules) {
      // needs to produce behavioral rules
      // future;  not yet implemented
    }

    //
    if (quest.hasChoices) {
      if (quest.acceptsMultiResponses) {
        print('Enter row #s of choices (eg 2,3,5,) then press enter/return!');
      } else {
        print('Enter row # of preferred choice, then press enter/return!');
      }
    } else {
      print('Type your answer, then press enter/return!');
    }
  }
}
