part of ConfigDialogRunner;

extension ListQuestExt1 on Iterable<QuestBase> {
  //
  Iterable<QuestPromptInstance> matchingPromptsWhere(
          bool Function(QuestPromptInstance) test) =>
      this
          .where((q) => q.containsPromptWhere(test))
          .fold<List<QuestPromptInstance>>(
        <QuestPromptInstance>[],
        (l, qu2) => l
          ..addAll(
            qu2.matchingPromptsWhere(test),
          ),
      );
}

class QuestListMgr {
  /*
    does nothing but track and manage the full
    list of Quest2s, both pending and completed/answered
  */
  int _currQuestionIdx = -1;
  List<QuestBase> _pendingQuestions = [];
  Map<AppScreen, int> _questCountByScreen = {};
  Map<AppScreen, List<QuestBase>> _answeredQuestsByScreen = {};

  // constructor
  QuestListMgr();

  //
  Iterable<UiFactoryRuleBase> get exportableQuestions =>
      _allAnsweredQuestions.whereType<UiFactoryRuleBase>();

  // bool _exportFilterLogic(QuestBase q) {
  //   // print(
  //   //   'QID: ${q.Quest2Id}  runtimeType: ${q.runtimeType}  appliesToClientConfiguration: ${q.appliesToClientConfiguration}',
  //   // );
  //   return q.appliesToClientConfiguration;
  // }

  List<QuestBase> get pendingQuestions => _pendingQuestions;
  QuestBase get _currentOrLastQuestion => _isAtBeginning
      ? _pendingQuestions[0]
      : _pendingQuestions[_currQuestionIdx];
  int get totalAnsweredQuestions =>
      _answeredQuestsByScreen.values.fold<int>(0, (r, qLst) => r + qLst.length);

  bool get _isAtBeginning => _currQuestionIdx < 0;
  bool get _notYetAtEnd => _currQuestionIdx < pendingQuestionCount - 2;
  // bool get _hasReachedEnd => !_notYetAtEnd;
  int get pendingQuestionCount => _isAtBeginning
      ? pendingQuestions.length
      : _pendingQuestions.length - (_currQuestionIdx + 1);

  List<QuestBase> get _allAnsweredQuestions =>
      _answeredQuestsByScreen.values.fold<List<QuestBase>>(
        <QuestBase>[],
        (List<QuestBase> l0, List<QuestBase> l1) => l0..addAll(l1),
      );

  List<AppScreen> get userSelectedScreens {
    Iterable<QuestPromptInstance> matchingPrompts = _allAnsweredQuestions
        .matchingPromptsWhere((qpi) => qpi.asksWhichScreensToConfig);

    List<AppScreen> uss =
        (matchingPrompts.first.userAnswers.cast(_currentOrLastQuestion) ?? []);

    print('userSelectedScreens has ${uss.length} items');
    return uss;
  }

  List<ScreenWidgetArea> configurableAreasForScreen(AppScreen as) {
    //
    Iterable<QuestPromptInstance> matchingPrompts = _allAnsweredQuestions
        .where((q) => q.appScreen == as)
        .matchingPromptsWhere((qpi) => qpi.asksWhichAreasOfScreenToConfig);
    return matchingPrompts.first.userAnswers.cast(_currentOrLastQuestion);
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

    Iterable<QuestPromptInstance> matchingPrompts = _allAnsweredQuestions
        .where((q) => q.appScreen == as && q.screenWidgetArea == area)
        .matchingPromptsWhere((qpi) => qpi.asksWhichAreasOfScreenToConfig);
    return matchingPrompts.first.userAnswers.cast(_currentOrLastQuestion);

    // return _allAnsweredQuest2s
    //     .whereType<Quest2<String, List<ScreenAreaWidgetSlot>>>()
    //     .where((q) => q.appScreen == as && q.screenWidgetArea == area)
    //     .map((q) => q.response?.answers ?? [])
    //     .fold<List<ScreenAreaWidgetSlot>>(
    //         [], (l0, l1) => l0..addAll(l1)).toList();
  }

  // void _sortPendingQuestions() {
  //   // its important that we ONLY sort the section AFTER _currQuest2Idx
  //   // or else we might re-ask prior (already answered) Quest2s
  //   if (_currQuestionIdx < 7) return;

  //   print('running sortPendingQuest2s');

  //   var unaskedQuests = _pendingQuestions.sublist(_currQuestionIdx + 1);

  //   unaskedQuests.sort((a, b) => a.sortKey.compareTo(b.sortKey));

  //   this._pendingQuestions = (_pendingQuestions.sublist(0, _currQuestionIdx + 1)
  //     ..addAll(unaskedQuests));
  // }

  QuestBase? nextQuestionToAnswer() {
    // AppScreen section
    _moveCurrentQuestToAnswered();
    //
    if (_currQuestionIdx + 1 >= _pendingQuestions.length) {
      return null;
    }
    ++_currQuestionIdx;
    return _currentOrLastQuestion;
  }

  void _moveCurrentQuestToAnswered() {
    // dont add at start or end
    if (_currQuestionIdx < 0 ||
        totalAnsweredQuestions >= _pendingQuestions.length) return;
    //
    List<QuestBase> lstQuestInCurScreen =
        _answeredQuestsByScreen[_currentOrLastQuestion.appScreen] ?? [];
    // attach in case list was missing
    _answeredQuestsByScreen[_currentOrLastQuestion.appScreen] =
        lstQuestInCurScreen;

    QuestBase? mostRecentSaved;
    if (lstQuestInCurScreen.length > 0) {
      mostRecentSaved = lstQuestInCurScreen.last;
    }
    // dont store same Question twice; code lingers on last question
    if (mostRecentSaved != null &&
        mostRecentSaved.questId == _currentOrLastQuestion.questId &&
        _notYetAtEnd) {
      //
      print(
        'Error: QID: ${mostRecentSaved.questId} seemd to be duplicate & wasnt moved into _answeredQuestsBySection',
      );
      return;
    }
    // store into list for this section;  but DO NOT remove from pendingQuest2s or messes up cur_idx tracking
    lstQuestInCurScreen.add(_currentOrLastQuestion);
  }

  void loadInitialQuestions() {
    //
    _pendingQuestions = loadInitialConfigQuestions();
    _questCountByScreen[AppScreen.eventConfiguration] =
        _pendingQuestions.length;
    // int c = 0;
    // _pendingQuest2s.forEach((q) {
    //   q.Quest2Id = ++c;
    // });
  }

  void addImplicitAnswers(
    List<QuestBase> implicitlyAnsweredQuests, {
    String dbgNam = 'init', // debug-name
  }) {
    var alreadyAnsweredQuests =
        _pendingQuestions.sublist(0, _currQuestionIdx + 1);
    alreadyAnsweredQuests.addAll(implicitlyAnsweredQuests);

    var unaskedQuests = _pendingQuestions.sublist(_currQuestionIdx + 1);

    this._pendingQuestions = alreadyAnsweredQuests..addAll(unaskedQuests);
  }

  void appendNewQuestions(
    List<QuestBase> quests, {
    String dbgNam = 'apndNewQs', // debug-name
  }) {
    //
    Set<AppScreen> appScreensSet = quests.map((e) => e.appScreen).toSet();

    print(
        '$dbgNam is adding ${quests.length} new Questions for these screens $appScreensSet');

    for (AppScreen as in appScreensSet) {
      int newCntBySec = quests
          .where((q) => q.appScreen == as)
          .fold<int>(0, (accumVal, _) => accumVal + 1);
      _questCountByScreen[as] = (_questCountByScreen[as] ?? 0) + newCntBySec;
    }
    // quest id's start at 1, not zero
    // int c = _pendingQuest2s.length;
    // quests.forEach((q) {
    //   q.Quest2Id = ++c;
    // });
    this._pendingQuestions.addAll(quests);

    // TODO:  test sorting after everything else is working
    // sorting not working and not necessary
    // _sortPendingQuest2s();
  }

  int get priorAnswerCount => priorAnswers.length;

  List<CaptureAndCast> get priorAnswers {
    // return all existing user answers
    // filter out any null responses
    List<Iterable<CaptureAndCast>> lstLstCc =
        _allAnsweredQuestions.map((q) => q.listResponses).toList();

    List<CaptureAndCast<dynamic>> resLst = lstLstCc.fold<List<CaptureAndCast>>(
        <CaptureAndCast>[], (l1, l2) => l1..addAll(l2));

    return resLst.toList();
  }
}
