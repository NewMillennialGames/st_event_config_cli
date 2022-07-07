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
  QuestBase seedQuest = QuestBase.initialEventConfigRule(
    QTargetResolution.forEvent(),
    'Pick screens to config',
    AppScreen.values.map((e) => e.name),
    CaptureAndCast<List<AppScreen>>((qb, idx) => AppScreen.values),
  );
  QuestListMgr _questMgr = QuestListMgr([seedQuest]);
  QuestionCascadeDispatcher _qcd = QuestionCascadeDispatcher();
  // var allPerm = Permute.buildAllTargetPermutations();

  var questCount = 0;
  var addedQuestCount = 0;

  // List<QuestBase> createdQuests = [];

  CastStrToAnswTypCallback<String> _castFunc =
      (QuestBase qb, String response) => '5';

  for (Permute pt in []) {
    // allPerm
    print(pt.targetPath);
    QuestPromptPayload qpp = QuestPromptPayload<String>(
      pt.qTarg.targetPath,
      ['0', '1', '2', '3'],
      VisRuleQuestType.dialogStruct,
      _castFunc,
    );
    questCount = _questMgr.pendingQuestionCount;
    QuestBase qb = pt.qFactory(pt.qTarg, [qpp]);
    qb.setAllAnswersWhileTesting(['0']);
    _qcd.appendNewQuestsOrInsertImplicitAnswers(_questMgr, qb);
    addedQuestCount = _questMgr.pendingQuestionCount - questCount;
    // createdQuests.add(qb);
  }

  // StreamController<List<String>> sendAnswersController =
  //     StreamController<List<String>>();
  // QuestListMgr _questMgr = QuestListMgr();
  //
  // FullFlowTestPresenter questPresent = FullFlowTestPresenter(
  //     sendAnswersController, _questMgr); // aka QuestionPresenterIfc
  // DialogRunner dlogRun = DialogRunner(
  //   questPresent,
  //   qListMgr: _questMgr,
  //   questCascadeDisp: _qcd,
  // );

  setUp(() {
    if (setupCompleted) return;

    setupCompleted = true;
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
