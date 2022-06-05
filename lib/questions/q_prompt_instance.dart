part of QuestionsLib;

class QuestPromptInstance<T> implements QPromptIfc {
  /* describes each prompt part of a QuestBase instance
    including list of prompts
    answers stored in CaptureAndCast<T>
  */
  final String userPrompt;
  final VisQuestChoiceCollection answChoiceCollection;
  final CaptureAndCast<T> _answerRepoAndTypeCast;
  final bool allowsMultipleChoices;

  QuestPromptInstance(
    this.userPrompt,
    this.answChoiceCollection,
    this._answerRepoAndTypeCast, {
    this.allowsMultipleChoices = true,
  }); // : _userAnswers = CaptureAndCast<T>(castFunc);

  factory QuestPromptInstance.fromRaw(
    String prompt,
    Iterable<String> choices,
    VisRuleQuestType questType,
    CaptureAndCast<T> answContainer,
  ) {
    //
    return QuestPromptInstance(
      prompt,
      VisQuestChoiceCollection.fromList(questType, choices),
      answContainer,
    );
  }

  // begin QPromptIfc impl
  @override
  void collectResponse(String s) {
    // store user answer response into  CaptureAndCast<T> _answerRepoAndTypeCast
    // print('Qpi.colResp:  Prompt: "$userPrompt" answered with $s!');
    _answerRepoAndTypeCast.captureUserRespStr(s);
  }

  // getters
  bool get hasChoices => answChoiceCollection.hasChoices;
  List<ResponseAnswerOption> get questsAndChoices =>
      answChoiceCollection.answerOptions;
  // end QPromptIfc impl

  CaptureAndCast<T> get userAnswers => _answerRepoAndTypeCast;
  bool get asksWhichScreensToConfig =>
      _answerRepoAndTypeCast.asksWhichScreensToConfig;
  bool get asksWhichAreasOfScreenToConfig =>
      _answerRepoAndTypeCast.asksWhichAreasOfScreenToConfig;
  bool get asksWhichSlotsOfAreaToConfig =>
      _answerRepoAndTypeCast.asksWhichSlotsOfAreaToConfig;

  Iterable<String> get choices => answChoiceCollection.choices;

  String createFormattedQuest2(Quest1Prompt quest) {
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

  static List<ResponseAnswerOption> getSubQuest2sAndChoiceOptions(
    VisualRuleType rt,
  ) {
    // return answChoiceCollection;
    return rt.requConfigQuests
        .map(
          (qrq) => ResponseAnswerOption(
            qrq.name,
            qrq.name,
          ),
        )
        .toList();
  }

  // static List<QuestPromptInstance> fromMap(
  //   Map<String, List<String>> questIterations,
  //   VisRuleQuestType questType,
  //   CastStrToAnswTypCallback castFunc,
  // ) {
  //   //
  //   List<QuestPromptInstance> l = [];
  //   for (MapEntry<String, List<String>> me in questIterations.entries) {
  //     l.add(
  //       QuestPromptInstance.fromRaw(
  //         me.key,
  //         me.value,
  //         questType,
  //         castFunc,
  //       ),
  //     );
  //   }
  //   return l;
  // }
}
