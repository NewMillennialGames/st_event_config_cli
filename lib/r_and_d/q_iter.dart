part of RandDee;

typedef CastStrToAnswTypCallback<T> = T Function(QTypeWrapper, String);

class SingleQuestIteration<RespOutTyp extends RuleResponseWrapperIfc> {
  /* describes each part of a question iteration
    including 
  */
  // final VisualRuleType visRuleType;
  final QTypeWrapper<RespOutTyp> qType;
  final String userPrompt;
  final VisQuestChoiceCollection answChoiceCollection;
  final CastStrToAnswTypCallback<RespOutTyp> castUserRespCallbk;
  late final RespOutTyp userAnswChoice;

  SingleQuestIteration(
    this.userPrompt,
    this.answChoiceCollection,
    // this.visRuleType,
    this.qType,
    this.castUserRespCallbk,
  );

  // getters
  bool get hasChoices => answChoiceCollection.hasChoices;
  Type get answType => RespOutTyp;
  VisualRuleType get visRuleType => qType.visRuleType;
  List<QuestOption> get questsAndChoices => answChoiceCollection.answerOptions;

  RespOutTyp typedUserAnsw(String userResponses) {
    this.userAnswChoice = castUserRespCallbk(qType, userResponses);
    return userAnswChoice;
  }

  AnswTypValMap get answerPayload => AnswTypValMap<RespOutTyp>(userAnswChoice);

  String get _subQuests => answChoiceCollection.toString();
  String createFormattedQuestion(Quest2 quest) {
    String templ = answChoiceCollection
        .questTemplByRuleType(quest.visRuleTypeForAreaOrSlot!);

    String slotStr =
        quest.slotInArea == null ? '' : quest.slotInArea!.name + ' on';
    Map<String, String> templFillerVals = {
      'slot': slotStr,
      'area':
          quest.screenWidgetArea?.name ?? 'error -- vis rule quest w no area?',
      'screen': quest.appScreen.name,
    };
    templ = templ.formatWithMap(templFillerVals);
    return templ;
  }

  Iterable<String> get choices => answChoiceCollection.choices;

  String get choiceName => visRuleType.friendlyName;
  // String get questStr => 'QwC: ' + qType.visRuleName + '\n' + _subQuests;
  String get questStr =>
      'Rule: $choiceName:  SubQs: "${questsAndChoices.fold<String>(
        '',
        (ac, uc) => ac + '' + uc.selectVal + ', ' + uc.displayStr,
      )}"';

  VisRuleQuestType get visQuestType => answChoiceCollection.visRuleQuestType;

  static List<VisRuleQuestWithChoices> getSubQuestionsAndChoiceOptions(
    VisualRuleType rt,
  ) {
    return rt.requiredQuestions
        .map(
          (qrq) => VisRuleQuestWithChoices(
            qrq,
            qrq.choices,
          ),
        )
        .toList();
  }
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

  Iterable<VisRuleQuestType> get visQuestTypes =>
      questIterations.map((e) => e.visQuestType);

  Iterable<AnswTypValMap> get allTypedAnswers =>
      questIterations.map((sqi) => sqi.answerPayload);

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
