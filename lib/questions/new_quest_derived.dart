part of QuestionsLib;

/*   the DerivedQuestGenerator & PerQuestGenOption classes desscribes the 
logic & data-types required to auto-gen new questions
based on answers to a prior question

  DerivedQuestGenerator is responsible
  for looking at questJustAnswered
  and creating any derived questions
  (sometimes with implicit answers
  that we dont need to ask)

*/

class NewQuestPerPromptOpts<AnsType> {
  /*
  describes logic and rules for a prompt on an auto-generated Question
  each instance lives inside DerivedQuestGenerator.perPromptDetails

  acceptsMultiResponses means user can select more
  than one choice, like:   "0,2,4"
  */

  final String promptTemplate;
  final NewQuestArgGen promptTemplArgGen;
  final ChoiceListFromPriorAnswer answerChoiceGenerator;
  final CastStrToAnswTypCallback<AnsType> newRespCastFunc;
  final int defaultAnswerIdx;
  final VisualRuleType? visRuleType;
  final VisRuleQuestType? visRuleQuestType;
  final bool acceptsMultiResponses;

  NewQuestPerPromptOpts(
    this.promptTemplate, {
    required this.promptTemplArgGen,
    required this.answerChoiceGenerator,
    required this.newRespCastFunc,
    this.visRuleType,
    this.visRuleQuestType,
    this.acceptsMultiResponses = false,
    this.defaultAnswerIdx = 0,
  }) {}

  // Type get genType => AnsType;
  // bool get genAsRuleQuestion => visRuleType != null;

}

class DerivedQuestGenerator {
  /*  <PriorAnsType>
    intersection of an answered Question, plus (usually) a QuestMatcher
    or (alternatively; see below) a specific question that we know already matched

    provides data/config to specify what new Question(s) to
    generate, such that user can provide full rule-specs

  Important:
    some instances of this object are created and stored on a
    QuestMatcher, in which case we don't know WHICH question
    will hit the matcher, (eg for the future)
    that hit will use this object to create new questions
    for those scenarios, most of the properties on this object are
    callbacks in which the 1st argument is the matching question

    other instances of this object are created INSIDE a closure on:
      extension VisualRuleTypeExt1 on VisualRuleType
    in which the pertinent question is IN SCOPE (as upval),
    and the first arg (QuestBase) on most of the callbacks are totally moot
    in that case, we can use upvalues once, and ignore the arg 1 QB
  */

  final NewQuestCount newQuestCountCalculator;
  final QTargetIntentUpdateFunc qTargetIntentUpdater;
  final NewQuestIdGenFromPriorAnswer? newQuestIdGenFromPriorQuest;
  final DerivedGenBehaviorOnMatchEnum genBehaviorOfDerivedQuests;
  QuestFactorytSignature? newQuestConstructor;
  final List<NewQuestPerPromptOpts> perPromptDetails;

  DerivedQuestGenerator._(
    this.perPromptDetails, {
    this.genBehaviorOfDerivedQuests =
        DerivedGenBehaviorOnMatchEnum.addPendingQuestions,
    required this.newQuestCountCalculator,
    QTargetIntentUpdateFunc? deriveTargetFromPriorRespCallbk,
    this.newQuestIdGenFromPriorQuest,
    this.newQuestConstructor,
  }) : this.qTargetIntentUpdater = deriveTargetFromPriorRespCallbk == null
            ? _ccTargetRes
            : deriveTargetFromPriorRespCallbk;

  factory DerivedQuestGenerator.singlePrompt(
    String questPromptTemplate, {
    DerivedGenBehaviorOnMatchEnum genBehaviorOfDerivedQuests =
        DerivedGenBehaviorOnMatchEnum.addPendingQuestions,
    required NewQuestCount newQuestCountCalculator,
    required NewQuestArgGen newQuestPromptArgGen,
    required ChoiceListFromPriorAnswer answerChoiceGenerator,
    // required NewQuestPerPromptOpts perNewQuestGenOpts,
    required CastStrToAnswTypCallback newRespCastFunc,
    NewQuestIdGenFromPriorAnswer? newQuestIdGenFromPriorQuest,
    QTargetIntentUpdateFunc? deriveTargetFromPriorRespCallbk,
    QuestFactorytSignature? newQuestConstructor,
  }) {
    var qpp = NewQuestPerPromptOpts(
      questPromptTemplate,
      promptTemplArgGen: newQuestPromptArgGen,
      answerChoiceGenerator: answerChoiceGenerator,
      newRespCastFunc: newRespCastFunc,
    );

    return DerivedQuestGenerator._(
      [qpp],
      genBehaviorOfDerivedQuests: genBehaviorOfDerivedQuests,
      newQuestCountCalculator: newQuestCountCalculator,
      deriveTargetFromPriorRespCallbk: deriveTargetFromPriorRespCallbk,
      newQuestIdGenFromPriorQuest: newQuestIdGenFromPriorQuest,
      newQuestConstructor: newQuestConstructor,
    );
  }

  factory DerivedQuestGenerator.multiPrompt(
    List<NewQuestPerPromptOpts> perNewQuestGenOpts, {
    required NewQuestCount newQuestCountCalculator,
    // optional args below
    DerivedGenBehaviorOnMatchEnum genBehaviorOfDerivedQuests =
        DerivedGenBehaviorOnMatchEnum.addPendingQuestions,
    NewQuestIdGenFromPriorAnswer? newQuestIdGenFromPriorQuest,
    QTargetIntentUpdateFunc? deriveTargetFromPriorRespCallbk,
    QuestFactorytSignature? newQuestConstructor,
  }) {
    return DerivedQuestGenerator._(
      perNewQuestGenOpts,
      genBehaviorOfDerivedQuests: genBehaviorOfDerivedQuests,
      newQuestCountCalculator: newQuestCountCalculator,
      deriveTargetFromPriorRespCallbk: deriveTargetFromPriorRespCallbk,
      newQuestIdGenFromPriorQuest: newQuestIdGenFromPriorQuest,
      newQuestConstructor: newQuestConstructor,
    );
  }

  factory DerivedQuestGenerator.noop() {
    /*
      dummy rec for when we dont need to produce new questions
      can serve as a placeholder for when this/self (DerivedQuestGenerator)
      will be generated by a function on the enclosing Matcher model object
      
      also used in testing
    */
    var qpp = NewQuestPerPromptOpts(
      'no op quest prompt',
      promptTemplArgGen: (a, ix) => [],
      answerChoiceGenerator: (_, __, niu) => [],
      newRespCastFunc: (_, __) => null,
    );
    return DerivedQuestGenerator._(
      [qpp],
      genBehaviorOfDerivedQuests: DerivedGenBehaviorOnMatchEnum.noop,
      newQuestCountCalculator: (qb) => 0,
    );
  }

  List<QuestBase> getDerivedAutoGenQuestions(
    QuestBase answeredQuest,
  ) {
    /* use existing answered Question
    plus logic defined in both this and PerQuestGenOptions
    to build and return a list of new Questions
    */
    int newQuestCount = newQuestCountCalculator(answeredQuest);

    if (newQuestCount < 1) {
      print(
        'DeQuestGen.getDerivedAutoGenQuestions bailed empty due to:\nnewQuestCount: $newQuestCount',
      );
      return [];
    }

    bool newQuConstrWasNull = newQuestConstructor == null;
    if (newQuConstrWasNull) {
      newQuestConstructor = answeredQuest.derivedQuestConstructor;
    }

    // TODO:  future
    bool newQuestContainsMultiPrompts = this.perPromptDetails.length > 1;
    NewQuestPerPromptOpts firstPromptConfig = this.perPromptDetails[0];

    List<QuestBase> createdQuests = [];
    for (int newQIdx = 0; newQIdx < newQuestCount; newQIdx++) {
      //
      int newQuestChoiceCount = firstPromptConfig
          .answerChoiceGenerator(answeredQuest, newQIdx, 0)
          .length;
      if (newQuestChoiceCount < 1) continue;

      // values required to build new question:

      // convert old (answered) targIntent into one for new question
      // added extra copyWith() in case passed function forgets it
      QTargetResolution targIntent =
          qTargetIntentUpdater(answeredQuest, newQIdx).copyWith();
      List<String> templArgs =
          firstPromptConfig.promptTemplArgGen(answeredQuest, newQIdx);
      String _userPrompt = firstPromptConfig.promptTemplate.format(templArgs);

      // select correct Gen-Options or use last if list is too short
      NewQuestPerPromptOpts instcGenOpt = perPromptDetails.first;
      // perNewQuestGenOpts.length > newQIdx
      //     ? perNewQuestGenOpts[newQIdx]
      //     : perNewQuestGenOpts.last;

      List<QuestPromptPayload> newQuestPrompts = [
        QuestPromptPayload(
          _userPrompt,
          firstPromptConfig
              .answerChoiceGenerator(answeredQuest, newQIdx, 0)
              .toList(),
          instcGenOpt.visRuleQuestType ?? VisRuleQuestType.dialogStruct,
          instcGenOpt.newRespCastFunc,
        ),
      ];

      if (newQuestContainsMultiPrompts) {
        newQuestPrompts = newQuestPrompts + _secondaryPrompts(answeredQuest);
      }

      String newQuestId = newQuestIdGenFromPriorQuest == null
          ? answeredQuest.questId + '-$newQIdx'
          : newQuestIdGenFromPriorQuest!(answeredQuest, newQIdx);
      QuestBase nxtQuest = newQuestConstructor!(
        targIntent,
        newQuestPrompts,
        questId: newQuestId,
      );
      createdQuests.add(nxtQuest);
    }

    if (newQuConstrWasNull) {
      // set back to null for the next time this instance is used
      newQuestConstructor = null;
    }
    return createdQuests;
  }

  List<QuestPromptPayload> _secondaryPrompts(QuestBase answeredQuest) {
    //
    List<QuestPromptPayload> lQpp = [];
    int secondPromptCount = perPromptDetails.length - 1;
    for (int nxtPromptIdx = 1;
        nxtPromptIdx < secondPromptCount;
        nxtPromptIdx++) {
      //
      NewQuestPerPromptOpts perPromptGenOps = perPromptDetails[nxtPromptIdx];
      var qpp = QuestPromptPayload(
        perPromptGenOps.promptTemplate,
        perPromptGenOps
            .answerChoiceGenerator(answeredQuest, nxtPromptIdx, nxtPromptIdx)
            .toList(),
        perPromptGenOps.visRuleQuestType ?? VisRuleQuestType.dialogStruct,
        perPromptGenOps.newRespCastFunc,
      );
      lQpp.add(qpp);
    }
    return lQpp;
  }

  // int _newQuestChoiceCount(
  //   QuestBase priorAnsweredQuest,
  //   int newQIdx,
  // ) {
  //   var answerChoiceGenerator = perPromptDetails[newQIdx].answerChoiceGenerator;
  //   return answerChoiceGenerator(priorAnsweredQuest, newQIdx, 0).length;
  // }

  int get promptCount => perPromptDetails.length;
  bool get createsQuestWithMultiPrompts => promptCount > 1;

  // bool get addsPendingQuestions =>
  //     genBehaviorOfDerivedQuests.addsPendingQuestions;

  // bool get createsImplicitAnswers =>
  //     genBehaviorOfDerivedQuests.createsImplicitAnswers; // || hasOnlyOneChoice;

  // bool hasOnlyOneChoice(QuestBase qb) => _firstQuestChoiceCount(qb) == 1;

  // bool hasZeroValidChoices(QuestBase qb) => _firstQuestChoiceCount(qb) < 1;

  static QTargetResolution _ccTargetRes(QuestBase qb, int idx) =>
      qb.qTargetResolution.copyWith();
}
