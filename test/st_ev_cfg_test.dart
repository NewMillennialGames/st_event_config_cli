import 'package:test/test.dart';
//
import 'package:st_ev_cfg/st_ev_cfg.dart';
import 'package:st_ev_cfg/config/all.dart';
import 'package:st_ev_cfg/util/all.dart';

void main() {
  test(
    '''asks which rules to config for listView (TV) on MarketView screen 
          answers with style and grouping
          verifies new quests generated properly from answer
          groupCtf needs prep & styleCfg does not
      ''',
    () {
      // const k_quests_created_in_test = 2;

      final _questMgr = QuestListMgr();
      final _cascadeDispatch = QCascadeDispatcher();

      expect(_questMgr.totalAnsweredQuestions, 0);

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

      _questMgr.appendGeneratedQuestsAndAnswers([askWhichRulesForMktVwTblVw]);

      // next 2 lines are virtually the same test
      expect(_questMgr.priorAnswers.length, 0);
      expect(_questMgr.totalAnsweredQuestions, 0);

      QuestBase quest = _questMgr.nextQuestionToAnswer()!;
      quest.setAllAnswersWhileTesting(['0,2']);

      // need to bump QuestListMgr to next question
      // to force prior into the answered queue
      var nxtQu = _questMgr.nextQuestionToAnswer();
      expect(nxtQu, null, reason: '_questMgr only has 1 question');
      expect(_questMgr.priorAnswers.length, 1, reason: 'quest was answered');

      // next line should create 2 new questions
      _cascadeDispatch.appendNewQuestsOrInsertImplicitAnswers(
        _questMgr,
        askWhichRulesForMktVwTblVw,
      );

      // one prep & one rule detail question, but not yet answered -- so zero exportable
      expect(
        _questMgr.exportableRuleQuestions.length,
        0,
        reason: '2 new but not yet answered',
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
      for (QuestBase q in _questMgr.pendingQuestions) {
        prepCount += q.isRulePrepQuestion ? 1 : 0;
        detailCount += q.isRuleDetailQuestion ? 1 : 0;
        var userPrompt = q.firstPrompt.userPrompt;
        print('QuestMatcher created:  $userPrompt  ${q.questId}');
      }
      print(
        'appendNewQuestsOrInsertImplicitAnswers created:  prepCount: $prepCount  detailCount: $detailCount',
      );
    },
    // skip: true,
  );
}
