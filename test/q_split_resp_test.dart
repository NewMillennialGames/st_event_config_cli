import 'package:test/test.dart';
//
import 'package:st_ev_cfg/st_ev_cfg.dart';
import 'package:st_ev_cfg/config/all.dart';
import 'package:st_ev_cfg/util/all.dart';

/*
  remaining bugs:
  1) showing "3rd" when should show 2nd
  2) asking 2nd when only one sort field
  3) showing sort when I selected group (offset problem)
  4) selecting ONLY tableview did the auto-answer when there was > 1 rule possible
*/

void main() {
  test(
    '''asks which rules to config for listView (TV) on MarketView screen 
          answers with style and grouping
          verifies new quests generated properly from answer
          groupCtf needs prep & styleCfg does not
      ''',
    () {
      // const k_quests_created_in_test = 2;

      final _cascadeDispatch = QCascadeDispatcher();

      // expect(_questMgr.totalAnsweredQuestions, 0);

      final qq = QTargetResolution.forRuleSelection(
        AppScreen.marketView,
        ScreenWidgetArea.tableview,
        null,
      );

      List<VisualRuleType> _possibleRules =
          ScreenWidgetArea.tableview.applicableRuleTypes(AppScreen.marketView);

      QuestPromptPayload prompt = QuestPromptPayload(
          'Select which rules to config within area {0} of screen {1}',
          _possibleRules.map((e) => e.name).toList(),
          VisRuleQuestType.dialogStruct,
          (qb, ruleIdxAnws) => castStrOfIdxsToIterOfInts(ruleIdxAnws, dflt: 0)
              .map((idx) => _possibleRules[idx])
              .toList());

      RuleSelectQuest askWhichRulesForMktVwTblVw = QuestBase.ruleSelectQuest(
        qq,
        [prompt],
        questId: QuestionIdStrings.specRulesForAreaOnScreen,
      ) as RuleSelectQuest;

      //
      askWhichRulesForMktVwTblVw.setAllAnswersWhileTesting(['0,2']);
      expect(
        askWhichRulesForMktVwTblVw.isFullyAnswered,
        true,
        reason: 'answer just set',
      );
      final _questMgr = QuestListMgr([askWhichRulesForMktVwTblVw]);

      expect(
        _questMgr.pendingQuestionCount,
        1,
        reason: 'one question in qlm',
      );
      expect(
        _questMgr.exportableVisRuleQuestions.length,
        0,
        reason: 'no rule detail questions created or answered yet',
      );

      // next 2 lines are virtually the same test
      expect(_questMgr.priorAnswers.length, 0);
      expect(_questMgr.totalAnsweredQuestions, 0);

      QuestBase askWhichRulesForMktVw2 = _questMgr.nextQuestionToAnswer()!;
      expect(
        askWhichRulesForMktVw2.questId,
        QuestionIdStrings.specRulesForAreaOnScreen,
        reason: 'verify we have correct question to answer',
      );

      // need to bump QuestListMgr to next question
      // to force prior into the answered queue
      var nxtQu = _questMgr.nextQuestionToAnswer();
      expect(_questMgr.totalAnsweredQuestions, 1, reason: 'quest was answered');
      expect(_questMgr.priorAnswers.length, 1, reason: 'quest was answered');
      expect(nxtQu, null, reason: '_questMgr only has 1 question');

      // next line should create 2 new questions
      _cascadeDispatch.appendNewQuestsOrInsertImplicitAnswers(
        _questMgr,
        askWhichRulesForMktVwTblVw,
      );

      // one prep & one rule detail question, but not yet answered -- so zero exportable
      // print('exportableVisRuleQuestions  &&&&& **');
      // for (VisualRuleDetailQuest q in _questMgr.exportableVisRuleQuestions) {
      //   // print('${q.questId}:  ${q.firstPrompt}');
      //   print('${q.questId} ${q.promptCount}');
      // }
      expect(
        _questMgr.exportableVisRuleQuestions.length,
        0,
        reason: '2 new rule quests but not yet answered',
      );
      //
      // now check that 2 questions were created
      // since there was no 2nd INITIAL question, nextQuestionToAnswer did not move index
      // so we subtract one from pending ...
      expect(
        _questMgr.pendingQuestionCount,
        2,
        reason: 'should generate one prep & one detail question',
      );
      //

      int prepCount = 0;
      int detailCount = 0;
      print('\n\nCreation summary:');
      // skip 1st question as it was already answered in this test
      for (QuestBase q in _questMgr.pendingQuestions.sublist(1)) {
        prepCount += q.isRulePrepQuestion ? 1 : 0;
        detailCount += q.isRuleDetailQuestion ? 1 : 0;
        var userPrompt = q.firstPrompt.userPrompt.substring(0, 52);
        print(
            'QuestMatcher created QID:  ${q.questId}\n\tprompt: $userPrompt\n\t(${q.isRulePrepQuestion ? "PREP ?" : "DETAIL ?"})');
      }
      print(
        'appendNewQuestsOrInsertImplicitAnswers created:  prepCount: $prepCount  detailCount: $detailCount',
      );
      expect(prepCount, 1, reason: 'need to ask # of group-by fields');
      expect(detailCount, 1, reason: 'need to ask TV row style');
    },
    // skip: true,
  );
}
