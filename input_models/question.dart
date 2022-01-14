part of EventCfgModels;

class Question {
  String quest;
  int order;

  Question(this.order, this.quest);

  UserResponse askAndWait() {
    print(quest);
    var userResp = stdin.readLineSync() ?? '-1';
    int answerIdx = int.parse(userResp);
    print("number you entered is: $answerIdx");

    return UserResponse();
  }

  static List<Question> loadForSection(AppSection appSection) {
    return [];
  }
}
