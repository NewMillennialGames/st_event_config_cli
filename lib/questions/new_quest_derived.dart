part of QuestionsLib;

/*   not sure if this is needed
  QuestMatcher() may be all we need


  AutoAnswer is responsible
  for looking at questJustAnswered
  and creating any implicit answers
  that we dont need to ask

*/

class PerQuestGenOptions<AnsType> {
  /*
  describes logic and rules for a single auto-generated Question
  instance lives inside DerivedQuestGenerator.perQuestGenOptions
  */
  final Iterable<String> answerChoices;
  final CastStrToAnswTypCallback<AnsType> castFunc;
  late final QTargetIntentUpdateFunc qTargetIntentUpdater;
  final int defaultAnswerIdx = 0;
  final String questId;
  final VisualRuleType? ruleType;
  final VisRuleQuestType? ruleQuestType;

  PerQuestGenOptions({
    required this.answerChoices,
    required this.castFunc,
    QTargetIntentUpdateFunc? qTargetIntentUpdaterArg,
    this.questId = '',
    this.ruleType,
    this.ruleQuestType,
  }) : this.qTargetIntentUpdater =
            qTargetIntentUpdaterArg == null ? _noOp : qTargetIntentUpdaterArg;

  Type get genType => AnsType;
  bool get genAsRuleQuestion => ruleType != null;

  static QTargetIntent _noOp(QTargetIntent qq, int idx) => qq;
}

class DerivedQuestGenerator {
  /*
    intersection of an answered Quest2, plus a QuestMatcher
    should indicate what new Quest2s to ask
  */

  String questTemplate;
  NewQuestCount newQuestCountCalculator;
  NewQuestArgGen newQuestArgGen;
  List<PerQuestGenOptions> perQuestGenOptions;

  DerivedQuestGenerator(
    this.questTemplate, {
    required this.newQuestCountCalculator,
    required this.newQuestArgGen,
    required this.perQuestGenOptions,
  });

  factory DerivedQuestGenerator.noop() {
    // dummy rec for when we dont need to produce new questions
    return DerivedQuestGenerator(
      'no op',
      newQuestCountCalculator: (qb) => 0,
      newQuestArgGen: (a, ix) => [],
      perQuestGenOptions: [],
    );
  }

  List<QuestBase> generatedQuestions(
    QuestBase answeredQuest,
    QuestMatcher? matcher,
  ) {
    /* use existing answered Question
    plus logic defined in both this and PerQuestGenOptions
    to build and return a list of new Questions
    */
    int toCreate = newQuestCountCalculator(answeredQuest);
    if (toCreate < 1) return [];

    List<QuestBase> createdQuest = [];
    for (int i = 0; i < toCreate; i++) {
      //
      List<String> templArgs = newQuestArgGen(answeredQuest, i);
      String newQuestStr = questTemplate.format(templArgs);

      PerQuestGenOptions genOptionsAtIdx = perQuestGenOptions.length <= i
          ? perQuestGenOptions.last
          : perQuestGenOptions[i];
      //
      QuestBase nxtQuest;

      QTargetIntent targIntent = answeredQuest.qTargetIntent;
      QuestFactorytSignature newQuestConstructor =
          targIntent.preferredQuestionConstructor;

      // targIntent = targIntent.

      if (genOptionsAtIdx.genAsRuleQuestion) {
        nxtQuest = newQuestConstructor(targIntent, []);
        // nxtQuest = QuestBase.makeFromExisting(
        //   answeredQuest,
        //   newQuestStr,
        //   genOptionsAtIdx,
        // );
      } else {
        // nxtQuest = answeredQuest.fromExisting(
        //   newQuestStr,
        //   genOptionsAtIdx,
        // );
      }

      nxtQuest = newQuestConstructor(targIntent, []);
      createdQuest.add(nxtQuest);
    }
    return createdQuest;
  }
}
