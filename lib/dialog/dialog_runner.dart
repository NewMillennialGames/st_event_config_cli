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
  // web logic;  start asking questions for GUI
  bool serveNextQuestionToGui() {
    //
    Question? _quest = _questGroupMgr.getNextQuestInCurrentSection();
    if (_quest == null) return false;
    questFormatter.askAndWaitForUserResponse(this, _quest);
    return true;
  }

  void advanceToNextQuestion() {
    //
    // logic to add new questions based on user response
    // two different methods
    bool didAddNew = _newQuestComposer.handleAcquiringNewQuestions(
      // _questGroupMgr,
      _questMgr,
    );
    if (!didAddNew & false) {
      // new version of handleAcquiringNewQuestions
      // run it only if handleAcquiringNewQuestions does no work
      appendNewQuests(_questMgr, _questMgr._currentOrLastQuestion);
    }
    // end of logic to add new questions based on user response

    bool hasNextQuest = serveNextQuestionToGui();
    if (!hasNextQuest) {
      questFormatter.informUiWeAreDone();
    }
  }

  // CLI logic
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

      // logic to add new questions based on user response
      // two different methods
      bool didAddNew = _newQuestComposer.handleAcquiringNewQuestions(
        // _questGroupMgr,
        _questMgr,
      );
      if (!didAddNew) {
        // new version of handleAcquiringNewQuestions
        // run it only if handleAcquiringNewQuestions does no work
        appendNewQuests(_questMgr, _quest);
      }
      // end of logic to add new questions based on user response

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
