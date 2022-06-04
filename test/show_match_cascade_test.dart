import 'package:st_ev_cfg/interfaces/q_presenter.dart';
import 'package:test/test.dart';
//
import 'package:st_ev_cfg/st_ev_cfg.dart';
import 'shared_utils.dart';

void main() {
  /*  
    not finished;  should be useful for people debugging the
      match -> gen -> cascade  loop

  */
  test(
      'show how questions created by each ST matcher will be matched by other matchers',
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
    var _qMatchColl = QMatchCollection.scoretrader();

    for (QuestMatcher qm in _qMatchColl.allMatchers) {
      List<QuestBase> producedQuestions =
          qm.getDerivedAutoGenQuestions(askNumSortSlots);
    }
  });
}
