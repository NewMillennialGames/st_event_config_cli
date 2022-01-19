part of InputModels;

typedef CastUserInputToTyp<InputTyp, AnsTyp> = AnsTyp Function(InputTyp input);
// to load prior answers for some questions
typedef PriorAnswersCallback = List<UserResponse> Function();

class Question<ConvertTyp, AnsTyp> extends Equatable {
  final QuestionQuantifier qQant;
  final String question;
  final Iterable<String>? answerChoices;
  final CastUserInputToTyp<ConvertTyp, AnsTyp>? castFunc;
  final int defaultAnswerIdx;
  final bool dynamicFromPriorState;
  final bool acceptsMultiResponses = false;
  // set later
  bool shouldSkip = false;
  int questionId = 0;
  UserResponse<AnsTyp>? response;

  Question(
    this.qQant,
    this.question,
    this.answerChoices,
    this.castFunc, {
    this.defaultAnswerIdx = 1,
    this.dynamicFromPriorState = false,
  });
  // getters
  bool get isRuleQuestion => false;
  AppSection get appSection => qQant.appSection;
  SectionUiArea? get uiComponent => qQant.uiCompInSection;

  List<String>? get choices => answerChoices?.toList();
  bool get hasChoices => (answerChoices?.length ?? 0) > 0;
  bool get capturesScalarValues => qQant.capturesScalarValues;
  bool get addsOrDeletesFutureQuestions => qQant.addsOrDeletesFutureQuestions;
  bool get producesVisualRules => qQant.producesVisualRules;
  bool get producesBehavioralRules => qQant.producesBehavioralRules;
  // building other questions based on prior answers
  bool get generatesScreenComponentQuestions =>
      addsOrDeletesFutureQuestions && AnsTyp is List<SectionUiArea>;
  bool get generatesVisRuleTypeQuestions =>
      addsOrDeletesFutureQuestions &&
      qQant.uiCompInSection != null &&
      AnsTyp is List<VisualRuleType>;
  bool get generatesBehRuleTypeQuestions =>
      addsOrDeletesFutureQuestions &&
      qQant.uiCompInSection != null &&
      AnsTyp is List<BehaviorRuleType>;

  void askAndWait(DialogRunner dlogRunner) {
    //
    _configSelfIfNecessary(dlogRunner.getPriorAnswersList);

    String? userResp = stdin.readLineSync();
    print("You entered: '$userResp'");

    int answerIdx = -1;
    AnsTyp? derivedUserResponse;
    if (ConvertTyp == int) {
      if (userResp != null) {
        answerIdx = int.tryParse(userResp) ?? -1;
      }
      if (answerIdx == -1 && (hasChoices || !capturesScalarValues)) {
        answerIdx = defaultAnswerIdx;
      }
      print('calling int converter ($answerIdx) on $question');
      derivedUserResponse = _castResponseToAnswer(answerIdx as ConvertTyp);
    } else if (ConvertTyp == String) {
      print('calling string converter ($userResp) on $question');
      derivedUserResponse = _castResponseToAnswer(userResp as ConvertTyp);
    } else {
      var t = typeOf<ConvertTyp>().toString();
      throw UnimplementedError('wtf $t');
    }

    // verify we got a value
    if (derivedUserResponse == null) {
      throw UnimplementedError('no conversion of $userResp or $answerIdx');
      // print('answer was null on $questionId: $question');
      // return;
    }
    this.response = UserResponse<AnsTyp>(derivedUserResponse);
    print("You entered: '$userResp' and ${derivedUserResponse.toString()}");
    _handleCreatingNewQuestions(dlogRunner);
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

  void _handleCreatingNewQuestions(DialogRunner dlogRunner) {
    //
    if (this.generatesScreenComponentQuestions) {
      //
      dlogRunner.generateAssociatedUiComponentQuestions(
        appSection,
        this.response as UserResponse<List<SectionUiArea>>,
      );
    } else if (this.generatesVisRuleTypeQuestions) {
      //
      dlogRunner.generateAssociatedUiRuleTypeQuestions(
        this.qQant.uiCompInSection!,
        this.response as UserResponse<List<VisualRuleType>>,
      );
    } else if (this.generatesBehRuleTypeQuestions) {
      //
      dlogRunner.generateAssociatedBehRuleTypeQuestions(
        this.qQant.uiCompInSection!,
        this.response as UserResponse<List<BehaviorRuleType>>,
      );
    }
  }

  // next two methods are for possible future usage?
  void _configSelfIfNecessary(PriorAnswersCallback getPriorAnswersList) {
    // some questions are based on what answers came before
    if (dynamicFromPriorState) {
      // assert(getPriorAnswersList != null,
      //     'this question needs to examine prior answers to decide what to ask');
      _deriveFromPriorAnswers(getPriorAnswersList());
    }
  }

  void _deriveFromPriorAnswers(List<UserResponse> answers) {
    /* 
    some questions need to review prior state
    before we know their shape or whether they
    should even be asked
    */
    this.shouldSkip = true;
  }

  // impl for equatable
  // but really being used as a search filter
  // to find questions in a specific granularity
  @override
  List<Object> get props => [qQant];

  @override
  bool get stringify => true;
}

// class Qb<ConvertTyp, AnsTyp> {
//   // Qb == question body
//   // simple class to hold question data
//   // ConvertTyp == data-type of user response (string or int from CLI)
//   // ConvertTyp may be different for the web UI
//   // AnsTyp == real answer data-type after conversion of ConvertTyp

//   QuestionQuantifier qq;
//   String question;
//   Iterable<String>? answerChoices;
//   CastUserInputToTyp<ConvertTyp, AnsTyp>? castFunc;
//   int defaultAnswerIdx;
//   bool dynamicFromPriorState;
//   bool shouldSkip = false;
//   bool acceptsMultiResponses = false;

//   Qb(
//     this.qq,
//     this.question,
//     this.answerChoices,
//     this.castFunc, {
//     this.defaultAnswerIdx = 1,
//     this.dynamicFromPriorState = false,
//   });

//   // getters
//   AppSection get section => qq.appSection;
//   UiComponent? get uiComp => qq.uiCompInSection;
//   bool get capturesScalarValues => qq.capturesScalarValues;
//   bool get addsOrDeletesFutureQuestions => qq.addsOrDeletesFutureQuestions;
//   bool get producesVisualRules => qq.producesVisualRules;
//   bool get producesBehavioralRules => qq.producesBehavioralRules;
//   Type get convertType => ConvertTyp;
//   // Type get convertType => typeOf<ConvertTyp>();
//   Type get answerType => AnsTyp;

//   void deriveFromPriorAnswers(List<UserResponse> answers) {
//     /*
//     some questions need to review prior state
//     before we know their shape or whether they
//     should even be asked
//     */
//     this.shouldSkip = true;
//   }
// }
