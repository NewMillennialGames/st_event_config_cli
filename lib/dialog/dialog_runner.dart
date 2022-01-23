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
  bool loopUntilComplete() {
    //
    // questFormatter manages display output
    // final questFormatter = CliQuestionFormatter();

    DialogSectionCfg? section = _questGroupMgr._getNextSection();
    while (section != null) {
      //

      bool shouldShowSection = section.isConfigurable;
      // bool shouldShowSection = questFormatter.askSectionQuestionAndWaitForUserResponse(
      //   this,
      //   section,
      // );
      if (shouldShowSection) {
        _outputSpacerLines(forSection: true);
        // check for another question
        Question? _quest = _questGroupMgr.getNextQuestInCurrentSection();
        while (_quest != null) {
          // askAndWaitForUserResponse() will callback to this
          // to create any derived questions for this section
          questFormatter.askAndWaitForUserResponse(this, _quest);
          _newQuestComposer.handleAcquiringNewQuestions(
              _questGroupMgr, _questMgr, _quest);

          _quest = _questGroupMgr.getNextQuestInCurrentSection();
          if (_quest != null) _outputSpacerLines();
        }
      }
      section = _questGroupMgr._getNextSection();
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
