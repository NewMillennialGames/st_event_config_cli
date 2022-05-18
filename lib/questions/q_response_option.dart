part of QuestionsLib;

class ResponseAnswerOption {
  //
  final String displayStr;
  final String selectVal;

  ResponseAnswerOption(
    this.displayStr,
    this.selectVal,
  );
}

class ResponseOptCollectionBase {
  //
  final List<ResponseAnswerOption> answerOptions;
  final int idxOfDefaultAnsw;
  final bool multiAllowed;

  ResponseOptCollectionBase(
    this.answerOptions, {
    this.idxOfDefaultAnsw = 0,
    this.multiAllowed = false,
  });

  bool get hasChoices => answerOptions.length > 0;
  Iterable<String> get choices => answerOptions.map((e) => e.displayStr);
}

class VisQuestChoiceCollection extends ResponseOptCollectionBase {
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
    Iterable<String> strChoices, {
    int defaultIdx = 0,
    bool multiAllowed = false,
  }) {
    //
    List<ResponseAnswerOption> answChoices = [];
    int idx = 0;
    strChoices.forEach((s) {
      answChoices.add(ResponseAnswerOption(s, '$idx'));
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
