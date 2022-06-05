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
    final testDataCreate = TestDataCreation();
    QuestionPresenterIfc questPresent = TestQuestRespGen([]);
    DialogRunner dlogRun = DialogRunner(questPresent);
    //
    // now create user question
    final qq = QTargetIntent.areaLevelRules(
      AppScreen.marketView,
      ScreenWidgetArea.tableview,
      VisualRuleType.groupCfg,
      responseAddsRuleDetailQuests: true,
    );

    QuestBase askNumSortSlots = testDataCreate.makeQuestion<int>(
      qq,
      'how many sort slots you want?',
      ['0', '1', '2', '3'],
      (QuestBase qb, String selCount) {
        return int.tryParse(selCount) ?? 0;
      },
    );
    var _qMatchColl = QMatchCollection([]);
    expect(_qMatchColl.matchCountFor(askNumSortSlots), 0);
    //
    _qMatchColl.append([
      QuestMatcher(
        'should match 1 based on screen, area ruletype',
        cascadeTypeOfMatchedQuest:
            QRespCascadePatternEm.addsRuleDetailQuestsForSlotOrArea,
        derivedQuestGen: DerivedQuestGenerator.noop(),
        // validateUserAnswerAfterPatternMatchIsTrueCallback: (p0) => true,
        appScreen: qq.appScreen,
        screenWidgetArea: qq.screenWidgetArea,
        visRuleTypeForAreaOrSlot: qq.visRuleTypeForAreaOrSlot,
      ),
      QuestMatcher(
        'should match 2 based on screen, area ruletype & valid answer',
        cascadeTypeOfMatchedQuest:
            QRespCascadePatternEm.addsRuleDetailQuestsForSlotOrArea,
        derivedQuestGen: DerivedQuestGenerator.noop(),
        validateUserAnswerAfterPatternMatchIsTrueCallback: (p0) => true,
        appScreen: qq.appScreen,
        screenWidgetArea: qq.screenWidgetArea,
        visRuleTypeForAreaOrSlot: qq.visRuleTypeForAreaOrSlot,
      ),
      QuestMatcher(
        'should NOT match based on wrong screen',
        cascadeTypeOfMatchedQuest:
            QRespCascadePatternEm.addsWhichAreaInSelectedScreenQuestions,
        derivedQuestGen: DerivedQuestGenerator.noop(),
        appScreen: AppScreen.eventConfiguration,
      ),
      QuestMatcher(
        'should NOT match based on invalid user answer',
        cascadeTypeOfMatchedQuest:
            QRespCascadePatternEm.addsWhichAreaInSelectedScreenQuestions,
        derivedQuestGen: DerivedQuestGenerator.noop(),
        validateUserAnswerAfterPatternMatchIsTrueCallback: (p0) => false,
        appScreen: AppScreen.marketView,
      ),
    ]);
    expect(_qMatchColl.matchCountFor(askNumSortSlots), 2);
  });

  test('validate that QuestMatcher hits question based on QID pattern', () {
    //
    // now create user question
    final qti = QTargetIntent.eventLevel();
    final qpp = QuestPromptPayload(
      'some question',
      ['0', '1', '1'],
      VisRuleQuestType.controlsVisibilityOfAreaOrSlot,
      (QuestBase qb, _) => 5,
    );
    String testQuestId = '111222';
    QuestBase anyBaseQuest =
        QuestBase.eventConfigRulePrompt(qti, [qpp], questId: testQuestId);

    var _qMatchColl = QMatchCollection([]);
    expect(_qMatchColl.matchCountFor(anyBaseQuest), 0);
    //

    final wontMatchByCascade = QuestMatcher(
      'should NOT match based on cascadeTypeOfMatchedQuest',
      cascadeTypeOfMatchedQuest:
          QRespCascadePatternEm.addsRuleDetailQuestsForSlotOrArea,
      validateUserAnswerAfterPatternMatchIsTrueCallback: (p0) => true,
      appScreen: qti.appScreen,
      screenWidgetArea: qti.screenWidgetArea,
      visRuleTypeForAreaOrSlot: qti.visRuleTypeForAreaOrSlot,
      derivedQuestGen: DerivedQuestGenerator.noop(),
    );

    final wontMatchByWrongScreenAndCascade = QuestMatcher(
      'should NOT match based on wrong screen',
      cascadeTypeOfMatchedQuest: QRespCascadePatternEm.noCascade,
      appScreen: AppScreen.leaderboard,
      derivedQuestGen: DerivedQuestGenerator.noop(),
    );

    final wontMatchByUserAnser = QuestMatcher(
      'should NOT match based on invalid user answer',
      cascadeTypeOfMatchedQuest:
          QRespCascadePatternEm.addsWhichAreaInSelectedScreenQuestions,
      validateUserAnswerAfterPatternMatchIsTrueCallback: (p0) => false,
      appScreen: AppScreen.marketView,
      derivedQuestGen: DerivedQuestGenerator.noop(),
    );

    final willMatchByQuestId = QuestMatcher(
      'should match 1 based on same quest ID',
      cascadeTypeOfMatchedQuest:
          QRespCascadePatternEm.addsRuleDetailQuestsForSlotOrArea,
      questIdPatternMatchTest: (qid) => qid == testQuestId,
      derivedQuestGen: DerivedQuestGenerator(
        'blah {0}',
        newQuestCountCalculator: (q) => 0,
        newQuestPromptArgGen: (_, __) => [],
        answerChoiceGenerator: (_, __) => [],
        perQuestGenOptions: [],
      ),
    );

    _qMatchColl.append([wontMatchByCascade]);
    expect(_qMatchColl.matchCountFor(anyBaseQuest), 0);

    _qMatchColl.append([wontMatchByWrongScreenAndCascade]);
    expect(_qMatchColl.matchCountFor(anyBaseQuest), 0);

    _qMatchColl.append([wontMatchByUserAnser]);
    expect(_qMatchColl.matchCountFor(anyBaseQuest), 0);

    _qMatchColl.append([willMatchByQuestId]);
    expect(_qMatchColl.matchCountFor(anyBaseQuest), 1);
  });
}
