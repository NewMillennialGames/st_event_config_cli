part of InputModels;

/*   not sure if this is needed
  QuestMatcher() may be all we need


  AutoAnswer is responsible
  for looking at questJustAnswered
  and creating any implicit answers
  that we dont need to ask

*/

// pass question, return how many new questions to create
typedef NewQuestCount = int Function(Question);
// pass question + newIndx, return list of args for question template
typedef NewQuestArgGen = List<String> Function(Question, int);

typedef QuestionQuantifierRevisor = QuestionQuantifier Function(
    QuestionQuantifier);

class PerQuestGenOptions<AnsType> {
  /*
  describes logic and rules for a single auto-generated question
  instance lives inside DerivedQuestGenerator.perQuestGenOptions
  */
  final Iterable<String> answerChoices;
  final AnsType Function(String) castFunc;
  late final QuestionQuantifierRevisor qQuantUpdater;
  final int defaultAnswerIdx = 0;
  final String questId;
  final bool genAsRuleQuestion;

  PerQuestGenOptions({
    required this.answerChoices,
    required this.castFunc,
    QuestionQuantifierRevisor? qQuantRev,
    this.questId = '',
    this.genAsRuleQuestion = false,
  }) : this.qQuantUpdater = qQuantRev == null ? _noOp : qQuantRev;

  Type get genType => AnsType;

  static QuestionQuantifier _noOp(QuestionQuantifier qq) => qq;
}

class DerivedQuestGenerator {
  /*
    intersection of an answered question, plus a QuestMatcher
    should indicate what new questions to ask
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

  List<Question> generatedQuestions(
    Question answeredQuest,
    QuestMatcher? matcher,
  ) {
    /* use existing answered question
    plus logic defined in both this and PerQuestGenOptions
    to build and return a list of new questions
    */
    int toCreate = newQuestCountCalculator(answeredQuest);
    if (toCreate < 1) return [];

    List<Question> createdQuest = [];
    for (int i = 0; i < toCreate; i++) {
      //
      List<String> templArgs = newQuestArgGen(answeredQuest, i);
      String newQuestStr = questTemplate.format(templArgs);

      PerQuestGenOptions genOptionsAtIdx = perQuestGenOptions.length <= i
          ? perQuestGenOptions.last
          : perQuestGenOptions[i];
      //
      Question nxtQuest = answeredQuest.fromExisting(
        newQuestStr,
        genOptionsAtIdx,
      );

      createdQuest.add(nxtQuest);
    }
    return createdQuest;
  }
}



  // static List<Question> pendingQuestsFromAnswer(Question quest) {
  //   List<VisualRuleType> vrts = quest.qQuantify.relatedSubVisualRules(quest);
  //   return [];
  // }

  // static List<Question> impliedAnswersFromAnswer(Question quest) {
  //   return [];
  // }