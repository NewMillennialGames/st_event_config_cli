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
    final qq = QTargetResolution.areaLevelRules(
      AppScreen.marketView,
      ScreenWidgetArea.tableview,
      VisualRuleType.groupCfg,
    );

    QuestBase askNumSortSlots = testDataCreate.makeQuestion<int>(
      qq,
      'how many sort slots you want?',
      ['0', '1', '2', '3'],
      (QuestBase qb, String selCount) {
        return int.tryParse(selCount) ?? 0;
      },
      questId: 'blahhh',
    );
    var _qMatchColl = QMatchCollection.scoretrader();

    int matchCount = 0;
    for (QuestMatcher qm in _qMatchColl.allMatchersTestOnly) {
      if (qm.doesMatch(askNumSortSlots)) {
        matchCount += 1;
        List<QuestBase> producedQuestions =
            qm.getDerivedAutoGenQuestions(askNumSortSlots);
      }
    }
    if (matchCount < 1) {
      //
      print('no matches so test is basically useless');
    }
  });
}
