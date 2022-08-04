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

typedef QuestId = String;
typedef GendQuestPredictionCallback = void Function(
  /* a callback to allow PermTestAnswerFactory
    to inform GenStatsCollector about how many
    new questions should be generated off of each
    answered question
  */
  QuestId qid,
  int unanswered,
  int answered,
);

class GenExpected {
  // defines count of expected derived-questions to be generated
  // in response to answers on question.qid
  final QuestId qid;
  final int unanswered;
  final int answered;
  GenExpected(this.qid, this.unanswered, this.answered);
}

class PermTestAnswerFactory {
  /* produces CONSISTENT mock/dummy answers
    for all questions in the test (both manual and derrived)

    also logs EXPECTED generated questions
    back to the GenStatsCollector on the QCascadeDispatcher
    so we can confirm everything is working
  */
  Map<QuestId, GenExpected> _expected = {};
  late GendQuestPredictionCallback _genPredictionCallback;
  PermTestAnswerFactory() {
    // init expected generator counts
    for (GenExpected ge in _expectedToGen) {
      _expected[ge.qid] = ge;
    }
    ;
  }

  void appendAnswersSetExpectedQGen(QuestBase qb) {
    /* currently only sending 1 answer to all questions
      which implies they should only create ONE
      derived generated question
    */
    assert(
      !qb.isFullyAnswered,
      'oops! appendAnswersSetExpectedQGen only works on unanswered quests',
    );

    // store prediction of derived question count
    // from answers to this question
    GenExpected? expectToGen = _expected[qb.questId];
    if (expectToGen == null) {
      print('err: no expected gen guess found for ${qb.questId}');
      _bruteGuess(qb);
    } else {
      // store how many derived questions WILL be produced
      // based on user answers
      _genPredictionCallback(
        qb.questId,
        expectToGen.unanswered,
        expectToGen.answered,
      );
    }

    // now set mock question answers
    int _maxUserResponses =
        qb.multiChoicesAllowed ? qb.countChoicesInFirstPrompt : 1;
    // prep questions offer 4 choices but user can only pick one
    // some questions may have zero choices; bump to 1
    _maxUserResponses = _maxUserResponses.clamp(1, _maxUserResponses);

    List<String> userAnsLst = List.generate(
      _maxUserResponses,
      (index) => (index).toString(),
    );

    if (qb is RegionTargetQuest) {
      /*  */
      // expectToGenUnanswered = 1;
      // if (qb.questId.startsWith(QuestionIdStrings.specAreasToConfigOnScreen)) {
      //   expectToGenUnanswered = 2;
      // }
    } else if (qb is RuleSelectQuest) {
      /*  */
    } else if (qb is RulePrepQuest) {
      /* will generate the 1 rule detail question 
        including multiple prompts
        based on how many instances to prep
      */
      // skip zero for prep questions; say I want 2 of whatever
      userAnsLst = ['2'];
    }

    String _ansStr = userAnsLst.reduce((full, one) => full + ',' + one);
    qb.setAllAnswersWhileTesting([_ansStr]);
  }

  void _bruteGuess(QuestBase qb) {
    //
    int _maxUserResponses =
        qb.multiChoicesAllowed ? qb.countChoicesInFirstPrompt : 1;
    // prep questions offer 4 choices but user can only pick one
    // some questions may have zero choices; bump to 1
    _maxUserResponses = _maxUserResponses.clamp(1, _maxUserResponses);

    int expectToGenUnanswered = _maxUserResponses;
    int expectToGenAnswered = 0;

    if (qb is RegionTargetQuest) {
      /*  */
      // expectToGenUnanswered = 1;
      // if (qb.questId.startsWith(QuestionIdStrings.specAreasToConfigOnScreen)) {
      //   expectToGenUnanswered = 2;
      // }
    } else if (qb is RuleSelectQuest) {
      /*  */
    } else if (qb is RulePrepQuest) {
      /* will generate the 1 rule detail question 
        including multiple prompts
        based on how many instances to prep
      */
      expectToGenUnanswered = 1;
    }

    // store how many derived questions SHOULD be produced
    // based on user answers
    _genPredictionCallback(
      qb.questId,
      expectToGenUnanswered,
      expectToGenAnswered,
    );

    print(
      "Warn: venturing a guess of $expectToGenUnanswered Q's generated from ${qb.questId}",
    );
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
      answerFactory.appendAnswersSetExpectedQGen(ptq);
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
      answerFactory.appendAnswersSetExpectedQGen(ptq);
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

    // now all questions have answers
    // pass each quest to cascade-dispatch
    // and confirm proper # & type of questions created
    for (RulePrepQuest questJustAnswered in allRulePrep) {
      // now set default answers on all these questions
      answerFactory.appendAnswersSetExpectedQGen(questJustAnswered);
      //
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
        if (vrt.needsVisRulePrepQuestion) {
          _allQtrAsRulePrep.add(
            qtr.copyWith(
              visRuleTypeForAreaOrSlot: vrt,
              precision: TargetPrecision.rulePrep,
            ),
          );
        }
      }
    }

    // keep recs where target IS complete & we have a vis rule specified
    // _allQtrAsRulePrep = _allQtrAsRulePrep
    //     .where(
    //         (qtr) => qtr.targetComplete && qtr.visRuleTypeForAreaOrSlot != null)
    //     .toList();

    // sort QTRs
    _allQtrAsRulePrep
        .sort((t1, t2) => t1.targetSortIndex.compareTo(t2.targetSortIndex));

    List<RulePrepQuest> rulePrepQuests = [];
    for (QTargetResolution areaOrSlotQtr in _allQtrAsRulePrep) {
      //
      QPromptCollection prompts =
          QPromptCollection.forRulePrepQuestion(areaOrSlotQtr);
      rulePrepQuests.add(
        RulePrepQuest(
          areaOrSlotQtr,
          prompts,
          questId: QuestionIdStrings.prepQuestForVisRule +
              '-' +
              areaOrSlotQtr.targetPath,
        ),
      );
    }
    return rulePrepQuests;
  }
}

// counts of how many derived questions will be auto-generated
// from the question IDs specified below
List<GenExpected> _expectedToGen = [
  GenExpected(
    "specAreasToConfigOnScreen-marketView-targetLevel",
    1,
    0,
  ),
  GenExpected(
    "specAreasToConfigOnScreen-leaderboardTraders-targetLevel",
    2,
    0,
  ),
  GenExpected(
    "specAreasToConfigOnScreen-leaderboardAssets-targetLevel",
    2,
    0,
  ),
  GenExpected(
    "specAreasToConfigOnScreen-portfolioPositions-targetLevel",
    2,
    0,
  ),
  GenExpected(
    "specAreasToConfigOnScreen-portfolioHistory-targetLevel",
    2,
    0,
  ),
  GenExpected(
    "specAreasToConfigOnScreen-marketResearch-targetLevel",
    2,
    0,
  ),
  GenExpected(
    "specSlotsToConfigInArea-marketView-filterBar-targetLevel",
    0,
    0,
  ),
  GenExpected(
    "specSlotsToConfigInArea-marketView-tableview-targetLevel",
    0,
    0,
  ),
  GenExpected(
    "specSlotsToConfigInArea-leaderboardTraders-header-targetLevel",
    1,
    0,
  ),
  GenExpected(
    "specSlotsToConfigInArea-leaderboardTraders-banner-targetLevel",
    1,
    0,
  ),
  GenExpected(
    "specSlotsToConfigInArea-leaderboardAssets-header-targetLevel",
    1,
    0,
  ),
  GenExpected(
    "specSlotsToConfigInArea-leaderboardAssets-banner-targetLevel",
    1,
    0,
  ),
  GenExpected(
    "specSlotsToConfigInArea-portfolioPositions-header-targetLevel",
    1,
    0,
  ),
  GenExpected(
    "specSlotsToConfigInArea-portfolioPositions-banner-targetLevel",
    1,
    0,
  ),
  GenExpected(
    "specSlotsToConfigInArea-portfolioPositions-tableview-targetLevel",
    0,
    0,
  ),
  GenExpected(
    "specSlotsToConfigInArea-portfolioHistory-header-targetLevel",
    1,
    0,
  ),
  GenExpected(
    "specSlotsToConfigInArea-portfolioHistory-banner-targetLevel",
    1,
    0,
  ),
  GenExpected(
    "specSlotsToConfigInArea-portfolioHistory-tableview-targetLevel",
    0,
    0,
  ),
  GenExpected(
    "specSlotsToConfigInArea-marketResearch-header-targetLevel",
    1,
    0,
  ),
  GenExpected(
    "specSlotsToConfigInArea-marketResearch-banner-targetLevel",
    1,
    0,
  ),
  GenExpected(
    "specRulesForSlotInArea-leaderboardAssets-banner-bannerUrl-targetLevel",
    1,
    0,
  ),
  GenExpected(
    "specRulesForSlotInArea-leaderboardAssets-banner-bannerUrl-ruleSelect",
    1,
    0,
  ),
  GenExpected(
    "specRulesForSlotInArea-portfolioHistory-banner-ruleSelect",
    1,
    0,
  ),
  GenExpected(
    "specRulesForSlotInArea-portfolioHistory-tableview-ruleSelect",
    1,
    0,
  ),
  GenExpected(
    "specRulesForSlotInArea-portfolioPositions-header-title-targetLevel",
    1,
    0,
  ),
  GenExpected(
    "specRulesForSlotInArea-portfolioPositions-header-title-ruleSelect",
    1,
    0,
  ),
  GenExpected(
    "specRulesForSlotInArea-portfolioPositions-header-subtitle-targetLevel",
    1,
    0,
  ),
  GenExpected(
    "specRulesForSlotInArea-portfolioPositions-header-subtitle-ruleSelect",
    1,
    0,
  ),
  GenExpected(
    "specRulesForSlotInArea-portfolioPositions-banner-bannerUrl-targetLevel",
    1,
    0,
  ),
  GenExpected(
    "specRulesForSlotInArea-portfolioPositions-banner-bannerUrl-ruleSelect",
    1,
    0,
  ),
  GenExpected(
    "specRulesForSlotInArea-portfolioHistory-header-title-targetLevel",
    1,
    0,
  ),
  GenExpected(
    "specRulesForSlotInArea-portfolioHistory-header-title-ruleSelect",
    1,
    0,
  ),
  GenExpected(
    "specRulesForSlotInArea-portfolioHistory-header-subtitle-targetLevel",
    1,
    0,
  ),
  GenExpected(
    "specRulesForSlotInArea-portfolioHistory-header-subtitle-ruleSelect",
    1,
    0,
  ),
  GenExpected(
    "specRulesForSlotInArea-marketResearch-header-ruleSelect",
    1,
    0,
  ),
  GenExpected(
    "specRulesForSlotInArea-portfolioHistory-banner-bannerUrl-targetLevel",
    1,
    0,
  ),
  GenExpected(
    "specRulesForSlotInArea-portfolioHistory-banner-bannerUrl-ruleSelect",
    1,
    0,
  ),
  GenExpected(
    "specRulesForSlotInArea-marketResearch-banner-ruleSelect",
    1,
    0,
  ),
  GenExpected(
    "specRulesForSlotInArea-marketResearch-header-title-targetLevel",
    1,
    0,
  ),
  GenExpected(
    "specRulesForSlotInArea-marketResearch-header-title-ruleSelect",
    1,
    0,
  ),
  GenExpected(
    "specRulesForSlotInArea-marketResearch-header-subtitle-targetLevel",
    1,
    0,
  ),
  GenExpected(
    "specRulesForSlotInArea-marketResearch-header-subtitle-ruleSelect",
    1,
    0,
  ),
  GenExpected(
    "specRulesForSlotInArea-marketResearch-banner-bannerUrl-targetLevel",
    1,
    0,
  ),
  GenExpected(
    "specRulesForSlotInArea-marketResearch-banner-bannerUrl-ruleSelect",
    1,
    0,
  ),
  GenExpected(
    "prepQuestForVisRule-marketView-filterBar-filterCfg-rulePrep",
    1,
    0,
  ),
  GenExpected(
    "prepQuestForVisRule-marketView-tableview-sortCfg-rulePrep",
    1,
    0,
  ),
  GenExpected(
    "prepQuestForVisRule-marketView-tableview-groupCfg-rulePrep",
    1,
    0,
  ),
  GenExpected(
    "prepQuestForVisRule-portfolioPositions-tableview-sortCfg-rulePrep",
    1,
    0,
  ),
  GenExpected(
    "prepQuestForVisRule-portfolioPositions-tableview-groupCfg-rulePrep",
    1,
    0,
  ),
  GenExpected(
    "prepQuestForVisRule-portfolioHistory-tableview-sortCfg-rulePrep",
    1,
    0,
  ),
  GenExpected(
    "prepQuestForVisRule-portfolioHistory-tableview-groupCfg-rulePrep",
    1,
    0,
  ),
];
