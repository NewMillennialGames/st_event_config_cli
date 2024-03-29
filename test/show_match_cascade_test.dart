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

    final _qcd = QCascadeDispatcher();

    int matchCount = 0;
    for (QuestMatcher qm in _qcd.allMatchersTestOnly) {
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
