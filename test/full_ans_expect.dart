import 'dart:async';
// import 'package:test/test.dart';
//
import 'package:st_ev_cfg/st_ev_cfg.dart';
import 'package:st_ev_cfg/interfaces/q_presenter.dart';
//
import 'package:st_ev_cfg/config/all.dart';
import 'package:st_ev_cfg/st_ev_cfg.dart';
import 'package:st_ev_cfg/util/all.dart';
import 'shared_utils.dart';

/* full-dialog-test helper classes only -- no tests in here

  contains a QuestionPresenterIfc called FullFlowTestPresenter
    QuestionPresenterIfc is interface used by DialogRunner to
    serve questions and get answers from an arbitrary presentation layer
      (CLI, web, test, etc)

  logical operation of FullFlowTestPresenter (fftp) is:
    receive each question pushed to fftp.askAndWaitForUserResponse()
    check to see if question matches a known pattern
    if yes, the known pattern should be associated with a response-generator
    use resp-gen to pass answer(s) to that question
    then tell dialog runner that question has been answered
    so it can advance and push next question

    at some point, we'll move past Event-Level config quests (they don't cascade)
    and reach the one about which app-screens we want to customize
    that should start a more complex process of verifying that the NEXT
    question we receive after sending an answer is the one we expect

    all expected questions must arrive in order, or the test will fail

  classes:
*/

class QTypeResponsePair {
  /*
    leave qType null to make it always match
  */
  VisRuleQuestType? qType;
  String response;

  QTypeResponsePair(
    this.qType,
    this.response,
  );

  bool matches(VisRuleQuestType qt) => qt == qType || qType == null;
}

class MatchResponsewGenVerifyNextQuest {
  //
  List<QTypeResponsePair> ansToPushInOrder;
  QuestMatcher qMatchForReponses;
  QuestMatcher? qMatchVerifyNextGendQuest;

  MatchResponsewGenVerifyNextQuest(
    this.ansToPushInOrder,
    this.qMatchForReponses,
    this.qMatchVerifyNextGendQuest,
  );

  List<String>? questResponsesIfMatches(QuestBase qb) {
    // gets all string answers when question matches qMatchForReponses
    if (!qMatchForReponses.doesMatch(qb)) return null;

    List<String> qAnswers = [];
    List<VisRuleQuestType> rqtsInPromptOrder = qb.embeddedQuestTypes;
    // List<VisRuleQuestType> rqts =
    //     qb.visRuleTypeForAreaOrSlot?.requRuleDetailCfgQuests ?? [];

    rqtsInPromptOrder.forEach((rqt) {
      Iterable<String> l = ansToPushInOrder.where((rp) => rp.matches(rqt)).map(
            (e) => e.response,
          );
      qAnswers.addAll(l);
    });
    if (qAnswers.isEmpty) return null;

    return qAnswers;
  }
}

class MatchAnswerVerifyWrapper {
  //
  int _curExpected = -1;
  List<MatchResponsewGenVerifyNextQuest> answAndExpectedLst;

  MatchAnswerVerifyWrapper(this.answAndExpectedLst);

  MatchResponsewGenVerifyNextQuest getNextOrLast() {
    if (_curExpected < answAndExpectedLst.length - 1) {
      _curExpected++;
    }
    return answAndExpectedLst[_curExpected];
  }

  List<String> getResponses(QuestBase qb) {
    return [];
  }

  // int get curExpected => _curExpected;
  MatchResponsewGenVerifyNextQuest get _curMrgv =>
      answAndExpectedLst[_curExpected];

  QuestMatcher get qMatchForReponses => _curMrgv.qMatchForReponses;
  QuestMatcher? get qMatchVerifyNextGendQuest =>
      _curMrgv.qMatchVerifyNextGendQuest;

  // List<TestRespGenWhenQuestLike> _lookForResponseGenerators(QuestBase quest) {
  //   //
  //   List<MatchResponsewGenVerifyNextQuest> lqm = [];
  //   for (MatchResponsewGenVerifyNextQuest rg in answAndExpectedLst) {
  //     //
  //     // if (rg.matcher.doesMatch(quest)) {
  //     //   lqm.add(rg);
  //     // }
  //   }
  //   return [];
  // }
}

class FullRunState {
  //
  MatchAnswerVerifyWrapper _matchAnswWrap;
  // _triggerStartWhen should match the "which app screens to cfg question"
  QuestMatcher _triggerStartWhen;

  bool _hasStarted = false;

  FullRunState._(List<MatchResponsewGenVerifyNextQuest> answAndExpectedLst,
      this._triggerStartWhen)
      : _matchAnswWrap = MatchAnswerVerifyWrapper(answAndExpectedLst);

  factory FullRunState.fullTest() {
    return FullRunState._(_fullData, _startWhenMatches);
  }

  bool validateNextQuestion(QuestBase nextQueToAnsw) {
    if (!_hasStarted || qMatchVerifyNextGendQuest == null) return true;

    return true;
  }

  QuestMatcher? get qMatchVerifyNextGendQuest =>
      _matchAnswWrap.qMatchVerifyNextGendQuest;

  List<String> getResponses(QuestBase qb) => _matchAnswWrap.getResponses(qb);
}
//

class FullFlowTestPresenter implements QuestionPresenterIfc {
  // receives Questions for test-automation
  StreamController<List<String>> sendAnswersController;
  QuestListMgr _questMgr;
  FullRunState runState = FullRunState.fullTest();

  FullFlowTestPresenter(
    this.sendAnswersController,
    this._questMgr,
  ) {
    sendAnswersController.stream
        .asBroadcastStream()
        .listen(_passAnswerAndAdvanceQuestion);
  }

  void _passAnswerAndAdvanceQuestion(List<String> respLst) {
    //
    _questMgr.currentOrLastQuestion.setAllAnswersWhileTesting(respLst);
  }

  @override
  void askAndWaitForUserResponse(
    DialogRunner dialoger,
    QuestBase quest,
  ) {
    //
    List<String> cannedAnswers = runState.getResponses(quest);
    if (cannedAnswers.length < 1) {
      // none so send default
      // quest.convertAndStoreUserResponse('0');
      // dialoger.advanceToNextQuestionFromGui();
      print('no response generators found for ${quest.questId}; exiting!');
      dialoger.generateNewQuestionsFromUserResponse(quest);
      return;
    }

    quest.setAllAnswersWhileTesting(cannedAnswers);
    // all prompts answered;  ready to advance to next quest
    // now check if user answer will generate new questions
    dialoger.generateNewQuestionsFromUserResponse(quest);
    // cli test;  not gui
    // dialoger.advanceToNextQuestionFromGui();
  }

  void showErrorAndRePresentQuestion(String errTxt, String questHelpMsg) {
    //
  }

  @override
  void informUiThatDialogIsComplete() {
    // _questMgr.
  }
}

// static vals for normal test case

QuestMatcher _startWhenMatches = QuestMatcher(
  'match on question about which screens to configure',
  derivedQuestGen: DerivedQuestGenerator.noopTest(),
  appScreen: AppScreen.eventConfiguration,
  questIdPatternMatchTest: (id) =>
      id.startsWith(QuestionIdStrings.selectAppScreens),
  validateUserAnswerAfterPatternMatchIsTrueCallback: (qb) {
    return qb.mainAnswer is List<AppScreen> &&
        (qb.mainAnswer as List<AppScreen>).length == 2;
  },
);

List<MatchResponsewGenVerifyNextQuest> _fullData = [];



  // List<String> _buildUserResponse(
  //   QuestBase quest,
  //   QuestPromptInstance qpi,
  //   List<TestRespGenWhenQuestLike> responseGenerators,
  // ) {
  //   //
  //   if (responseGenerators.length < 1) return [];

  //   VisRuleQuestType vqt = qpi.visQuestType;
  //   for (TestRespGenWhenQuestLike wql in responseGenerators) {
  //     List<String> gendTestAnswer = wql.answerFor(vqt);
  //     if (gendTestAnswer.isNotEmpty) {
  //       return gendTestAnswer;
  //     }
  //   }
  //   // remove any adjacent comma's
  //   // userAnswer = userAnswer.replaceAll(',,,', ',');
  //   // userAnswer = userAnswer.replaceAll(',,', ',');
  //   // userAnswer = userAnswer.replaceAll(',,', ',');
  //   return [];
  // }