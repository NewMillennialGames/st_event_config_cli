import 'dart:async';
import 'package:test/test.dart';
//
import 'package:st_ev_cfg/st_ev_cfg.dart';
import 'package:st_ev_cfg/util/all.dart';
//
import 'full_ans_expect.dart';
import 'shared_utils.dart';
/*
  create every possible target and question type
  and see if correct derived question gets created

*/

class Permute {
  //
  QTargetResolution qTarg;
  QuestFactorytSignature qFactory;

  Permute(this.qTarg, this.qFactory);

  String get targetPath => qTarg.targetPath;

  static List<QTargetResolution> _allPossibleEnumCombinations() {
    //
    List<QTargetResolution> _allTarg = [];
    for (AppScreen appScrn
        in AppScreen.eventConfiguration.topConfigurableScreens) {
      for (ScreenWidgetArea scrArea in appScrn.configurableScreenAreas) {
        // loop areas on screen
        QTargetResolution? qTargArea =
            QTargetResolution.forTargetting(appScrn, scrArea, null);

        for (VisualRuleType areaRt in scrArea.applicableRuleTypes(appScrn)) {
          // loop rules for area
          QTargetResolution qRuleDetArea = QTargetResolution.forVisRuleDetail(
            appScrn,
            scrArea,
            null,
            areaRt,
          );
          _allTarg.add(qRuleDetArea);
        }
        for (ScreenAreaWidgetSlot widSlot
            in scrArea.applicableWigetSlots(appScrn)) {
          // loop slots in area
          if (qTargArea != null) {
            _allTarg.add(qTargArea);
            qTargArea = null;
          }
          QTargetResolution? qTargSlot =
              QTargetResolution.forTargetting(appScrn, scrArea, widSlot);
          for (VisualRuleType rt in widSlot.possibleConfigRules(scrArea)) {
            // loop rules for slot in area

            if (qTargSlot != null) {
              _allTarg.add(qTargSlot);
              qTargSlot = null;
            }

            QTargetResolution qRuleDet = QTargetResolution.forVisRuleDetail(
              appScrn,
              scrArea,
              widSlot,
              rt,
            );
            _allTarg.add(qRuleDet);
          }
        }
      }
    }
    return _allTarg;
  }

  static List<Permute> buildAllPermutations() {
    //
    List<QTargetResolution> _allTarg = _allPossibleEnumCombinations();
    _allTarg.sort((t1, t2) => t1.targetSortIndex.compareTo(t2.targetSortIndex));
    return _allTarg
        .map((qt) => Permute(qt, qt.guessQuestSignatureForTest))
        .toList();
  }
}

void main() {
  //
  bool setupCompleted = false;
  QuestBase seedQuest = QuestBase.initialEventConfigRule(
    QTargetResolution.forEvent(),
    'Pick screens to config',
    AppScreen.values.map((e) => e.name),
    CaptureAndCast<List<AppScreen>>((qb, idx) => AppScreen.values),
  );
  QuestListMgr _questMgr = QuestListMgr([seedQuest]);
  QuestionCascadeDispatcher _qcd = QuestionCascadeDispatcher();
  var allPerm = Permute.buildAllPermutations();

  var questCount = 0;
  var addedQuestCount = 0;

  // List<QuestBase> createdQuests = [];

  CastStrToAnswTypCallback<String> _castFunc =
      (QuestBase qb, String response) => '5';

  for (Permute pt in allPerm) {
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
