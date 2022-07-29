part of QuestionsLib;

typedef ValidateUserResp = bool Function(String);

class QuestPromptInstance<T> implements QPromptIfc {
  /* describes each prompt part of a QuestBase instance
    including list of prompts
    answers stored in CaptureAndCast<T>
  */
  final String userPrompt;
  final VisQuestChoiceCollection answChoiceCollection;
  final CaptureAndCast<T> _answerRepoAndTypeCast;
  final bool allowsMultipleChoices;
  final ValidateUserResp? validateUserResp;

  QuestPromptInstance(
    this.userPrompt,
    this.answChoiceCollection,
    this._answerRepoAndTypeCast, {
    this.allowsMultipleChoices = true,
    this.validateUserResp = null,
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
  void collectResponse(String userResp) {
    // store user answer response into  CaptureAndCast<T> _answerRepoAndTypeCast
    // print('Qpi.colResp:  Prompt: "$userPrompt" answered with $s!');
    _validateUserResponse(userResp);
    _answerRepoAndTypeCast.captureUserRespStr(userResp);
    // print('userResp of "$userResp" stored on $userPrompt');
  }

  void _validateUserResponse(String userResp) {
    if (userResp.isEmpty) {
      throw Exception('user response cant be empty');
    }
    if (validateUserResp == null) return;

    bool isValid = validateUserResp!(userResp);
    if (!isValid) {
      throw Exception('user response failed validation');
    }
  }

  // getters
  bool get shouldAutoAnswer => answChoiceCollection.canAutoAnswer;
  String? get autoAnswerIfAppropriate =>
      shouldAutoAnswer ? answChoiceCollection.autoAnswerIfAppropriate : null;
  bool get hasAnswer => _answerRepoAndTypeCast.hasAnswer;
  bool get hasChoices => answChoiceCollection.hasChoices;
  List<ResponseAnswerOption> get questsAndChoices =>
      answChoiceCollection.answerOptions;
  // end QPromptIfc impl

  CaptureAndCast<T> get userRespConverter => _answerRepoAndTypeCast;
  bool get asksWhichScreensToConfig =>
      _answerRepoAndTypeCast.asksWhichScreensToConfig;
  bool get asksWhichAreasOfScreenToConfig =>
      _answerRepoAndTypeCast.asksWhichAreasOfScreenToConfig;
  bool get asksWhichSlotsOfAreaToConfig =>
      _answerRepoAndTypeCast.asksWhichSlotsOfAreaToConfig;

  Iterable<ResponseAnswerOption> get answerOptions =>
      answChoiceCollection.answerOptions;

  String createFormattedQuestion(RegionTargetQuest quest) {
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

  static List<ResponseAnswerOption> getSubQuestionsAndChoiceOptions(
    VisualRuleType rt,
  ) {
    // return answChoiceCollection;
    return rt.requRuleDetailCfgQuests
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
