import 'package:test/test.dart';
//
import 'package:st_ev_cfg/st_ev_cfg.dart';

void main() {
  test('creates user answer & verifies new questions generated from it', () {
    const k_quests_created_in_test = 2;

    final _questMgr = QuestListMgr();
    expect(_questMgr.totalAnsweredQuestions, 0);

    // final qq = QuestionQuantifier.areaLevelRules(
    //   AppScreen.marketView,
    //   ScreenWidgetArea.tableview,
    //   VisualRuleType.groupCfg,
    //   responseAddsRuleDetailQuests: true,
    // );
    // final askNumSlots = Question<String, int>(
    //   qq,
    //   'how many Grouping positions would you like to configure?',
    //   ['0', '1', '$k_quests_created_in_test', '3'],
    //   (selCount) {
    //     print('running convert on $selCount');
    //     return int.tryParse(selCount) ?? 0;
    //   },
    // );
    // _questMgr.appendNewQuestions([askNumSlots]);
    // // next 2 lines are virtually the same test
    // expect(_questMgr.priorAnswers.length, 0);
    // expect(_questMgr.totalAnsweredQuestions, 0);

    // Question quest = _questMgr.nextQuestionToAnswer()!;
    // quest.convertAndStoreUserResponse('$k_quests_created_in_test');
    // // need to bump QuestListMgr to next question
    // // to force prior into the answered queue
    // var nxtQu = _questMgr.nextQuestionToAnswer();
    // expect(nxtQu, null, reason: '_questMgr only has 1 question');
    // expect(_questMgr.priorAnswers.length, 1, reason: 'quest was answered');

    // // next line should create 2 new questions
    // appendNewQuestsOrInsertImplicitAnswers(_questMgr);
    // // they should be rule questions, but not yet answered -- so zero exportable
    // expect(_questMgr.exportableQuestions.length, 0);

    // // now check that k_quests_created_in_test questions were created
    // // since there was no 2nd INITIAL question, nextQuestionToAnswer did not move index
    // // so we subtract one from pending ...
    // expect(_questMgr.pendingQuestionCount - 1, k_quests_created_in_test);

    // for (Question q in _questMgr.pendingQuestions) {
    //   print('QuestMatcher created:  ${q.questStr}  ${q.questionId}');
    // }
  });
}
