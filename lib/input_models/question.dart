part of EventCfgModels;

class Question<T> {
  String quest;
  int order;
  late UserResponse<T> response;

  Question(this.order, this.quest);

  void askAndWait() {
    print(quest);
    var userResp = stdin.readLineSync() ?? '-1';
    int answerIdx = int.parse(userResp);
    print("number you entered is: $answerIdx");

    var answer = answerIdx as T;
    response = UserResponse<T>(answer);
  }

  static List<Question> loadForSection(AppSection appSection) {
    return [];
  }
}
