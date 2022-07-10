import 'dart:math';

import 'package:test/test.dart';
//
import 'package:st_ev_cfg/st_ev_cfg.dart';
import 'package:st_ev_cfg/config/all.dart';
import 'package:st_ev_cfg/util/all.dart';
//
// import 'shared_utils.dart';

void main() {
  //
  const k_num_group_flds_in_test = 2;
  final k_quest_id = QuestionIdStrings.prepQuestForVisRule;

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
      final _qcd = QCascadeDispatcher();

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
          'QuestMatcher created:  ${q.firstPrompt.userPrompt}  ${q.questId}',
        );
      }
    },
  );

  test(
      'creates user answer abt LV group-by depth, & verifies 1 quest w 4 prompts generated from it',
      () {
    final _qcd = QCascadeDispatcher();
    final _questMgr = QuestListMgr();
    expect(_questMgr.totalAnsweredQuestions, 0);

    // now create user question
    var qTarg = QTargetResolution.forVisRulePrep(
      AppScreen.marketView,
      ScreenWidgetArea.tableview,
      null,
      VisualRuleType.groupCfg,
    );

    var ask = QuestPromptPayload<int>(
        'set ListView group-by depth on marketView',
        ['0', '1', '$k_num_group_flds_in_test', '3'],
        VisRuleQuestType.askCountOfSlotsToConfigure,
        (QuestBase qb, String selCount) {
      // print('askNumSlots convert on str $selCount');
      return int.tryParse(selCount) ?? 0;
    });

    QuestBase askGroupDepth = QuestBase.rulePrepQuest(
      qTarg,
      [ask],
      questId: k_quest_id,
    );

    expect(askGroupDepth.isRulePrepQuestion, true);
    // add question to q-manager
    _questMgr.appendGeneratedQuestsAndAnswers([askGroupDepth]);
    // next 2 lines are virtually the same test
    expect(_questMgr.priorAnswers.length, 0);
    expect(_questMgr.totalAnsweredQuestions, 0);

    QuestBase quest = _questMgr.nextQuestionToAnswer()!;
    // provide answers
    quest.setAllAnswersWhileTesting(['$k_num_group_flds_in_test']);

    // will auto-respond using value provided in _autoResponseGenerators above
    // testQuestPresenter.askAndWaitForUserResponse(dlogRun, quest);

    // need to bump QuestListMgr to next (null) Question
    // to force prior into the answered queue
    QuestBase? nxtQu = _questMgr.nextQuestionToAnswer();
    expect(nxtQu, isNull, reason: 'questMgr only has 1 Question');
    expect(
      _questMgr.currentOrLastQuestion.questId,
      k_quest_id,
      reason: 'should be 1st quest ($k_quest_id)',
    );

    // next line should create 1 new Question with 4 prompts in it
    _qcd.appendNewQuestsOrInsertImplicitAnswers(
      _questMgr,
      _questMgr.currentOrLastQuestion,
    );

    expect(_questMgr.priorAnswerCount, 1, reason: 'quest was answered');

    // it's a rule Questions, but not yet answered -- so zero exportable
    expect(_questMgr.exportableRuleQuestions.length, 0);

    // now check that 1 Question was created
    // since there was no 2nd INITIAL Question
    expect(_questMgr.pendingQuestionCount, 1);

    // confirm 4 prompts
    nxtQu = _questMgr.nextQuestionToAnswer();
    expect(nxtQu?.promptCount ?? 0, k_num_group_flds_in_test * 2);

    for (QuestBase q in _questMgr.pendingQuestions) {
      print(
        'QuestMatcher created:  ${q.firstPrompt.userPrompt}  ${q.questId}',
      );
    }
  });
}
