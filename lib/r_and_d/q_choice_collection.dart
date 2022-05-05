part of RandDee;

class QuestOption {
  //
  final String displayStr;
  final String selectVal;

  QuestOption(
    this.displayStr,
    this.selectVal,
  );
}

class QuestChoiceCollectionBase {
  //
  final List<QuestOption> answerOptions;
  final int idxOfDefaultAnsw;
  final bool multiAllowed;

  QuestChoiceCollectionBase(
    this.answerOptions, {
    this.idxOfDefaultAnsw = 0,
    this.multiAllowed = false,
  });

  bool get hasChoices => answerOptions.length > 0;
  Iterable<String> get choices => answerOptions.map((e) => e.displayStr);
}

class VisQuestChoiceCollection extends QuestChoiceCollectionBase {
  //
  final VisRuleQuestType visRuleQuestType;

  VisQuestChoiceCollection(
    this.visRuleQuestType,
    answerOptions, {
    idxOfDefaultAnsw = 0,
    multiAllowed = false,
  }) : super(
          answerOptions,
          idxOfDefaultAnsw: idxOfDefaultAnsw,
          multiAllowed: multiAllowed,
        );

  factory VisQuestChoiceCollection.fromList(
    VisRuleQuestType visRuleQuestType,
    List<String> strChoices, {
    int defaultIdx = 0,
    bool multiAllowed = false,
  }) {
    //
    List<QuestOption> answChoices = [];
    int idx = 0;
    strChoices.forEach((s) {
      answChoices.add(QuestOption(s, '$idx'));
      idx++;
    });
    return VisQuestChoiceCollection(
      visRuleQuestType,
      answChoices,
      idxOfDefaultAnsw: defaultIdx,
      multiAllowed: multiAllowed,
    );
  }

  String questTemplByRuleType(VisualRuleType ruleTyp) {
    //
    return visRuleQuestType.questTemplByRuleType(ruleTyp);
  }
}
