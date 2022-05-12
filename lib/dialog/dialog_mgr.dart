part of ConfigDialogRunner;

class DialogMgr {
  /*  not really in use much
    none of this functionality is needed
    --
    keeps track of Dialog Sections (aka groups of related Quest2s)
    and also coordinates (stays in sync with) the QuestListMgr
  */
  final QuestListMgr _questMgr;
  // List<DialogSectionCfg> _sections = [];
  // int _currSectionIdx = -1;

  // constructor
  DialogMgr(this._questMgr);

  //
  Quest2? getNextQuestInCurrentSection() {
    // only in this section
    // return _questMgr._nextQuest2For(currentAppScreenTyp);
    return _questMgr.nextQuest2ToAnswer();
  }

  // List<UserResponse> get priorAnswers {
  //   //
  //   return _questMgr.priorAnswers;
  // }

  void loadBeginningDialog() {
    //
    _loadAppUiSections();
    // only load Quest2s for top (eventConfiguration) section
    // answers in that section will kick off creation of new Quests
    // inside of NewQuest2Collector()
    List<Quest2> quests = loadInitialConfigQuest2s();
    _questMgr.appendNewQuest2s(quests);
  }

  // void _loadQuest2sForSpecifiedSection(AppScreen section) {
  //   List<Quest2> quests = loadQuest2sAtTopOfSection(section);
  //   _questMgr.appendNewQuest2s(quests);
  // }

  void _loadAppUiSections() {
    // List<DialogSectionCfg> l = [];
    // for (AppScreen s in AppScreen.values) {
    //   l.add(DialogSectionCfg(s));
    // }
    // this._sections = l;
  }
}
