part of CfgInputModels;

class FlutterQuestionFormatter {
  // TODO:  future
  // to render widget views of the question
  // move this class to the parent flutter project
}

class CliQuestionFormatter {
  // formatter for command-line IO
  CliQuestionFormatter();

  void askAndWaitForUserResponse(
    Dialoger dialoger,
    Question quest,
  ) {
    _printQuestion(quest);
    _printOptions(quest);
    _printInstructions(quest);
    // now capture user answer
    quest.askAndWait(dialoger);
  }

  void _printQuestion(Question quest) {
    // show the question
    print(quest.question);
  }

  void _printOptions(Question quest) {
    //
    if ((quest.choices?.length ?? 0) < 1) return;

    print('Select from these options:\n');
    quest.choices?.forEachIndexed((idx, opt) {
      print('\t$idx) $opt');
    });
  }

  void _printInstructions(Question quest) {
    if ((quest.choices?.length ?? 0) < 1) {
      //
      print('Type your answer, then press enter/return!');
    } else {
      print('Enter row # of preferred choice, then press enter/return!');
    }
  }
}
