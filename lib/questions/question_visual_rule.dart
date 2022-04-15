part of QuestionsLib;

class VisualRuleQuestion<ConvertTyp, AnsTyp extends RuleResponseWrapperIfc>
    extends Question<ConvertTyp, AnsTyp> {
  /*
    VisualRuleQuestion questions are multi-part questions
    need to ask user:
      depending on visRuleType, the questions required are one of:
        VisRuleQuestType enum

    must collect enough data to render the full rule
  */
  late VisRuleChoiceConfig _questDef;

  VisualRuleQuestion(
    AppScreen appSection,
    ScreenWidgetArea screenArea,
    VisualRuleType visRuleType,
    ScreenAreaWidgetSlot? slot,
    // CastUserInputToTyp<ConvertTyp, AnsTyp>? castFunc,
  ) : super(
          QuestionQuantifier.ruleDetailMultiResponse(
            appSection,
            screenArea,
            visRuleType,
            slot,
            null,
          ),
          'niu--sub questions will be used',
          null,
          null,
        ) {
    // derive question/choices config
    this._questDef = VisRuleChoiceConfig.fromRuleTyp(visRuleType);
    // create empty response container
    this.response = UserResponse(visRuleType.ruleResponseContainer as AnsTyp);
  }

  VisRuleChoiceConfig get questDef => _questDef;
  List<VisRuleQuestWithChoices> get questsAndChoices =>
      _questDef.questsAndChoices;

  @override
  String get questStr => _questDef.questStr;

  // @override
  // bool get gens2ndOr3rdSortGroupFilterQuests {
  //   return this.response?.answers.gens2ndOr3rdSortGroupFilterQuests ?? false;
  // }

  RuleResponseWrapperIfc get asVisualRules {
    // doing the hard work of converting answers
    // into a structured data representation
    // var vrs = response!.answers;
    return response!.answers;
  }

  void castResponseListAndStore(Map<VisRuleQuestType, String> multiAnswerMap) {
    // store user answers
    (this.response?.answers as RuleResponseWrapperIfc)
        .castResponsesToAnswerTypes(multiAnswerMap);
  }

  static Question makeFromExisting(
    Question ques,
    String newQuestStr,
    PerQuestGenOptions genOpt,
  ) {
    //
    QuestionQuantifier qq = ques.qQuantify.copyWith();
    var vrq = VisualRuleQuestion(
      ques.appScreen,
      ques.screenWidgetArea!,
      qq.visRuleTypeForAreaOrSlot!,
      ques.slotInArea,
    );
    vrq._questDef = VisRuleChoiceConfig.fromGenOptions(genOpt);

    return vrq;
  }
}
