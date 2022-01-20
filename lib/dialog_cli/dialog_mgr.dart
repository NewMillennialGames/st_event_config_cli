part of ConfigDialogRunner;

class DialogMgr {
  /*
    keeps track of Dialog Sections (aka groups of related questions)
    and also coordinates (stays in sync with) the QuestListMgr
  */
  final QuestListMgr _questMgr;
  List<DialogSectionCfg> _sections = [];
  int _currSectionIdx = -1;

  // constructor
  DialogMgr(this._questMgr);

  //
  DialogSectionCfg get _currentSectionCfg => _sections[_currSectionIdx];
  AppSection get currentSectiontype => _currentSectionCfg.appSection;

  DialogSectionCfg? _getNextSection() {
    //
    if (_currSectionIdx + 1 >= _sections.length) return null;
    ++_currSectionIdx;
    return _currentSectionCfg;
  }

  Question? getNextQuestInCurrentSection() {
    // only in this section
    return _questMgr._nextQuestionFor(currentSectiontype);
  }

  List<UserResponse> get priorAnswers {
    //
    return _questMgr.priorAnswers;
  }

  void loadBeginningDialog() {
    //
    _loadAppUiSections();
    // only load questions for top section
    // top == AppSection.eventConfiguration
    loadQuestionsForSpecifiedSection(AppSection.eventConfiguration);
  }

  void loadQuestionsForSpecifiedSection(AppSection section) {
    List<Question> quests = loadQuestionsForSection(section);
    _questMgr.appendQuestions(quests);
  }

  void _loadAppUiSections() {
    List<DialogSectionCfg> l = [];
    for (AppSection s in AppSection.values) {
      l.add(DialogSectionCfg(s));
    }
    this._sections = l;
  }
}
