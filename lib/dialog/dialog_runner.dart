part of ConfigDialogRunner;

class DialogRunner {
  /* actually runs the conversation

  the top-level obj that coordinates:
    QuestListMgr
    QuestionPresenter
    NewQuestionCollector
    
  to produce CLI output to the user
  */
  final QuestListMgr _qListMgr; // = QuestListMgr();
  // final NewQuestionCollector _newQuestComposer = NewQuestionCollector();
  // set in init
  final QuestionPresenter questPresenter;
  final int linesBetweenSections;
  final int linesBetweenQuest2s;
  final QMatchCollection _qMatchColl;
  //

  DialogRunner(
    this.questPresenter, {
    QuestListMgr? qListMgr,
    this.linesBetweenSections = 3,
    this.linesBetweenQuest2s = 1,
    bool loadDefaultQuest = true,
    QMatchCollection? qMatchColl,
  })  : _qListMgr = qListMgr ?? QuestListMgr(),
        _qMatchColl =
            qMatchColl != null ? qMatchColl : QMatchCollection.scoretrader() {
    List<QuestBase> quests = loadInitialConfigQuestions();
    if (loadDefaultQuest) {
      _qListMgr.appendNewQuestions(quests);
    }
  }

  QuestListMgr get questionLstMgr => _qListMgr;
  List<CaptureAndCast> getPriorAnswersList() {
    // used when a Quest2 needs to review prior
    // answers to configure itself
    return _qListMgr.priorAnswers;
  }

  // web logic;  start asking Questions for GUI
  bool serveNextQuestionToGui() {
    //
    QuestBase? _quest = _qListMgr.nextQuestionToAnswer();
    if (_quest == null) return false;
    questPresenter.askAndWaitForUserResponse(this, _quest);
    return true;
  }

  void advanceToNextQuestionFromGui() {
    /* called by web presenter
      run logic to add new Questions based on user response to current Question
      we currently have two different methods:
        1) _newQuestComposer.handleAcquiringNewQuest2s() was my original brute-force approach
          it's brittle and hard to test (will remove this eventually)
        2) appendNewQuestsOrInsertImplicitAnswers is a much more elegant and flexible
          approach based on pattern matching and Quest2 generation functions

      I'm leaving both in place right now because we don't currently have this
      package under test and I don't want to break existing functionality
      but new auto-generated Quest2s should be placed under #2 (appendNewQuestsOrInsertImplicitAnswers)
    */

    // bool didAddNew = _newQuestComposer.handleAcquiringNewQuestions(_qListMgr);
    bool didAddNew = false;
    if (!didAddNew) {
      // run appendNewQuestsOrInsertImplicitAnswers only if handleAcquiringNewQuestions does no work
      _qMatchColl.appendNewQuestsOrInsertImplicitAnswers(_qListMgr);
    }
    // end of logic to add new Quest2s based on user response

    bool hasNextQuest = serveNextQuestionToGui();
    if (!hasNextQuest) {
      questPresenter.informUiThatDialogIsComplete();
    }
  }

  // CLI logic
  bool cliLoopUntilComplete() {
    //
    // questFormatter manages display output
    // final questFormatter = CliQuest2Formatter();

    _outputSpacerLines(forSection: true);
    // check for another Quest2
    QuestBase? _quest = _qListMgr.nextQuestionToAnswer();
    while (_quest != null) {
      // askAndWaitForUserResponse() will callback to handleQuestionCascade (below)
      // to create any derived Questions based on user answers
      questPresenter.askAndWaitForUserResponse(this, _quest);

      _quest = _qListMgr.nextQuestionToAnswer();
      if (_quest != null) _outputSpacerLines();
    }
    return true;
  }

  void _outputSpacerLines({bool forSection = false}) {
    if (forSection) {
      print('\n' * this.linesBetweenSections);
    } else {
      print('\n' * this.linesBetweenQuest2s);
    }
  }

  void handleQuestionCascade(QuestBase _quest) {
    // logic to add new Questions based on user response
    // two different methods
    // called from inside of: questPresenter.askAndWaitForUserResponse
    // bool didAddNew = _newQuestComposer.handleAcquiringNewQuestions(_qListMgr);
    bool didAddNew = false;
    if (!didAddNew) {
      // new version of handleAcquiringNewQuest2s
      // run it only if handleAcquiringNewQuest2s does no work
      _qMatchColl.appendNewQuestsOrInsertImplicitAnswers(_qListMgr);
    }
    // end of logic to add new Questions based on user response
  }
}
