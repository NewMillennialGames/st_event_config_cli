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
  int _currQuest2Idx = -1;
  List<QuestBase> _pendingQuest2s = [];
  Map<AppScreen, int> _questCountBySection = {};
  Map<AppScreen, List<QuestBase>> _answeredQuestsBySection = {};

  // constructor
  QuestListMgr();

  //
  List<QuestBase> get exportableQuest2s =>
      _allAnsweredQuest2s.where(_exportFilterLogic).toList();

  bool _exportFilterLogic(QuestBase q) {
    // print(
    //   'QID: ${q.Quest2Id}  runtimeType: ${q.runtimeType}  appliesToClientConfiguration: ${q.appliesToClientConfiguration}',
    // );
    return q.appliesToClientConfiguration;
  }

  List<QuestBase> get pendingQuest2s => _pendingQuest2s;
  QuestBase get _currentOrLastQuest2 => _pendingQuest2s[_currQuest2Idx];
  int get totalAnsweredQuest2s => _answeredQuestsBySection.values
      .fold<int>(0, (r, qLst) => r + qLst.length);

  int get pendingQuest2Count => _pendingQuest2s.length - _currQuest2Idx;

  List<QuestBase> get _allAnsweredQuest2s =>
      _answeredQuestsBySection.values.fold<List<QuestBase>>(
        [],
        (List<QuestBase> l0, List<QuestBase> l1) => l0..addAll(l1),
      );

  List<AppScreen> get userSelectedScreens {
    Iterable<QuestPromptInstance> matchingPrompts = _allAnsweredQuest2s
        .matchingPromptsWhere((qpi) => qpi.asksWhichScreensToConfig);

    List<AppScreen> uss = (matchingPrompts.first.userAnswers.cast() ?? []);

    print('userSelectedScreens has ${uss.length} items');
    return uss;
  }

  List<ScreenWidgetArea> configurableAreasForScreen(AppScreen as) {
    //
    Iterable<QuestPromptInstance> matchingPrompts = _allAnsweredQuest2s
        .where((q) => q.appScreen == as)
        .matchingPromptsWhere((qpi) => qpi.asksWhichAreasOfScreenToConfig);
    return matchingPrompts.first.userAnswers.cast();
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

    Iterable<QuestPromptInstance> matchingPrompts = _allAnsweredQuest2s
        .where((q) => q.appScreen == as && q.screenWidgetArea == area)
        .matchingPromptsWhere((qpi) => qpi.asksWhichAreasOfScreenToConfig);
    return matchingPrompts.first.userAnswers.cast();

    // return _allAnsweredQuest2s
    //     .whereType<Quest2<String, List<ScreenAreaWidgetSlot>>>()
    //     .where((q) => q.appScreen == as && q.screenWidgetArea == area)
    //     .map((q) => q.response?.answers ?? [])
    //     .fold<List<ScreenAreaWidgetSlot>>(
    //         [], (l0, l1) => l0..addAll(l1)).toList();
  }

  void _sortPendingQuest2s() {
    // its important that we ONLY sort the section AFTER _currQuest2Idx
    // or else we might re-ask prior (already answered) Quest2s
    if (_currQuest2Idx < 7) return;

    print('running sortPendingQuest2s');

    var unaskedQuests = _pendingQuest2s.sublist(_currQuest2Idx + 1);

    unaskedQuests.sort((a, b) => a.sortKey.compareTo(b.sortKey));

    this._pendingQuest2s =
        (_pendingQuest2s.sublist(0, _currQuest2Idx + 1)..addAll(unaskedQuests));
  }

  QuestBase? nextQuest2ToAnswer() {
    // AppScreen section
    _moveCurrentQuestToAnswered();
    //
    if (_currQuest2Idx + 1 >= _pendingQuest2s.length) {
      return null;
    }
    ++_currQuest2Idx;
    // if (_currentOrLastQuest2.appScreen != section) {
    //   --_currQuest2Idx;
    //   return null;
    // }
    return _currentOrLastQuest2;
  }

  void _moveCurrentQuestToAnswered() {
    // dont add at start or end
    if (_currQuest2Idx < 0 || totalAnsweredQuest2s >= _pendingQuest2s.length)
      return;
    //
    QuestBase? mostRecentSaved =
        _answeredQuestsBySection[_currentOrLastQuest2.appScreen]?.last;
    // dont store same Quest2 twice
    if (mostRecentSaved != null &&
        mostRecentSaved.questId == _currentOrLastQuest2.questId) {
      //
      print(
        'Error: QID: ${mostRecentSaved.questId} seemd to be duplicate & wasnt moved into _answeredQuestsBySection',
      );
      return;
    }
    ;
    // store into list for this section;  but DO NOT remove from pendingQuest2s or messes up cur_idx tracking
    var l = _answeredQuestsBySection[_currentOrLastQuest2.appScreen] ?? [];
    l.add(_currentOrLastQuest2);
    _answeredQuestsBySection[_currentOrLastQuest2.appScreen] = l;
  }

  void loadInitialQuest2s() {
    //
    _pendingQuest2s = loadInitialConfigQuest2s();
    _questCountBySection[AppScreen.eventConfiguration] = _pendingQuest2s.length;
    // int c = 0;
    // _pendingQuest2s.forEach((q) {
    //   q.Quest2Id = ++c;
    // });
  }

  void addImplicitAnswers(
    List<QuestBase> implicitlyAnsweredQuests, {
    String dbgNam = 'init', // debug-name
  }) {
    var alreadyAnsweredQuests = _pendingQuest2s.sublist(0, _currQuest2Idx + 1);
    alreadyAnsweredQuests.addAll(implicitlyAnsweredQuests);

    var unaskedQuests = _pendingQuest2s.sublist(_currQuest2Idx + 1);

    this._pendingQuest2s = alreadyAnsweredQuests..addAll(unaskedQuests);
  }

  void appendNewQuest2s(
    List<QuestBase> quests, {
    String dbgNam = 'init', // debug-name
  }) {
    //
    Set<AppScreen> newSections = quests.map((e) => e.appScreen).toSet();

    print('$dbgNam is adding ${quests.length} new Quest2s to $newSections');

    for (AppScreen as in newSections) {
      int newCntBySec = quests
          .where((q) => q.appScreen == as)
          .fold(0, (accumVal, _) => accumVal + 1);
      _questCountBySection[as] = (_questCountBySection[as] ?? 0) + newCntBySec;
    }
    // quest id's start at 1, not zero
    // int c = _pendingQuest2s.length;
    // quests.forEach((q) {
    //   q.Quest2Id = ++c;
    // });
    this._pendingQuest2s.addAll(quests);

    // TODO:  test sorting after everything else is working
    // sorting not working and not necessary
    // _sortPendingQuest2s();
  }

  List<CaptureAndCast> get priorAnswers {
    // return all existing user answers
    // filter out any null responses

    // return _allAnsweredQuest2s
    //     .map((e) => e.response)
    //     .whereType<UserResponse>()
    //     .toList();

    throw UnimplementedError('NIU???');
  }
}
