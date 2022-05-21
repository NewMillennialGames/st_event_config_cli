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
    final _questMgr = QuestListMgr();
    final _qMatchColl = QMatchCollection([]);
    expect(_questMgr.totalAnsweredQuestions, 0);
  });

  test('check if matchers hit', () {
    final _questMgr = QuestListMgr();
    expect(_questMgr.totalAnsweredQuestions, 0);
  });
}
