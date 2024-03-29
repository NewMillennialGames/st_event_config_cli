import 'package:st_ev_cfg/interfaces/q_presenter.dart';
import 'package:test/test.dart';
//
import 'package:st_ev_cfg/st_ev_cfg.dart';
import 'shared_utils.dart';

void main() {
  /*  


  */
  test(
      'validate that QuestMatcher hits question based on QTargetIntent properties',
      () {
    // final testDataCreate = TestDataCreation();
    QuestionPresenterIfc questPresent = TestQuestRespGen([]);
    DialogRunner dlogRun = DialogRunner(questPresent);
    //
    // now create user question
    final qq = QTargetResolution.forVisRulePrep(
      AppScreen.marketView,
      ScreenWidgetArea.tableview,
      null,
      VisualRuleType.groupCfg,
    );

    var ask = QuestPromptPayload<int>('how many sort slots you want?',
        ['0', '1', '2', '3'], VisRuleQuestType.askCountOfSlotsToConfigure,
        (QuestBase qb, String selCount) {
      // print('askNumSlots convert on str $selCount');
      return int.tryParse(selCount) ?? 0;
    });

    QuestBase askNumSortSlots = QuestBase.rulePrepQuest(
      qq,
      [ask],
      questId: 'blahhh',
    );

    var _qMatchColl = QMatchCollection([]);
    expect(_qMatchColl.matchCountFor(askNumSortSlots), 0);
    //
    _qMatchColl.appendForTesting([
      QuestMatcher(
        'should match 1 based on instance type and question ID',
        RulePrepQuest,
        questIdPatternMatchTest: (priorQuestId) {
          return priorQuestId == 'blahhh';
        },
        // respCascadePatternEm:
        //     QRespCascadePatternEm.respCreatesRuleDetailForSlotOrAreaQuestions,
        derivedQuestGen: DerivedQuestGenerator.noopTest(),
        // validateUserAnswerAfterPatternMatchIsTrueCallback: (p0) => true,
        // appScreen: qq.appScreen,
        // screenWidgetArea: qq.screenWidgetArea,
        // visRuleTypeForAreaOrSlot: qq.visRuleTypeForAreaOrSlot,
      ),
      QuestMatcher(
        'should match 2 based on instance type and answer validation',
        RulePrepQuest,
        // respCascadePatternEm:
        //     QRespCascadePatternEm.respCreatesRuleDetailForSlotOrAreaQuestions,
        derivedQuestGen: DerivedQuestGenerator.noopTest(),
        validateUserAnswerAfterPatternMatchIsTrueCallback: (p0) => true,
        // appScreen: qq.appScreen,
        // screenWidgetArea: qq.screenWidgetArea,
        // visRuleTypeForAreaOrSlot: qq.visRuleTypeForAreaOrSlot,
      ),
      QuestMatcher(
        'should NOT match based on wrong instance type',
        RuleSelectQuest,
        // respCascadePatternEm:
        //     QRespCascadePatternEm.respCreatesWhichAreaInScreenQuestions,
        derivedQuestGen: DerivedQuestGenerator.noopTest(),
        // appScreen: AppScreen.eventConfiguration,
      ),
      QuestMatcher(
        'should NOT match based on invalid user answer',
        RulePrepQuest,
        // respCascadePatternEm:
        //     QRespCascadePatternEm.respCreatesWhichAreaInScreenQuestions,
        derivedQuestGen: DerivedQuestGenerator.noopTest(),
        validateUserAnswerAfterPatternMatchIsTrueCallback: (p0) => false,
        // appScreen: AppScreen.marketView,
      ),
    ]);
    expect(_qMatchColl.matchCountFor(askNumSortSlots), 2);
  });

  test('validate that QuestMatcher hits question based on QID pattern', () {
    //
    // now create user question
    final qti = QTargetResolution.forEvent();
    final qpp = QuestPromptPayload(
      'some question',
      ['0', '1', '1'],
      VisRuleQuestType.controlsVisibilityOfAreaOrSlot,
      (QuestBase qb, _) => 5,
    );
    String testQuestId = '111222';
    QuestBase anyBaseQuest = QuestBase.eventLevelCfgQuest(
      qti,
      [qpp],
      questId: testQuestId,
    );

    var _qMatchColl = QMatchCollection([]);
    expect(_qMatchColl.matchCountFor(anyBaseQuest), 0);
    //

    final wontMatchByCascade = QuestMatcher(
      'should NOT match based on wrong instance type',
      RuleSelectQuest,
      // respCascadePatternEm:
      //     QRespCascadePatternEm.respCreatesRuleDetailForSlotOrAreaQuestions,
      validateUserAnswerAfterPatternMatchIsTrueCallback: (p0) => true,
      // appScreen: qti.appScreen,
      // screenWidgetArea: ScreenWidgetArea.banner,
      // visRuleTypeForAreaOrSlot: qti.visRuleTypeForAreaOrSlot,
      derivedQuestGen: DerivedQuestGenerator.noopTest(),
    );

    final wontMatchByWrongScreenAndCascade = QuestMatcher(
      'should NOT match based on wrong user answer',
      EventLevelCfgQuest,
      validateUserAnswerAfterPatternMatchIsTrueCallback: (p0) => false,
      derivedQuestGen: DerivedQuestGenerator.noopTest(),
    );

    final wontMatchByUserAnser = QuestMatcher(
      'should NOT match based on wrong quest ID',
      EventLevelCfgQuest,
      questIdPatternMatchTest: (priorQuestId) => false,
      validateUserAnswerAfterPatternMatchIsTrueCallback: (p0) => false,
      derivedQuestGen: DerivedQuestGenerator.noopTest(),
    );

    final willMatchByQuestId = QuestMatcher(
      'should match 1 based on same quest ID',
      EventLevelCfgQuest,
      // respCascadePatternEm:
      //     QRespCascadePatternEm.respCreatesRuleDetailForSlotOrAreaQuestions,
      questIdPatternMatchTest: (qid) => qid == testQuestId,
      derivedQuestGen: DerivedQuestGenerator.singlePrompt(
        'blah {0}',
        newQuestCountCalculator: (q) => 0,
        newQuestPromptArgGen: (_, __, pi) => [],
        answerChoiceGenerator: (_, __, niu) => [],
        newRespCastFunc: (_, __) => null,
      ),
    );

    _qMatchColl.appendForTesting([wontMatchByCascade]);
    expect(_qMatchColl.matchCountFor(anyBaseQuest), 0);

    _qMatchColl.appendForTesting([wontMatchByWrongScreenAndCascade]);
    expect(_qMatchColl.matchCountFor(anyBaseQuest), 0);

    _qMatchColl.appendForTesting([wontMatchByUserAnser]);
    expect(_qMatchColl.matchCountFor(anyBaseQuest), 0);

    _qMatchColl.appendForTesting([willMatchByQuestId]);
    expect(_qMatchColl.matchCountFor(anyBaseQuest), 1);
  });
}
