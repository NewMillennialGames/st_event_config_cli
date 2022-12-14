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
  // set in init
  final QuestionPresenterIfc questPresenter;
  final int linesBetweenSections;
  final int linesBetweenQuest2s;
  final QCascadeDispatcher questCascadeDispatcher;
  //

  DialogRunner(
    this.questPresenter, {
    QuestListMgr? qListMgr,
    this.linesBetweenSections = 3,
    this.linesBetweenQuest2s = 1,
    bool loadDefaultQuest = true,
    QCascadeDispatcher? questCascadeDisp,
  })  : _qListMgr = qListMgr ?? QuestListMgr(),
        questCascadeDispatcher =
            questCascadeDisp == null ? QCascadeDispatcher() : questCascadeDisp {
    if (loadDefaultQuest) {
      List<QuestBase> quests = loadInitialConfigQuestions();
      _qListMgr.appendGeneratedQuestsAndAnswers(quests);
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

    questCascadeDispatcher.appendNewQuestsOrInsertImplicitAnswers(
      _qListMgr,
      _qListMgr.currentOrLastQuestion,
    );
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
      // askAndWaitForUserResponse() will callback to gentNewQuestionsFromUserResponse (below)
      // to create any derived Questions based on user answers

      // next line for testing
      questPresenter.askAndWaitForUserResponse(this, _quest);
      // TODO:  enable block below for production
      // try {
      //   questPresenter.askAndWaitForUserResponse(this, _quest);
      // } catch (e, _) {
      //   ConfigLogger.log(Level.FINER,
      //       'Err:  cliLoopUntilComplete running questPresenter.askAndWaitForUserResponse');
      //   ConfigLogger.log(Level.FINER, 'Err thrown was ${e.toString()}');
      //   questPresenter.showErrorAndRePresentQuestion(
      //       e as String, _quest.helpMsgOnError ?? '');
      //   continue;
      // }

      _quest = _qListMgr.nextQuestionToAnswer();
      if (_quest != null) {
        _outputSpacerLines();
        // print('no more questions found!!');
      }
    }
    return true;
  }

  void generateNewQuestionsFromEventLevelAnswer(QuestBase questJustAnswered) {
    // logic to add new Questions based on user response
    questCascadeDispatcher.appendNewQuestsOrInsertImplicitAnswers(
      _qListMgr,
      questJustAnswered,
    );
  }

  void generateNewQuestionsFromUserRuleCfgResponse(
    QuestBase questJustAnswered,
  ) {
    // logic to add new Questions based on user response
    questCascadeDispatcher.appendNewQuestsOrInsertImplicitAnswers(
      _qListMgr,
      questJustAnswered,
    );
  }

  void _outputSpacerLines({bool forSection = false}) {
    if (forSection) {
      ConfigLogger.log(Level.INFO, '\n' * this.linesBetweenSections);
    } else {
      ConfigLogger.log(Level.INFO, '\n' * this.linesBetweenQuest2s);
    }
  }
}
