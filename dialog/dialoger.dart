part of ConfigDialog;

class Dialoger {
  //
  final DialogTree _tree = DialogTree();

  Dialoger() {
    _tree.loadDialog();
  }

  String _summaryOfUserAnswers = '';
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
          UserResponse answer = _quest.askAndWait();
          _tree._collectAnswer(answer);
          _quest = section.getNextQuestion();
        }
      }

      section = _tree._getNextSection();
    }

    return _summaryOfUserAnswers;
  }
}
