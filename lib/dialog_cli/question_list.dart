part of ConfigDialogRunner;

class QuestListMgr {
  /*
    does nothing but track and manage the full
    list of questions, both pending and completed/answered
  */
  int _currQuestionIdx = -1;
  List<Question> _pendingQuestions = [];
  Map<AppSection, int> _questCountBySection = {};
  Map<AppSection, List<Question>> _answeredQuestsBySection = {};

  // constructor
  QuestListMgr();

  //
  Question get _currentOrLastQuestion => _pendingQuestions[_currQuestionIdx];
  int get totalAnsweredQuestions => _answeredQuestsBySection.values
      .fold<int>(0, (r, qLst) => r + qLst.length);

  Question? _nextQuestionFor(AppSection section) {
    //
    _moveCurrentQuestToAnswered();
    //
    if (_currQuestionIdx + 1 >= _pendingQuestions.length) {
      return null;
    }
    ++_currQuestionIdx;
    if (_currentOrLastQuestion.appSection != section) {
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
        _answeredQuestsBySection[_currentOrLastQuestion.appSection]?.last;
    // dont store same question twice
    if (mostRecentSaved != null &&
        mostRecentSaved.questionId == _currentOrLastQuestion.questionId) return;
    // store into list for this section
    var l = _answeredQuestsBySection[_currentOrLastQuestion.appSection] ?? [];
    l.add(_currentOrLastQuestion);
    _answeredQuestsBySection[_currentOrLastQuestion.appSection] = l;
  }

  void loadInitialQuestions() {
    //
    _pendingQuestions = loadQuestionsForSection(AppSection.eventConfiguration);
    _questCountBySection[AppSection.eventConfiguration] =
        _pendingQuestions.length;
    int c = 0;
    _pendingQuestions.forEach((q) {
      q.questionId = ++c;
    });
  }

  void appendQuestions(
    AppSection section,
    List<Question> quests,
  ) {
    //
    _questCountBySection[section] =
        (_questCountBySection[section] ?? 0) + quests.length;

    int c = _pendingQuestions.length;
    quests.forEach((q) {
      q.questionId = ++c;
    });
    _pendingQuestions.addAll(quests);
  }

  List<UserResponse> get priorAnswers {
    // return all existing user answers

    // List<Question> l0, List<Question>
    List<Question> _allAnsweredQuestions =
        _answeredQuestsBySection.values.fold<List<Question>>(
      [],
      (l0, l1) => l0..addAll(l1),
    );

    return _allAnsweredQuestions
        .map((e) => e.response)
        .whereType<UserResponse>()
        .toList();
  }
}
