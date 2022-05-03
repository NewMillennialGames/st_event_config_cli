part of RandDee;

typedef CastStrToAnswTypCallback<T> = T Function(UserChoiceCollection, String);

class UserChoice {
  //
  final String displayStr;
  final String selectVal;

  UserChoice(
    this.displayStr,
    this.selectVal,
  );
}

class UserChoiceCollection<T> {
  //
  final List<UserChoice> answChoices;
  final int idxOfDefaultAnsw;
  final bool multiAllowed;

  UserChoiceCollection(
    this.answChoices, {
    this.idxOfDefaultAnsw = 0,
    this.multiAllowed = false,
  });

  factory UserChoiceCollection.fromList(
    List<String> strChoices, {
    int defaultIdx = 0,
    bool multiAllowed = false,
  }) {
    //
    List<UserChoice> answChoices = [];
    int idx = 0;
    strChoices.forEach((s) {
      answChoices.add(UserChoice(s, '$idx'));
      idx++;
    });
    return UserChoiceCollection(
      answChoices,
      idxOfDefaultAnsw: defaultIdx,
      multiAllowed: multiAllowed,
    );
  }

  bool get hasChoices => answChoices.length > 0;
}

class SingleQuestIteration<RespOutTyp> {
  /* describes each part of a question iteration
    including 
  */
  final String userPrompt;
  final UserChoiceCollection<RespOutTyp> answChoiceCollection;
  final CastStrToAnswTypCallback<RespOutTyp> castUserRespCallbk;
  late final RespOutTyp userAnswChoice;

  SingleQuestIteration(
    this.userPrompt,
    this.answChoiceCollection,
    this.castUserRespCallbk,
  );

  // getters
  bool get hasChoices => answChoiceCollection.hasChoices;
  Type get answType => RespOutTyp;

  RespOutTyp typedUserAnsw(String userResponses) {
    this.userAnswChoice =
        castUserRespCallbk(answChoiceCollection, userResponses);
    return userAnswChoice;
  }

  AnswTypValMap get answerPayload => AnswTypValMap<RespOutTyp>(userAnswChoice);
}

class QuestIterDef {
  /* describes iteration qualities of a given question

  */
  List<SingleQuestIteration> questIterations;
  bool isRuleQuestion;
  int _curPartIdx = -1;

  QuestIterDef._(
    this.questIterations, {
    this.isRuleQuestion = false,
  });

  factory QuestIterDef.fromList(
    List<SingleQuestIteration> questIterations, {
    bool isRuleQuestion = false,
  }) {
    // NIU;  make more convenient
    return QuestIterDef._(
      questIterations,
      isRuleQuestion: isRuleQuestion,
    );
  }

  // getters
  int get _partCount => questIterations.length;
  bool get isCompleted => _curPartIdx >= _partCount - 1;
  bool get isMultiPart => _partCount > 1;
  SingleQuestIteration? get nextPart {
    _curPartIdx++;
    if (_curPartIdx > _partCount - 1) return null;
    return questIterations[_curPartIdx];
  }

  Iterable<AnswTypValMap> get allTypedAnswers =>
      questIterations.map((sqi) => sqi.answerPayload);
}
