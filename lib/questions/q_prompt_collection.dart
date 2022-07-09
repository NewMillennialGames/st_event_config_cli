part of QuestionsLib;

class QPromptCollection {
  /* describes iteration (prompt) properties
   of a given QuestBase subclass

  */
  List<QuestPromptInstance> prompts;
  bool isRuleQuestion;
  int _curPartIdx = -1;

  QPromptCollection(
    this.prompts, {
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
      userPrompt,
      choices,
      questType,
      captureAndCast,
    );
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
      userPrompt,
      choices,
      questType,
      captureAndCast,
    );
    return QPromptCollection([qpi], isRuleQuestion: true);
  }

  factory QPromptCollection.fromListQpp(List<QuestPromptPayload> qpps) {
    //
    List<QuestPromptInstance> lstQpi = qpps.map((qpp) {
      return QuestPromptInstance.fromRaw(
        qpp.userPrompt,
        qpp.choices,
        qpp.questType,
        qpp.captureAndCast,
      );
    }).toList();
    return QPromptCollection(lstQpi);
  }

  static QPromptCollection fromList(List<QuestPromptPayload> qpp) {
    //
    // List<QPromptCollection> qpcLst = [];
    // qpp.forEach((qpp) {
    //   qpcLst.add();
    // });
    return QPromptCollection.fromListQpp(qpp);
  }

  static QPromptCollection pickAreasForScreen(AppScreen as) {
    // centralized this main prompt for testing ease
    List<ScreenWidgetArea> configurableAreas = as.configurableScreenAreas;

    List<ScreenWidgetArea> _castAnswer(QuestBase qb, String lstAreaIdxs) {
      return castStrOfIdxsToIterOfInts(lstAreaIdxs, dflt: 0)
          .map(
            (i) => configurableAreas[i],
          )
          .toList();
    }

    return QPromptCollection.singleDialog(
      'Select areas to config in screen ${as.name}',
      configurableAreas.map((a) => a.name),
      CaptureAndCast<List<ScreenWidgetArea>>(_castAnswer),
    );
  }

  static QPromptCollection selectTargetSlotsInArea(
    AppScreen as,
    ScreenWidgetArea swa,
  ) {
    List<ScreenAreaWidgetSlot> configurableSlots = swa.applicableWigetSlots(as);

    List<ScreenAreaWidgetSlot> _castAnswer(QuestBase qb, String lstAreaIdxs) {
      return castStrOfIdxsToIterOfInts(lstAreaIdxs, dflt: 0)
          .map(
            (i) => configurableSlots[i],
          )
          .toList();
    }

    return QPromptCollection.singleDialog(
      'Select slots to config in area ${swa.name} of screen ${as.name}',
      configurableSlots.map((a) => a.name),
      CaptureAndCast<List<ScreenAreaWidgetSlot>>(_castAnswer),
    );
  } //

  static QPromptCollection selectRulesForTarget(
    QTargetResolution qtr,
  ) {
    List<VisualRuleType> permissibleRules = qtr.possibleRulesAtAnyTarget;

    List<VisualRuleType> _castAnswer(QuestBase qb, String lstAreaIdxs) {
      return castStrOfIdxsToIterOfInts(lstAreaIdxs, dflt: 0)
          .map(
            (i) => permissibleRules[i],
          )
          .toList();
    }

    return QPromptCollection.singleDialog(
      'Select desired rules to apply on target ${qtr.targetPath}',
      permissibleRules.map((a) => a.name),
      CaptureAndCast<List<VisualRuleType>>(_castAnswer),
    );
  } //

  static QPromptCollection forRulePrepQuestion(
    QTargetResolution qtr,
  ) {
    VisualRuleType targetRule =
        qtr.visRuleTypeForAreaOrSlot ?? VisualRuleType.generalDialogFlow;
    assert(
      targetRule.requiresVisRulePrepQuestion,
      'requires a rule that needs prep',
    );

    String promptTmpl = targetRule.prepTemplate;
    String prompt = promptTmpl.format([qtr.targetPath]);

    int _castAnswer(QuestBase qb, String lstAreaIdxs) {
      return castStrOfIdxsToIterOfInts(lstAreaIdxs, dflt: 0).first;
    }

    return QPromptCollection.singleDialog(
      prompt,
      ['0', '1', '2', '3'],
      CaptureAndCast<int>(_castAnswer),
    );
  } //

  // getters
  List<VisRuleQuestType> get embeddedQuestTypes =>
      prompts.map<VisRuleQuestType>((e) => e.visQuestType).toList();

  Iterable<CaptureAndCast> get listResponses =>
      prompts.map((qpi) => qpi._answerRepoAndTypeCast);

  int get _partCount => prompts.length;
  bool get isCompleted => _curPartIdx >= _partCount - 1 || allPartsHaveAnswers;
  bool get isMultiPart => _partCount > 1;
  bool get allPartsHaveAnswers =>
      prompts.where((QuestPromptInstance pi) => pi.hasAnswer).length >=
      _partCount;

  QuestPromptInstance? getNextUserPromptIfExists() {
    _curPartIdx++;
    if (_curPartIdx > _partCount - 1) return null;
    return prompts[_curPartIdx];
  }

  Iterable<VisRuleQuestType> get visQuestTypes =>
      prompts.map((e) => e.visQuestType);

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
