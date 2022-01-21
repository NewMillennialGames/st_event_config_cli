part of ConfigDialogRunner;

class QuestListMgr {
  /*
    does nothing but track and manage the full
    list of questions, both pending and completed/answered
  */
  int _currQuestionIdx = -1;
  List<Question> _pendingQuestions = [];
  Map<AppScreen, int> _questCountBySection = {};
  Map<AppScreen, List<Question>> _answeredQuestsBySection = {};

  // constructor
  QuestListMgr();

  //
  Question get _currentOrLastQuestion => _pendingQuestions[_currQuestionIdx];
  int get totalAnsweredQuestions => _answeredQuestsBySection.values
      .fold<int>(0, (r, qLst) => r + qLst.length);

  List<Question> get _allAnsweredQuestions =>
      _answeredQuestsBySection.values.fold<List<Question>>(
        [],
        (l0, l1) => l0..addAll(l1),
      );

  List<AppScreen> get userSelectedScreens {
    List<AppScreen> uss = (_allAnsweredQuestions
            .whereType<Question<String, List<AppScreen>>>()
            .where((q) => q.asksWhichScreensToConfig)
            .first
            .response
            ?.answers ??
        []);

    print('userSelectedScreens has ${uss.length} items');
    return uss;
  }

  Map<AppScreen, List<ScreenWidgetArea>> get screenAreasPerScreen {
    //
    Map<AppScreen, List<ScreenWidgetArea>> map = {};

    for (AppScreen as in userSelectedScreens) {
      map[as] = screenAreasFor(as);
    }
    return map;
  }

  Map<AppScreen, Map<ScreenWidgetArea, List<SubWidgetInScreenArea>>>
      get allSlotsInAreasInScreens {
    //
    Map<AppScreen, Map<ScreenWidgetArea, List<SubWidgetInScreenArea>>> tree =
        {};

    for (MapEntry<AppScreen, List<ScreenWidgetArea>> mapEntry
        in screenAreasPerScreen.entries<AppScreen, List<ScreenWidgetArea>>) {
      //
      tree[mapEntry.key] = {};
      for (ScreenWidgetArea area in mapEntry.value) {
        tree[mapEntry.key] = {area: screenSlotsInAreasFor(mapEntry.key, area)};
      }
    }

    return tree;
  }

  List<ScreenWidgetArea> screenAreasFor(AppScreen as) {
    //
    return _allAnsweredQuestions
        .whereType<Question<String, List<ScreenWidgetArea>>>()
        .where((q) => q.appScreen == as)
        .map((q) => q.response?.answers ?? [])
        .fold<List<ScreenWidgetArea>>([], (l0, l1) => l0..addAll(l1)).toList();
  }

  List<SubWidgetInScreenArea> screenSlotsInAreasFor(
    AppScreen as,
    ScreenWidgetArea area,
  ) {
    //
    return _allAnsweredQuestions
        .whereType<Question<String, List<SubWidgetInScreenArea>>>()
        .where((q) => q.appScreen == as && q.screenWidgetArea == area)
        .map((q) => q.response?.answers ?? [])
        .fold<List<SubWidgetInScreenArea>>(
            [], (l0, l1) => l0..addAll(l1)).toList();
  }

  Question? _nextQuestionFor(AppScreen section) {
    //
    _moveCurrentQuestToAnswered();
    //
    if (_currQuestionIdx + 1 >= _pendingQuestions.length) {
      return null;
    }
    ++_currQuestionIdx;
    if (_currentOrLastQuestion.appScreen != section) {
      --_currQuestionIdx;
      return null;
    }
    return _currentOrLastQuestion;
  }

  void _moveCurrentQuestToAnswered() {
    // dont add at start or end
    if (_currQuestionIdx < 0 ||
        totalAnsweredQuestions >= _pendingQuestions.length) return;
    //
    Question? mostRecentSaved =
        _answeredQuestsBySection[_currentOrLastQuestion.appScreen]?.last;
    // dont store same question twice
    if (mostRecentSaved != null &&
        mostRecentSaved.questionId == _currentOrLastQuestion.questionId) return;
    // store into list for this section
    var l = _answeredQuestsBySection[_currentOrLastQuestion.appScreen] ?? [];
    l.add(_currentOrLastQuestion);
    _answeredQuestsBySection[_currentOrLastQuestion.appScreen] = l;
  }

  void loadInitialQuestions() {
    //
    _pendingQuestions = loadInitialConfigQuestions();
    _questCountBySection[AppScreen.eventConfiguration] =
        _pendingQuestions.length;
    int c = 0;
    _pendingQuestions.forEach((q) {
      q.questionId = ++c;
    });
  }

  void appendQuestions(
    List<Question> quests,
  ) {
    //
    Set<AppScreen> newSections = quests.map((e) => e.appScreen).toSet();

    for (AppScreen as in newSections) {
      int newCntBySec = quests
          .where((q) => q.appScreen == as)
          .fold(0, (accumVal, _) => accumVal + 1);
      _questCountBySection[as] = (_questCountBySection[as] ?? 0) + newCntBySec;
    }
    int c = _pendingQuestions.length;
    quests.forEach((q) {
      q.questionId = ++c;
    });
    _pendingQuestions.addAll(quests);
  }

  List<UserResponse> get priorAnswers {
    // return all existing user answers

    // List<Question> l0, List<Question>

    return _allAnsweredQuestions
        .map((e) => e.response)
        .whereType<UserResponse>()
        .toList();
  }
}
