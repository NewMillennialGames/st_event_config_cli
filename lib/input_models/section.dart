part of CfgInputModels;

class DialogSectionCfg {
  //
  AppSection appSection;
  int _processedQuestCount = 0;
  List<Question> _questions = [];
  int currQuestIdx = -1;

  DialogSectionCfg(this.appSection);

  bool get wasProcessed => _processedQuestCount > 0;
  int get order => appSection.index;
  String get name => appSection.name;

  List<UserResponse> get priorAnswers {
    // skip questions where user-response is null
    return _questions
        .sublist(0, currQuestIdx - 1)
        .map((q) => q.response)
        .whereType<UserResponse>()
        .toList();
  }

  void loadQuestions() {
    //
    _questions = loadQuestionsForSection(appSection);
  }

  void appendQuestions(int idx, List<Question> newQuestions) {
    _questions.addAll(newQuestions);
  }

  bool askIfNeeded() {
    if (!appSection.isConfigureable) return false;

    print(appSection.includeStr + '(enter y/yes or n/no)');
    var userResp = stdin.readLineSync() ?? 'Y';
    print("askIfNeeded got: $userResp");
    return userResp.toUpperCase().startsWith('Y');
  }

  Question? getNextQuestion() {
    ++currQuestIdx;
    if (currQuestIdx >= _questions.length) return null;

    return _questions[currQuestIdx];
  }
}
