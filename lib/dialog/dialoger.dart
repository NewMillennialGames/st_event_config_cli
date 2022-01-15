part of ConfigDialog;

class Dialoger {
  //
  final DialogTree _tree = DialogTree();
  int currQuestIdx = 0;

  Dialoger() {
    _tree.loadDialog();
  }

  List<UserResponse> getPriorAnswerCallback() {
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
          _quest.askAndWait(this);
          currQuestIdx++;
          _quest = section.getNextQuestion();
        }
      }
      section = _tree._getNextSection();
    }
    String _summaryOfUserAnswers =
        _tree.priorAnswers.map((r) => r.toString()).toString();
    return _summaryOfUserAnswers;
  }

  void generateAssociatedUiComponentQuestions(
    AppSection section,
    UserResponse<List<UiComponent>> response,
  ) {
    //
    var includedQuestions = loadAddlSectionQuestions(section, response);
    _tree.insertNewQuestions(currQuestIdx, includedQuestions);
  }

  void generateAssociatedUiRuleTypeQuestions(
    UiComponent uiComp,
    UserResponse<List<RuleType>> response,
  ) {
    //
    var includedQuestions = loadAddlRuleQuestions(uiComp, response);
    _tree.insertNewQuestions(currQuestIdx, includedQuestions);
  }
}
