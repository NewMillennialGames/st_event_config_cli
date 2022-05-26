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

class PerQuestGenOption<AnsType> {
  /*
  describes logic and rules for a single auto-generated Question
  instance lives inside DerivedQuestGenerator.perQuestGenOptions
  */

  final CastStrToAnswTypCallback<AnsType> castFunc;
  final int defaultAnswerIdx = 0;
  final VisualRuleType? ruleType;
  final VisRuleQuestType? ruleQuestType;

  PerQuestGenOption({
    required this.castFunc,
    this.ruleType,
    this.ruleQuestType,
  });

  Type get genType => AnsType;
  bool get genAsRuleQuestion => ruleType != null;
}

class DerivedQuestGenerator {
  /*
    intersection of an answered Quest2, plus a QuestMatcher
    should indicate what new Quest2s to ask
  */

  final String questPromptTemplate;
  final NewQuestCount newQuestCountCalculator;
  final NewQuestArgGen newQuestPromptArgGen;
  final ChoiceListFromPriorAnswer answerChoiceGenerator;
  final QTargetIntentUpdateFunc qTargetIntentUpdater;
  final List<PerQuestGenOption> perQuestGenOptions;
  final NewQuestIdGenFromPriorAnswer? newQuestIdGenFromPriorQuest;

  DerivedQuestGenerator(
    this.questPromptTemplate, {
    required this.newQuestCountCalculator,
    required this.newQuestPromptArgGen,
    required this.answerChoiceGenerator,
    required this.perQuestGenOptions,
    QTargetIntentUpdateFunc? qTargetIntentUpdaterArg,
    this.newQuestIdGenFromPriorQuest,
  }) : this.qTargetIntentUpdater = qTargetIntentUpdaterArg == null
            ? _ccTargIntent
            : qTargetIntentUpdaterArg;

  static QTargetIntent _ccTargIntent(QuestBase qb, int idx) =>
      qb.qTargetIntent.copyWith();

  factory DerivedQuestGenerator.noop() {
    // dummy rec for when we dont need to produce new questions
    // eg testing
    return DerivedQuestGenerator(
      'no op',
      newQuestCountCalculator: (qb) => 0,
      newQuestPromptArgGen: (a, ix) => [],
      answerChoiceGenerator: (_, __) => [],
      perQuestGenOptions: [],
    );
  }

  List<QuestBase> getDerivedAutoGenQuestions(
    QuestBase answeredQuest,
    QuestMatcher matcher,
  ) {
    /* use existing answered Question
    plus logic defined in both this and PerQuestGenOptions
    to build and return a list of new Questions
    */
    int newQuestCount = newQuestCountCalculator(answeredQuest);
    if (newQuestCount < 1) return [];

    List<QuestBase> createdQuests = [];
    for (int newQIdx = 0; newQIdx < newQuestCount; newQIdx++) {
      //
      QTargetIntent targIntent = answeredQuest.qTargetIntent;
      QuestFactorytSignature newQuestConstructor =
          targIntent.preferredQuestionConstructor;

      // values required to build new question:

      // convert old (answered) targIntent into one for new question
      targIntent = qTargetIntentUpdater(answeredQuest, newQIdx);

      List<String> templArgs = newQuestPromptArgGen(answeredQuest, newQIdx);
      String _userPrompt = questPromptTemplate.format(templArgs);

      PerQuestGenOption instcGenOpt = perQuestGenOptions.length > newQIdx
          ? perQuestGenOptions[newQIdx]
          : perQuestGenOptions.last;

      List<QuestPromptPayload> newQuestPrompts = [
        QuestPromptPayload(
          _userPrompt,
          answerChoiceGenerator(answeredQuest, newQIdx).toList(),
          instcGenOpt.ruleQuestType ?? VisRuleQuestType.dialogStruct,
          instcGenOpt.castFunc,
        ),
      ];

      String newQuestId = newQuestIdGenFromPriorQuest == null
          ? answeredQuest.questId + '-$newQIdx'
          : newQuestIdGenFromPriorQuest!(answeredQuest, newQIdx);
      QuestBase nxtQuest = newQuestConstructor(
        targIntent,
        newQuestPrompts,
        questId: newQuestId,
      );
      createdQuests.add(nxtQuest);
    }
    return createdQuests;
  }
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