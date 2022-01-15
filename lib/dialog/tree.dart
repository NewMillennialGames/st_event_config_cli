part of ConfigDialog;

class DialogTree {
  //
  List<DialogSectionCfg> _sections = [];
  DialogTree();

  List<UserResponse> get priorAnswers {
    // TODO
    List<UserResponse> lst = [];
    for (DialogSectionCfg s in _sections) {
      //
      lst.addAll(s.priorAnswers);
    }
    return lst;
  }

  void loadDialog() {
    //
    _sections = _loadAppUiSections();
    _loadQuestionsForSection();
  }

  List<DialogSectionCfg> _loadAppUiSections() {
    List<DialogSectionCfg> l = [];
    for (AppSection s in AppSection.values) {
      l.add(DialogSectionCfg(s));
    }
    l.sort((a, b) => a.order.compareTo(b.order));
    return l;
  }

  void _loadQuestionsForSection() {
    for (DialogSectionCfg s in _sections) {
      s.loadQuestions();
    }
  }

  DialogSectionCfg? _getNextSection() {
    //
  }

  void _collectAnswer(UserResponse answer) {}
}
