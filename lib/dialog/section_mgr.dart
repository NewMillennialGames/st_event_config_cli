part of ConfigDialogRunner;

class SectionManager {
  //
  List<DialogSectionCfg> _sections = [];
  int currSectionIdx = -1;
  DialogTree dTree;

  // constructor
  SectionManager(this.dTree);

  //
  DialogSectionCfg get currentSectionCfg => _sections[currSectionIdx];
  AppSection get currentSectiontype => currentSectionCfg.appSection;

  List<UserResponse> get priorAnswers {
    //
    return dTree.priorAnswers;
  }

  void loadInitialConversation() {
    //
    _sections = _loadAppUiSections();
    _loadQuestionsForSection();
  }

  List<DialogSectionCfg> _loadAppUiSections() {
    List<DialogSectionCfg> l = [];
    for (AppSection s in AppSection.values) {
      l.add(DialogSectionCfg(s));
    }
    return l;
  }

  void _loadQuestionsForSection() {
    for (DialogSectionCfg s in _sections) {
      dTree.loadQuestions(s.appSection);
    }
  }

  DialogSectionCfg? _getNextSection() {
    //
    ++currSectionIdx;
    if (currSectionIdx >= _sections.length) return null;
    return _sections[currSectionIdx];
  }

  void insertNewQuestions(
    int currQuestIdx,
    List<Question> newQuestions,
  ) {
    //
    currentSectionCfg.appendQuestions(currQuestIdx, newQuestions);
  }
}
