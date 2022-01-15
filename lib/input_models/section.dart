part of EventCfgModels;

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

  void loadQuestions() {
    //
    _questions = Question.loadForSection(appSection);
  }

  bool askIfNeeded() {
    print(appSection.includeStr + '(enter y/yes or n/no)');
    var userResp = stdin.readLineSync() ?? 'Y';
    print("you entered is: $userResp");
    return userResp.toUpperCase().startsWith('Y');
  }

  Question? getNextQuestion() {
    currQuestIdx += 1;
    if (currQuestIdx - 1 > _questions.length) return null;

    return _questions[currQuestIdx];
  }
}
