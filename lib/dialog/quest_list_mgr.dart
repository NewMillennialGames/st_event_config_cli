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
  List<Question> get exportableQuestions =>
      _allAnsweredQuestions.where(_exportFilterLogic).toList();

  bool _exportFilterLogic(Question q) {
    // print(
    //   'QID: ${q.questionId}  runtimeType: ${q.runtimeType}  appliesToClientConfiguration: ${q.appliesToClientConfiguration}',
    // );
    return q.appliesToClientConfiguration;
  }

  Question get _currentOrLastQuestion => _pendingQuestions[_currQuestionIdx];
  int get totalAnsweredQuestions => _answeredQuestsBySection.values
      .fold<int>(0, (r, qLst) => r + qLst.length);

  List<Question> get _allAnsweredQuestions =>
      _answeredQuestsBySection.values.fold<List<Question>>(
        [],
        (List<Question> l0, List<Question> l1) => l0..addAll(l1),
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

  List<ScreenWidgetArea> configurableAreasForScreen(AppScreen as) {
    //
    return _allAnsweredQuestions
        .whereType<Question<String, List<ScreenWidgetArea>>>()
        .where((q) => q.appScreen == as)
        .map((q) => q.response?.answers ?? [])
        .fold<List<ScreenWidgetArea>>([], (l0, l1) => l0..addAll(l1)).toList();
  }

  Map<AppScreen, List<ScreenWidgetArea>> get screenAreasPerScreen {
    //
    Map<AppScreen, List<ScreenWidgetArea>> map = {};

    for (AppScreen as in userSelectedScreens) {
      map[as] = configurableAreasForScreen(as);
    }
    return map;
  }

  Map<AppScreen, Map<ScreenWidgetArea, List<ScreenAreaWidgetSlot>>>
      get allSlotsInAreasInScreens {
    //
    Map<AppScreen, Map<ScreenWidgetArea, List<ScreenAreaWidgetSlot>>> tree = {};

    // <AppScreen, List<ScreenWidgetArea>>
    for (MapEntry<AppScreen, List<ScreenWidgetArea>> mapEntry
        in screenAreasPerScreen.entries) {
      //
      tree[mapEntry.key] = {};
      for (ScreenWidgetArea area in mapEntry.value) {
        tree[mapEntry.key] = {area: screenSlotsInAreasFor(mapEntry.key, area)};
      }
    }

    return tree;
  }

  // List<ScreenWidgetArea> configurableAreasForScreen(AppScreen as) {
  //   // return previously answered config areas for this screen

  // }

  List<ScreenAreaWidgetSlot> screenSlotsInAreasFor(
    AppScreen as,
    ScreenWidgetArea area,
  ) {
    //
    return _allAnsweredQuestions
        .whereType<Question<String, List<ScreenAreaWidgetSlot>>>()
        .where((q) => q.appScreen == as && q.screenWidgetArea == area)
        .map((q) => q.response?.answers ?? [])
        .fold<List<ScreenAreaWidgetSlot>>(
            [], (l0, l1) => l0..addAll(l1)).toList();
  }

  void _sortPendingQuestions() {
    // its important that we ONLY sort the section AFTER _currQuestionIdx
    // or else we might re-ask prior (already answered) questions
    if (_currQuestionIdx < 7) return;

    print('running sortPendingQuestions');

    var unaskedQuests = _pendingQuestions.sublist(_currQuestionIdx + 1);

    unaskedQuests.sort((a, b) => a.sortKey.compareTo(b.sortKey));

    this._pendingQuestions = (_pendingQuestions.sublist(0, _currQuestionIdx + 1)
      ..addAll(unaskedQuests));
  }

  Question? nextQuestionToAnswer() {
    // AppScreen section
    _moveCurrentQuestToAnswered();
    //
    if (_currQuestionIdx + 1 >= _pendingQuestions.length) {
      return null;
    }
    ++_currQuestionIdx;
    // if (_currentOrLastQuestion.appScreen != section) {
    //   --_currQuestionIdx;
    //   return null;
    // }
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
        mostRecentSaved.questionId == _currentOrLastQuestion.questionId) {
      //
      print(
          'QID: ${mostRecentSaved.questionId} seemd to be duplicate & wasnt moved into _answeredQuestsBySection');
      return;
    }
    ;
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
    // _pendingQuestions.forEach((q) {
    //   q.questionId = ++c;
    // });
  }

  void addImplicitAnswers(
    List<Question> implicitlyAnsweredQuests, {
    String dbgNam = 'init', // debug-name
  }) {
    var alreadyAnsweredQuests =
        _pendingQuestions.sublist(0, _currQuestionIdx + 1);
    alreadyAnsweredQuests.addAll(implicitlyAnsweredQuests);

    var unaskedQuests = _pendingQuestions.sublist(_currQuestionIdx + 1);

    this._pendingQuestions = alreadyAnsweredQuests..addAll(unaskedQuests);
  }

  void appendNewQuestions(
    List<Question> quests, {
    String dbgNam = 'init', // debug-name
  }) {
    //
    Set<AppScreen> newSections = quests.map((e) => e.appScreen).toSet();

    print('$dbgNam is adding ${quests.length} new questions to $newSections');

    for (AppScreen as in newSections) {
      int newCntBySec = quests
          .where((q) => q.appScreen == as)
          .fold(0, (accumVal, _) => accumVal + 1);
      _questCountBySection[as] = (_questCountBySection[as] ?? 0) + newCntBySec;
    }
    // quest id's start at 1, not zero
    // int c = _pendingQuestions.length;
    // quests.forEach((q) {
    //   q.questionId = ++c;
    // });
    this._pendingQuestions.addAll(quests);

    // TODO:  test sorting after everything else is working
    // sorting not working and not necessary
    // _sortPendingQuestions();
  }

  List<UserResponse> get priorAnswers {
    // return all existing user answers
    // filter out any null responses

    return _allAnsweredQuestions
        .map((e) => e.response)
        .whereType<UserResponse>()
        .toList();
  }
}
