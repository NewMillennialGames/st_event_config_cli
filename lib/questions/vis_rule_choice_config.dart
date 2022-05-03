part of QuestionsLib;

class VisRuleQuestWithChoices {
  //
  final VisRuleQuestType ruleQuestType;
  final List<String> _ruleQuestChoices;

  VisRuleQuestWithChoices(
    this.ruleQuestType,
    this._ruleQuestChoices,
  );

  String get questStr => 'QwC: ' + ruleQuestType.name + '\n' + _subQuests;
  String get _subQuests => _ruleQuestChoices.toString();

  String createFormattedQuestion(VisualRuleQuestion rQuest) {
    String templ =
        ruleQuestType.questTemplByRuleType(rQuest.visRuleTypeForAreaOrSlot!);

    String slotStr =
        rQuest.slotInArea == null ? '' : rQuest.slotInArea!.name + ' on';
    Map<String, String> templFillerVals = {
      'slot': slotStr,
      'area':
          rQuest.screenWidgetArea?.name ?? 'error -- vis rule quest w no area?',
      'screen': rQuest.appScreen.name,
    };
    templ = templ.formatWithMap(templFillerVals);
    return templ;
  }

  List<String> get choices => _ruleQuestChoices;
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
  String get questStr =>
      'Rule: ${ruleTyp.name}:  SubQs: "${questsAndChoices.fold<String>(
        '',
        (ac, c) =>
            ac +
            '' +
            c.choices.reduce(
              (s1, s2) => s1 + ', ' + s2,
            ),
      )}"';

  List<VisRuleQuestType> get visQuestTypes =>
      questsAndChoices.map((e) => e.ruleQuestType).toList();

  factory VisRuleChoiceConfig.fromRuleTyp(VisualRuleType ruleTyp) {
    // use VisualRuleType to get list of sub-questions
    // and their respective choice options
    List<VisRuleQuestWithChoices> questsAndChoices =
        getSubQuestionsAndChoiceOptions(ruleTyp);
    return VisRuleChoiceConfig._(ruleTyp, questsAndChoices);
  }

  factory VisRuleChoiceConfig.fromGenOptions(PerQuestGenOptions genOpt) {
    //
    var qwc = VisRuleQuestWithChoices(
        genOpt.ruleQuestType!, genOpt.answerChoices.toList());
    return VisRuleChoiceConfig._(genOpt.ruleType!, [qwc]);
  }

  static List<VisRuleQuestWithChoices> getSubQuestionsAndChoiceOptions(
    VisualRuleType rt,
  ) {
    return rt.requiredQuestions
        .map(
          (qrq) => VisRuleQuestWithChoices(
            qrq,
            qrq.choices,
          ),
        )
        .toList();
  }
}
