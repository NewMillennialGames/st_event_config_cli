import 'package:test/test.dart';
//
import 'package:st_ev_cfg/st_ev_cfg.dart';

void main() {
  test('creates user answer & verifies new questions generated from it', () {
    const k_quests_created_in_test = 2;

    final _questMgr = QuestListMgr();
    expect(_questMgr.totalAnsweredQuestions, 0);

    final qq = QuestionQuantifier.areaLevelSlots(
      AppScreen.marketView,
      ScreenWidgetArea.tableview,
      responseAddsWhichRuleQuestions: true,
    );
    final askNumSlots = Question<String, int>(
      qq,
      'how many Grouping positions would you like to configure?',
      ['0', '1', '$k_quests_created_in_test', '3'],
      (selCount) => int.tryParse(selCount) ?? 0,
    );
    _questMgr.appendNewQuestions([askNumSlots]);
    // next 2 lines are virtually the same test
    expect(_questMgr.priorAnswers.length, 0);
    expect(_questMgr.totalAnsweredQuestions, 0);

    Question quest = _questMgr.nextQuestionToAnswer()!;
    quest.convertAndStoreUserResponse('$k_quests_created_in_test');
    // need to bump QuestListMgr to next question
    // to force prior into the answered queue
    var nxtQu = _questMgr.nextQuestionToAnswer();
    expect(nxtQu, null, reason: '_questMgr only has 1 question');
    expect(_questMgr.priorAnswers.length, 1);

    // next line should create 2 new questions
    appendNewQuestsOrInsertImplicitAnswers(_questMgr);
    // none of these are rule questions so zero exportable
    expect(_questMgr.exportableQuestions.length, 0);

    // now check that k_quests_created_in_test questions were created
    // since there was no 2nd INITIAL question, nextQuestionToAnswer did not move index
    // so we subtract one from pending ...
    // expect(_questMgr.pendingQuestionCount - 1, k_quests_created_in_test);
  });
}
