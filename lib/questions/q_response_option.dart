part of QuestionsLib;

class ResponseAnswerOption {
  //
  final String displayStr;
  final String selectVal;

  ResponseAnswerOption(
    this.displayStr,
    this.selectVal,
  );

  String get selectOptionForAutoAnswer =>
      selectVal.isNotEmpty ? selectVal : "0";
}

class ResponseOptCollectionBase {
  //
  final List<ResponseAnswerOption> answerOptions;
  final int idxOfDefaultAnsw;
  final bool multiChoicesAllowed;

  ResponseOptCollectionBase(
    this.answerOptions, {
    this.idxOfDefaultAnsw = -1,
    this.multiChoicesAllowed = false,
  });

  bool get hasChoices => answerOptions.length > 0;
  // Iterable<String> get choices => answerOptions.map((e) => e.displayStr);

  bool get canAutoAnswer => answerOptions.length == 1 && idxOfDefaultAnsw == -1;
  String? get autoAnswerIfAppropriate =>
      canAutoAnswer ? answerOptions.first.selectOptionForAutoAnswer : null;
}

class VisQuestChoiceCollection extends ResponseOptCollectionBase {
  //
  final VisRuleQuestType visRuleQuestType;

  VisQuestChoiceCollection(
    this.visRuleQuestType,
    answerOptions, {
    idxOfDefaultAnsw = -1,
    multiAllowed = false,
  }) : super(
          answerOptions,
          idxOfDefaultAnsw: idxOfDefaultAnsw,
          multiChoicesAllowed: multiAllowed,
        );

  factory VisQuestChoiceCollection.fromList(
    VisRuleQuestType visRuleQuestType,
    Iterable<String> strChoices, {
    int defaultIdx = -1,
    bool multiAllowed = false,
  }) {
    //
    List<ResponseAnswerOption> answChoices = [];

    int idx = 0;
    strChoices.forEach((String s) {
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
