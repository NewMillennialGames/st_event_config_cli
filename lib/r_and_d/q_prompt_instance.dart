part of RandDee;

class QuestPromptInstance<T> {
  /* describes each part of a question iteration
    including list of prompts
    does NOTHING with answers
    those are stored at Question instance level
  */
  final String userPrompt;
  final VisQuestChoiceCollection answChoiceCollection;
  final CaptureAndCast<T> _userAnswers;

  QuestPromptInstance(
    this.userPrompt,
    this.answChoiceCollection,
    CastStrToAnswTypCallback<T> castFunc,
  ) : _userAnswers = CaptureAndCast<T>(castFunc);

  factory QuestPromptInstance.fromRaw(
    String prompt,
    List<String> choices,
    VisRuleQuestType questType,
    CastStrToAnswTypCallback<T> castFunc,
  ) {
    //
    return QuestPromptInstance(
      prompt,
      VisQuestChoiceCollection.fromList(questType, choices),
      castFunc,
    );
  }

  // getters
  bool get hasChoices => answChoiceCollection.hasChoices;
  List<QuestChoiceOption> get questsAndChoices =>
      answChoiceCollection.answerOptions;

  String get _subQuests => answChoiceCollection.toString();
  String createFormattedQuestion(Quest2 quest) {
    String templ = answChoiceCollection
        .questTemplByRuleType(quest.visRuleTypeForAreaOrSlot!);

    String slotStr =
        quest.slotInArea == null ? '' : quest.slotInArea!.name + ' on';
    Map<String, String> templFillerVals = {
      'slot': slotStr,
      'area':
          quest.screenWidgetArea?.name ?? 'error -- vis rule quest w no area?',
      'screen': quest.appScreen.name,
    };
    templ = templ.formatWithMap(templFillerVals);
    return templ;
  }

  Iterable<String> get choices => answChoiceCollection.choices;

  // String get choiceName => visRuleType.friendlyName;
  // String get questStr => 'QwC: ' + qType.visRuleName + '\n' + _subQuests;
  String questStr(String choiceName) =>
      'Rule: $choiceName:  SubQs: "${questsAndChoices.fold<String>(
        '',
        (ac, uc) => ac + '' + uc.selectVal + ', ' + uc.displayStr,
      )}"';

  VisRuleQuestType get visQuestType => answChoiceCollection.visRuleQuestType;

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

  static List<QuestPromptInstance> fromMap(
    Map<String, List<String>> questIterations,
    VisRuleQuestType questType,
    CastStrToAnswTypCallback castFunc,
  ) {
    //
    List<QuestPromptInstance> l = [];
    for (MapEntry<String, List<String>> me in questIterations.entries) {
      l.add(
        QuestPromptInstance.fromRaw(
          me.key,
          me.value,
          questType,
          castFunc,
        ),
      );
    }
    return l;
  }
}
