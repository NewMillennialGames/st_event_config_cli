import 'package:test/test.dart';
//
import 'package:st_ev_cfg/st_ev_cfg.dart';
import 'package:st_ev_cfg/config/all.dart';
import 'package:st_ev_cfg/util/all.dart';
//
import 'shared_utils.dart';

void main() {
  //
  const k_quests_created_in_test = 2;

  /*  
  */
  test(
    'verify new questions get created based on gen-rules; matcher removed so now zero',
    () {
      //
      // ask which screens to configure
      QuestBase askScreens = QuestBase.initialEventConfigRule(
        QTargetResolution.forEvent(),
        DlgStr.selectAppScreens, // <String, List<AppScreen>>
        AppScreen.eventConfiguration.topConfigurableScreens.map((e) => e.name),
        CaptureAndCast<List<AppScreen>>((QuestBase qb, s) =>
            castStrOfIdxsToIterOfInts(s)
                .map((idx) =>
                    AppScreen.eventConfiguration.topConfigurableScreens[idx])
                .toList()),
        questId: QuestionIdStrings.selectAppScreens,
      );

      final _questMgr = QuestListMgr();
      final _qcd = QuestionCascadeDispatcher();

      _questMgr.appendGeneratedQuestsAndAnswers([askScreens]);

      QuestBase quest = _questMgr.nextQuestionToAnswer()!;
      // provide answers
      quest.setAllAnswersWhileTesting(['0,1']);

      // need to bump QuestListMgr to next (null) Question
      // to force prior into the answered queue
      QuestBase? nullQuest = _questMgr.nextQuestionToAnswer();

      // next line should create 2 new Questions
      _qcd.appendNewQuestsOrInsertImplicitAnswers(
          _questMgr, _questMgr.currentOrLastQuestion);
      expect(_questMgr.priorAnswerCount, 1);
      expect(_questMgr.pendingQuestionCount, 0);

      for (QuestBase q in _questMgr.pendingQuestions) {
        print(
          'QuestMatcher created:  ${q.firstQuestion.userPrompt}  ${q.questId}',
        );
      }
    },
  );

  test(
      'creates user answer abt LV group-by depth, & verifies new Questions generated from it',
      () {
    final testDataCreator = TestDataCreation();
    final _qcd = QuestionCascadeDispatcher();
    final _questMgr = QuestListMgr();
    expect(_questMgr.totalAnsweredQuestions, 0);

    // now create user question
    var qTarg = QTargetResolution.forVisRulePrep(
      AppScreen.marketView,
      ScreenWidgetArea.tableview,
      null,
      VisualRuleType.groupCfg,
    );

    // qTarg = qTarg.copyWith(targetComplete: true);

    QuestBase askGroupDepth = testDataCreator.makeQuestion<int>(
      qTarg,
      'set ListView group-by depth on marketView',
      ['0', '1', '$k_quests_created_in_test', '3'],
      (QuestBase qb, String selCount) {
        // print('askNumSlots convert on str $selCount');
        return int.tryParse(selCount) ?? 0;
      },
      questId: '',
    );

    // add question to q-manager
    _questMgr.appendGeneratedQuestsAndAnswers([askGroupDepth]);
    // next 2 lines are virtually the same test
    expect(_questMgr.priorAnswers.length, 0);
    expect(_questMgr.totalAnsweredQuestions, 0);

    QuestBase quest = _questMgr.nextQuestionToAnswer()!;
    // provide answers
    quest.setAllAnswersWhileTesting(['2']);

    // will auto-respond using value provided in _autoResponseGenerators above
    // testQuestPresenter.askAndWaitForUserResponse(dlogRun, quest);

    // need to bump QuestListMgr to next (null) Question
    // to force prior into the answered queue
    QuestBase? nxtQu = _questMgr.nextQuestionToAnswer();

    // next line should create 2 new Questions
    _qcd.appendNewQuestsOrInsertImplicitAnswers(
      _questMgr,
      _questMgr.currentOrLastQuestion,
    );
    expect(nxtQu, null, reason: '_questMgr only has 1 Question');
    expect(_questMgr.priorAnswerCount, 1, reason: 'quest was answered');

    // they both should be rule Questions, but not yet answered -- so zero exportable
    expect(_questMgr.exportableRuleQuestions.length, 0);

    // now check that k_quests_created_in_test Questions were created
    // since there was no 2nd INITIAL Question
    expect(_questMgr.pendingQuestionCount, 2);

    for (QuestBase q in _questMgr.pendingQuestions) {
      print(
        'QuestMatcher created:  ${q.firstQuestion.userPrompt}  ${q.questId}',
      );
    }
  });
}
