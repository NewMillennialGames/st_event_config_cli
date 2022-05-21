import 'package:st_ev_cfg/interfaces/q_presenter.dart';
import 'package:test/test.dart';
//
import 'package:st_ev_cfg/st_ev_cfg.dart';
import './test_q_presenter.dart';

void main() {
  //
  const k_quests_created_in_test = 2;

  // late QuestBase askNumSlots;
  // setUp(() {
  //   // askNumSlots = QuestBase.multiPrompt(qq, prompts, questId: 'test1');
  // });

  /*  
  */

  test('creates user answer & verifies new Questions generated from it', () {
    final _questMgr = QuestListMgr();
    final _qMatchColl = QMatchCollection.scoretrader();
    expect(_questMgr.totalAnsweredQuestions, 0);

    List<RespGenWhenQuestLike> _autoResponseGenerators = [
      RespGenWhenQuestLike(
        AppScreen.marketView,
        ScreenWidgetArea.tableview,
        VisualRuleType.groupCfg,
        responsesByQType: [
          QTypeResponsePair(
            VisRuleQuestType.dialogStruct,
            '2',
          ),
        ],
      )
    ];
    QuestionPresenter questPresent = TestQuestRespGen(_autoResponseGenerators);
    DialogRunner dlogRun = DialogRunner(questPresent);
    //
    // now create user question
    final qq = QTargetIntent.areaLevelRules(
      AppScreen.marketView,
      ScreenWidgetArea.tableview,
      VisualRuleType.groupCfg,
      responseAddsRuleDetailQuests: true,
    );
    QuestBase askNumSlots = QuestBase.dlogCascade(
      qq,
      'how many Grouping positions would you like to configure?',
      ['0', '1', '$k_quests_created_in_test', '3'],
      CaptureAndCast<int>((selCount) {
        print('running convert on str $selCount');
        return int.tryParse(selCount) ?? 0;
      }),
    );

    // add question to q-manager
    _questMgr.appendNewQuestions([askNumSlots]);
    // next 2 lines are virtually the same test
    expect(_questMgr.priorAnswers.length, 0);
    expect(_questMgr.totalAnsweredQuestions, 0);

    QuestBase quest = _questMgr.nextQuestionToAnswer()!;

    // will auto-respond using value provided in _autoResponseGenerators above
    questPresent.askAndWaitForUserResponse(dlogRun, quest);

    // next line should create 2 new Questions
    _qMatchColl.appendNewQuestsOrInsertImplicitAnswers(_questMgr);

    // need to bump QuestListMgr to next Quest2
    // to force prior into the answered queue
    QuestBase? nxtQu = _questMgr.nextQuestionToAnswer();
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
