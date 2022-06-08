import 'package:st_ev_cfg/st_ev_cfg.dart';
import 'package:st_ev_cfg/interfaces/q_presenter.dart';
import 'package:st_ev_cfg/util/all.dart';

/* helper classes only
  no tests in here

  allows defining rules for auto-generated answers
  to facilitate tesing parts of the system
  that create new questions based on existing answers
*/

class TestDataCreation {
  //
  QuestBase makeQuestion<T>(
    QTargetIntent qq,
    String prompt,
    List<String> choices,
    CastStrToAnswTypCallback<T> clbk, {
    String questId = '',
  }) {
    //
    return QuestBase.dlogCascade(
      qq,
      prompt,
      choices,
      CaptureAndCast<T>(clbk),
      questId: questId,
    );
  }
}

class TestQuestRespGen implements QuestionPresenterIfc {
  // receives Questions for test-automation
  List<TestRespGenWhenQuestLike> questionMatchers;

  TestQuestRespGen(this.questionMatchers);

  List<TestRespGenWhenQuestLike> _lookForResponseGenerators(QuestBase quest) {
    //
    // if (!(quest is QuestVisualRule)) {
    //   //
    //   print('Warn: called _lookForResponseGenerators with non-rule Question');
    //   return [];
    // }

    List<TestRespGenWhenQuestLike> lqm = [];
    for (TestRespGenWhenQuestLike qm in questionMatchers) {
      //
      if (qm.matches(quest)) {
        lqm.add(qm);
      }
    }
    return lqm;
  }

  String? _buildUserResponse(
    QuestBase quest,
    QuestPromptInstance qpi,
    List<TestRespGenWhenQuestLike> responseGenerators,
  ) {
    //
    if (responseGenerators.length < 1) return null;

    VisRuleQuestType vqt = qpi.visQuestType;
    for (TestRespGenWhenQuestLike wql in responseGenerators) {
      String? gendTestAnswer = wql.answerFor(vqt);
      if (gendTestAnswer != null) {
        return gendTestAnswer;
      }
    }
    // remove any adjacent comma's
    // userAnswer = userAnswer.replaceAll(',,,', ',');
    // userAnswer = userAnswer.replaceAll(',,', ',');
    // userAnswer = userAnswer.replaceAll(',,', ',');
    return null;
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
      dialoger.handleQuestionCascade(quest);
      return;
    }

    QuestPromptInstance? promptInst = quest.getNextUserPromptIfExists();
    while (promptInst != null) {
      String? _fullResponse = _buildUserResponse(
        quest,
        promptInst,
        responseGenerators,
      );
      promptInst.collectResponse((_fullResponse != null) ? _fullResponse : '');

      // now see if there is another prompt waiting to be answered
      promptInst = quest.getNextUserPromptIfExists();
    }
    // all prompts answered;  ready to advance to next quest
    // now check if user answer will generate new questions
    dialoger.handleQuestionCascade(quest);
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
  /*  Response to Generate when Question like:

  defines a QuestBase pattern
    and the auto-response answer that should be provided
    by test (as user) in response to each prompt
  */
  AppScreen screen;
  ScreenWidgetArea? area;
  ScreenAreaWidgetSlot? slot;
  VisualRuleType? ruleType;
  List<QTypeResponsePair> responsesByQType;

  TestRespGenWhenQuestLike(
    this.screen,
    this.area,
    this.ruleType, {
    this.slot,
    this.responsesByQType = const [],
  });

  bool matches(QuestBase quest) {
    /* return true if this response generator
      is a match for the question being tested
    */
    bool isSame = quest.appScreen == screen;
    if (!isSame) return false;
    isSame = area == null || quest.screenWidgetArea == area;
    isSame = isSame && slot == null || quest.slotInArea == slot;
    isSame = isSame && ruleType == null ||
        quest.qTargetIntent.visRuleTypeForAreaOrSlot == ruleType;
    isSame = isSame && responsesByQType.length > 0;
    // if (!isSame) return false;

    // Set<String> aua = quest.allUserAnswers.toSet();
    // Set<String> allMatchAnswers =
    //     responsesByQType.map((e) => e.response).toSet();
    // isSame = isSame && aua.intersection(allMatchAnswers).length > 0;
    return isSame;
  }

  String? answerFor(VisRuleQuestType qType) {
    // each prompt on a Question can have its own: VisRuleQuestType
    for (QTypeResponsePair respPair in responsesByQType) {
      if (respPair.matches(qType)) {
        return respPair.response;
      }
    }
    return null;
  }
}
