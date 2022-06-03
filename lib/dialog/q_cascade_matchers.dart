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

  factory QMatchCollection.scoretrader() {
    return QMatchCollection(stDfltMatcherList);
  }

  void append(List<QuestMatcher> ml) {
    _matcherList.addAll(ml);
  }

  // top level function to add new Questions or implicit answers
  void appendNewQuestsOrInsertImplicitAnswers(QuestListMgr questListMgr) {
    //
    QuestBase questJustAnswered = questListMgr._currentOrLastQuestion;
    print(
      'comparing "${questJustAnswered.questId}" to ${_matcherList.length} matchers for new quests',
    );
    for (QuestMatcher qMatchTest in _matcherList) {
      if (qMatchTest.doesMatch(questJustAnswered)) {
        print(
          '*** it does match!!  addsPendingQuestions: ${qMatchTest.addsPendingQuestions}  createsImplicitAnswers: ${qMatchTest.createsImplicitAnswers}',
        );
        if (qMatchTest.addsPendingQuestions) {
          List<QuestBase> newQuests =
              qMatchTest.getDerivedAutoGenQuestions(questJustAnswered);
          questListMgr.appendNewQuestions(newQuests);
        }
        if (qMatchTest.createsImplicitAnswers) {
          questListMgr.addImplicitAnswers(
            qMatchTest.getDerivedAutoGenQuestions(questJustAnswered),
          );
        }
      }
    }
  }

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
}

enum DerivedGenBehaviorOnMatchEnum {
  addPendingQuestions,
  addImplicitAnswers,
  addQuestsAndAnswers, // aka BOTH
  noop,
}

extension MatcherBehaviorEnumExt1 on DerivedGenBehaviorOnMatchEnum {
  //
  bool get addsPendingQuestions => [
        DerivedGenBehaviorOnMatchEnum.addPendingQuestions,
        DerivedGenBehaviorOnMatchEnum.addQuestsAndAnswers
      ].contains(this);

  bool get createsImplicitAnswers => [
        DerivedGenBehaviorOnMatchEnum.addImplicitAnswers,
        DerivedGenBehaviorOnMatchEnum.addQuestsAndAnswers
      ].contains(this);
}

class QuestMatcher<AnsType> {
  /*
  define all properties a matcher may need to eval
  in order to verify it's a match

  */
  final String matcherDescrip;
  // cascadeType indicates whether we add new Quest2s, auto-answers or both
  final QRespCascadePatternEm? cascadeTypeOfMatchedQuest;
  final DerivedQuestGenerator derivedQuestGen;

  // AddQuestChkCallbk is for doing more advanced analysis to verify a match
  final AddQuestChkCallbk? validateUserAnswerAfterPatternMatchIsTrueCallback;

  // pattern matching values;  leave null to not match on them
  final AppScreen? appScreen;
  final ScreenWidgetArea? screenWidgetArea;
  final ScreenAreaWidgetSlot? slotInArea;
  final VisualRuleType? visRuleTypeForAreaOrSlot;
  final BehaviorRuleType? behRuleTypeForAreaOrSlot;
  final bool matchOnlyOnRuleQuestion;
  final PriorQuestIdMatchPatternTest? questIdPatternTest;

  late Type? typ = CaptureAndCast<AnsType>;

  //
  QuestMatcher(
    this.matcherDescrip, {
    required this.cascadeTypeOfMatchedQuest,
    required this.derivedQuestGen,
    this.validateUserAnswerAfterPatternMatchIsTrueCallback,
    this.questIdPatternTest,
    this.appScreen,
    this.screenWidgetArea,
    this.slotInArea,
    this.visRuleTypeForAreaOrSlot,
    this.behRuleTypeForAreaOrSlot,
    this.matchOnlyOnRuleQuestion = false,
  });

  // getters
  bool get addsPendingQuestions =>
      derivedQuestGen.genBehaviorOfDerivedQuests.addsPendingQuestions;
  bool get createsImplicitAnswers =>
      derivedQuestGen.genBehaviorOfDerivedQuests.createsImplicitAnswers;

  bool get usesMatchByQIdPatternCallback => questIdPatternTest != null;
  bool get shouldValidateUserAnswer =>
      validateUserAnswerAfterPatternMatchIsTrueCallback != null;

  // public methods
  bool doesMatch(QuestBase prevAnsweredQuest) {
    //
    if (usesMatchByQIdPatternCallback) {
      // print('this matcher targeted at a SPECIFIC question & does not consider other atts');
      bool patternDoesMatch =
          this.questIdPatternTest!(prevAnsweredQuest.questId);
      if (!patternDoesMatch) {
        return false;
      }
      // is proper match on questId; should we also check answer?
      if (shouldValidateUserAnswer) {
        return validateUserAnswerAfterPatternMatchIsTrueCallback!(
          prevAnsweredQuest,
        );
      }
      return patternDoesMatch; // always true here
    }

    bool isAPatternMatch = _doDeeperMatch(prevAnsweredQuest);
    // pattern doesnt match so exit early
    if (!isAPatternMatch) return false;

    // pattern match succeeded (isAPatternMatch == true)
    // so now validate user answer if requested
    if (shouldValidateUserAnswer) {
      return validateUserAnswerAfterPatternMatchIsTrueCallback!(
        prevAnsweredQuest,
      );
    }
    return isAPatternMatch; // always true here
  }

  List<QuestBase> getDerivedAutoGenQuestions(QuestBase quest) =>
      derivedQuestGen.getDerivedAutoGenQuestions(quest, this);

  bool _doDeeperMatch(QuestBase quest) {
    // compare all properties instead of only QuestionId
    bool dMatch = true;
    dMatch = dMatch &&
        (this.cascadeTypeOfMatchedQuest == null ||
            this.cascadeTypeOfMatchedQuest == quest.qTargetIntent.cascadeType);
    if (!dMatch) return false; // only continue tests when succeeding
    print('Cascade matches: $dMatch');

    dMatch =
        dMatch && (this.appScreen == null || this.appScreen == quest.appScreen);
    if (!dMatch) return false;
    print('appScreen matches: $dMatch');

    dMatch = dMatch &&
        (this.screenWidgetArea == null ||
            this.screenWidgetArea == quest.screenWidgetArea);
    if (!dMatch) return false;
    print('screenWidgetArea matches: $dMatch');

    dMatch = dMatch &&
        (this.slotInArea == null || this.slotInArea == quest.slotInArea);
    if (!dMatch) return false;
    print('slotInArea matches: $dMatch');

    dMatch = dMatch &&
        (this.visRuleTypeForAreaOrSlot == null ||
            this.visRuleTypeForAreaOrSlot == quest.visRuleTypeForAreaOrSlot);
    if (!dMatch) return false;
    print('visRuleTypeForAreaOrSlot matches: $dMatch');
    print('isRuleQuestion: ${quest.isRuleQuestion}');

    // dMatch =
    //     dMatch && (this.typ == null || quest.response.runtimeType == this.typ);
    return dMatch;
  }
}
