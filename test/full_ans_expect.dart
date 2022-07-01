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

class AnswAndExpected {
  //
  List<String> answersToPush;
  QuestMatcher nextQuestMatch;

  AnswAndExpected(
    this.answersToPush,
    QuestMatcher? _nextQuestMatch,
  ) : nextQuestMatch =
            _nextQuestMatch == null ? _startWhenMatches : _nextQuestMatch;
}

class FullRunState {
  //
  List<AnswAndExpected> answAndExpectedLst;
  QuestMatcher _triggerStartWhen;
  bool _hasStarted = false;
  int _curExpected = -1;

  FullRunState._(this.answAndExpectedLst, this._triggerStartWhen);

  factory FullRunState.fullTest() {
    return FullRunState._(_fullData, _startWhenMatches);
  }

  bool validateNextQuestion(QuestBase nextQueToAnsw) {
    return true;
  }
}

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

List<AnswAndExpected> _fullData = [];

//
// //
// import 'package:st_ev_cfg/st_ev_cfg.dart';
// import 'package:st_ev_cfg/interfaces/q_presenter.dart';
// import 'package:st_ev_cfg/util/all.dart';

// /* helper classes only
//   no tests in here

//   allows defining rules for auto-generated answers
//   to facilitate tesing parts of the system
//   that create new questions based on existing answers
// */

class FullFlowPresenter implements QuestionPresenterIfc {
  // receives Questions for test-automation
  StreamController<List<String>> sendAnswersController;
  late List<TestRespGenWhenQuestLike> matchersAndRespGen;

  FullFlowPresenter(this.sendAnswersController) {
    this.matchersAndRespGen = [];

    sendAnswersController.stream.listen(_passAnswerAndAdvanceQuestion);
  }

  void _passAnswerAndAdvanceQuestion(List<String> respLst) {
    //
  }

  List<TestRespGenWhenQuestLike> _lookForResponseGenerators(QuestBase quest) {
    //
    // if (!(quest is QuestVisualRule)) {
    //   //
    //   print('Warn: called _lookForResponseGenerators with non-rule Question');
    //   return [];
    // }

    List<TestRespGenWhenQuestLike> lqm = [];
    for (TestRespGenWhenQuestLike rg in matchersAndRespGen) {
      //
      if (rg.matcher.doesMatch(quest)) {
        lqm.add(rg);
      }
    }
    return lqm;
  }

  List<String> _buildUserResponse(
    QuestBase quest,
    QuestPromptInstance qpi,
    List<TestRespGenWhenQuestLike> responseGenerators,
  ) {
    //
    if (responseGenerators.length < 1) return [];

    VisRuleQuestType vqt = qpi.visQuestType;
    for (TestRespGenWhenQuestLike wql in responseGenerators) {
      List<String> gendTestAnswer = wql.answerFor(vqt);
      if (gendTestAnswer.isNotEmpty) {
        return gendTestAnswer;
      }
    }
    // remove any adjacent comma's
    // userAnswer = userAnswer.replaceAll(',,,', ',');
    // userAnswer = userAnswer.replaceAll(',,', ',');
    // userAnswer = userAnswer.replaceAll(',,', ',');
    return [];
  }

  @override
  void askAndWaitForUserResponse(
    DialogRunner dialoger,
    QuestBase quest,
  ) {
    //
    List<TestRespGenWhenQuestLike> responseGenerators =
        _lookForResponseGenerators(quest);
    if (responseGenerators.length < 1) {
      // none so send default
      // quest.convertAndStoreUserResponse('0');
      // dialoger.advanceToNextQuestionFromGui();
      print('no response generators found for ${quest.questId}; exiting!');
      dialoger.generateNewQuestionsFromUserResponse(quest);
      return;
    }

    QuestPromptInstance? promptInst = quest.getNextUserPromptIfExists();
    while (promptInst != null) {
      List<String> _fullResponse = _buildUserResponse(
        quest,
        promptInst,
        responseGenerators,
      );
      promptInst.collectResponse(
          (_fullResponse.isNotEmpty) ? _fullResponse.first : '');

      // now see if there is another prompt waiting to be answered
      promptInst = quest.getNextUserPromptIfExists();
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
  void informUiThatDialogIsComplete() {}
}

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

class TestRespGenWhenQuestLike {
  //
  QuestMatcher matcher;
  List<QTypeResponsePair> responsesByQType;

  TestRespGenWhenQuestLike(this.matcher, this.responsesByQType);

  List<String> answerFor(VisRuleQuestType qType) {
    // each prompt on a Question can have its own: VisRuleQuestType
    List<String> l = [];
    for (QTypeResponsePair respPair in responsesByQType) {
      if (respPair.matches(qType)) {
        l.add(respPair.response);
      }
    }
    return l;
  }
}

// class TestRespGenWhenQuestLike {
//   /*  Response to Generate when Question like:

//   defines a QuestBase pattern
//     and the auto-response answer that should be provided
//     by test (as user) in response to each prompt
//   */
//   AppScreen screen;
//   ScreenWidgetArea? area;
//   ScreenAreaWidgetSlot? slot;
//   VisualRuleType? ruleType;
//   List<QTypeResponsePair> responsesByQType;

//   TestRespGenWhenQuestLike(
//     this.screen,
//     this.area,
//     this.ruleType, {
//     this.slot,
//     this.responsesByQType = const [],
//   });

//   bool matches(QuestBase quest) {
//     /* return true if this response generator
//       is a match for the question being tested
//     */
//     bool isSame = quest.appScreen == screen;
//     if (!isSame) return false;
//     isSame = area == null || quest.screenWidgetArea == area;
//     isSame = isSame && slot == null || quest.slotInArea == slot;
//     isSame = isSame && ruleType == null ||
//         quest.qTargetResolution.visRuleTypeForAreaOrSlot == ruleType;
//     isSame = isSame && responsesByQType.length > 0;
//     // if (!isSame) return false;

//     // Set<String> aua = quest.allUserAnswers.toSet();
//     // Set<String> allMatchAnswers =
//     //     responsesByQType.map((e) => e.response).toSet();
//     // isSame = isSame && aua.intersection(allMatchAnswers).length > 0;
//     return isSame;
//   }

//   String? answerFor(VisRuleQuestType qType) {
//     // each prompt on a Question can have its own: VisRuleQuestType
//     for (QTypeResponsePair respPair in responsesByQType) {
//       if (respPair.matches(qType)) {
//         return respPair.response;
//       }
//     }
//     return null;
//   }
// }
