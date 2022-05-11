part of RandDee;

class QDefCollection {
  /* describes iteration qualities of a given question

  */
  List<QuestPromptInstance> questIterations;
  bool isRuleQuestion;
  int _curPartIdx = -1;

  QDefCollection(
    this.questIterations, {
    this.isRuleQuestion = false,
  });

  // getters
  int get _partCount => questIterations.length;
  bool get isCompleted => _curPartIdx >= _partCount - 1;
  bool get isMultiPart => _partCount > 1;
  // QuestPromptInstance get _curQuestion => questIterations[_curPartIdx];
  QuestPromptInstance? getNextUserPromptIfExists() {
    _curPartIdx++;
    if (_curPartIdx > _partCount - 1) return null;
    return questIterations[_curPartIdx];
  }

  Iterable<VisRuleQuestType> get visQuestTypes =>
      questIterations.map((e) => e.visQuestType);

  // Iterable<AnswTypValMap> get allTypedAnswers =>
  //     questIterations.map((sqi) => sqi.answerPayload);

  // List<QuestChoiceOption> get curQAnswerOptions => _curQuestion.questsAndChoices;

  // SubmitUserResponseFunc get storeUserReponse => _storeUserReponse;

  // void _storeUserReponse(String resp) {
  //   //
  //   assert(nextPart != null, 'no current question');
  //   nextPart.answerPayload.answers.
  // }

  // factory QuestIterDef.fromRuleTyp(VisualRuleType ruleTyp) {
  //   // use VisualRuleType to get list of sub-questions
  //   // and their respective choice options
  //   List<VisRuleQuestWithChoices> questsAndChoices =
  //       getSubQuestionsAndChoiceOptions(ruleTyp);
  //   return QuestIterDef._(ruleTyp, questsAndChoices);
  // }

  // factory QuestIterDef.fromGenOptions(PerQuestGenOptions genOpt) {
  //   //
  //   var qwc = VisRuleQuestWithChoices(
  //       genOpt.ruleQuestType!, genOpt.answerChoices.toList());
  //   return QuestIterDef._(genOpt.ruleType!, [qwc]);
  // }
}


  // factory QDefCollection.fromMap(
  //   Map<String, List<String>> questIterations, {
  //   bool isRuleQuestion = false,
  // }) {
  //   List<SingleQPromptInstance> l =
  //       SingleQPromptInstance.fromMap(questIterations);
  //   return QDefCollection(
  //     l,
  //     isRuleQuestion: isRuleQuestion,
  //   );
  // }