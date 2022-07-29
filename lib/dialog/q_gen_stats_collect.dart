part of ConfigDialogRunner;

/*
  the GenStatsCollector is mostly to assist in testing
  and system validation
  it is used from QCascadeDispatcher to record
  how many derived questions are created
  from each answered question

  we can then compare expected to actual
  to validate that configurator is working
  as expected

  based on how many questions existed before and after
  each generation pass
*/

typedef QuestId = String;

enum QGenChngType { unanswered, answered }

class StatChange {
  //
  final QGenChngType changeType;
  int start = 0;
  int end = 0;

  // expected & actual are fields for testing
  int expected = -1;

  StatChange({this.changeType = QGenChngType.unanswered});

  int get generatedQuestionCount => end - start;
  // for testing
  int get actual => end;

  // void update(StatChange sc) {
  //   // NIU
  //   assert(sc.changeType == this.changeType, 'update from wrong type');
  //   assert(
  //     sc.start == 0 || sc.start == this.start,
  //     'update should be empty or match',
  //   );
  //   end += sc.end;
  // }
}

class PerQStats {
  /* each answered question is only processed
  on time so generally no need to handle multiple passes
  in this object

  pending == unanswered
  completed == answered
  */

  final QuestId qid;
  final StatChange unanswered = StatChange();
  final StatChange answered = StatChange(changeType: QGenChngType.answered);

  PerQStats(this.qid);

  int get unansweredQsAdded => unanswered.generatedQuestionCount;
  int get answeredQsAdded => answered.generatedQuestionCount;

  void setStartCounts(int unans, int ans) {
    //
    unanswered.start = unans;
    answered.start = ans;
  }

  void setEndCounts(
    int unans,
    int ans, {
    bool testMode = false,
  }) {
    //
    unanswered.end = unans;
    answered.end = ans;

    if (testMode) {
      print(
        '$qid\t$unansweredQsAdded\t$answeredQsAdded   \t\t\t(from setEndCounts())',
      );
    }
  }
}

class GenPrediction {
  /* how many questions we anticipate being
    generated off of answers to a prior question
    */
  final int unanswered;
  final int answered;

  GenPrediction(this.unanswered, [this.answered = 0]);
}

class GenStatsCollector {
  /*
    activeQuestId will be null
    EXCEPT WHEN we are between
    startCounting() and collectPostGenTotals() cycles

  */
  QuestId? activeQuestId;
  final Map<QuestId, PerQStats> _genStats = {};
  final Map<QuestId, GenPrediction> _predictedGenCount = {};

  GenStatsCollector();

  void setExpectedGenPrediction(QuestId qid, int unanswered, int answered) {
    // called by PermTestAnswerFactory to log details
    // for comparison to ACTUAL generated counts
    _predictedGenCount[qid] = GenPrediction(unanswered, answered);
  }

  void startCounting(
    QuestListMgr questListMgr,
    QuestBase questJustAnswered,
  ) {
    // begin tracking stats for current question
    activeQuestId = questJustAnswered.questId;
    PerQStats qStats = _genStats[activeQuestId] ?? PerQStats(activeQuestId!);

    int unansweredQuestions = questListMgr.pendingQuestionCount;
    int answeredQuestions = questListMgr.totalAnsweredQuestions;

    qStats.setStartCounts(unansweredQuestions, answeredQuestions);

    _genStats[activeQuestId!] = qStats;
  }

  void collectPostGenTotals(
    QuestListMgr questListMgr,
    QuestBase questJustAnswered, {
    bool printSummary = false,
  }) {
    /*  stop accumulating stats for current question
          pending == unanswered
          completed == answered
     */
    PerQStats qStats = _genStats[activeQuestId]!;
    qStats.setEndCounts(
      questListMgr.pendingQuestionCount,
      questListMgr.totalAnsweredQuestions,
    );

    if (printSummary) {
      print('Q-Id:\t$activeQuestId');
      print('\tPrompt:\t${questJustAnswered.firstPrompt.userPrompt}');
      int choiceCount = questJustAnswered.countChoicesInFirstPrompt;
      print(
        '\t$choiceCount Choices:\t${questJustAnswered.firstPrompt.answerOptions}',
      );
      int ansCount = questJustAnswered.mainAnswer is Iterable
          ? (questJustAnswered.mainAnswer as Iterable).length
          : 1;
      print('\t$ansCount Answers:\t${questJustAnswered.mainAnswer}');
      print('\tGenerated:\t${qStats.unansweredQsAdded}');

      int expectedGenCount = ansCount;
      /*
        targetting questions at AREA level often generate:
          1 quest about which rules, and
          1 quest about which slots
        so expectedGenCount estimate is not always accurate
        double it
      */
      if (questJustAnswered.isRegionTargetQuestion &&
          questJustAnswered.slotInArea == null) {
        // expectedGenCount *= 2;
      }
      if (expectedGenCount != qStats.unansweredQsAdded) {
        print('\tPossible Err: should have generated $expectedGenCount');
      }
    }

    activeQuestId = null;
  }

  PerQStats statsFor(QuestId qid) {
    return _genStats[qid] ?? PerQStats(qid);
  }

  List<PerQStats> getTestComparisonValues() {
    /* compare actual to expected
    to validate test results
    */

    List<PerQStats> compareVals = [];

    for (MapEntry<QuestId, GenPrediction> entry in _predictedGenCount.entries) {
      GenPrediction expectToGen = entry.value;
      QuestId qid = entry.key;
      PerQStats actualStats = _genStats[qid] ?? PerQStats(qid);
      // copy expected values to inst
      actualStats.unanswered.expected = expectToGen.unanswered;
      actualStats.answered.expected = expectToGen.answered;
      compareVals.add(actualStats);
    }
    return compareVals;
  }
}
