import 'dart:math';
//
import 'package:st_ev_cfg/st_ev_cfg.dart';
import 'package:st_ev_cfg/config/all.dart';
/*
  create every possible target and question type
  and see if correct derived question gets created

  primary risk to test failure (other than bugs)
  is duplicate or ambiguous question-ID's
*/

var randGen = Random();

typedef GendQuestPredictionCallback = void Function(
  /* a callback to allow PermTestAnswerFactory
    to inform GenStatsCollector about how many
    new questions should be generated off of each
    answered question
  */
  QID qid,
  int unanswered,
  int answered,
);

class PermTestAnswerFactory {
  /* produces CONSISTENT mock/dummy answers
    for all questions in the test (both manual and derrived)

    also logs EXPECTED generated questions
    back to the GenStatsCollector on the QCascadeDispatcher
    so we can confirm everything is working
  */
  late GendQuestPredictionCallback _genPredictionCallback;
  PermTestAnswerFactory();

  void appendRandomAnswers(QuestBase qb) {
    /* currently only sending 1 answer to all questions
      which implies they should only create ONE
      derived generated question
    */
    assert(!qb.isFullyAnswered, 'oops!');
    IntRange firstPromptUserChoiceAllowedRange = qb.userRespCountRangeForTest;

    int _maxUserResponses = firstPromptUserChoiceAllowedRange.item2 + 1;
    // reduce max to some rand mid-value > zero
    int expectToGenUnanswered = randGen.nextInt(_maxUserResponses) + 1;
    int expectToGenAnswered = 0;

    print(
      '_maxUserResponses: $_maxUserResponses, expectToGenUnanswered: $expectToGenUnanswered',
    );

    // random always picks up the low numbers
    List<String> userAnsLst = List.generate(
      expectToGenUnanswered,
      (index) => index.toString(),
    );

    // if (qb is RegionTargetQuest) {
    //   /*  */
    //   // expectToGenUnanswered = 1;
    //   // if (qb.questId.startsWith(QuestionIdStrings.specAreasToConfigOnScreen)) {
    //   //   expectToGenUnanswered = 2;
    //   // }
    // } else if (qb is RuleSelectQuest) {
    //   /*  */
    // } else if (qb is RulePrepQuest) {
    //   /*  */
    // }

    // store how many derived questions SHOULD be produced
    // based on user answers
    _genPredictionCallback(
      qb.questId,
      expectToGenUnanswered,
      expectToGenAnswered,
    );

    String _ansStr = userAnsLst.reduce((full, one) => full + ',' + one);
    qb.setAllAnswersWhileTesting([_ansStr]);
  }

  void setExpectedGenPredictCallback(GendQuestPredictionCallback cb) {
    // function from GenStatsCollector
    _genPredictionCallback = cb;
  }
}

class PermuteTest {
  /*  contains data and logic to
    execute all our tests
  */

  PermTestAnswerFactory answerFactory = PermTestAnswerFactory();

  PermuteTest();
  // List<RegionTargetQuest> allTargets = [];
  // List<RuleSelectQuest> allRuleSelect = [];
  // List<RulePrepQuest> allRulePrep = [];
  //  {
  //   allTargets = Permute.buildPosibleTargetQuestsWithAnswers();
  //   allRuleSelect = Permute.buildPossibleRuleSelectQuestsWithAnswers();
  //   allRulePrep = Permute.buildPosibleRuleRulePreQuestsWithAnswers();
  // }

  void testAllTargetDerived(
    QuestListMgr qlm,
    QCascadeDispatcher qcd,
  ) {
    // predictionCallback allows the answer generator to say
    // how many new questions should be produced by each question
    answerFactory.setExpectedGenPredictCallback(
      qcd.statsCollector.setExpectedGenPrediction,
    );

    List<RegionTargetQuest> allTargQuests =
        Permute.buildPosibleTargetQuestsUnanswered();

    // now set default answers on all these questions
    for (RegionTargetQuest ptq in allTargQuests) {
      //
      answerFactory.appendRandomAnswers(ptq);
    }

    // now all questions have answers
    // pass each quest to cascade-dispatch
    // and confirm proper # & type of questions created
    for (RegionTargetQuest questJustAnswered in allTargQuests) {
      qcd.appendNewQuestsOrInsertImplicitAnswers(qlm, questJustAnswered);
    }
  }

  void testAllRuleSelectDerived(
    QuestListMgr qlm,
    QCascadeDispatcher qcd,
  ) {
    // predictionCallback allows the answer generator to say
    // how many new questions should be produced by each question
    answerFactory.setExpectedGenPredictCallback(
      qcd.statsCollector.setExpectedGenPrediction,
    );
    //
    List<RuleSelectQuest> allRuleSelect =
        Permute.buildPossibleRuleSelectQuestsUnanswered();

    // now set default answers on all these questions
    for (RuleSelectQuest ptq in allRuleSelect) {
      //
      answerFactory.appendRandomAnswers(ptq);
    }

    // now all questions have answers
    // pass each quest to cascade-dispatch
    // and confirm proper # & type of questions created
    for (RuleSelectQuest questJustAnswered in allRuleSelect) {
      qcd.appendNewQuestsOrInsertImplicitAnswers(qlm, questJustAnswered);
    }
  }

  void testAllRulePrepDerived(
    QuestListMgr qlm,
    QCascadeDispatcher qcd,
  ) {
    // predictionCallback allows the answer generator to say
    // how many new questions should be produced by each question
    answerFactory.setExpectedGenPredictCallback(
      qcd.statsCollector.setExpectedGenPrediction,
    );
    //
    List<RulePrepQuest> allRulePrep =
        Permute.buildPosibleRulePrepQuestsUnanswered();

    // now set default answers on all these questions
    for (RulePrepQuest rpq in allRulePrep) {
      //
      answerFactory.appendRandomAnswers(rpq);
    }

    // now all questions have answers
    // pass each quest to cascade-dispatch
    // and confirm proper # & type of questions created
    for (RulePrepQuest questJustAnswered in allRulePrep) {
      qcd.appendNewQuestsOrInsertImplicitAnswers(qlm, questJustAnswered);
    }
  }
}

class Permute {
  //
  Permute(); // this.qTarg, this.qFactory

  static List<QTargetResolution> _allPossibleTargetCombinations() {
    /* a complete list of fully resolved possible targets

    these are over-resolved (meaning full target depth set)
    so that they can be used in any derrived questions generated

    no visual-rules are set in these instances

    the normal implication is that these fully resolved
    QTR recs will (would normally) be created in the NEW
    question associated with an explicit user-answer to a targeting question

    in actuality, these (overly resol ed) will be embedded in a pre-question
    so we can use their "target answer", (set w mock data) as a way to
    create auto-answers to test creation of all derrived questions
    */
    List<QTargetResolution> _allPossibleTargets = [];
    for (AppScreen appScrn
        in AppScreen.eventConfiguration.topConfigurableScreens) {
      // add one with only (each) screen set
      QTargetResolution qTargScreen =
          QTargetResolution.forTargetting(appScrn, null, null);
      _allPossibleTargets.add(qTargScreen);
      for (ScreenWidgetArea scrArea in appScrn.configurableScreenAreas) {
        // loop config areas on screen
        // add a targ with only (each) area set
        QTargetResolution qTargArea =
            QTargetResolution.forTargetting(appScrn, scrArea, null);
        // store QTR where target is not complete
        _allPossibleTargets.add(qTargArea);
        // store QTR where target IS complete
        _allPossibleTargets
            .add(qTargArea.copyWith(precision: TargetPrecision.ruleSelect));
        for (ScreenAreaWidgetSlot widSlot
            in scrArea.applicableWigetSlots(appScrn)) {
          // loop config slots in area of screen
          QTargetResolution qTargSlot =
              QTargetResolution.forTargetting(appScrn, scrArea, widSlot);
          // store QTR where target is not complete
          _allPossibleTargets.add(qTargSlot);
          // store QTR where target IS complete
          _allPossibleTargets
              .add(qTargSlot.copyWith(precision: TargetPrecision.ruleSelect));
        }
      }
    }
    return _allPossibleTargets;
  }

  static List<RegionTargetQuest> buildPosibleTargetQuestsUnanswered() {
    /* 
      my QTargetResolution recs are over-resolved
      meaning their data exists AS IF they are the result of
      prior answers adding to a formerly incomplete state

    build every possible targetting question
    with reasonable default answers
    generators should build derived questions
    to allow user to select which rule for area
    verify those rule-select questions were created!!
    once slots are set, they are no longer targetting questions
     */

    List<QTargetResolution> _allTarg = _allPossibleTargetCombinations();

    // targets with only app screen resolved
    List<QTargetResolution> _allScreenLevelTargets =
        _allTarg.where((qtr) => qtr.screenWidgetArea == null).toList();

    List<RegionTargetQuest> regTargetQuests = [];
    // String promptTempl = 'Select area/slot for target ${0}';

    for (QTargetResolution qtr in _allScreenLevelTargets) {
      regTargetQuests.add(
        RegionTargetQuest(
          qtr,
          QPromptCollection.pickAreasForScreen(qtr.appScreen),
          questId: QuestionIdStrings.specAreasToConfigOnScreen +
              '-' +
              qtr.targetPath,
        ),
      );
    }

    // keep recs where target is NOT marked complete
    // but area IS SET (below screen level)
    List<QTargetResolution> _allQtrWithAreaOnly = _allTarg
        .where((qtr) =>
            !qtr.targetComplete &&
            qtr.screenWidgetArea != null &&
            qtr.slotInArea == null)
        .toList();

    // sort QTRs with area set
    _allQtrWithAreaOnly
        .sort((t1, t2) => t1.targetSortIndex.compareTo(t2.targetSortIndex));

    for (QTargetResolution areaQtr in _allQtrWithAreaOnly) {
      //
      QPromptCollection prompts = QPromptCollection.selectTargetSlotsInArea(
        areaQtr.appScreen,
        areaQtr.screenWidgetArea!,
      );
      regTargetQuests.add(
        RegionTargetQuest(
          areaQtr,
          prompts,
          questId: QuestionIdStrings.specSlotsToConfigInArea +
              '-' +
              areaQtr.targetPath,
        ),
      );
    }
    return regTargetQuests;
  }

  static List<RuleSelectQuest> buildPossibleRuleSelectQuestsUnanswered() {
    /* 
      my QTargetResolution recs are over-resolved
      meaning their data exists AS IF they are the result of
      prior answers
     */

    List<QTargetResolution> _allTarg = _allPossibleTargetCombinations();
    // convert all target QTR to ruleSelect precision
    List<QTargetResolution> _allQtrAsRuleSelect = _allTarg
        .map<QTargetResolution>(
          (e) => e.copyWith(
            precision: TargetPrecision.ruleSelect,
          ),
        )
        .toList();

    // keep recs where target IS SET complete
    _allQtrAsRuleSelect = _allTarg.where((qtr) => qtr.targetComplete).toList();

    // sort QTRs with area set
    _allQtrAsRuleSelect
        .sort((t1, t2) => t1.targetSortIndex.compareTo(t2.targetSortIndex));

    List<RuleSelectQuest> ruleSelectQuests = [];
    for (QTargetResolution areaQtr in _allQtrAsRuleSelect) {
      //
      QPromptCollection prompts =
          QPromptCollection.selectRulesForTarget(areaQtr);
      ruleSelectQuests.add(
        RuleSelectQuest(
          areaQtr,
          prompts,
          questId: QuestionIdStrings.specRulesForSlotInArea +
              '-' +
              areaQtr.targetPath,
        ),
      );
    }
    return ruleSelectQuests;
  }

  static List<RulePrepQuest> buildPosibleRulePrepQuestsUnanswered() {
    /*  only targets with a visual-rule can serve as basis for a
        rule-prep question
        but none of the recs coming from _allPossibleTargetCombinations
        have rules set on them

        attach sensible visual-rules to all of these

      fyi:  my QTargetResolution recs are over-resolved
      meaning their data exists AS IF they are the result of
      prior answers
    */
    List<QTargetResolution> _allTarg = _allPossibleTargetCombinations();

    List<QTargetResolution> _allQtrAsRulePrep = [];
    for (QTargetResolution qtr in _allTarg) {
      List<VisualRuleType> allowedRules = qtr.possibleRulesAtAnyTarget;
      for (VisualRuleType vrt in allowedRules) {
        if (vrt.requiresVisRulePrepQuestion) {
          _allQtrAsRulePrep.add(
            qtr.copyWith(
              visRuleTypeForAreaOrSlot: vrt,
              precision: TargetPrecision.rulePrep,
            ),
          );
        }
      }
    }

    // keep recs where target IS complete & we have a
    _allQtrAsRulePrep = _allTarg
        .where(
            (qtr) => qtr.targetComplete && qtr.visRuleTypeForAreaOrSlot != null)
        .toList();

    // sort QTRs
    _allQtrAsRulePrep
        .sort((t1, t2) => t1.targetSortIndex.compareTo(t2.targetSortIndex));

    List<RulePrepQuest> rulePrepQuests = [];
    for (QTargetResolution areaQtr in _allQtrAsRulePrep) {
      //
      QPromptCollection prompts =
          QPromptCollection.forRulePrepQuestion(areaQtr);
      rulePrepQuests.add(
        RulePrepQuest(
          areaQtr,
          prompts,
          questId:
              QuestionIdStrings.prepQuestForVisRule + '-' + areaQtr.targetPath,
        ),
      );
    }
    return rulePrepQuests;
  }
}
