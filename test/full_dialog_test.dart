import 'dart:async';
import 'package:test/test.dart';
//
import 'package:st_ev_cfg/st_ev_cfg.dart';
import 'package:st_ev_cfg/interfaces/q_presenter.dart';
//
import 'full_ans_expect.dart';
import 'shared_utils.dart';
/*
  loop through a fixed dialog pattern & verify
  all expected questions to follow in order

  TODO:  not currently implemented
*/

void main() {
  //
  bool setupCompleted = false;
  StreamController<List<String>> sendAnswersController =
      StreamController<List<String>>();
  QuestListMgr _questMgr = QuestListMgr();
  QuestionCascadeDispatcher _qcd = QuestionCascadeDispatcher();
  FullFlowPresenter questPresent =
      FullFlowPresenter(sendAnswersController); // aka QuestionPresenterIfc
  DialogRunner dlogRun = DialogRunner(
    questPresent,
    qListMgr: _questMgr,
    questCascadeDisp: _qcd,
  );

  setUp(() {
    if (setupCompleted) return;

    setupCompleted = true;
  });

  test(
    'send answers until top level quests exhausted',
    () {
      questPresent.askAndWaitForUserResponse(
        dlogRun,
        _questMgr.currentOrLastQuestion,
      );
    },
  );

  test(
    'answer all event level questions',
    () {
      expect(_questMgr.pendingQuestionCount, 0);
    },
  );

  test('select screen to config', () {
    expect(_questMgr.pendingQuestionCount, 0);
  });

  // group('', () {
  //   test(
  //     'creates Question w several prompts & verifies count + access',
  //     () {
  //       expect(twoPromptQuest.promptCount, 2);
  //       QuestPromptInstance? usrPrompt1 =
  //           twoPromptQuest.getNextUserPromptIfExists();
  //       QuestPromptInstance? usrPrompt2 =
  //           twoPromptQuest.getNextUserPromptIfExists();
  //       QuestPromptInstance? usrPrompt3 =
  //           twoPromptQuest.getNextUserPromptIfExists();
  //       expect(usrPrompt1, isNotNull);
  //       expect(usrPrompt2, isNotNull);
  //       expect(usrPrompt3, isNull);
  //     },
  //   );
  // });
}
