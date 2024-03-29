import 'package:test/test.dart';
//
import 'package:st_ev_cfg/st_ev_cfg.dart';
import 'package:st_ev_cfg/interfaces/q_presenter.dart';
//
import 'shared_utils.dart';
/*
  add 1 question; verify it's next served
  verify question has correct # of prompts
*/

const String _questId = 'test1';

void main() {
  late QuestBase twoPromptQuest;

  setUp(() {
    final qq = QTargetResolution.forVisRulePrep(
      AppScreen.marketView,
      ScreenWidgetArea.tableview,
      null,
      VisualRuleType.groupCfg,
    );

    List<QuestPromptPayload> prompts = [
      QuestPromptPayload(
        'how many Grouping positions would you like to configure?',
        ['0', '1', '2', '3'],
        VisRuleQuestType.dialogStruct,
        (QuestBase qb, String selCount) => int.tryParse(selCount) ?? 0,
      ),
      QuestPromptPayload(
        'how many Grouping positions would you like to configure?',
        ['0', '1', '2', '3'],
        VisRuleQuestType.dialogStruct,
        (QuestBase qb, String selCount) => int.tryParse(selCount) ?? 0,
      ),
    ];

    twoPromptQuest =
        QuestBase.visualRuleDetailQuest(qq, prompts, questId: _questId);
  });

  test(
    'creates Question w several prompts & verifies count + access',
    () {
      expect(twoPromptQuest.promptCount, 2);
      QuestPromptInstance? usrPrompt1 =
          twoPromptQuest.getNextUserPromptIfExists();
      QuestPromptInstance? usrPrompt2 =
          twoPromptQuest.getNextUserPromptIfExists();
      QuestPromptInstance? usrPrompt3 =
          twoPromptQuest.getNextUserPromptIfExists();
      expect(usrPrompt1, isNotNull);
      expect(usrPrompt2, isNotNull);
      expect(usrPrompt3, isNull);
    },
  );

  test(
    'confirms quest added is first served',
    () {
      final _questMgr = QuestListMgr();
      expect(_questMgr.pendingQuestionCount, 0);
      expect(_questMgr.totalAnsweredQuestions, 0);
      _questMgr.appendGeneratedQuestsAndAnswers([twoPromptQuest]);
      expect(_questMgr.pendingQuestionCount, 1);
      QuestBase? q1 = _questMgr.nextQuestionToAnswer();
      expect(q1?.questId, _questId);
    },
  );

  test(
    'confirms presenter moves answered question into totalAnsweredQuestions',
    () {
      final _questMgr = QuestListMgr();
      QuestionPresenterIfc qp = TestQuestRespGen([]);
      DialogRunner dlogRun = DialogRunner(
        qp,
        qListMgr: _questMgr,
        loadDefaultQuest: false,
      );

      expect(_questMgr.pendingQuestionCount, 0);
      expect(_questMgr.totalAnsweredQuestions, 0);
      _questMgr.appendGeneratedQuestsAndAnswers([twoPromptQuest]);
      expect(_questMgr.pendingQuestionCount, 1);
      dlogRun.cliLoopUntilComplete();
      expect(_questMgr.pendingQuestionCount, 0);
      expect(_questMgr.totalAnsweredQuestions, 1);
    },
  );

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
