part of ConfigDialog;

class Dialoger {
  //
  final DialogTree _tree = DialogTree();

  Dialoger() {
    _tree.loadDialog();
  }

  List<UserResponse> _getPriorAnswerCallback() {
    // used when a question needs to review prior
    // answers to configure itself
    return _tree.priorAnswers;
  }

  //
  String loopUntilComplete() {
    //
    DialogSectionCfg? section = _tree._getNextSection();
    while (section != null) {
      //
      bool doSection = section.askIfNeeded();
      if (doSection) {
        Question? _quest = section.getNextQuestion();
        while (_quest != null) {
          // UserResponse answer = _quest.askAndWait();
          // _tree._collectAnswer(answer);
          _quest.askAndWait(_getPriorAnswerCallback);
          _quest = section.getNextQuestion();
        }
      }
      section = _tree._getNextSection();
    }
    String _summaryOfUserAnswers =
        _tree.priorAnswers.map((r) => r.toString()).toString();
    return _summaryOfUserAnswers;
  }
}
