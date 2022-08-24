part of QuestionsLib;

/*   the DerivedQuestGenerator & NewQuestPerPromptOpts classes desscribes the 
logic & data-types required to auto-gen new questions
 (including multiple prompts within the question)
based on answers to a prior question

  DerivedQuestGenerator is responsible
  for looking at questJustAnswered
  and creating any derived questions
  (sometimes with implicit answers
  that we dont need to ask
    although that impl is not currently added
  )

*/

class NewQuestPerPromptOpts<AnsType> {
  /*
  describes logic and rules for a prompt on an auto-generated Question
  each instance lives inside DerivedQuestGenerator.perPromptDetails

  acceptsMultiResponses means user can select more
  than one choice, like:   "0,2,4"

  I have a hunch that generally
    AnsType is one of VisRuleQuestType or bool
    eg VisRuleQuestType.selectDataFieldName.subquestionsForEachPrepInstance(vrt)
  */

  final String promptTemplate;
  final NewQuestArgGen promptTemplArgGen;
  final ChoiceListFromPriorAnswer answerChoiceGenerator;
  final CastStrToAnswTypCallback<AnsType> newRespCastFunc;
  final int defaultAnswerIdx;
  final VisualRuleType? visRuleType;
  final VisRuleQuestType? visRuleQuestType;
  // instanceIdx used to order prompts in multi-part questions
  final int instanceIdx;
  bool acceptsMultiResponses;

  NewQuestPerPromptOpts(
    this.promptTemplate, {
    required this.promptTemplArgGen,
    required this.answerChoiceGenerator,
    required this.newRespCastFunc,
    this.visRuleType,
    this.visRuleQuestType,
    this.acceptsMultiResponses = false,
    this.defaultAnswerIdx = 0,
    this.instanceIdx = 0,
  }) {
    //
  }

  // Type get genType => AnsType;
  // bool get genAsRuleQuestion => visRuleType != null;

}

class DerivedQuestGenerator {
  /*  <PriorAnsType>
    intersection of an answered Question, plus (usually) a QuestMatcher
    or (alternatively; see below) a specific question that we know already matched

    provides data/config to specify how to generate new Question(s)
    such that user can provide more targetting info, or full rule-specs

  Important:
    some instances of this object are created and stored on a
    QuestMatcher, in which case we don't know WHICH question
    will hit the matcher, (eg for the future)
    that hit will use this object to create new questions
    for those scenarios, most of the properties on this object are
    callbacks in which the 1st argument is the matching question

    other instances of this object are created INSIDE a closure on:
      extension VisualRuleTypeExt1 on VisualRuleType
    in which the pertinent question is IN SCOPE (as upval),
    and the first arg (QuestBase) on most of the callbacks are totally moot
    in that case, we can use upvalues once, and ignore the arg 1 QB
  */

  final List<NewQuestPerPromptOpts> perPromptDetails;
  final NewQuestCount newQuestCountCalculator;
  // qTargetResUpdater func may not be necessary now that each question
  // knows how to generate it's own derived QTargetResolution
  final QTargetResUpdateFunc qTargetResUpdater;
  final NewQuestIdGenFromPriorAnswer? newQuestIdGenFromPriorQuest;
  final DerivedGenBehaviorOnMatchEnum genBehaviorOfDerivedQuests;
  QuestFactorytSignature? newQuestConstructor;
  final BailQGenWhenTrue? bailQGenWhenTrueCallbk;

  DerivedQuestGenerator._(
    // private constructor
    this.perPromptDetails, {
    required this.newQuestCountCalculator,
    QTargetResUpdateFunc? deriveTargetFromPriorRespCallbk,
    this.newQuestIdGenFromPriorQuest,
    this.newQuestConstructor,
    this.genBehaviorOfDerivedQuests =
        DerivedGenBehaviorOnMatchEnum.addPendingQuestions,
    this.bailQGenWhenTrueCallbk,
  }) : this.qTargetResUpdater = deriveTargetFromPriorRespCallbk == null
            ? _ccTargetRes
            : deriveTargetFromPriorRespCallbk;

  factory DerivedQuestGenerator.singlePrompt(
    String questPromptTemplate, {
    required NewQuestCount newQuestCountCalculator,
    required NewQuestArgGen newQuestPromptArgGen,
    required ChoiceListFromPriorAnswer answerChoiceGenerator,
    required CastStrToAnswTypCallback newRespCastFunc,
    // optional args below
    DerivedGenBehaviorOnMatchEnum genBehaviorOfDerivedQuests =
        DerivedGenBehaviorOnMatchEnum.addPendingQuestions,
    NewQuestIdGenFromPriorAnswer? newQuestIdGenFromPriorQuest,
    QTargetResUpdateFunc? deriveTargetFromPriorRespCallbk,
    QuestFactorytSignature? newQuestConstructor,
    BailQGenWhenTrue? bailQGenWhenTrueCallbk,
    bool acceptsMultiResponses = false,
  }) {
    var qpp = NewQuestPerPromptOpts(
      questPromptTemplate,
      promptTemplArgGen: newQuestPromptArgGen,
      answerChoiceGenerator: answerChoiceGenerator,
      newRespCastFunc: newRespCastFunc,
      acceptsMultiResponses: acceptsMultiResponses,
    );

    return DerivedQuestGenerator._(
      [qpp],
      genBehaviorOfDerivedQuests: genBehaviorOfDerivedQuests,
      newQuestCountCalculator: newQuestCountCalculator,
      deriveTargetFromPriorRespCallbk: deriveTargetFromPriorRespCallbk,
      newQuestIdGenFromPriorQuest: newQuestIdGenFromPriorQuest,
      newQuestConstructor: newQuestConstructor,
      bailQGenWhenTrueCallbk: bailQGenWhenTrueCallbk,
    );
  }

  factory DerivedQuestGenerator.multiPrompt(
    List<NewQuestPerPromptOpts> perNewQuestGenOpts, {
    required NewQuestCount newQuestCountCalculator,
    // optional args below
    DerivedGenBehaviorOnMatchEnum genBehaviorOfDerivedQuests =
        DerivedGenBehaviorOnMatchEnum.addPendingQuestions,
    NewQuestIdGenFromPriorAnswer? newQuestIdGenFromPriorQuest,
    QTargetResUpdateFunc? deriveTargetFromPriorRespCallbk,
    QuestFactorytSignature? newQuestConstructor,
    BailQGenWhenTrue? bailQGenWhenTrueCallbk,
    bool allAcceptsMultiResponses = false,
  }) {
    if (allAcceptsMultiResponses) {
      for (NewQuestPerPromptOpts qpp in perNewQuestGenOpts) {
        qpp.acceptsMultiResponses = allAcceptsMultiResponses;
      }
    }
    return DerivedQuestGenerator._(
      perNewQuestGenOpts,
      genBehaviorOfDerivedQuests: genBehaviorOfDerivedQuests,
      newQuestCountCalculator: newQuestCountCalculator,
      deriveTargetFromPriorRespCallbk: deriveTargetFromPriorRespCallbk,
      newQuestIdGenFromPriorQuest: newQuestIdGenFromPriorQuest,
      newQuestConstructor: newQuestConstructor,
      bailQGenWhenTrueCallbk: bailQGenWhenTrueCallbk,
    );
  }

  factory DerivedQuestGenerator.noop() {
    /*
      dummy rec for when we dont need to produce new questions
      can serve as a placeholder for when this/self (DerivedQuestGenerator)
      will be generated by a function on the enclosing Matcher model object
      
      also used in testing
    */
    return DerivedQuestGenerator._(
      [], // no prompts means inert (noop) DQG (isNoopGenerator true)
      genBehaviorOfDerivedQuests: DerivedGenBehaviorOnMatchEnum.noop,
      newQuestCountCalculator: (qb) => 0,
    );
  }

  factory DerivedQuestGenerator.noopTest() {
    // dgq that won't throw off our match count
    // because isNoopGenerator will be false
    var qpp = NewQuestPerPromptOpts<bool>('',
        promptTemplArgGen: (_, __, pi) => [],
        answerChoiceGenerator: (_, __, n) => [],
        newRespCastFunc: (_, __) => false);

    return DerivedQuestGenerator._(
      [qpp], // > 0 prompts means isNoopGenerator is false
      genBehaviorOfDerivedQuests: DerivedGenBehaviorOnMatchEnum.noop,
      newQuestCountCalculator: (qb) => 0,
    );
  }

  List<QuestBase> getDerivedAutoGenQuestions(
    QuestBase answeredQuest, {
    String matcherDescrip4Debug = '',
  }) {
    /* use existing answered Question
    plus logic defined in both this and perPromptDetails
    to build and return a list of new Questions
    */
    int newQuestCount = newQuestCountCalculator(answeredQuest);

    // priscilla can make debugInfo differ based on debug-level;  example below
    // Debug.info
    String debugInfo = firstPromptOrNoOp;
    // Debug.finer
    // String debugInfo = matcherDescrip4Debug;

    if (newQuestCount < 1) {
     ConfigLogger.log(Level.WARNING, 
        'DeQuestGen.getDerivedAutoGenQuestions aborted due to:\n\tnewQuestCount: $newQuestCount from matcher:\n\t$debugInfo',
      );
      return [];
    }

    // store new questions here
    List<QuestBase> createdQuests = [];
    //
    bool newQuConstrWasNull = newQuestConstructor == null;
    if (newQuConstrWasNull) {
      // if newQuestConstructor was not stored on this
      // then use the default derivedQuestConstructor from the prior question
      newQuestConstructor = answeredQuest.derivedQuestConstructor;
    }

    int newQuestPromptCount = this.perPromptDetails.length;

    // values required to build new question:
    // loop once for each new question & again for each prompt
    for (int newQIdx = 0; newQIdx < newQuestCount; newQIdx++) {
      if (bailQGenWhenTrueCallbk != null &&
          bailQGenWhenTrueCallbk!(
            answeredQuest,
            newQIdx,
          )) {
        // print(
        //   'skipping Q# $newQIdx on ${answeredQuest.questId} for bailQGenWhenTrueCallbk; no derived quest generated from matcher $matcherDescrip4Debug',
        // );
        continue;
      }

      List<QuestPromptPayload> newQuestPrompts = [];
      for (int promptEntryListIdx = 0;
          promptEntryListIdx < newQuestPromptCount;
          promptEntryListIdx++) {
        // loop once for each prompt in a single question
        NewQuestPerPromptOpts currPromptConfig =
            this.perPromptDetails[promptEntryListIdx];

        List<String> promptChoices = currPromptConfig.answerChoiceGenerator(
          answeredQuest,
          newQIdx,
          promptEntryListIdx,
        );

        if (promptChoices.length < 1) {
          // print(
          //   'prompt $promptEntryListIdx (${currPromptConfig.instanceIdx}) on PREV questId ${answeredQuest.questId} has no choices so bailing.',
          // );
          // print(
          //   '''\tCan occur when answer has a mix of rules requiring BOTH prep & detail as next step.
          //   \tThe rule going directly to detail can return no choices to prevent a prep question prompt from being created!''',
          // );
          continue;
        }

        List<String> templArgs = currPromptConfig.promptTemplArgGen(
          answeredQuest,
          newQIdx,
          promptEntryListIdx,
        );
        String _userPrompt = currPromptConfig.promptTemplate.format(templArgs);

        newQuestPrompts.add(QuestPromptPayload(
          _userPrompt,
          promptChoices,
          currPromptConfig.visRuleQuestType ?? VisRuleQuestType.dialogStruct,
          currPromptConfig.newRespCastFunc,
        ));
      }

      // dont create new quests if there are ZERO prompts
      if (newQuestPrompts.length < 1) continue;

      // convert old (answered) targIntent into one for new question
      // added extra copyWith() in case passed function forgets it
      QTargetResolution targIntent =
          qTargetResUpdater(answeredQuest, newQIdx).copyWith();

      String newQuestId = newQuestIdGenFromPriorQuest == null
          ? answeredQuest.questId + '-$newQIdx'
          : newQuestIdGenFromPriorQuest!(answeredQuest, newQIdx);
      QuestBase nxtQuest = newQuestConstructor!(
        targIntent,
        newQuestPrompts,
        questId: newQuestId,
      );
      createdQuests.add(nxtQuest);
    }

    if (newQuConstrWasNull) {
      // set back to null for the next time this instance is used
      newQuestConstructor = null;
    }
    return createdQuests;
  }

  String get firstPromptOrNoOp {
    if (isNoopGenerator || perPromptDetails.length < 1) return 'noop_dqg';
    return perPromptDetails.first.promptTemplate;
  }

  bool get isNoopGenerator =>
      promptCount == 0 &&
      genBehaviorOfDerivedQuests == DerivedGenBehaviorOnMatchEnum.noop;

  int get promptCount => perPromptDetails.length;
  bool get createsQuestWithMultiPrompts => promptCount > 1;

  static QTargetResolution _ccTargetRes(QuestBase prevAnswQuest, int newQIdx) {
    /*       returns near exact clone of exising target
      for when the deriveTargetFromPriorRespCallbk argument
      is not passed (as null) to this constructor 

    */
    // generic logic to try to update rule asap
    var existingAnswers = prevAnswQuest.mainAnswer;
    if (existingAnswers is Iterable<VisualRuleType>) {
      VisualRuleType curRule = existingAnswers.toList()[newQIdx];
     ConfigLogger.log(Level.INFO, '_ccTargetRes got ${curRule.name}');
      return prevAnswQuest.qTargetResolution
          .copyWith(visRuleTypeForAreaOrSlot: curRule);
    }
    if (existingAnswers is Iterable<BehaviorRuleType>) {
      BehaviorRuleType curRule = existingAnswers.toList()[newQIdx];
      return prevAnswQuest.qTargetResolution
          .copyWith(behRuleTypeForAreaOrSlot: curRule);
    }

    return prevAnswQuest.qTargetResolution.copyWith();
  }
}
