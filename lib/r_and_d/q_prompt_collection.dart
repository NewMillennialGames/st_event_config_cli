part of RandDee;

class QPromptCollection {
  /* describes iteration qualities of a given QuestBase

  */
  List<QuestPromptInstance> questIterations;
  bool isRuleQuestion;
  int _curPartIdx = -1;

  QPromptCollection(
    this.questIterations, {
    this.isRuleQuestion = false,
  });

  factory QPromptCollection.singleDialog(
    String userPrompt,
    Iterable<String> choices,
    CaptureAndCast captureAndCast, {
    VisRuleQuestType questType = VisRuleQuestType.dialogStruct,
  }) {
    //
    QuestPromptInstance qpi = QuestPromptInstance.fromRaw(
        userPrompt, choices, questType, captureAndCast);
    return QPromptCollection([qpi]);
  }

  factory QPromptCollection.singleRule(
    String userPrompt,
    Iterable<String> choices,
    CaptureAndCast captureAndCast, {
    VisRuleQuestType questType = VisRuleQuestType.dialogStruct,
  }) {
    //
    QuestPromptInstance qpi = QuestPromptInstance.fromRaw(
        userPrompt, choices, questType, captureAndCast);
    return QPromptCollection([qpi], isRuleQuestion: true);
  }

  // getters
  int get _partCount => questIterations.length;
  bool get isCompleted => _curPartIdx >= _partCount - 1;
  bool get isMultiPart => _partCount > 1;
  // QuestPromptInstance get _curQuest2 => questIterations[_curPartIdx];
  QuestPromptInstance? getNextUserPromptIfExists() {
    _curPartIdx++;
    if (_curPartIdx > _partCount - 1) return null;
    return questIterations[_curPartIdx];
  }

  Iterable<VisRuleQuestType> get visQuestTypes =>
      questIterations.map((e) => e.visQuestType);

  // Iterable<AnswTypValMap> get allTypedAnswers =>
  //     questIterations.map((sqi) => sqi.answerPayload);

  // List<QuestChoiceOption> get curQAnswerOptions => _curQuest2.questsAndChoices;

  // SubmitUserResponseFunc get storeUserReponse => _storeUserReponse;

  // void _storeUserReponse(String resp) {
  //   //
  //   assert(nextPart != null, 'no current Quest2');
  //   nextPart.answerPayload.answers.
  // }

  // factory QuestIterDef.fromRuleTyp(VisualRuleType ruleTyp) {
  //   // use VisualRuleType to get list of sub-Quest2s
  //   // and their respective choice options
  //   List<VisRuleQuestWithChoices> questsAndChoices =
  //       getSubQuest2sAndChoiceOptions(ruleTyp);
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
  //   bool isRuleQuest2 = false,
  // }) {
  //   List<SingleQPromptInstance> l =
  //       SingleQPromptInstance.fromMap(questIterations);
  //   return QDefCollection(
  //     l,
  //     isRuleQuest2: isRuleQuest2,
  //   );
  // }