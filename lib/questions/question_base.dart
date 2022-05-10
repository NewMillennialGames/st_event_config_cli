part of QuestionsLib;

// to load prior answers for some questions
// typedef PriorAnswersCallback = List<UserResponse> Function();

class Question<ConvertTyp, AnsTyp> extends Equatable {
  //
  final QTargetQuantify qQuantify;
  final String _questStr;
  final Iterable<String>? _answerChoices;
  // castFunc not used on Rule-Type-Questions
  final CastUserInputToTyp<ConvertTyp, AnsTyp>? castFunc;
  final int defaultAnswerIdx;
  final bool acceptsMultiResponses;
  final bool isNotForOutput;
// unique value for expedited matching
  String questionId = '';
  UserResponse<AnsTyp>? response;

  Question(
    this.qQuantify,
    this._questStr,
    this._answerChoices,
    this.castFunc, {
    this.defaultAnswerIdx = 1,
    this.acceptsMultiResponses = false,
    this.isNotForOutput = false,
    String? questId,
  }) : questionId = questId == null ? qQuantify.sortKey : questId;
  // getters
  String get questStr => _questStr;
  bool get isRuleQuestion =>
      this is VisualRuleQuestion || this is BehaveRuleQuestion;

  bool get isTopLevelConfigOrScreenQuestion =>
      qQuantify.isTopLevelConfigOrScreenQuestion;
  List<String>? get answerChoicesList => _answerChoices?.toList();
  bool get hasChoices => (_answerChoices?.length ?? 0) > 0;

  // quantified info
  AppScreen get appScreen => qQuantify.appScreen;
  ScreenWidgetArea? get screenWidgetArea => qQuantify.screenWidgetArea;
  ScreenAreaWidgetSlot? get slotInArea => qQuantify.slotInArea;
  //
  VisualRuleType? get visRuleTypeForAreaOrSlot =>
      qQuantify.visRuleTypeForAreaOrSlot;
  BehaviorRuleType? get behRuleTypeForAreaOrSlot =>
      qQuantify.behRuleTypeForAreaOrSlot;
  //

  // below controls how each question causes cascade creation of new questions
  bool get generatesNoNewQuestions => qQuantify.generatesNoNewQuestions;

  bool get asksWhichScreensToConfig =>
      qQuantify.appScreen == AppScreen.eventConfiguration &&
      AnsTyp == List<AppScreen>;

  bool get addsWhichAreaInSelectedScreenQuestions =>
      qQuantify.addsWhichAreaInSelectedScreenQuestions &&
      appScreen == AppScreen.eventConfiguration &&
      AnsTyp == List<AppScreen>;

  bool get addsWhichRulesForSelectedAreaQuestions =>
      qQuantify.addsWhichRulesForSelectedAreaQuestions &&
      AnsTyp == List<ScreenWidgetArea>;

  bool get addsWhichSlotOfSelectedAreaQuestions =>
      qQuantify.addsWhichSlotOfSelectedAreaQuestions &&
      AnsTyp == List<ScreenWidgetArea>;

  bool get addsWhichRulesForSlotsInArea =>
      qQuantify.addsWhichRulesForSlotsInArea &&
      AnsTyp == List<ScreenAreaWidgetSlot>;

  bool get addsRuleDetailQuestsForSlotOrArea =>
      qQuantify.addsRuleDetailQuestsForSlotOrArea;

  // bool get addsBehavioralRuleQuestions => qQuantify.addsBehavioralRuleQuestions;

  String get sortKey => qQuantify.sortKey;
  // ask 2nd & 3rd position for (sort, group, filter)
  // bool get gens2ndOr3rdSortGroupFilterQuests => false;

  // appliesToClientConfiguration == should be exported to file
  bool get appliesToClientConfiguration =>
      isRuleQuestion || appScreen == AppScreen.eventConfiguration;

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
    // print('\n\nResp: $derivedUserResponse');
    this.response = UserResponse<AnsTyp>(derivedUserResponse);
  }

  Question fromExisting(
    String quStr,
    PerQuestGenOptions pqt,
  ) {
    // used to create derived questions from existing answers
    QTargetQuantify newQq = pqt.qQuantUpdater(this.qQuantify);
    String newId = pqt.questId.isNotEmpty
        ? pqt.questId
        : (this.questionId + ':' + newQq.sortKey);
    return Question<String, dynamic>(
      newQq,
      quStr,
      pqt.answerChoices,
      pqt.castFunc,
      defaultAnswerIdx: pqt.defaultAnswerIdx,
      questId: newId,
    );
  }

  AnsTyp? _castResponseToAnswer(ConvertTyp convertibleVal) {
    // ConvertTyp must be either String or int
    // AnsTyp is typically a string or whatever returned from: castFunc()

    try {
      if (convertibleVal is String) {
        if (this.castFunc != null) {
          return castFunc!(convertibleVal);
        } else {
          return convertibleVal as AnsTyp?;
        }
      }
    } catch (e) {
      //
      print('Err: Str $convertibleVal was invalid or out of range');
      return null;
    }

    assert(convertibleVal == int, 'wtf?');

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

  // impl for equatable
  // but really being used as a search filter
  // to find questions in a specific granularity
  @override
  List<Object> get props => [qQuantify];

  @override
  bool get stringify => true;
}




  // // next two methods are for possible future usage?
  // void configSelfIfNecessary(PriorAnswersCallback getPriorAnswersList) {
  //   // some questions are based on what answers came before
  //   if (false) {
  //     // dynamicFromPriorState
  //     // assert(getPriorAnswersList != null,
  //     //     'this question needs to examine prior answers to decide what to ask');
  //     _deriveFromPriorAnswers(getPriorAnswersList());
  //   }
  // }

  // void _deriveFromPriorAnswers(List<UserResponse> answers) {
  //   /* 
  //   some questions need to review prior state
  //   before we know their shape or whether they
  //   should even be asked
  //   */
  //   // this.shouldSkip = true;
  // }