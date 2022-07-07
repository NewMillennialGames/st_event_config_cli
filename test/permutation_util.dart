// import 'dart:async';
// import 'package:test/test.dart';
//
import 'package:st_ev_cfg/st_ev_cfg.dart';
import 'package:st_ev_cfg/util/all.dart';
//
// import 'full_ans_expect.dart';
/*
  create every possible target and question type
  and see if correct derived question gets created

*/

class AnswerFactory {
  /* produces CONSISTENT mock/dummy answers
    for all questions in the test (both manual and derrived)

  */
  AnswerFactory();

  List<String> answerFor(QuestBase qb) {
    return ['0'];
  }
}

class PermuteTest {
  /*  contains data and logic to
    execute all our tests
  */
  List<RegionTargetQuest> allTargets = [];
  List<RuleSelectQuest> allRuleSelect = [];
  List<RulePrepQuest> allRulePrep = [];
  AnswerFactory answerFactory = AnswerFactory();

  PermuteTest() {
    allTargets = Permute.buildAllPosTargetQuests();
    allRuleSelect = Permute.buildAllPosRuleSelectQuests();
    allRulePrep = Permute.buildAllPosRuleRulePreQuests();
  }

  void testAllTargetDerived() {
    //
  }

  void testAllRuleSelectDerived() {
    //
  }

  void testAllRulePrepDerived() {
    //
  }
}

class Permute {
  //
  QTargetResolution qTarg;
  QuestFactorytSignature qFactory;

  Permute(this.qTarg, this.qFactory);

  String get targetPath => qTarg.targetPath;

  static List<QTargetResolution> _allPossibleTargetCombinations() {
    /*
  {
    bool withRules = false,
  }
    */
    List<QTargetResolution> _allTarg = [];
    for (AppScreen appScrn
        in AppScreen.eventConfiguration.topConfigurableScreens) {
      for (ScreenWidgetArea scrArea in appScrn.configurableScreenAreas) {
        // loop areas on screen
        QTargetResolution? qTargArea =
            QTargetResolution.forTargetting(appScrn, scrArea, null);

        // if (withRules) {
        //   for (VisualRuleType areaRt in scrArea.applicableRuleTypes(appScrn)) {
        //     // loop rules for area
        //     QTargetResolution qRuleDetArea = QTargetResolution.forVisRuleDetail(
        //       appScrn,
        //       scrArea,
        //       null,
        //       areaRt,
        //     );
        //     _allTarg.add(qRuleDetArea);
        //   }
        // }
        for (ScreenAreaWidgetSlot widSlot
            in scrArea.applicableWigetSlots(appScrn)) {
          // loop slots in area
          if (qTargArea != null) {
            _allTarg.add(qTargArea);
            qTargArea = null;
          }
          QTargetResolution? qTargSlot =
              QTargetResolution.forTargetting(appScrn, scrArea, widSlot);

          if (qTargSlot != null) {
            _allTarg.add(qTargSlot);
            qTargSlot = null;
          }
        }
      }
    }
    return _allTarg;
  }

  static List<RegionTargetQuest> buildAllPosTargetQuests() {
    // build every possible targetting question
    // generators should build derived questions
    // to allow user to select which rule

    List<QTargetResolution> _allTarg = _allPossibleTargetCombinations();
    _allTarg.sort((t1, t2) => t1.targetSortIndex.compareTo(t2.targetSortIndex));

    List<RegionTargetQuest> l = [];
    String promptTempl = 'Select desired rules targeting ${0}';

    for (QTargetResolution qtr in _allTarg) {
      List<VisualRuleType> possibleRulesForTarget =
          qtr.possibleRulesAtAnyTarget;

      // create custom cast function for selected rule
      List<VisualRuleType> castAnswer(QuestBase qb, String lstAreaIdxs) {
        return castStrOfIdxsToIterOfInts(lstAreaIdxs, dflt: 0)
            .map(
              (i) => possibleRulesForTarget[i],
            )
            .toList();
      }

      String prompt = promptTempl.format([qtr.targetPath]);
      QPromptCollection prompts = QPromptCollection.singleDialog(
        prompt,
        ['0'],
        CaptureAndCast<List<VisualRuleType>>(castAnswer),
      );
      l.add(RegionTargetQuest(qtr, prompts));
    }
    return l;
  }

  static List<RuleSelectQuest> buildAllPosRuleSelectQuests() {
    // build every possible targetting question
    // generators should build derived questions
    // to allow user to select which rule

    List<QTargetResolution> _allTarg = _allPossibleTargetCombinations();
    _allTarg.sort((t1, t2) => t1.targetSortIndex.compareTo(t2.targetSortIndex));

    List<RuleSelectQuest> l = [];
    String promptTempl = 'Select desired rules targeting ${0}';

    for (QTargetResolution qtr in _allTarg) {
      List<VisualRuleType> possibleRulesForTarget =
          qtr.possibleRulesAtAnyTarget;

      // create custom cast function for selected rule
      List<VisualRuleType> castAnswer(QuestBase qb, String lstAreaIdxs) {
        return castStrOfIdxsToIterOfInts(lstAreaIdxs, dflt: 0)
            .map(
              (i) => possibleRulesForTarget[i],
            )
            .toList();
      }

      String prompt = promptTempl.format([qtr.targetPath]);
      QPromptCollection prompts = QPromptCollection.singleDialog(
        prompt,
        ['0'],
        CaptureAndCast<List<VisualRuleType>>(castAnswer),
      );
      l.add(RuleSelectQuest(qtr, prompts));
    }
    return l;
  }

  static List<RulePrepQuest> buildAllPosRuleRulePreQuests() {
    // build every possible targetting question
    // generators should build derived questions
    // to allow user to select which rule

    // for (VisualRuleType rt in widSlot.possibleConfigRules(scrArea)) {
    //   // loop rules for slot in area

    //   if (qTargSlot != null) {
    //     _allTarg.add(qTargSlot);
    //     qTargSlot = null;
    //   }

    //   // if (withRules) {
    //   //   QTargetResolution qRuleDet = QTargetResolution.forVisRuleDetail(
    //   //     appScrn,
    //   //     scrArea,
    //   //     widSlot,
    //   //     rt,
    //   //   );
    //   //   _allTarg.add(qRuleDet);
    //   // }
    // }

    List<QTargetResolution> _allTarg = _allPossibleTargetCombinations();
    _allTarg.sort((t1, t2) => t1.targetSortIndex.compareTo(t2.targetSortIndex));

    List<RulePrepQuest> l = [];
    String promptTempl = 'Select desired rules targeting ${0}';

    for (QTargetResolution qtr in _allTarg) {
      List<VisualRuleType> possibleRulesForTarget =
          qtr.possibleRulesAtAnyTarget;

      // create custom cast function for selected rule
      List<VisualRuleType> castAnswer(QuestBase qb, String lstAreaIdxs) {
        return castStrOfIdxsToIterOfInts(lstAreaIdxs, dflt: 0)
            .map(
              (i) => possibleRulesForTarget[i],
            )
            .toList();
      }

      String prompt = promptTempl.format([qtr.targetPath]);
      QPromptCollection prompts = QPromptCollection.singleDialog(
        prompt,
        ['0'],
        CaptureAndCast<List<VisualRuleType>>(castAnswer),
      );
      l.add(RulePrepQuest(qtr, prompts));
    }
    return l;
  }
}
