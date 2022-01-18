part of ConfigDialogRunner;

class Dialoger {
  //
  final DialogTree _tree = DialogTree();
  late final SectionManager _secMgr;
  final int linesBetweenSections;
  final int linesBetweenQuestions;
  //
  int currQuestIdx = 0;

  Dialoger([
    this.linesBetweenSections = 3,
    this.linesBetweenQuestions = 1,
  ]) {
    _secMgr = SectionManager(_tree);
    _secMgr.loadInitialConversation();
  }

  List<UserResponse> getPriorAnswersList() {
    // used when a question needs to review prior
    // answers to configure itself
    return _tree.priorAnswers;
  }

  //
  String loopUntilComplete() {
    //
    // questFormatter manages display output
    final questFormatter = CliQuestionFormatter();

    DialogSectionCfg? section = _secMgr._getNextSection();
    while (section != null) {
      //
      bool shouldShowSection =
          questFormatter.askSectionQuestionAndWaitForUserResponse(
        this,
        section,
      );
      if (shouldShowSection) {
        _addEmptyLines(isSection: true);
        Question? _quest = section.getNextQuestion();
        while (_quest != null) {
          questFormatter.askAndWaitForUserResponse(this, _quest);
          currQuestIdx++;
          _quest = section.getNextQuestion();
          if (_quest != null) _addEmptyLines();
        }
      }
      section = _secMgr._getNextSection();
    }

    // not every answer-type (generic) has a toString method
    // String _summaryOfUserAnswers =
    //     _tree.priorAnswers.map((r) => r.toString()).toString();
    // return _summaryOfUserAnswers;
    return '';
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
        loadAddlRuleQuestions(_secMgr.currentSectiontype, uiComp, response);
    _tree.insertNewQuestions(currQuestIdx, includedQuestions);
  }
}
