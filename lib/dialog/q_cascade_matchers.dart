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

enum MatcherBehaviorEnum {
  addPendingQuestions,
  addImplicitAnswers,
  addQuestsAndAnswers, // aka BOTH
}

extension MatcherBehaviorEnumExt1 on MatcherBehaviorEnum {
  //
  bool get addsPendingQuestions => [
        MatcherBehaviorEnum.addPendingQuestions,
        MatcherBehaviorEnum.addQuestsAndAnswers
      ].contains(this);

  bool get createsImplicitAnswers => [
        MatcherBehaviorEnum.addImplicitAnswers,
        MatcherBehaviorEnum.addQuestsAndAnswers
      ].contains(this);
}

class QuestMatcher<AnsType> {
  /*
  define all properties a matcher may need to eval
  in order to verify it's a match

  */
  final MatcherBehaviorEnum matcherMatchBehavior;
  // AddQuestChkCallbk is for doing more advanced analysis to verify a match
  final AddQuestChkCallbk? validateUserAnswerAfterPatternMatchIsTrueCallback;
  // cascadeType indicates whether we add new Quest2s, auto-answers or both
  final QRespCascadePatternEm? cascadeType;
  // pattern matching values;  leave null to not match on them
  final AppScreen? appScreen;
  final ScreenWidgetArea? screenWidgetArea;
  final ScreenAreaWidgetSlot? slotInArea;
  final VisualRuleType? visRuleTypeForAreaOrSlot;
  final BehaviorRuleType? behRuleTypeForAreaOrSlot;
  final bool isRuleQuestion;
  final PriorQuestIdMatchPatternTest? questIdPatternTest;
  final DerivedQuestGenerator derivedQuestGen;
  late Type? typ = CaptureAndCast<AnsType>;
  final String matcherDescrip;
  //
  QuestMatcher(
    this.matcherDescrip,
    this.matcherMatchBehavior,
    this.derivedQuestGen, {
    this.validateUserAnswerAfterPatternMatchIsTrueCallback,
    this.cascadeType,
    this.questIdPatternTest,
    this.appScreen,
    this.screenWidgetArea,
    this.slotInArea,
    this.visRuleTypeForAreaOrSlot,
    this.behRuleTypeForAreaOrSlot,
    this.isRuleQuestion = false,
  });

  // getters
  bool get addsPendingQuestions => matcherMatchBehavior.addsPendingQuestions;
  bool get createsImplicitAnswers =>
      matcherMatchBehavior.createsImplicitAnswers;

  bool get usesMatchByQuestIdPattern => this.questIdPatternTest != null;

  // public methods
  bool doesMatch(QuestBase quest) {
    //
    if (usesMatchByQuestIdPattern && quest.questId != this.questIdPatternTest) {
      // print('this matcher targeted at a SPECIFIC question & does not apply to passed quest');
      return false;
    } else if (quest.questId == this.questIdPatternTest) {
      // exact match on questId
      if (validateUserAnswerAfterPatternMatchIsTrueCallback != null) {
        return validateUserAnswerAfterPatternMatchIsTrueCallback!(quest);
      }
      return true;
    }

    bool isAPatternMatch = _doDeeperMatch(quest);
    // pattern doesnt match so exit early
    if (!isAPatternMatch) return false;

    // pattern match succeeded (isAPatternMatch == true), so now validate user answer
    if (validateUserAnswerAfterPatternMatchIsTrueCallback != null) {
      return validateUserAnswerAfterPatternMatchIsTrueCallback!(quest);
    }
    return isAPatternMatch;
  }

  List<QuestBase> getDerivedAutoGenQuestions(QuestBase quest) =>
      derivedQuestGen.getDerivedAutoGenQuestions(quest, this);

  bool _doDeeperMatch(QuestBase quest) {
    // compare all properties instead of only Quest2Id
    bool dMatch = true;
    dMatch = dMatch &&
        (this.cascadeType == null ||
            this.cascadeType == quest.qTargetIntent.cascadeType);
    print('Cascade matches: $dMatch');
    dMatch =
        dMatch && (this.appScreen == null || this.appScreen == quest.appScreen);
    print('appScreen matches: $dMatch');

    dMatch = dMatch &&
        (this.screenWidgetArea == null ||
            this.screenWidgetArea == quest.screenWidgetArea);
    print('screenWidgetArea matches: $dMatch');

    dMatch = dMatch &&
        (this.slotInArea == null || this.slotInArea == quest.slotInArea);
    print('slotInArea matches: $dMatch');

    dMatch = dMatch &&
        (this.visRuleTypeForAreaOrSlot == null ||
            this.visRuleTypeForAreaOrSlot == quest.visRuleTypeForAreaOrSlot);
    print('visRuleTypeForAreaOrSlot matches: $dMatch');
    print('isRuleQuestion: ${quest.isRuleQuestion}');

    // dMatch =
    //     dMatch && (this.typ == null || quest.response.runtimeType == this.typ);
    return dMatch;
  }
}
