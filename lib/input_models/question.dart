part of EventCfgModels;

typedef CastIdxToTyp<T> = T Function(int idx);
// to load prior answers for some questions
typedef PriorAnswersCallback = List<UserResponse> Function();

class Qb<T> {
  // Qb == question body
  // simple class to hold question data
  // T == data-type of user response
  AppSection section;
  String question;
  Iterable<String>? answerChoices;
  CastIdxToTyp<T>? castFunc;
  int defaultAnswerIdx;
  bool dynamicFromPriorState;
  bool shouldSkip = false;

  Qb(
    this.section,
    this.question, [
    this.answerChoices,
    this.castFunc,
    this.defaultAnswerIdx = 1,
    this.dynamicFromPriorState = false,
  ]);

  void deriveFromPriorAnswers(List<UserResponse> answers) {
    /* 
    some questions need to review prior state
    before we know their shape or whether they
    should even be asked
    */
    this.shouldSkip = true;
  }
}

class Question<T> {
  int order;
  Qb<T> _quest;
  late UserResponse<T> response;

  Question(this.order, this._quest);
  // getters
  String get question => _quest.question;
  AppSection get section => _quest.section;
  List<String>? get choices => _quest.answerChoices?.toList();
  CastIdxToTyp<T>? get castFunc => _quest.castFunc;

  void askAndWait(PriorAnswersCallback? getPriorAnswersList) {
    //
    _configSelfIfNecessary(getPriorAnswersList);
    print(question);
    String? userResp = stdin.readLineSync();
    int answerIdx = -1;
    if (userResp != null) {
      answerIdx = int.tryParse(userResp) ?? -1;
    }
    if (answerIdx == -1) {
      answerIdx = _quest.defaultAnswerIdx;
    }
    print("You entered: $answerIdx (idx) and $userResp (val)");

    T? answer = _castResponseToAnswer(answerIdx, userResp ?? '');
    // verify we got a value
    if (answer == null) return;
    this.response = UserResponse<T>([answer]);
  }

  void _configSelfIfNecessary(PriorAnswersCallback? getPriorAnswersList) {
    // some questions are based on what answers came before
    if (_quest.dynamicFromPriorState) {
      assert(getPriorAnswersList != null,
          'this question needs to examine prior answers to decide what to ask');
      _quest.deriveFromPriorAnswers(getPriorAnswersList!());
    }
  }

  T? _castResponseToAnswer(int answerIdx, String userResp) {
    T? answer;
    if (castFunc != null) {
      answer = castFunc!(answerIdx);
    } else if (T.runtimeType == String) {
      if (choices != null) {
        answer = choices![answerIdx] as T;
      } else {
        answer = userResp as T;
      }
    } else {
      answer = answerIdx as T;
    }
    return answer;
  }
}
