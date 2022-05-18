import "dart:io";
import 'package:collection/collection.dart';
//
import '../interfaces/q_presenter.dart';
import '../questions/all.dart';
import '../dialog/all.dart';

class CliQuestionPresenter implements QuestionPresenter {
  // formatter for command-line IO
  CliQuestionPresenter();

  @override
  void askAndWaitForUserResponse(
    DialogRunner dialoger,
    QuestBase quest,
  ) {
    QuestPromptInstance? promptInst = quest.getNextUserPromptIfExists();
    while (promptInst != null) {
      _askAndStoreAnswer(dialoger, quest, promptInst);
      promptInst = quest.getNextUserPromptIfExists();
    }
    // user answer might generate new questions
    dialoger.handleQuestionCascade(quest);
  }

  void _askAndStoreAnswer(
    DialogRunner dialoger,
    QuestBase quest,
    QuestPromptInstance promptInst,
  ) {
    //
    //     String ruleQuestoverview =
    //     'Config ${promptInst} in the ${ruleQuest.screenWidgetArea?.name} of ${ruleQuest.appScreen.name} screen  (please answer each Quest2 below)';
    // print(ruleQuestoverview);

    _printQuestion(promptInst);
    _printOptions(promptInst);
    _printInstructions(quest, promptInst);

    bool validAnswerProvided = true;
    try {
      // bad user input or incomplete cast function can throw exception
      _getAnswerAndStoreIt(dialoger, quest, promptInst);
    } catch (e) {
      validAnswerProvided = false;
      // just rethrow until error handling is implemented
      rethrow;
      // throw UnimplementedError('quest.askAndWait has thrown $e');
      //  try asking again x times?
      // while (true) {
      //   quest.askAndWait(dialoger);
      // }
    } finally {
      // code that should always execute; irrespective of the exception
      if (!validAnswerProvided) {
        // config may be corrupt??
      }
    }
  }

  void _getAnswerAndStoreIt(
    DialogRunner dialoger,
    QuestBase quest,
    QuestPromptInstance promptInst,
  ) {
    //
    String userResp = stdin.readLineSync() ?? '';
    promptInst.collectResponse(userResp);
  }

  void _printQuestion(QuestPromptInstance promptInst) {
    // show the Quest2
    print(promptInst.userPrompt);
  }

  void _printOptions(QuestPromptInstance promptInst) {
    //
    if (!promptInst.hasChoices) return;

    print('Select from these options:\n');
    promptInst.choices.forEachIndexed((idx, opt) {
      String forDflt = '';
      // promptInst.a == idx ? '  (default: just press return)' : '';
      print('\t$idx) $opt $forDflt');
    });
  }

  void _printInstructions(QuestBase quest, QuestPromptInstance promptInst) {
    //
    if (quest.addsWhichAreaInSelectedScreenQuest2s) {
      // user will enter string or comma delimited list of ints
    } else if (quest.addsWhichRulesForSelectedAreaQuest2s) {
      // causes Quest2s to be added or removed from future queue
      // user may enter int or comma delimited list of ints
    } else if (quest.addsWhichRulesForSlotsInArea) {
      //
    } else if (quest.addsRuleDetailQuestsForSlotOrArea) {
      // needs to produce visual formatting rules
      // user will select a widget display option
    } else if (false) {
      // needs to produce behavioral rules
      // future;  not yet implemented
    }

    //
    if (promptInst.hasChoices) {
      if (promptInst.questsAndChoices.length > 1) {
        print('Enter row #s of choices (eg 0,1,2) then press enter/return!');
      } else {
        print('Enter row # of preferred choice, then press enter/return!');
      }
    } else {
      print('Type your answer, then press enter/return!');
    }
  }

  @override
  void informUiThatDialogIsComplete() {}
}
