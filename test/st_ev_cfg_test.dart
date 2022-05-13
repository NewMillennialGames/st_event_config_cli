import 'package:test/test.dart';
//
import 'package:st_ev_cfg/st_ev_cfg.dart';

void main() {
  test('creates user answer & verifies new Quest2s generated from it', () {
    const k_quests_created_in_test = 2;

    final _questMgr = QuestListMgr();
    expect(_questMgr.totalAnsweredQuest2s, 0);

    final qq = QTargetIntent.areaLevelRules(
      AppScreen.marketView,
      ScreenWidgetArea.tableview,
      VisualRuleType.groupCfg,
      responseAddsRuleDetailQuests: true,
    );
    final askNumSlots = QuestBase(
      qq,
      'how many Grouping positions would you like to configure?',
      ['0', '1', '$k_quests_created_in_test', '3'],
      (selCount) {
        print('running convert on $selCount');
        return int.tryParse(selCount) ?? 0;
      },
    );
    _questMgr.appendNewQuest2s([askNumSlots]);
    // next 2 lines are virtually the same test
    expect(_questMgr.priorAnswers.length, 0);
    expect(_questMgr.totalAnsweredQuest2s, 0);

    QuestBase quest = _questMgr.nextQuest2ToAnswer()!;
    // quest.convertAndStoreUserResponse('$k_quests_created_in_test');
    // need to bump QuestListMgr to next Quest2
    // to force prior into the answered queue
    var nxtQu = _questMgr.nextQuest2ToAnswer();
    expect(nxtQu, null, reason: '_questMgr only has 1 Quest2');
    expect(_questMgr.priorAnswers.length, 1, reason: 'quest was answered');

    // next line should create 2 new Quest2s
    appendNewQuestsOrInsertImplicitAnswers(_questMgr);
    // they should be rule Quest2s, but not yet answered -- so zero exportable
    expect(_questMgr.exportableQuest2s.length, 0);

    // now check that k_quests_created_in_test Quest2s were created
    // since there was no 2nd INITIAL Quest2, nextQuest2ToAnswer did not move index
    // so we subtract one from pending ...
    expect(_questMgr.pendingQuest2Count - 1, k_quests_created_in_test);

    for (QuestBase q in _questMgr.pendingQuest2s) {
      // print('QuestMatcher created:  ${q.questStr}  ${q.Quest2Id}');
    }
  });
}
