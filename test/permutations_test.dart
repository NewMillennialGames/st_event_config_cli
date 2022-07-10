import 'dart:async';
import 'package:test/test.dart';
//
import 'package:st_ev_cfg/st_ev_cfg.dart';
import 'package:st_ev_cfg/util/all.dart';
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

void main() {
  /*

  */
  bool setupCompleted = false;
  var questCount = 0;
  var addedQuestCount = 0;

  PermuteTest permute = PermuteTest();

  QuestBase seedQuest = QuestBase.initialEventConfigRule(
    QTargetResolution.forEvent(),
    'Pick screens to config',
    AppScreen.values.map((e) => e.name),
    CaptureAndCast<List<AppScreen>>((qb, idx) => AppScreen.values),
  );
  QuestListMgr _questMgr = QuestListMgr([seedQuest]);
  QCascadeDispatcher _qcd = QCascadeDispatcher();

  setUp(() {
    if (setupCompleted) return;

    setupCompleted = true;
  });

  group('check all derived', () {
    test(
      'check derived from target answers',
      () {
        permute.testAllTargetDerived(_questMgr, _qcd);
      },
    );
    test(
      'check derived from rule-select answers',
      () {
        permute.testAllRuleSelectDerived(_questMgr, _qcd);
      },
    );
    test(
      'check derived from rule-prep answers',
      () {
        permute.testAllRulePrepDerived(_questMgr, _qcd);
      },
    );
  });
}
