part of InputModels;

class VisRuleQuestWithChoices {
  //
  final VisRuleQuestType ruleQuestType;
  final List<String> ruleQuestChoices;

  VisRuleQuestWithChoices(
    this.ruleQuestType,
    this.ruleQuestChoices,
  );

  String createFormattedQuestion(VisualRuleQuestion rQuest) {
    String templ =
        ruleQuestType.templateForRuleType(rQuest.visRuleTypeForSlotInArea!);

    String slotStr =
        rQuest.slotInArea == null ? '' : rQuest.slotInArea!.name + '';
    Map<String, String> templFillerVals = {
      'slot': slotStr,
      'area':
          rQuest.screenWidgetArea?.name ?? 'error -- vis rule quest w no area?',
      'screen': rQuest.appScreen.name,
    };
    templ = templ.formatWithMap(templFillerVals);
    return templ;
  }

  List<String> get choices => ruleQuestChoices;
}

class VisRuleChoiceConfig {
  //
  final VisualRuleType ruleTyp;
  final List<VisRuleQuestWithChoices> questsAndChoices;

  VisRuleChoiceConfig._(
    this.ruleTyp,
    this.questsAndChoices,
  );

  String get choiceName => ruleTyp.friendlyName;

  factory VisRuleChoiceConfig.fromRuleTyp(VisualRuleType ruleTyp) {
    // use VisualRuleType to get list of sub-questions
    // and their respective choice options
    List<VisRuleQuestWithChoices> questsAndChoices =
        getSubQuestionsAndChoiceOptions(ruleTyp);
    return VisRuleChoiceConfig._(ruleTyp, questsAndChoices);
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
