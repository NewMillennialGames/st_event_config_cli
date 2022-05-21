import 'package:st_ev_cfg/interfaces/q_presenter.dart';
import 'package:test/test.dart';
//
import 'package:st_ev_cfg/st_ev_cfg.dart';
import 'shared_utils.dart';

void main() {
  //
  const k_quests_created_in_test = 2;

  // late QuestBase askNumSlots;
  // setUp(() {
  //   // askNumSlots = QuestBase.multiPrompt(qq, prompts, questId: 'test1');
  // });

  /*  
  */
  // test(
  //   'simply see if new questions get created based on gen-rules',
  //   () {
  //     //
  //     final testDataCreate = TestDataCreation();
  //         final qq = QTargetIntent.areaLevelRules(
  //     AppScreen.marketView,
  //     ScreenWidgetArea.tableview,
  //     VisualRuleType.groupCfg,
  //     responseAddsRuleDetailQuests: true,
  //   );
  //   QuestBase askNumSlots = testDataCreate.makeQuestion<int>(
  //       qq, '', ['0', '1', '$k_quests_created_in_test', '3'], (selCount) {
  //     print('askNumSlots convert on str $selCount');
  //     return int.tryParse(selCount) ?? 0;
  //   });

  //   },
  // );

  test('creates user answer & verifies new Questions generated from it', () {
    final testDataCreator = TestDataCreation();
    final _questMgr = QuestListMgr();
    final _qMatchColl = QMatchCollection.scoretrader();
    expect(_questMgr.totalAnsweredQuestions, 0);

    // List<TestRespGenWhenQuestLike> _autoResponseGenerators = [
    //   TestRespGenWhenQuestLike(
    //     AppScreen.marketView,
    //     ScreenWidgetArea.tableview,
    //     VisualRuleType.groupCfg,
    //     responsesByQType: [
    //       QTypeResponsePair(
    //         VisRuleQuestType.dialogStruct,
    //         '2',
    //       ),
    //     ],
    //   )
    // ];
    // QuestionPresenter testQuestPresenter =
    //     TestQuestRespGen(_autoResponseGenerators);
    // DialogRunner dlogRun = DialogRunner(testQuestPresenter);
    //
    // now create user question
    final qq = QTargetIntent.areaLevelRules(
      AppScreen.marketView,
      ScreenWidgetArea.tableview,
      VisualRuleType.groupCfg,
      responseAddsRuleDetailQuests: true,
    );

    QuestBase askNumSlots = testDataCreator.makeQuestion<int>(
        qq, 'no op prompt', ['0', '1', '$k_quests_created_in_test', '3'],
        (selCount) {
      print('askNumSlots convert on str $selCount');
      return int.tryParse(selCount) ?? 0;
    });

    // add question to q-manager
    _questMgr.appendNewQuestions([askNumSlots]);
    // next 2 lines are virtually the same test
    expect(_questMgr.priorAnswers.length, 0);
    expect(_questMgr.totalAnsweredQuestions, 0);

    QuestBase quest = _questMgr.nextQuestionToAnswer()!;
    // provide answers
    quest.setAllAnswersWhileTesting(['2']);

    // will auto-respond using value provided in _autoResponseGenerators above
    // testQuestPresenter.askAndWaitForUserResponse(dlogRun, quest);

    // need to bump QuestListMgr to next Question
    // to force prior into the answered queue
    QuestBase? nxtQu = _questMgr.nextQuestionToAnswer();

    // next line should create 2 new Questions
    _qMatchColl.appendNewQuestsOrInsertImplicitAnswers(_questMgr);
    expect(nxtQu, null, reason: '_questMgr only has 1 Question');
    expect(_questMgr.priorAnswerCount, 1, reason: 'quest was answered');

    // they should be rule Questions, but not yet answered -- so zero exportable
    expect(_questMgr.exportableQuestions.length, 0);

    // now check that k_quests_created_in_test Questions were created
    // since there was no 2nd INITIAL Question
    expect(_questMgr.pendingQuestionCount, 2);

    // for (QuestBase q in _questMgr.pendingQuestions) {
    //   // print('QuestMatcher created:  ${q.questStr}  ${q.Quest2Id}');
    // }
  });
}
