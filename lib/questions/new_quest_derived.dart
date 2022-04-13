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
  //
  Iterable<String> answerChoices;
  QuestionQuantifierRevisor qQuantifierRevisor;
  AnsType Function(String) castFunc;
  int defaultAnswerIdx = 0;
  String questId;

  PerQuestGenOptions(
    this.answerChoices,
    this.qQuantifierRevisor,
    this.castFunc, {
    this.questId = '',
  });

  Type get genType => AnsType;
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
    this.questTemplate,
    this.newQuestCountCalculator,
    this.newQuestArgGen,
    this.perQuestGenOptions,
  );

  List<Question> generatedQuestions(
    Question answeredQuest,
    QuestMatcher? matcher,
  ) {
    //
    int toCreate = newQuestCountCalculator(answeredQuest);
    List<Question> createdQuest = [];
    for (int i = 0; i < toCreate; i++) {
      //
      List<String> templArgs = newQuestArgGen(answeredQuest, i);
      String newQuestStr = questTemplate.format(templArgs);

      PerQuestGenOptions pqo = perQuestGenOptions.length <= i
          ? perQuestGenOptions.last
          : perQuestGenOptions[i];
      Question nxtQuest = answeredQuest.fromExisting(
        newQuestStr,
        pqo,
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