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
    QuestionPresenter questPresent = TestQuestRespGen([]);
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
      (String selCount) {
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
    final qq = QTargetIntent.eventLevel();
    final qpp = QuestPromptPayload('some question', ['0', '1', '1'],
        VisRuleQuestType.controlsVisibilityOfAreaOrSlot, (_) => 5);
    QuestBase anyBaseQuest =
        QuestBase.eventConfigRulePrompt(qq, [qpp], questId: '111222');

    var _qMatchColl = QMatchCollection([]);
    expect(_qMatchColl.matchCountFor(anyBaseQuest), 0);
    //
    _qMatchColl.append([
      QuestMatcher(
        'should match 1 quest ID',
        cascadeTypeOfMatchedQuest:
            QRespCascadePatternEm.addsRuleDetailQuestsForSlotOrArea,
        questIdPatternTest: (qid) => qid == '111222',
        derivedQuestGen: DerivedQuestGenerator(
          'blah {0}',
          newQuestCountCalculator: (q) => 0,
          newQuestPromptArgGen: (_, __) => [],
          answerChoiceGenerator: (_, __) => [],
          perQuestGenOptions: [],
        ),
      ),
      QuestMatcher(
        'should NOT match based on screen, area ruletype & valid answer',
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
    expect(_qMatchColl.matchCountFor(anyBaseQuest), 1);
  });
}
