part of Quest2sLib;

/*   not sure if this is needed
  QuestMatcher() may be all we need


  AutoAnswer is responsible
  for looking at questJustAnswered
  and creating any implicit answers
  that we dont need to ask

*/

// pass Quest2, return how many new Quest2s to create
typedef NewQuestCount = int Function(Quest2);
// pass Quest2 + newIndx, return list of args for Quest2 template
typedef NewQuestArgGen = List<String> Function(Quest2, int);

typedef Quest2QuantifierRevisor = QTargetIntent Function(QTargetIntent);

class PerQuestGenOptions<AnsType> {
  /*
  describes logic and rules for a single auto-generated Quest2
  instance lives inside DerivedQuestGenerator.perQuestGenOptions
  */
  final Iterable<String> answerChoices;
  final AnsType Function(String) castFunc;
  late final Quest2QuantifierRevisor qQuantUpdater;
  final int defaultAnswerIdx = 0;
  final String questId;
  final VisualRuleType? ruleType;
  final VisRuleQuestType? ruleQuestType;

  PerQuestGenOptions({
    required this.answerChoices,
    required this.castFunc,
    Quest2QuantifierRevisor? qQuantRev,
    this.questId = '',
    this.ruleType,
    this.ruleQuestType,
  }) : this.qQuantUpdater = qQuantRev == null ? _noOp : qQuantRev;

  Type get genType => AnsType;
  bool get genAsRuleQuest2 => ruleType != null;

  static QTargetIntent _noOp(QTargetIntent qq) => qq;
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

  List<Quest2> generatedQuest2s(
    Quest2 answeredQuest,
    QuestMatcher? matcher,
  ) {
    /* use existing answered Quest2
    plus logic defined in both this and PerQuestGenOptions
    to build and return a list of new Quest2s
    */
    int toCreate = newQuestCountCalculator(answeredQuest);
    if (toCreate < 1) return [];

    List<Quest2> createdQuest = [];
    for (int i = 0; i < toCreate; i++) {
      //
      List<String> templArgs = newQuestArgGen(answeredQuest, i);
      String newQuestStr = questTemplate.format(templArgs);

      PerQuestGenOptions genOptionsAtIdx = perQuestGenOptions.length <= i
          ? perQuestGenOptions.last
          : perQuestGenOptions[i];
      //
      Quest2 nxtQuest;
      if (genOptionsAtIdx.genAsRuleQuest2) {
        nxtQuest = Quest2.makeFromExisting(
          answeredQuest,
          newQuestStr,
          genOptionsAtIdx,
        );
      } else {
        nxtQuest = answeredQuest.fromExisting(
          newQuestStr,
          genOptionsAtIdx,
        );
      }

      createdQuest.add(nxtQuest);
    }
    return createdQuest;
  }
}



  // static List<Quest2> pendingQuestsFromAnswer(Quest2 quest) {
  //   List<VisualRuleType> vrts = quest.qQuantify.relatedSubVisualRules(quest);
  //   return [];
  // }

  // static List<Quest2> impliedAnswersFromAnswer(Quest2 quest) {
  //   return [];
  // }