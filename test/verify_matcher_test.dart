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

    QuestBase askNumSlots = testDataCreate.makeQuestion<int>(
      qq,
      '',
      ['0', '1', '2', '3'],
      (selCount) {
        return int.tryParse(selCount) ?? 0;
      },
    );
    var _qMatchColl = QMatchCollection([]);
    expect(_qMatchColl.matchCountFor(askNumSlots), 0);
    //
    _qMatchColl.append([
      QuestMatcher(
        'should match 1',
        MatcherBehaviorEnum.addPendingQuestions,
        DerivedQuestGenerator.noop(),
        validateUserAnswerAfterPatternMatchIsTrueCallback: (p0) => true,
        appScreen: qq.appScreen,
        screenWidgetArea: qq.screenWidgetArea,
        visRuleTypeForAreaOrSlot: qq.visRuleTypeForAreaOrSlot,
      ),
      QuestMatcher(
        'should match 2',
        MatcherBehaviorEnum.addPendingQuestions,
        DerivedQuestGenerator.noop(),
        validateUserAnswerAfterPatternMatchIsTrueCallback: (p0) => true,
        appScreen: qq.appScreen,
        screenWidgetArea: qq.screenWidgetArea,
        visRuleTypeForAreaOrSlot: qq.visRuleTypeForAreaOrSlot,
      ),
      QuestMatcher(
        'should NOT match',
        MatcherBehaviorEnum.addPendingQuestions,
        DerivedQuestGenerator.noop(),
        validateUserAnswerAfterPatternMatchIsTrueCallback: (p0) => false,
        appScreen: AppScreen.eventConfiguration,
      ),
    ]);
    expect(_qMatchColl.matchCountFor(askNumSlots), 2);
  });

  // test('check if matchers hit', () {
  //   final _questMgr = QuestListMgr();
  //   expect(_questMgr.totalAnsweredQuestions, 0);
  // });
}
