part of ConfigDialogRunner;

class DialogRunner {
  //
  final DialogQuestMgr _questMgr = DialogQuestMgr();
  late final QuestionGroupMgr _questGroupMgr;
  final int linesBetweenSections;
  final int linesBetweenQuestions;
  //
  AppSection _currSection = AppSection.eventConfiguration;

  DialogRunner([
    this.linesBetweenSections = 3,
    this.linesBetweenQuestions = 1,
  ]) {
    _questGroupMgr = QuestionGroupMgr(_questMgr);
    _questGroupMgr.loadBeginningDialog();
  }

  List<UserResponse> getPriorAnswersList() {
    // used when a question needs to review prior
    // answers to configure itself
    return _questMgr.priorAnswers;
  }

  //
  String loopUntilComplete() {
    //
    // questFormatter manages display output
    final questFormatter = CliQuestionFormatter();

    DialogSectionCfg? section = _questGroupMgr._getNextSection();
    while (section != null) {
      //
      bool shouldShowSection =
          questFormatter.askSectionQuestionAndWaitForUserResponse(
        this,
        section,
      );
      if (shouldShowSection) {
        // remember current section for derived questions
        _currSection = section.appSection;
        // load static questions here
        _questGroupMgr.loadQuestionsForSpecifiedSection(_currSection);
        _outputSpacerLines(forSection: true);
        // check for another question
        Question? _quest = _questGroupMgr.getNextQuestInCurrentSection();
        while (_quest != null) {
          // askAndWaitForUserResponse() will callback to this
          // to create any derived questions for this section
          questFormatter.askAndWaitForUserResponse(this, _quest);
          _quest = _questGroupMgr.getNextQuestInCurrentSection();
          if (_quest != null) _outputSpacerLines();
        }
      }
      section = _questGroupMgr._getNextSection();
    }

    // not every answer-type (generic) has a toString method
    // String _summaryOfUserAnswers =
    //     _tree.priorAnswers.map((r) => r.toString()).toString();
    // return _summaryOfUserAnswers;
    return '';
  }

  void _outputSpacerLines({bool forSection = false}) {
    if (forSection) {
      print('\n' * this.linesBetweenSections);
    } else {
      print('\n' * this.linesBetweenQuestions);
    }
  }

  // create questions based on prior answers
  void generateAssociatedUiComponentQuestions(
    AppSection section,
    UserResponse<List<UiComponent>> response,
  ) {
    //
    var includedQuestions = loadSpecificComponentQuestions(section, response);
    _questMgr.appendQuestions(section, includedQuestions);
  }

  void generateAssociatedUiRuleTypeQuestions(
    UiComponent uiComp,
    UserResponse<List<VisualRuleType>> response,
  ) {
    //
    var includedQuestions = fabricateVisualRuleQuestions(
      _questGroupMgr.currentSectiontype,
      uiComp,
      response,
    );
    _questMgr.appendQuestions(
      _questGroupMgr.currentSectiontype,
      includedQuestions,
    );
  }

  void generateAssociatedBehRuleTypeQuestions(
    UiComponent uiComp,
    UserResponse<List<BehaviorRuleType>> response,
  ) {
    // future
    // var includedQuestions = loadAddlRuleQuestions(
    //     _questGroupMgr.currentSectiontype, uiComp, response);
    // _questMgr.appendQuestions(
    //     _questGroupMgr.currentSectiontype, includedQuestions);
  }
}
