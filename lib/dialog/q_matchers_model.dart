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

  void appendForTesting(List<QuestMatcher> ml) {
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

    if (_foundQmatchers.length > 0) {
      // _foundQmatchers.forEach((QuestMatcher qm) {
      //   print('\nQuest: ${questJustAnswered.questId}');
      //   // print('\t\ton screen: ' + questJustAnswered.appScreen.name);
      //   print('\tmatched: ' + qm.matcherDescrip);
      // });
    } else {
      // print(
      //   '*** appendNewQuestsOrInsertImplicitAnswers found ${_foundQmatchers.length} QuestMatchers for ${questJustAnswered.questId}',
      // );
    }
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

  next 2 cannot be final;  only one is used
  function takes precedence; if deriveQuestGenCallbk passed
  it will be used
  */
  DerivedQuestGenerator derivedQuestGen;
  // derQuestGeneratorFactory will build a DerivedQuestGenerator when derivedQuestGen is a noop
  DerQuestGeneratorFactoryClbk? deriveQuestGenCallbk; // <AnsTypOfMatched>

  // AddQuestChkCallbk is for doing more advanced analysis to verify a match
  final AddQuestRespChkCallbk?
      validateUserAnswerAfterPatternMatchIsTrueCallback;
  final PriorQuestIdMatchPatternTest? questIdPatternMatchTest;

  // pattern matching values;  leave null to not match on them
  Type matchedQuestType;
  TargetPrecision? targetPrecision;
  //
  QuestMatcher(
    this.matcherDescrip,
    this.matchedQuestType, {
    required this.derivedQuestGen,
    this.targetPrecision,
    this.validateUserAnswerAfterPatternMatchIsTrueCallback,
    this.questIdPatternMatchTest,
    // send DerivedQuestGenerator.noop to derivedQuestGen
    // when you wish to use deriveQuestGenCallbk
    this.deriveQuestGenCallbk,
  }) {
    // below crashes all tests
    // assert(questType is QuestBase, 'questType must be subclass of QuestBase');
  }

  // getters
  bool get producesBuilderRules => false;
  bool get usesMatchByQIdPatternCallback => questIdPatternMatchTest != null;
  bool get shouldValidateUserAnswer =>
      validateUserAnswerAfterPatternMatchIsTrueCallback != null;
  bool get isTargetComplete =>
      targetPrecision != null ? targetPrecision!.targetComplete : false;

  // public methods
  bool doesMatch(QuestBase prevAnsweredQuest) {
    //
    bool isAPatternMatch = targetPrecision == null ||
        targetPrecision == prevAnsweredQuest.qTargetResolution.precision;
    if (!isAPatternMatch || prevAnsweredQuest.runtimeType != matchedQuestType) {
      return false;
    }

    if (usesMatchByQIdPatternCallback) {
      // print('this matcher targeted at a SPECIFIC question & does not consider other atts');
      isAPatternMatch =
          this.questIdPatternMatchTest!(prevAnsweredQuest.questId);
      if (!isAPatternMatch) {
        return false;
      }
    }

    // is proper match on questId; should we also check answer?
    // pattern match succeeded (isAPatternMatch == true)
    // so now validate user answer if requested
    if (shouldValidateUserAnswer) {
      isAPatternMatch = validateUserAnswerAfterPatternMatchIsTrueCallback!(
        prevAnsweredQuest,
      );
    }
    if (isAPatternMatch) {
      //
      bool isNoopGenerator = this.derivedQuestGen.isNoopGenerator;
      String shortDesc = matcherDescrip.substring(0, 80);
      print(
        'Matcher: ${prevAnsweredQuest.questId} HIT on:\n\t"$shortDesc"\n\t(matcher uses: ${isNoopGenerator ? "CALLBACK" : "STATIC"} as source for DQG)',
      );
    }
    return isAPatternMatch;
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

  // bool _doDeeperMatch(QuestBase quest) {
  //   // compare all properties instead of only QuestionId
  //   bool dMatch = true;
  //   // dMatch = dMatch &&
  //   //     (this.respCascadePatternEm == null ||
  //   //         this.respCascadePatternEm == quest.respCascadePatternEm);
  //   // if (!dMatch) return false; // only continue tests when succeeding
  //   // print('Cascade matches: $dMatch');

  //   // dMatch =
  //   //     dMatch && (this.appScreen == null || this.appScreen == quest.appScreen);
  //   // if (!dMatch) return false;
  //   // // print('appScreen matches: $dMatch');

  //   // dMatch = dMatch &&
  //   //     (this.screenWidgetArea == null ||
  //   //         this.screenWidgetArea == quest.screenWidgetArea);
  //   // if (!dMatch) return false;
  //   // // print('screenWidgetArea matches: $dMatch');

  //   // dMatch = dMatch &&
  //   //     (this.slotInArea == null || this.slotInArea == quest.slotInArea);
  //   // if (!dMatch) return false;
  //   // // print('slotInArea matches: $dMatch');

  //   // dMatch = dMatch &&
  //   //     (this.visRuleTypeForAreaOrSlot == null ||
  //   //         this.visRuleTypeForAreaOrSlot == quest.visRuleTypeForAreaOrSlot);
  //   // if (!dMatch) return false;
  //   // print('visRuleTypeForAreaOrSlot matches: $dMatch');
  //   // print('isRuleQuestion: ${quest.isRuleDetailQuestion}');

  //   // dMatch =
  //   //     dMatch && (this.typ == null || quest.response.runtimeType == this.typ);
  //   return dMatch;
  // }
}


/*

class Base {
  
}

class OneA extends Base {
  
}

class OneB extends Base {
  
}


class TypeTest {
  Type typ;
  
  TypeTest(this.typ);
}



void main() {
  
  TypeTest tt = TypeTest(Base);
  TypeTest ttA = TypeTest(OneA);
  TypeTest ttB = TypeTest(OneB);
  
  print('Class (Base) level:');
  print(tt.typ is Base);
  print(tt.typ.runtimeType is Base);
  // below works
  print(tt.typ == Base);
  print(tt.typ.runtimeType == Base);
  
  print('\nInstance level:');
  Base b = Base();
  // below works
  print(tt.typ == b.runtimeType);
  print(tt.typ.runtimeType == b);
  
  
  print('\nClass (OneA) level:');
  print(ttA.typ is OneA);
  print(ttA.typ.runtimeType is OneA);
  // below works
  print(ttA.typ == OneA);
  print(ttA.typ.runtimeType == OneA);
  
  print('\nInstance level:');
  OneA on = OneA();
  // below works
  print(ttA.typ == on.runtimeType);
  print(ttA.typ.runtimeType == on);
  
  
  print('\nClass (OneB) level:');
  print(ttB.typ is OneB);
  print(ttB.typ.runtimeType is OneB);
  // below works
  print(ttB.typ == OneB);
  print(ttB.typ.runtimeType == OneB);
  
  print('\nInstance level:');
  OneB ob = OneB();
  // below works
  print(ttB.typ == ob.runtimeType);
  print(ttB.typ.runtimeType == ob);
}



*/