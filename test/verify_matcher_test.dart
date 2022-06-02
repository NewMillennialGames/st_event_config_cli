import 'package:st_ev_cfg/interfaces/q_presenter.dart';
import 'package:test/test.dart';
//
import 'package:st_ev_cfg/st_ev_cfg.dart';
import 'shared_utils.dart';

void main() {
  //
  // const k_quests_created_in_test = 2;

  /*  
  */

  test('validate that matchers hit', () {
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
      (selCount) {
        return int.tryParse(selCount) ?? 0;
      },
    );
    var _qMatchColl = QMatchCollection([]);
    expect(_qMatchColl.matchCountFor(askNumSortSlots), 0);
    //
    _qMatchColl.append([
      QuestMatcher(
        'should match 1',
        cascadeTypeOfMatchedQuest:
            QRespCascadePatternEm.addsRuleDetailQuestsForSlotOrArea,
        derivedQuestGen: DerivedQuestGenerator.noop(),
        validateUserAnswerAfterPatternMatchIsTrueCallback: (p0) => true,
        appScreen: qq.appScreen,
        screenWidgetArea: qq.screenWidgetArea,
        visRuleTypeForAreaOrSlot: qq.visRuleTypeForAreaOrSlot,
      ),
      QuestMatcher(
        'should match 2',
        cascadeTypeOfMatchedQuest:
            QRespCascadePatternEm.addsRuleDetailQuestsForSlotOrArea,
        derivedQuestGen: DerivedQuestGenerator.noop(),
        validateUserAnswerAfterPatternMatchIsTrueCallback: (p0) => true,
        appScreen: qq.appScreen,
        screenWidgetArea: qq.screenWidgetArea,
        visRuleTypeForAreaOrSlot: qq.visRuleTypeForAreaOrSlot,
      ),
      QuestMatcher(
        'should NOT match',
        cascadeTypeOfMatchedQuest:
            QRespCascadePatternEm.addsWhichAreaInSelectedScreenQuestions,
        derivedQuestGen: DerivedQuestGenerator.noop(),
        validateUserAnswerAfterPatternMatchIsTrueCallback: (p0) => true,
        appScreen: AppScreen.eventConfiguration,
      ),
      QuestMatcher(
        'should NOT match',
        cascadeTypeOfMatchedQuest:
            QRespCascadePatternEm.addsWhichAreaInSelectedScreenQuestions,
        derivedQuestGen: DerivedQuestGenerator.noop(),
        validateUserAnswerAfterPatternMatchIsTrueCallback: (p0) => false,
        appScreen: AppScreen.leaderboard,
      ),
    ]);
    expect(_qMatchColl.matchCountFor(askNumSortSlots), 2);
  });

  // test('check if matchers hit', () {
  //   final _questMgr = QuestListMgr();
  //   expect(_questMgr.totalAnsweredQuestions, 0);
  // });
}
