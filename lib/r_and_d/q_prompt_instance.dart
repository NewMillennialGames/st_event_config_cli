part of RandDee;

class QuestPromptInstance<T> implements QPromptIfc {
  /* describes each part of a Quest2 iteration
    including list of prompts
    does NOTHING with answers
    those are stored at Quest2 instance level
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

  // begin QPromptIfc impl
  @override
  void collectResponse(String s) {
    // accumulate user answers in list of strings
    _userAnswers.capture(s);
  }

  // getters
  bool get hasChoices => answChoiceCollection.hasChoices;
  List<QuestChoiceOption> get questsAndChoices =>
      answChoiceCollection.answerOptions;
  // end QPromptIfc impl

  CaptureAndCast<T> get userAnswers => _userAnswers;
  bool get asksWhichScreensToConfig => _userAnswers.asksWhichScreensToConfig;
  bool get asksWhichAreasOfScreenToConfig =>
      _userAnswers.asksWhichAreasOfScreenToConfig;
  bool get asksWhichSlotsOfAreaToConfig =>
      _userAnswers.asksWhichSlotsOfAreaToConfig;

  Iterable<String> get choices => answChoiceCollection.choices;

  String createFormattedQuest2(Quest2 quest) {
    String templ = answChoiceCollection.questTemplByRuleType(
      quest.visRuleTypeForAreaOrSlot!,
    );

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

  // String get _subQuests => answChoiceCollection.toString();
  // String get choiceName => visRuleType.friendlyName;
  // String get questStr => 'QwC: ' + qType.visRuleName + '\n' + _subQuests;
  String questStr(String choiceName) =>
      'Rule: $choiceName:  SubQs: "${questsAndChoices.fold<String>(
        '',
        (ac, uc) => ac + '' + uc.selectVal + ', ' + uc.displayStr,
      )}"';

  VisRuleQuestType get visQuestType => answChoiceCollection.visRuleQuestType;

  static List<VisRuleQuestWithChoices> getSubQuest2sAndChoiceOptions(
    VisualRuleType rt,
  ) {
    return rt.requiredQuest2s
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
