import 'package:st_ev_cfg/st_ev_cfg.dart';
import 'package:st_ev_cfg/interfaces/q_presenter.dart';

/* helper classes only
  no tests in here
*/

class TestQuestRespGen implements QuestionPresenter {
  // receives Quest2s for test-automation
  List<WhenQuestLike> Quest2Matchers;

  TestQuestRespGen(this.Quest2Matchers);

  List<WhenQuestLike> _lookForResponseGenerators(QuestBase quest) {
    //
    if (!(quest is Quest1Prompt)) {
      //
      print('Warn: called _lookForResponseGenerators with top-level Quest2');
      return [];
    }

    List<WhenQuestLike> lqm = [];
    for (WhenQuestLike qm in Quest2Matchers) {
      //
      if (qm.matches(quest)) {
        lqm.add(qm);
      }
    }
    return lqm;
  }

  String _buildUserResponse(
    QuestBase quest,
    List<WhenQuestLike> responseGenerators,
  ) {
    //
    assert(quest is QuestBase, 'bad argument');
    QuestBase vrq = quest as QuestBase;

    List<VisRuleQuestType> questTypes = [];
    //  vrq.questDef.visQuestTypes;

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
  void askAndWaitForUserResponse(
    DialogRunner dialoger,
    QuestBase quest,
  ) {
    //
    List<WhenQuestLike> responseGenerators = _lookForResponseGenerators(quest);
    if (responseGenerators.length < 1) {
      // none so send default
      // quest.convertAndStoreUserResponse('0');
      dialoger.advanceToNextQuestion();
      return;
    }

    String _fullResponse = _buildUserResponse(quest, responseGenerators);
    // quest.convertAndStoreUserResponse(_fullResponse);
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

  bool matches(Quest1Prompt quest) {
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
