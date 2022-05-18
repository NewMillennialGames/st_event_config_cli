import 'package:st_ev_cfg/st_ev_cfg.dart';
import 'package:st_ev_cfg/interfaces/q_presenter.dart';

/* helper classes only
  no tests in here
*/

class TestQuestRespGen implements QuestionPresenter {
  // receives Questions for test-automation
  List<WhenQuestLike> questionMatchers;

  TestQuestRespGen(this.questionMatchers);

  List<WhenQuestLike> _lookForResponseGenerators(QuestBase quest) {
    //
    // if (!(quest is QuestVisualRule)) {
    //   //
    //   print('Warn: called _lookForResponseGenerators with non-rule Question');
    //   return [];
    // }

    List<WhenQuestLike> lqm = [];
    for (WhenQuestLike qm in questionMatchers) {
      //
      if (qm.matches(quest)) {
        lqm.add(qm);
      }
    }
    return lqm;
  }

  String _buildUserResponse(
    QuestBase quest,
    QuestPromptInstance qpi,
    List<WhenQuestLike> responseGenerators,
  ) {
    //
    String userAnswer = '';
    VisRuleQuestType vqt = qpi.visQuestType;
    for (WhenQuestLike wql in responseGenerators) {
      String gendTestAnswer = wql.answerFor(vqt);
      if (gendTestAnswer.isNotEmpty) {
        userAnswer = gendTestAnswer;
        break;
      }
    }
    // remove any adjacent comma's
    // userAnswer = userAnswer.replaceAll(',,,', ',');
    // userAnswer = userAnswer.replaceAll(',,', ',');
    // userAnswer = userAnswer.replaceAll(',,', ',');
    return userAnswer;
  }

  @override
  void askAndWaitForUserResponse(
    DialogRunner dialoger,
    QuestBase quest,
  ) {
    //
    List<WhenQuestLike> responseGenerators = _lookForResponseGenerators(quest);
    if (responseGenerators.length < 1) {
      // none so send default
      // quest.convertAndStoreUserResponse('0');
      dialoger.advanceToNextQuestionFromGui();
      return;
    }

    QuestPromptInstance? promptInst = quest.getNextUserPromptIfExists();
    while (promptInst != null) {
      String _fullResponse = _buildUserResponse(
        quest,
        promptInst,
        responseGenerators,
      );
      promptInst.collectResponse(_fullResponse);
      promptInst = quest.getNextUserPromptIfExists();
    }
    // all prompts answered;  ready to advance to next quest
    // now check if user answer will generate new questions
    dialoger.handleQuestionCascade(quest);
    // cli test;  not gui
    // dialoger.advanceToNextQuestionFromGui();
  }

  @override
  void informUiThatDialogIsComplete() {}
}

class QuestAnswerPair {
  //
  VisRuleQuestType qType;
  String answer;

  QuestAnswerPair(
    this.qType,
    this.answer,
  );

  bool matches(VisRuleQuestType qt) => qt == qType;
}

class WhenQuestLike {
  /* defines a QuestBase pattern
    and the answer that should be provided
    by auto-test (as user) in response
  */
  AppScreen screen;
  ScreenWidgetArea? area;
  ScreenAreaWidgetSlot? slot;
  VisualRuleType? ruleType;
  List<QuestAnswerPair> questTypes;

  WhenQuestLike(
    this.screen,
    this.area,
    this.slot, [
    this.questTypes = const [],
  ]);

  bool matches(QuestBase quest) {
    bool isSame = quest.appScreen == screen;
    if (!isSame) return false;
    isSame = area == null || quest.screenWidgetArea == area;
    isSame = isSame && slot == null || quest.slotInArea == slot;
    isSame = isSame && ruleType == null ||
        quest.qTargetIntent.visRuleTypeForAreaOrSlot == ruleType;
    isSame = isSame && questTypes.length > 0;
    return isSame;
  }

  String answerFor(VisRuleQuestType qType) {
    for (QuestAnswerPair pair in questTypes) {
      if (pair.matches(qType)) {
        return pair.answer;
      }
    }
    return '';
  }
}
