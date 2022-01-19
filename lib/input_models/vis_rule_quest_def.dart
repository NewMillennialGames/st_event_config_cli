part of InputModels;

class VisRuleQuestWithChoices {
  //
  final VisRuleQuestType ruleQuestType;
  final List<String> ruleQuestChoices;

  VisRuleQuestWithChoices(
    this.ruleQuestType,
    this.ruleQuestChoices,
  );
}

class VisRuleQuestDef {
  //
  final VisualRuleType ruleTyp;
  final List<VisRuleQuestWithChoices> questsAndChoices;

  VisRuleQuestDef._(
    this.ruleTyp,
    this.questsAndChoices,
  );

  factory VisRuleQuestDef.byRuleTyp(VisualRuleType ruleTyp) {
    // use VisualRuleType to get list of sub-questions
    // and their respective choice options
    List<VisRuleQuestWithChoices> questsAndChoices =
        getSubQuestionsAndChoiceOptions(ruleTyp);
    return VisRuleQuestDef._(ruleTyp, questsAndChoices);
  }

  static List<VisRuleQuestWithChoices> getSubQuestionsAndChoiceOptions(
    VisualRuleType rt,
  ) {
    return rt.questionsRequired
        .map(
          (qrq) => VisRuleQuestWithChoices(
            qrq,
            qrq.choices,
          ),
        )
        .toList();
  }
}
