part of ConfigDialog;

class Dialoger {
  //
  final DialogTree _tree = DialogTree();
  final int linesBetweenSections;
  final int linesBetweenQuestions;
  //
  int currQuestIdx = 0;

  Dialoger([
    this.linesBetweenSections = 3,
    this.linesBetweenQuestions = 1,
  ]) {
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
    final questFormatter = CliQuestionFormatter();

    DialogSectionCfg? section = _tree._getNextSection();
    while (section != null) {
      //
      bool doSection = section.askIfNeeded();
      if (doSection) {
        _addEmptyLines(isSection: true);
        Question? _quest = section.getNextQuestion();
        while (_quest != null) {
          questFormatter.askAndWaitForUserResponse(this, _quest);
          currQuestIdx++;
          _quest = section.getNextQuestion();
          if (_quest != null) _addEmptyLines();
        }
      }
      section = _tree._getNextSection();
    }
    String _summaryOfUserAnswers =
        _tree.priorAnswers.map((r) => r.toString()).toString();
    return _summaryOfUserAnswers;
  }

  void _addEmptyLines({bool isSection = false}) {
    if (isSection) {
      print('\n' * this.linesBetweenSections);
    } else {
      print('\n' * this.linesBetweenQuestions);
    }
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
    UserResponse<List<VisualRuleType>> response,
  ) {
    //
    var includedQuestions =
        loadAddlRuleQuestions(_tree.currentSectiontype, uiComp, response);
    _tree.insertNewQuestions(currQuestIdx, includedQuestions);
  }
}
