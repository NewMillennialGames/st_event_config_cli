import 'package:test/test.dart';
//
import 'package:st_ev_cfg/st_ev_cfg.dart';

void main() {
  test('creates user answer & verifies new questions generated from it', () {
    final _questMgr = QuestListMgr();
    expect(_questMgr.totalAnsweredQuestions, 0);
    // _questMgr.loadInitialQuestions();

    final List<Question> quests = [];
    _questMgr.appendNewQuestions(quests);

    var quest = _questMgr.nextQuestionToAnswer();
    appendNewQuestsOrInsertImplicitAnswers(_questMgr);

    // now check that questions were created
    expect(_questMgr, 3);
    // expect(calculator.addOne(-7), -6);
    // expect(calculator.addOne(0), 1);
  });
}
