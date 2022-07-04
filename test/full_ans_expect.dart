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
  // ansToPushInOrder == list of answers to send to matching question
  List<QTypeResponsePair> ansToPushInOrder;
  // qMatchForReponses == match for ansToPushInOrder
  QuestMatcher qMatchForReponses;
  // qMatchVerifyNextGendQuest == verify structure of
  // next derived (from qMatchForReponses) question
  QuestMatcher? qMatchVerifyNextGendQuest;

  MatchResponsewGenVerifyNextQuest(
    this.ansToPushInOrder,
    this.qMatchForReponses,
    this.qMatchVerifyNextGendQuest,
  );

  bool doesMatch(QuestBase qb) => qMatchForReponses.doesMatch(qb);

  // getters
  List<String> get answers => ansToPushInOrder.map((e) => e.response).toList();

  // List<String>? questResponsesIfMatches(QuestBase qb) {
  //   // gets all string answers when question matches qMatchForReponses
  //   if (!qMatchForReponses.doesMatch(qb)) return null;

  //   List<String> qAnswers = [];
  //   List<VisRuleQuestType> rqtsInPromptOrder = qb.embeddedQuestTypes;

  //   rqtsInPromptOrder.forEach((VisRuleQuestType rqt) {
  //     Iterable<String> l =
  //         ansToPushInOrder.where((QTypeResponsePair rp) => rp.matches(rqt)).map(
  //               (e) => e.response,
  //             );
  //     qAnswers.addAll(l);
  //   });
  //   if (qAnswers.isEmpty) return null;

  //   return qAnswers;
  // }
}

class MatchAnswerVerifyWrapper {
  //
  int _curExpected = -1;
  int _questIdxOfScreenQuest = -1;
  List<MatchResponsewGenVerifyNextQuest> answAndExpectedLst;

  MatchAnswerVerifyWrapper(this.answAndExpectedLst);

  MatchResponsewGenVerifyNextQuest getNextOrLast() {
    if (_curExpected < answAndExpectedLst.length - 1) {
      _bumpIdx();
    }
    return answAndExpectedLst[_curExpected];
  }

  MatchResponsewGenVerifyNextQuest responderFor(QuestBase qb) {
    //
    _bumpIdx();
    Iterable<MatchResponsewGenVerifyNextQuest> lstGv =
        answAndExpectedLst.where((gv) => gv.doesMatch(qb));
    if (lstGv.length < 1) {
      print('Warn: no matcher found');
      return answAndExpectedLst[_curExpected];
    } else if (lstGv.length > 1) {
      print('Warn: multi matchers found');
    }
    return lstGv.first;
  }

  void _bumpIdx() {
    _curExpected++;
  }

  void hasStarted() {
    // just encountered the app-screens question
    _questIdxOfScreenQuest = _curExpected;
  }

  // int get curExpected => _curExpected;
  MatchResponsewGenVerifyNextQuest get _curMrgv =>
      answAndExpectedLst[_curExpected];

  QuestMatcher get qMatchForReponses => _curMrgv.qMatchForReponses;
  QuestMatcher? get qMatchVerifyNextGendQuest =>
      _curMrgv.qMatchVerifyNextGendQuest;

  //       List<String> getResponses(QuestBase qb) {
  //   //
  //   MatchResponsewGenVerifyNextQuest gv = responderFor(qb);
  //   return gv.ansToPushInOrder.map((e) => e.response).toList();

  //   // List<MatchResponsewGenVerifyNextQuest> lstGv =
  //   //     answAndExpectedLst.where((gv) => gv.doesMatch(qb)).toList();
  //   // return lstGv.fold<List<String>>(
  //   //   [],
  //   //   (List<String> lstStr, MatchResponsewGenVerifyNextQuest gv) =>
  //   //       lstStr +
  //   //       gv.ansToPushInOrder.map((QTypeResponsePair e) => e.response).toList(),
  //   // );
  // }

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
  /* tracks state of the test

  */
  MatchAnswerVerifyWrapper _matchAnswWrap;
  // _triggerStartWhen should match the "which app screens to cfg question"
  QuestMatcher _triggerStartWhen;

  bool _hasStarted = false;

  FullRunState._(
    List<MatchResponsewGenVerifyNextQuest> answAndExpectedLst,
    this._triggerStartWhen,
  ) : _matchAnswWrap = MatchAnswerVerifyWrapper(answAndExpectedLst);

  factory FullRunState.fullTest() {
    return FullRunState._(_fullData, _startWhenMatches);
  }

  bool processNextQuestion(QuestBase nextQueToAnsw) {
    // return true of answer set
    if (!_hasStarted) {
      if (_triggerStartWhen.doesMatch(nextQueToAnsw)) {
        _hasStarted = true;
        _matchAnswWrap.hasStarted();
      }
    }

    MatchResponsewGenVerifyNextQuest matchingResponder =
        _matchAnswWrap.responderFor(nextQueToAnsw);

    nextQueToAnsw.setAllAnswersWhileTesting(matchingResponder.answers);
    return matchingResponder.answers.isNotEmpty;
  }

  // QuestMatcher? get qMatchVerifyNextGendQuest =>
  //     _matchAnswWrap.qMatchVerifyNextGendQuest;

  // List<String> getResponses(QuestBase qb) => _matchAnswWrap.getResponses(qb);
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
    bool didSendAnswer = runState.processNextQuestion(quest);
    if (didSendAnswer) {
      // none so send default
      // quest.convertAndStoreUserResponse('0');
      // dialoger.advanceToNextQuestionFromGui();
      print('no (or empty) response generator found for ${quest.questId}');
    }
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
    // var las = (qb.mainAnswer as List<AppScreen>);
    return qb.mainAnswer is List<AppScreen> &&
        (qb.mainAnswer as List<AppScreen>).length == 2;
  },
);

List<MatchResponsewGenVerifyNextQuest> _fullData = [
  MatchResponsewGenVerifyNextQuest(
    [],
    QuestMatcher(
      'match on question about which screens to configure',
      derivedQuestGen: DerivedQuestGenerator.noopTest(),
      appScreen: AppScreen.marketView,
      questIdPatternMatchTest: (id) =>
          id.startsWith(QuestionIdStrings.selectAppScreens),
      validateUserAnswerAfterPatternMatchIsTrueCallback: (qb) {
        // var las = (qb.mainAnswer as List<AppScreen>);
        return qb.mainAnswer is List<ScreenWidgetArea> &&
            (qb.mainAnswer as List<ScreenWidgetArea>).length == 2;
      },
    ),
    null,
  ),
];

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
