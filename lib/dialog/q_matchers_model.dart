part of ConfigDialogRunner;

/*  Questions about ListView area (aka TableView)
  sorting, grouping or filtering pose a new requirement
  we need to know HOW MANY (from 0-3) fields they want to specify
  under that respective rule

  for example, under grouping, if they say 2, then we should add 2 Quest2s
  to let them specify the grouping-key (some asset field/property)

*/

const String _missingQuestId = '-na';

class QMatchCollection {
  /*  use basic constructor for testing
      use factory QMatchCollection.scoretrader
      for real CLI usage
  */
  List<QuestMatcher> _matcherList;

  QMatchCollection(this._matcherList);

  // factory QMatchCollection.scoretrader() {
  //   return QMatchCollection(stDfltMatcherList);
  // }

  void append(List<QuestMatcher> ml) {
    _matcherList.addAll(ml);
  }

  // top level function to add new Questions or implicit answers
  void appendNewQuestsOrInsertImplicitAnswers(
    QuestListMgr questListMgr,
    QuestBase questJustAnswered,
  ) {
    //
    if (questJustAnswered.questId !=
        questListMgr.currentOrLastQuestion.questId) {
      // happens durring testing; not sure if this is a real problem or not?
      // print(
      //   'Warning:  current quest idx was moved during this process',
      // );
    }
    // print(
    //   'comparing "${questJustAnswered.questId}" to ${_matcherList.length} matchers for new quests',
    // );
    List<QuestMatcher> _foundQmatchers = [];
    List<QuestBase> newGendPendingQuests = []; // generated questions
    for (QuestMatcher curQuestMatcher in _matcherList) {
      if (curQuestMatcher.doesMatch(questJustAnswered)) {
        // remember matcher and get generated questions from it
        _foundQmatchers.add(curQuestMatcher);
        newGendPendingQuests.addAll(
          curQuestMatcher.getDerivedAutoGenQuestions(
            questJustAnswered,
          ),
        );
      }
    }
    questListMgr.appendGeneratedQuestsAndAnswers(newGendPendingQuests);

    if (_foundQmatchers.length < 1) {
      print(
        '*** appendNewQuestsOrInsertImplicitAnswers found ${_foundQmatchers.length} QuestMatchers for ${questJustAnswered.questId}',
      );
    }
    // _foundQmatchers.forEach((qm) {
    //   print('\nScreen: ');
    //   print(questJustAnswered.appScreen.name);
    //   print('\t\t' + qm.matcherDescrip);
    // });
  }

  // testing below
  int matchCountFor(QuestBase quest) {
    // mostly for testing
    int cnt = 0;
    for (QuestMatcher matchTest in _matcherList) {
      if (matchTest.doesMatch(quest)) {
        cnt++;
      }
    }
    return cnt;
  }

  // mostly for testing
  Iterable<QuestMatcher> get allMatchersTestOnly => _matcherList;
}

class QuestMatcher<AnsTypOfMatched, AnsTypOfGend> {
  /*
  defines rules for generating NEW QUESTIONS (or answers)
  off of the answers (main answer type) from each prior question

  AnsTypOfMatched is the main answer type of matched question
  AnsTypOfGend is the main answer type of generated questions

  define all properties a matcher may need to eval
  in order to verify it's a match
  but most logic just works on this callback:
    questIdPatternMatchTest(priorQuestId);
  which receives the prior question ID as a test for match succcess
  */
  final String matcherDescrip;
  bool _hasCreatedDynamicDqg = false;
  /* cascadeTypeOfMatchedQuest indicates what type of
    new Questions (or potentially auto-answers)
    will be added by the DerivedQuestGenerator

    cascadeTypeOfMatchedQuest == cascadeWorkDoneByRespGendQuests 
    on QTargetIntent
  */
  // final QRespCascadePatternEm? respCascadePatternEm;
  /*
  next 2 cannot be final;  only one is used
  function takes precedence; if deriveQuestGenCallbk passed
  it will be used
  */
  DerivedQuestGenerator derivedQuestGen; // <AnsTypOfMatched>
  // derQuestGeneratorFactory will build a DerivedQuestGenerator when derivedQuestGen is a noop
  DerQuestGeneratorFactoryClbk? deriveQuestGenCallbk; // <AnsTypOfMatched>

  // AddQuestChkCallbk is for doing more advanced analysis to verify a match
  final AddQuestRespChkCallbk?
      validateUserAnswerAfterPatternMatchIsTrueCallback;
  final PriorQuestIdMatchPatternTest? questIdPatternMatchTest;

  // pattern matching values;  leave null to not match on them
  final AppScreen? appScreen;
  final ScreenWidgetArea? screenWidgetArea;
  final ScreenAreaWidgetSlot? slotInArea;
  final VisualRuleType? visRuleTypeForAreaOrSlot;
  final BehaviorRuleType? behRuleTypeForAreaOrSlot;

  //
  QuestMatcher(
    this.matcherDescrip, {
    required this.derivedQuestGen,
    this.validateUserAnswerAfterPatternMatchIsTrueCallback,
    this.questIdPatternMatchTest,
    this.appScreen,
    this.screenWidgetArea,
    this.slotInArea,
    this.visRuleTypeForAreaOrSlot,
    this.behRuleTypeForAreaOrSlot,
    this.deriveQuestGenCallbk,
  });

  // getters
  bool get producesBuilderRules => false;
  bool get usesMatchByQIdPatternCallback => questIdPatternMatchTest != null;
  bool get shouldValidateUserAnswer =>
      validateUserAnswerAfterPatternMatchIsTrueCallback != null;
  bool get isTargetComplete =>
      appScreen != null &&
      screenWidgetArea != null &&
      visRuleTypeForAreaOrSlot != null;

  // expose generic types
  // Type get matchedAnsTyp => AnsTypOfMatched;
  // Type get generatedQuestAnsTyp => AnsTypOfGend;

  // public methods
  bool doesMatch(QuestBase prevAnsweredQuest) {
    //
    if (usesMatchByQIdPatternCallback) {
      // print('this matcher targeted at a SPECIFIC question & does not consider other atts');
      bool patternDoesMatch =
          this.questIdPatternMatchTest!(prevAnsweredQuest.questId);
      if (!patternDoesMatch) {
        return false;
      }
      // is proper match on questId; should we also check answer?
      if (shouldValidateUserAnswer) {
        return validateUserAnswerAfterPatternMatchIsTrueCallback!(
          prevAnsweredQuest,
        );
      }
      if (patternDoesMatch) {
        var firstPrompt = derivedQuestGen.perPromptDetails.first;
        print(
          'QID: ${prevAnsweredQuest.questId} does match ${firstPrompt.promptTemplate}',
        );
      }
      return patternDoesMatch; // always true here
    }

    bool isAPatternMatch = _doDeeperMatch(prevAnsweredQuest);
    // pattern doesnt match so exit early
    if (!isAPatternMatch) return false;

    // check target resolution
    // isAPatternMatch =
    // prevAnsweredQuest.targetPathIsComplete && isTargetComplete;

    // pattern match succeeded (isAPatternMatch == true)
    // so now validate user answer if requested
    if (shouldValidateUserAnswer) {
      return validateUserAnswerAfterPatternMatchIsTrueCallback!(
        prevAnsweredQuest,
      );
    }

    if (isAPatternMatch && !this.derivedQuestGen.isNoopGenerator) {
      var firstPrompt = derivedQuestGen.perPromptDetails.first;
      print(
        'QID: ${prevAnsweredQuest.questId} does match ${firstPrompt.promptTemplate}',
      );
    }
    return isAPatternMatch; // always true here
  }

  List<QuestBase> getDerivedAutoGenQuestions(QuestBase answeredQuest) {
    DerivedQuestGenerator dqg = activeDqg(answeredQuest); // <AnsTypOfMatched>
    if (dqg.isNoopGenerator) {
      print('Warn: bailing getDerivedAutoGenQuestions because dqg is a no-op');
      return [];
    }
    return dqg.getDerivedAutoGenQuestions(answeredQuest);
  }

  AnsTypOfMatched getTypedAnswer(QuestBase priorAnsweredQuest) {
    // should only call this when Question doesMatch
    assert(
      doesMatch(priorAnsweredQuest),
      'invalid usage of getTypedAnswer; should only call this when Question doesMatch',
    );
    return priorAnsweredQuest.mainAnswer as AnsTypOfMatched;
  }

  bool _doDeeperMatch(QuestBase quest) {
    // compare all properties instead of only QuestionId
    bool dMatch = true;
    // dMatch = dMatch &&
    //     (this.respCascadePatternEm == null ||
    //         this.respCascadePatternEm == quest.respCascadePatternEm);
    // if (!dMatch) return false; // only continue tests when succeeding
    // print('Cascade matches: $dMatch');

    dMatch =
        dMatch && (this.appScreen == null || this.appScreen == quest.appScreen);
    if (!dMatch) return false;
    // print('appScreen matches: $dMatch');

    dMatch = dMatch &&
        (this.screenWidgetArea == null ||
            this.screenWidgetArea == quest.screenWidgetArea);
    if (!dMatch) return false;
    // print('screenWidgetArea matches: $dMatch');

    dMatch = dMatch &&
        (this.slotInArea == null || this.slotInArea == quest.slotInArea);
    if (!dMatch) return false;
    // print('slotInArea matches: $dMatch');

    dMatch = dMatch &&
        (this.visRuleTypeForAreaOrSlot == null ||
            this.visRuleTypeForAreaOrSlot == quest.visRuleTypeForAreaOrSlot);
    if (!dMatch) return false;
    // print('visRuleTypeForAreaOrSlot matches: $dMatch');
    // print('isRuleQuestion: ${quest.isRuleDetailQuestion}');

    // dMatch =
    //     dMatch && (this.typ == null || quest.response.runtimeType == this.typ);
    return dMatch;
  }

  DerivedQuestGenerator activeDqg(QuestBase? qb) {
    if (deriveQuestGenCallbk == null || _hasCreatedDynamicDqg)
      return derivedQuestGen;

    assert(
      derivedQuestGen.isNoopGenerator,
      'err:  expected noop stored generator;  why would you add a real DQG when you added deriveQuestGenCallbk to immediately replace it?',
    );
    // should generate DQG rather than return stored DQG
    derivedQuestGen = deriveQuestGenCallbk!(
      qb!,
      0,
    ); // as DerivedQuestGenerator<AnsTypOfMatched>
    _hasCreatedDynamicDqg = true;
    return derivedQuestGen;
  }
}
