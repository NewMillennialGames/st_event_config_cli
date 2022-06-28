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

class PerPromptGenDetails {
  /* individual prompts in a multi-part question

  */
  final String? promptOverride;

  PerPromptGenDetails(this.promptOverride);
}

class PerQuestGenResponsHandlingOpts<AnsType> {
  /*
  describes logic and rules for a single auto-generated Question
  each instance lives inside DerivedQuestGenerator.perQuestGenOptions

  perhaps I should name it:  PerPrompt ....??
  */

  final CastStrToAnswTypCallback<AnsType> newRespCastFunc;
  final int defaultAnswerIdx = 0;
  final VisualRuleType? visRuleType;
  final VisRuleQuestType? visRuleQuestType;
  final bool acceptsMultiResponses;
  List<PerPromptGenDetails> promptDetails = [];

  PerQuestGenResponsHandlingOpts({
    required this.newRespCastFunc,
    this.visRuleType,
    this.visRuleQuestType,
    this.acceptsMultiResponses = false,
    List<String> questPrompts = const [],
  }) {}

  // Type get genType => AnsType;
  // bool get genAsRuleQuestion => visRuleType != null;
  int get promptCount => promptDetails.length;
  bool get hasMultiPrompts => promptCount > 1;
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

  final String questPromptTemplate;
  final DerivedGenBehaviorOnMatchEnum genBehaviorOfDerivedQuests;
  final NewQuestCount newQuestCountCalculator;
  final NewQuestArgGen newQuestPromptArgGen;
  final ChoiceListFromPriorAnswer answerChoiceGenerator;
  final QTargetIntentUpdateFunc qTargetIntentUpdater;
  final NewQuestIdGenFromPriorAnswer? newQuestIdGenFromPriorQuest;
  final List<PerQuestGenResponsHandlingOpts> perNewQuestGenOpts;
  QuestFactorytSignature? newQuestConstructor;

  DerivedQuestGenerator(
    this.questPromptTemplate, {
    this.genBehaviorOfDerivedQuests =
        DerivedGenBehaviorOnMatchEnum.addPendingQuestions,
    required this.newQuestCountCalculator,
    required this.newQuestPromptArgGen,
    required this.answerChoiceGenerator,
    required this.perNewQuestGenOpts,
    this.newQuestIdGenFromPriorQuest,
    QTargetIntentUpdateFunc? deriveTargetFromPriorRespCallbk,
    this.newQuestConstructor,
  }) : this.qTargetIntentUpdater = deriveTargetFromPriorRespCallbk == null
            ? _ccTargIntent
            : deriveTargetFromPriorRespCallbk;

  static QTargetResolution _ccTargIntent(QuestBase qb, int idx) =>
      qb.qTargetResolution.copyWith();

  factory DerivedQuestGenerator.noop() {
    // dummy rec for when we dont need to produce new questions
    // eg testing
    return DerivedQuestGenerator(
      'no op',
      genBehaviorOfDerivedQuests: DerivedGenBehaviorOnMatchEnum.noop,
      newQuestCountCalculator: (qb) => 0,
      newQuestPromptArgGen: (a, ix) => [],
      answerChoiceGenerator: (_, __, niu) => [],
      perNewQuestGenOpts: [],
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
    bool newQuestContainsMultiPrompts = this.perNewQuestGenOpts.length > 1;

    List<QuestBase> createdQuests = [];
    for (int newQIdx = 0; newQIdx < newQuestCount; newQIdx++) {
      //

      int newQuestChoiceCount = _newQuestChoiceCount(answeredQuest, newQIdx);
      if (newQuestChoiceCount < 1) continue;

      // values required to build new question:

      // convert old (answered) targIntent into one for new question
      // added extra copyWith() in case passed function forgets it
      QTargetResolution targIntent =
          qTargetIntentUpdater(answeredQuest, newQIdx).copyWith();
      List<String> templArgs = newQuestPromptArgGen(answeredQuest, newQIdx);
      String _userPrompt = questPromptTemplate.format(templArgs);

      // select correct Gen-Options or use last if list is too short
      PerQuestGenResponsHandlingOpts instcGenOpt = perNewQuestGenOpts.first;
      // perNewQuestGenOpts.length > newQIdx
      //     ? perNewQuestGenOpts[newQIdx]
      //     : perNewQuestGenOpts.last;

      List<QuestPromptPayload> newQuestPrompts = [
        QuestPromptPayload(
          _userPrompt,
          answerChoiceGenerator(answeredQuest, newQIdx, 0).toList(),
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
    int secondPromptCount = perNewQuestGenOpts.length - 1;
    for (int newQIdx = 1; newQIdx < secondPromptCount; newQIdx++) {
      //
      PerQuestGenResponsHandlingOpts perPromptGenOps =
          perNewQuestGenOpts[newQIdx];
      var qpp = QuestPromptPayload(
        questPromptTemplate,
        answerChoiceGenerator(answeredQuest, newQIdx, newQIdx).toList(),
        perPromptGenOps.visRuleQuestType ?? VisRuleQuestType.dialogStruct,
        perPromptGenOps.newRespCastFunc,
      );
      lQpp.add(qpp);
    }
    return lQpp;
  }

  // bool get addsPendingQuestions =>
  //     genBehaviorOfDerivedQuests.addsPendingQuestions;

  // bool get createsImplicitAnswers =>
  //     genBehaviorOfDerivedQuests.createsImplicitAnswers; // || hasOnlyOneChoice;

  int _newQuestChoiceCount(
    QuestBase priorAnsweredQuest,
    int newQIdx,
  ) {
    return answerChoiceGenerator(priorAnsweredQuest, newQIdx, 0).length;
  }

  // bool hasOnlyOneChoice(QuestBase qb) => _firstQuestChoiceCount(qb) == 1;

  // bool hasZeroValidChoices(QuestBase qb) => _firstQuestChoiceCount(qb) < 1;
}
