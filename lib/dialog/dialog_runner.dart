part of ConfigDialogRunner;

class DialogRunner {
  /* actually runs the conversation

  the top-level obj that coordinates:
    DialogMgr
    QuestListMgr
    CliQuestionFormatter
    
  to produce CLI output to the user
  */
  final QuestListMgr _questMgr = QuestListMgr();
  final NewQuestionCollector _newQuestComposer = NewQuestionCollector();
  late final DialogMgr _questGroupMgr;
  // set in init
  final QuestionPresenter questFormatter;
  final int linesBetweenSections;
  final int linesBetweenQuestions;
  //

  DialogRunner(
    this.questFormatter, [
    this.linesBetweenSections = 3,
    this.linesBetweenQuestions = 1,
  ]) {
    _questGroupMgr = DialogMgr(_questMgr);
    _questGroupMgr.loadBeginningDialog();
  }

  QuestListMgr get questionMgr => _questMgr;
  List<UserResponse> getPriorAnswersList() {
    // used when a question needs to review prior
    // answers to configure itself
    return _questMgr.priorAnswers;
  }

  //
  // web start asking questions for web
  bool serveNextQuestionToGui() {
    //
    Question? _quest = _questGroupMgr.getNextQuestInCurrentSection();
    if (_quest == null) return false;
    questFormatter.askAndWaitForUserResponse(this, _quest);
    return true;
  }

  void advanceToNextQuestion() {
    //
    _newQuestComposer.handleAcquiringNewQuestions(
      _questGroupMgr,
      _questMgr,
    );

    bool hasNextQuest = serveNextQuestionToGui();
    if (!hasNextQuest) {
      questFormatter.informUiWeAreDone();
    }
  }

  //
  bool cliLoopUntilComplete() {
    //
    // questFormatter manages display output
    // final questFormatter = CliQuestionFormatter();

    _outputSpacerLines(forSection: true);
    // check for another question
    Question? _quest = _questGroupMgr.getNextQuestInCurrentSection();
    while (_quest != null) {
      // askAndWaitForUserResponse() will callback to this
      // to create any derived questions for this section
      questFormatter.askAndWaitForUserResponse(this, _quest);
      _newQuestComposer.handleAcquiringNewQuestions(
        _questGroupMgr,
        _questMgr,
      );

      _quest = _questGroupMgr.getNextQuestInCurrentSection();
      if (_quest != null) _outputSpacerLines();
    }
    return true;
  }

  void _outputSpacerLines({bool forSection = false}) {
    if (forSection) {
      print('\n' * this.linesBetweenSections);
    } else {
      print('\n' * this.linesBetweenQuestions);
    }
  }
}
