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

class PerQuestGenResponsHandlingOpts<AnsType> {
  /*
  describes logic and rules for a single auto-generated Question
  each instance lives inside DerivedQuestGenerator.perQuestGenOptions
  */

  final CastStrToAnswTypCallback<AnsType> newRespCastFunc;
  final int defaultAnswerIdx = 0;
  final VisualRuleType? visRuleType;
  final VisRuleQuestType? visRuleQuestType;
  final bool acceptsMultiResponses;

  PerQuestGenResponsHandlingOpts({
    required this.newRespCastFunc,
    this.visRuleType,
    this.visRuleQuestType,
    this.acceptsMultiResponses = false,
  });

  Type get genType => AnsType;
  bool get genAsRuleQuestion => visRuleType != null;
}

class DerivedQuestGenerator<PriorAnsType> {
  /*
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
  // final CastPriorAnswToType<PriorAnsType>? castPriorAnswToType;
  final NewQuestCount newQuestCountCalculator;
  final NewQuestArgGen newQuestPromptArgGen;
  final ChoiceListFromPriorAnswer answerChoiceGenerator;
  final QTargetIntentUpdateFunc qTargetIntentUpdater;
  final NewQuestIdGenFromPriorAnswer? newQuestIdGenFromPriorQuest;
  final List<PerQuestGenResponsHandlingOpts> perQuestGenOptions;
  QuestFactorytSignature? newQuestConstructor;

  DerivedQuestGenerator(
    this.questPromptTemplate, {
    this.genBehaviorOfDerivedQuests =
        DerivedGenBehaviorOnMatchEnum.addPendingQuestions,
    required this.newQuestCountCalculator,
    required this.newQuestPromptArgGen,
    required this.answerChoiceGenerator,
    required this.perQuestGenOptions,
    this.newQuestIdGenFromPriorQuest,
    QTargetIntentUpdateFunc? qTargetIntentUpdaterCallbk,
    this.newQuestConstructor,
  }) : this.qTargetIntentUpdater = qTargetIntentUpdaterCallbk == null
            ? _ccTargIntent
            : qTargetIntentUpdaterCallbk;

  static QTargetIntent _ccTargIntent(QuestBase qb, int idx) =>
      qb.qTargetIntent.copyWith();

  factory DerivedQuestGenerator.noop() {
    // dummy rec for when we dont need to produce new questions
    // eg testing
    return DerivedQuestGenerator(
      'no op',
      genBehaviorOfDerivedQuests: DerivedGenBehaviorOnMatchEnum.noop,
      newQuestCountCalculator: (qb) => 0,
      newQuestPromptArgGen: (a, ix) => [],
      answerChoiceGenerator: (_, __) => [],
      perQuestGenOptions: [],
    );
  }

  List<QuestBase> getDerivedAutoGenQuestions(
    QuestBase answeredQuest,
    QuestMatcher? matcher,
  ) {
    /* use existing answered Question
    plus logic defined in both this and PerQuestGenOptions
    to build and return a list of new Questions
    */
    int newQuestCount = newQuestCountCalculator(answeredQuest);
    if (newQuestCount < 1) return [];

    if (newQuestConstructor == null) {
      newQuestConstructor = answeredQuest.derivedQuestConstructor;
    }

    List<QuestBase> createdQuests = [];
    for (int newQIdx = 0; newQIdx < newQuestCount; newQIdx++) {
      //

      // values required to build new question:

      // convert old (answered) targIntent into one for new question
      // added extra copyWith() in case passed function forgets it
      QTargetIntent targIntent =
          qTargetIntentUpdater(answeredQuest, newQIdx).copyWith();
      List<String> templArgs = newQuestPromptArgGen(answeredQuest, newQIdx);
      String _userPrompt = questPromptTemplate.format(templArgs);

      // select correct Gen-Options or use last if list is too short
      PerQuestGenResponsHandlingOpts instcGenOpt =
          perQuestGenOptions.length > newQIdx
              ? perQuestGenOptions[newQIdx]
              : perQuestGenOptions.last;

      List<QuestPromptPayload> newQuestPrompts = [
        QuestPromptPayload(
          _userPrompt,
          answerChoiceGenerator(answeredQuest, newQIdx).toList(),
          instcGenOpt.visRuleQuestType ?? VisRuleQuestType.dialogStruct,
          instcGenOpt.newRespCastFunc,
        ),
      ];

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
    return createdQuests;
  }

  bool get addsPendingQuestions =>
      genBehaviorOfDerivedQuests.addsPendingQuestions;

  bool get createsImplicitAnswers =>
      genBehaviorOfDerivedQuests.createsImplicitAnswers; // || hasOnlyOneChoice;

  bool hasOnlyOneChoice(QuestBase qb) =>
      answerChoiceGenerator(qb, 0).length == 1;
}

// if (genOptionsAtIdx.genAsRuleQuestion) {
//   nxtQuest = newQuestConstructor(targIntent, []);
//   // nxtQuest = QuestBase.makeFromExisting(
//   //   answeredQuest,
//   //   newQuestStr,
//   //   genOptionsAtIdx,
//   // );
// } else {
//   // nxtQuest = answeredQuest.fromExisting(
//   //   newQuestStr,
//   //   genOptionsAtIdx,
//   // );
// }
