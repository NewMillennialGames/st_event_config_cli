part of CfgInputModels;

typedef CastIdxToTyp<AnsTyp, InputTyp> = AnsTyp Function(InputTyp idx);
// to load prior answers for some questions
typedef PriorAnswersCallback = List<UserResponse> Function();

class Qb<AnsTyp, ConvertTyp> {
  // Qb == question body
  // simple class to hold question data
  // T == data-type of user response
  // ConvertTyp in [int, string]
  AppSection section;
  String question;
  Iterable<String>? answerChoices;
  CastIdxToTyp<AnsTyp, ConvertTyp>? castFunc;
  int defaultAnswerIdx;
  bool dynamicFromPriorState;
  bool generatesMoreQuestions = false;
  UiComponent? uiComp;
  bool shouldSkip = false;

  Qb(
    this.section,
    this.question,
    this.answerChoices,
    this.castFunc, {
    this.defaultAnswerIdx = 1,
    this.dynamicFromPriorState = false,
    this.generatesMoreQuestions = false,
    this.uiComp,
  });

  void deriveFromPriorAnswers(List<UserResponse> answers) {
    /* 
    some questions need to review prior state
    before we know their shape or whether they
    should even be asked
    */
    this.shouldSkip = true;
  }
}

class Question<AnsTyp, ConvertTyp> {
  int questionId;
  Qb<AnsTyp, ConvertTyp> _quest;
  UserResponse<AnsTyp>? response;

  Question(
    this.questionId,
    this._quest,
  );
  // getters
  String get question => _quest.question;
  AppSection get section => _quest.section;
  List<String>? get choices => _quest.answerChoices?.toList();
  CastIdxToTyp<AnsTyp, ConvertTyp>? get castFunc => _quest.castFunc;

  // building other questions based on prior answers
  bool get generatesScreenComponentQuestions =>
      _quest.generatesMoreQuestions && AnsTyp is List<UiComponent>;
  bool get generatesRuleTypeQuestions =>
      _quest.generatesMoreQuestions && AnsTyp is List<RuleType>;

  void askAndWait(Dialoger dialoger) {
    //
    _configSelfIfNecessary(dialoger.getPriorAnswerCallback);
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

    AnsTyp? answer;
    if (ConvertTyp is int) {
      answer = _castResponseToAnswer(answerIdx as ConvertTyp);
    } else if (ConvertTyp is String) {
      answer = _castResponseToAnswer(userResp as ConvertTyp);
    }

    // verify we got a value
    if (answer == null) {
      print('answer was null on $questionId: $question');
      return;
    }

    this.response = UserResponse<AnsTyp>(answer);
    // if (answer is Iterable) {
    //   this.response = UserResponse<AnsTyp>(answer);
    // } else {
    //   this.response = UserResponse<AnsTyp>(answer);
    // }

    if (this.generatesScreenComponentQuestions) {
      dialoger.generateAssociatedUiComponentQuestions(
        section,
        this.response as UserResponse<List<UiComponent>>,
      );
    } else if (this.generatesRuleTypeQuestions) {
      // FIXME
      dialoger.generateAssociatedUiRuleTypeQuestions(
        UiComponent.banner,
        this.response as UserResponse<List<RuleType>>,
      );
    }
  }

  void _configSelfIfNecessary(PriorAnswersCallback getPriorAnswersList) {
    // some questions are based on what answers came before
    if (_quest.dynamicFromPriorState) {
      assert(getPriorAnswersList != null,
          'this question needs to examine prior answers to decide what to ask');
      _quest.deriveFromPriorAnswers(getPriorAnswersList());
    }
  }

  AnsTyp? _castResponseToAnswer(ConvertTyp convertibleVal) {
    // ConvertTyp must be either String or int
    // AnsTyp is typically a string or whatever returned from: castFunc()
    if (convertibleVal is String) {
      if (this.castFunc != null) {
        return castFunc!(convertibleVal);
      } else {
        return convertibleVal as AnsTyp?;
      }
    }

    assert(convertibleVal is int, 'wtf?');

    AnsTyp? answer;
    if (castFunc != null) {
      answer = castFunc!(convertibleVal);
    } else {
      int answerIdx = convertibleVal as int;
      if (choices != null) {
        answer = choices![answerIdx] as AnsTyp;
      } else {
        answer = convertibleVal as AnsTyp;
      }
    }
    return answer;
  }
}
