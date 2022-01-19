part of InputModels;

class VisRuleQuestWithChoices {
  //
  final VisRuleQuestType questType;
  final List<String> choices;

  VisRuleQuestWithChoices(
    this.questType,
    this.choices,
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
    List<VisRuleQuestWithChoices> questsAndChoices = _fromRt(ruleTyp);
    return VisRuleQuestDef._(ruleTyp, questsAndChoices);
  }

  static List<VisRuleQuestWithChoices> _fromRt(VisualRuleType rt) {
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
