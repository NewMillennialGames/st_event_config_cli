part of ConfigDialogRunner;

class DialogMgr {
  /*  not really in use much
    none of this functionality is needed
    --
    keeps track of Dialog Sections (aka groups of related questions)
    and also coordinates (stays in sync with) the QuestListMgr
  */
  final QuestListMgr _questMgr;
  // List<DialogSectionCfg> _sections = [];
  // int _currSectionIdx = -1;

  // constructor
  DialogMgr(this._questMgr);

  //
  Question? getNextQuestInCurrentSection() {
    // only in this section
    // return _questMgr._nextQuestionFor(currentAppScreenTyp);
    return _questMgr.nextQuestionToAnswer();
  }

  // List<UserResponse> get priorAnswers {
  //   //
  //   return _questMgr.priorAnswers;
  // }

  void loadBeginningDialog() {
    //
    _loadAppUiSections();
    // only load questions for top (eventConfiguration) section
    // answers in that section will kick off creation of new Quests
    // inside of NewQuestionCollector()
    List<Question> quests = loadInitialConfigQuestions();
    _questMgr.appendNewQuestions(quests);
  }

  // void _loadQuestionsForSpecifiedSection(AppScreen section) {
  //   List<Question> quests = loadQuestionsAtTopOfSection(section);
  //   _questMgr.appendNewQuestions(quests);
  // }

  void _loadAppUiSections() {
    // List<DialogSectionCfg> l = [];
    // for (AppScreen s in AppScreen.values) {
    //   l.add(DialogSectionCfg(s));
    // }
    // this._sections = l;
  }
}
