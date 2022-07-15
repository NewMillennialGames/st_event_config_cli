import 'package:test/test.dart';
//
import 'package:st_ev_cfg/st_ev_cfg.dart';
import 'package:st_ev_cfg/config/all.dart';
//
import 'permutation_util.dart';
/*  Summary:
  create every possible question type
  and see if correct derived question gets created

  Detail:

  use permutations loop to create all possible
    1. targetting questions
    2. rule-select questions
    3. rule-prep questions

with PRE-CANNED answers (needed by the generators)

and for each above generated set
    use matchers to confirm that the
    proper derived questions were created
    by the default cascade dispatcher


regarding PRE-CANNED answers, we may need a top-level
structure that defines the rule for selecting
the answer for THIS TEST RUN
that will allow us to 

*/

const SKIP_THESE_TESTS = false;

void main() {
  /* - */
  late PermuteTest permute;
  late QuestBase seedQuest;
  late QuestListMgr _questMgr;
  late QCascadeDispatcher _qcd;

  setUp(() {
    //
    permute = PermuteTest();

    seedQuest = QuestBase.initialEventConfigRule(
      QTargetResolution.forEvent(),
      'Select app screens to config',
      AppScreen.values.map((e) => e.name),
      CaptureAndCast<List<AppScreen>>((qb, idx) => AppScreen.values),
      questId: QuestionIdStrings.selectAppScreens,
    );

    // select 1st 3 screens
    seedQuest.setAllAnswersWhileTesting(['0,1,2']);
    _questMgr = QuestListMgr([seedQuest]);
    _qcd = QCascadeDispatcher();
  });

  group(
    'check that derived questions are created properly from prior user answers  (20, 44, 7)',
    () {
      test(
        'check derived from target answers',
        () {
          assert(
            _questMgr.pendingQuestionCount == 1,
            'err: seemed setup did not re-init objects??',
          );
          print('questId\tunansweredQsAdded\tansweredQsAdded');
          permute.testAllTargetDerived(_questMgr, _qcd);
          List<PerQStats> compareVals =
              _qcd.statsCollector.getTestComparisonValues();

          // print(
          //   '**** there were ${compareVals.length} questions in "testAllTargetDerived" test',
          // );
          assert(
            compareVals.length > 0,
            'no questions created!!  testAllTargetDerived test invalid',
          );

          for (PerQStats pqs in compareVals) {
            expect(
              pqs.unansweredQsAdded,
              pqs.unanswered.expected,
              reason:
                  'QID: ${pqs.qid} was expected to create ${pqs.unanswered.expected} quests but actually created ${pqs.unansweredQsAdded}',
            );

            expect(
              pqs.answeredQsAdded,
              pqs.answered.expected,
              reason:
                  'QID: ${pqs.qid} was expected to create ${pqs.answered.expected} quests but actually created ${pqs.answeredQsAdded}',
            );
          }
        },
      );
      test(
        'check derived from rule-select answers',
        () {
          assert(
            _questMgr.pendingQuestionCount == 1,
            'err: seemed setup did not re-init objects??',
          );
          permute.testAllRuleSelectDerived(_questMgr, _qcd);
          List<PerQStats> compareVals =
              _qcd.statsCollector.getTestComparisonValues();

          // print(
          //   '**** there were ${compareVals.length} questions in "testAllRuleSelectDerived" test',
          // );
          assert(
            compareVals.length > 0,
            'no questions created!!  testAllRuleSelectDerived test invalid',
          );

          int loopCnt = 0;
          for (PerQStats pqs in compareVals) {
            loopCnt++;
            print('testing quest #$loopCnt');
            expect(
              pqs.unansweredQsAdded,
              pqs.unanswered.expected,
              reason:
                  'QID: ${pqs.qid} was expected to create ${pqs.unanswered.expected} quests but actually created ${pqs.unansweredQsAdded}',
            );

            expect(
              pqs.answeredQsAdded,
              pqs.answered.expected,
              reason:
                  'QID: ${pqs.qid} was expected to create ${pqs.answered.expected} quests but actually created ${pqs.answeredQsAdded}',
            );
          }
        },
      );
      test(
        'check derived from rule-prep answers',
        () {
          assert(
            _questMgr.pendingQuestionCount == 1,
            'err: seemed setup did not re-init objects??',
          );
          permute.testAllRulePrepDerived(_questMgr, _qcd);
          List<PerQStats> compareVals =
              _qcd.statsCollector.getTestComparisonValues();
          // print(
          //   '**** there were ${compareVals.length} questions in "testAllRulePrepDerived" test',
          // );
          assert(
            compareVals.length > 0,
            'no questions created!!  testAllRulePrepDerived test invalid',
          );

          for (PerQStats pqs in compareVals) {
            expect(
              pqs.unansweredQsAdded,
              pqs.unanswered.expected,
              reason:
                  'QID: ${pqs.qid} was expected to create ${pqs.unanswered.expected} quests but actually created ${pqs.unansweredQsAdded}',
            );

            expect(
              pqs.answeredQsAdded,
              pqs.answered.expected,
              reason:
                  'QID: ${pqs.qid} was expected to create ${pqs.answered.expected} quests but actually created ${pqs.answeredQsAdded}',
            );
          }
        },
      );
    },
    skip: SKIP_THESE_TESTS,
  );
}
