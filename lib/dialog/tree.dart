part of ConfigDialogRunner;

class DialogTree {
  //
  List<Question> _questions = [];
  int currQuestionIdx = -1;
  List<Question> _answeredQuestions = [];

  // constructor
  DialogTree();

  //
  List<UserResponse> get priorAnswers {
    //
    return _answeredQuestions
        .map((e) => e.response)
        .whereType<UserResponse>()
        .toList();
  }

  void loadQuestions(AppSection appSection) {
    //
  }

  void insertNewQuestions(
    int currQuestIdx,
    List<Question> newQuestions,
  ) {
    //
    // currentSectionCfg.appendQuestions(currQuestIdx, newQuestions);
    _questions.addAll(newQuestions);
  }
}
