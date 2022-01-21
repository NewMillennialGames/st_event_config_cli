part of InputModels;

// to load prior answers for some questions
typedef PriorAnswersCallback = List<UserResponse> Function();

class Question<ConvertTyp, AnsTyp> extends Equatable {
  //
  final QuestionQuantifier qQuantify;
  final String question;
  final Iterable<String>? _answerChoices;
  // castFunc not used on Rule-Type-Questions
  final CastUserInputToTyp<ConvertTyp, AnsTyp>? castFunc;
  final int defaultAnswerIdx;
  final bool dynamicFromPriorState;
  final bool acceptsMultiResponses;
  // set later
  bool shouldSkip = false;
  int questionId = 0;
  UserResponse<AnsTyp>? response;

  Question(
    this.qQuantify,
    this.question,
    this._answerChoices,
    this.castFunc, {
    this.defaultAnswerIdx = 1,
    this.dynamicFromPriorState = false,
    this.acceptsMultiResponses = false,
  });
  // getters
  bool get isRuleQuestion => false;
  bool get isTopLevelConfigOrScreenQuestion =>
      qQuantify.isTopLevelConfigOrScreenQuestion;
  List<String>? get answerChoicesList => _answerChoices?.toList();
  bool get hasChoices => (_answerChoices?.length ?? 0) > 0;

  // quantified info
  AppScreen get appScreen => qQuantify.appScreen;
  ScreenWidgetArea? get screenWidgetArea => qQuantify.screenWidgetArea;
  SubWidgetInScreenArea? get slotInArea => qQuantify.slotInArea;
  //
  VisualRuleType? get visRuleTypeForSlotInArea =>
      qQuantify.visRuleTypeForSlotInArea;
  BehaviorRuleType? get behRuleTypeForSlotInArea =>
      qQuantify.behRuleTypeForSlotInArea;
  //

  // below controls how each question causes cascade creation of new questions
  bool get generatesNoNewQuestions => qQuantify.generatesNoNewQuestions;
  bool get asksWhichScreensToConfig =>
      qQuantify.appScreen == AppScreen.eventConfiguration &&
      response?.answers is List<AppScreen>;
  bool get asksAreasWithinSelectedScreens =>
      qQuantify.asksAreasWithinSelectedScreens;
  bool get asksSlotsWithinSelectedScreenAreas =>
      qQuantify.asksSlotsWithinSelectedScreenAreas;
  bool get asksRuleTypesForSelectedAreasOrSlots =>
      qQuantify.asksRuleTypesForSelectedAreasOrSlots;
  bool get asksDetailsForEachVisualRuleType =>
      qQuantify.asksDetailsForEachVisualRuleType;
  bool get asksDetailsForEachBehaveRuleType =>
      qQuantify.asksDetailsForEachBehaveRuleType;

  void convertAndStoreUserResponse(String userResp) {
    //
    int answerIdx = -1;
    AnsTyp? derivedUserResponse;
    if (ConvertTyp == int) {
      if (userResp != null) {
        answerIdx = int.tryParse(userResp) ?? -1;
      }
      if (answerIdx == -1 && (hasChoices)) {
        answerIdx = defaultAnswerIdx;
      }
      // print('calling int converter ($answerIdx) on $question');
      derivedUserResponse = _castResponseToAnswer(answerIdx as ConvertTyp);
    } else if (ConvertTyp == String) {
      // print('calling string converter ($userResp) on $question');
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
    print('Response: $derivedUserResponse');
    this.response = UserResponse<AnsTyp>(derivedUserResponse);
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
      if (answerChoicesList != null) {
        answer = answerChoicesList![answerIdx] as AnsTyp;
      } else {
        answer = convertibleVal as AnsTyp;
      }
    }
    return answer;
  }

  // next two methods are for possible future usage?
  void configSelfIfNecessary(PriorAnswersCallback getPriorAnswersList) {
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
  List<Object> get props => [qQuantify];

  @override
  bool get stringify => true;
}
