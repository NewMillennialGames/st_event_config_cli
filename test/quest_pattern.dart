import 'package:st_ev_cfg/st_ev_cfg.dart';
import 'package:st_ev_cfg/interfaces/q_presenter.dart';

class TestQuestRespGen implements QuestionPresenter {
  // receives questions for test-automation
  List<WhenQuestLike> questionMatchers;

  TestQuestRespGen(this.questionMatchers);

  List<WhenQuestLike> _lookForResponseGenerators(Question quest) {
    //
    if (!(quest is VisualRuleQuestion)) {
      //
      print('Warn: called _lookForResponseGenerators with top-level question');
      return [];
    }

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
    Question quest,
    List<WhenQuestLike> responseGenerators,
  ) {
    //
    assert(quest is VisualRuleQuestion, 'bad argument');
    VisualRuleQuestion vrq = quest as VisualRuleQuestion;

    List<VisRuleQuestType> questTypes = vrq.questDef.visQuestTypes;

    String userAnswer = '';
    for (WhenQuestLike wql in responseGenerators) {
      for (VisRuleQuestType qt in questTypes) {
        var s = wql.answerFor(qt);
        if (s.isNotEmpty) {
          userAnswer += s + ',';
        }
      }
    }
    // remove any adjacent comma's
    // userAnswer = userAnswer.replaceAll(',,,', ',');
    // userAnswer = userAnswer.replaceAll(',,', ',');
    // userAnswer = userAnswer.replaceAll(',,', ',');
    return userAnswer;
  }

  @override
  void askAndWaitForUserResponse(DialogRunner dialoger, Question quest) {
    //
    List<WhenQuestLike> responseGenerators = _lookForResponseGenerators(quest);
    if (responseGenerators.length < 1) {
      // none so send default
      quest.convertAndStoreUserResponse('0');
      dialoger.advanceToNextQuestion();
      return;
    }

    String _fullResponse = _buildUserResponse(quest, responseGenerators);
    quest.convertAndStoreUserResponse(_fullResponse);
    dialoger.advanceToNextQuestion();
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
  /* defines a question pattern
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

  bool matches(Question quest) {
    bool isSame = quest.appScreen == screen;
    if (!isSame) return false;
    isSame = area == null || quest.screenWidgetArea == area;
    isSame = isSame && slot == null || quest.slotInArea == slot;
    isSame = isSame && ruleType == null ||
        quest.qQuantify.visRuleTypeForAreaOrSlot == ruleType;
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
