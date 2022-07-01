import 'package:test/test.dart';
//
import 'package:st_ev_cfg/st_ev_cfg.dart';
import 'package:st_ev_cfg/interfaces/q_presenter.dart';
//
import 'shared_utils.dart';
/*
  loop through a fixed dialog pattern & verify
  all expected questions to follow in order
*/

const String _questId = 'test1';

void main() {
  QuestionPresenterIfc questPresent = TestQuestRespGen([]);
  DialogRunner dlogRun = DialogRunner(questPresent);
  QuestionCascadeDispatcher _qcd = QuestionCascadeDispatcher();
  QuestListMgr _questMgr = QuestListMgr();

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
    'verify init and question count',
    () {
      expect(twoPromptQuest.promptCount, 2);
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
