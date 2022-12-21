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

  List<QuestBase> getGendQuestions(QuestBase questJustAnswered) {
    // List<QuestMatcher> _foundQmatchers = [];
    List<QuestBase> newGendPendingQuests = []; // generated questions
    for (QuestMatcher curQuestMatcher in _matcherList) {
      if (curQuestMatcher.doesMatch(questJustAnswered)) {
        // remember matcher and get generated questions from it
        // _foundQmatchers.add(curQuestMatcher);
        newGendPendingQuests.addAll(
          curQuestMatcher.getDerivedAutoGenQuestions(
            questJustAnswered,
          ),
        );
      }
    }
    return newGendPendingQuests;
  }

  // top level function to add new Questions or implicit answers
  void appendNewQuestsOrInsertImplicitAnswers(
      QuestListMgr questListMgr, QuestBase questJustAnswered,
      {bool addAfterCurrent = false}) {
    //
    if (questJustAnswered.questId !=
        questListMgr.currentOrLastQuestion.questId) {
      // happens durring testing; not sure if this is a real problem or not?
      // ConfigLogger.log(Level.FINER,
      //   'Warning:  current quest idx was moved during this process',
      // );
    }
    // ConfigLogger.log(Level.FINER,
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
      //   ConfigLogger.log(Level.FINER, '\nQuest: ${questJustAnswered.questId}');
      //   // ConfigLogger.log(Level.FINER, '\t\ton screen: ' + questJustAnswered.appScreen.name);
      //   ConfigLogger.log(Level.FINER, '\tmatched: ' + qm.matcherDescrip);
      // });
    } else {
      // ConfigLogger.log(Level.FINER,
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
  /* cascadeTypeOfMatchedQuest indicates what type of
    new Questions (or potentially auto-answers)
    will be added by the DerivedQuestGenerator

    cascadeTypeOfMatchedQuest == cascadeWorkDoneByRespGendQuests 
    on QTargetIntent

  next 2 cannot be final;  only one is used
  function takes precedence; if deriveQuestGenCallbk passed
  it will be used

  ALWAYS use _getActiveDqg(qb)
  and NEVER READ derivedQuestGen directly
  */
  DerivedQuestGenerator derivedQuestGen;
  // derQuestGeneratorFactory will build a DerivedQuestGenerator when derivedQuestGen is a noop instance
  DerQuestGeneratorFactoryClbk? deriveQuestGenCallbk;

  // AddQuestRespChkCallbk is for doing more advanced analysis to verify a match
  final AddQuestRespChkCallbk?
      validateUserAnswerAfterPatternMatchIsTrueCallback;
  final PriorQuestIdMatchPatternTest? questIdPatternMatchTest;

  // pattern matching values;  leave null to not match on them
  Type matchedQuestType;
  // TargetPrecision? targetPrecision;
  //
  QuestMatcher(
    this.matcherDescrip,
    this.matchedQuestType, {
    required this.derivedQuestGen,
    // this.targetPrecision,
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
  // bool get isTargetComplete =>
  //     targetPrecision != null ? targetPrecision!.targetComplete : false;

  // public methods
  bool doesMatch(QuestBase prevAnsweredQuest) {
    //
    // bool isAPatternMatch = targetPrecision == null ||
    //     targetPrecision == prevAnsweredQuest.qTargetResolution.precision;

    bool isAPatternMatch = true;
    if (prevAnsweredQuest.runtimeType != matchedQuestType) {
      return false;
    }

    if (usesMatchByQIdPatternCallback) {
      // ConfigLogger.log(Level.FINER, 'this matcher targeted at a SPECIFIC question & does not consider other atts');
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
      bool isNoopGenerator = _getActiveDqg(prevAnsweredQuest).isNoopGenerator;
      isAPatternMatch = isNoopGenerator ? false : isAPatternMatch;

      String shortDesc =
          matcherDescrip.replaceAll("\n", "").replaceAll("    ", " ");

      int strLen = min(120, shortDesc.length);
      shortDesc = shortDesc.substring(0, strLen).trimRight();

      ConfigLogger.log(
        Level.INFO,
        '\tMatcher Hit -- QID: ${prevAnsweredQuest.questId}\n\t\thit -> "$shortDesc"\n\t\t(using: ${isNoopGenerator ? "CALLBACK" : "STATIC"} as source for DQG)',
      );
    }
    return isAPatternMatch;
  }

  List<QuestBase> getDerivedAutoGenQuestions(QuestBase answeredQuest) {
    DerivedQuestGenerator dqg = _getActiveDqg(answeredQuest);
    if (dqg.isNoopGenerator) {
      ConfigLogger.log(Level.SEVERE,
          'Err: bailing getDerivedAutoGenQuestions because dqg is a no-op');
      return [];
    }
    return dqg.getDerivedAutoGenQuestions(
      answeredQuest,
      matcherDescrip4Debug: this.matcherDescrip,
    );
  }

  AnsTypOfMatched getTypedAnswer(QuestBase priorAnsweredQuest) {
    // should only call this when Question doesMatch
    assert(
      doesMatch(priorAnsweredQuest),
      'invalid usage of getTypedAnswer; should only call this when Question doesMatch',
    );
    return priorAnsweredQuest.mainAnswer as AnsTypOfMatched;
  }

  DerivedQuestGenerator _getActiveDqg(QuestBase qb) {
    // never replace the STORED derivedQuestGen or many problems will result
    assert(
      deriveQuestGenCallbk == null || derivedQuestGen.isNoopGenerator,
      'its an error to provide BOTH a valid derivedQuestGen and a callback to generate one',
      // matchers are reused between questions; cannot leave a DYNAMIC/CALLBACK built value stored on this instance or it will mix question types
    );
    if (deriveQuestGenCallbk == null) return derivedQuestGen;

    assert(
      derivedQuestGen.isNoopGenerator,
      'err:  expected noop generator when callback specified;  why would you add a real DQG when you added deriveQuestGenCallbk to immediately replace it?',
    );
    // should generate DQG rather than return stored DQG;  always generated it fresh for each question
    return deriveQuestGenCallbk!(
      qb,
      0,
    );
  }
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
  
  ConfigLogger.log(Level.FINER,'Class (Base) level:');
  ConfigLogger.log(Level.FINER,tt.typ is Base);
  ConfigLogger.log(Level.FINER,tt.typ.runtimeType is Base);
  // below works
  ConfigLogger.log(Level.FINER,tt.typ == Base);
  ConfigLogger.log(Level.FINER,tt.typ.runtimeType == Base);
  
  ConfigLogger.log(Level.FINER,'\nInstance level:');
  Base b = Base();
  // below works
  ConfigLogger.log(Level.FINER,tt.typ == b.runtimeType);
  ConfigLogger.log(Level.FINER,tt.typ.runtimeType == b);
  
  
  ConfigLogger.log(Level.FINER,'\nClass (OneA) level:');
  ConfigLogger.log(Level.FINER,ttA.typ is OneA);
  ConfigLogger.log(Level.FINER,ttA.typ.runtimeType is OneA);
  // below works
  ConfigLogger.log(Level.FINER,ttA.typ == OneA);
  ConfigLogger.log(Level.FINER,ttA.typ.runtimeType == OneA);
  
  ConfigLogger.log(Level.FINER,'\nInstance level:');
  OneA on = OneA();
  // below works
  ConfigLogger.log(Level.FINER,ttA.typ == on.runtimeType);
  ConfigLogger.log(Level.FINER,ttA.typ.runtimeType == on);
  
  
  ConfigLogger.log(Level.FINER,'\nClass (OneB) level:');
  ConfigLogger.log(Level.FINER,ttB.typ is OneB);
  ConfigLogger.log(Level.FINER,ttB.typ.runtimeType is OneB);
  // below works
  ConfigLogger.log(Level.FINER,ttB.typ == OneB);
  ConfigLogger.log(Level.FINER,ttB.typ.runtimeType == OneB);
  
  ConfigLogger.log(Level.FINER,'\nInstance level:');
  OneB ob = OneB();
  // below works
  ConfigLogger.log(Level.FINER,ttB.typ == ob.runtimeType);
  ConfigLogger.log(Level.FINER,ttB.typ.runtimeType == ob);
}



*/