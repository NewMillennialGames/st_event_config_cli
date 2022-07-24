import "dart:io";
import 'package:collection/collection.dart';
//
import '../interfaces/q_presenter.dart';
import '../questions/all.dart';
import '../dialog/all.dart';

class CliQuestionPresenter implements QuestionPresenterIfc {
  // formatter for command-line IO
  CliQuestionPresenter();

  @override
  void askAndWaitForUserResponse(
    DialogRunner dialoger,
    QuestBase quest,
  ) {
    QuestPromptInstance? promptInst = quest.getNextUserPromptIfExists();
    print(
      'beginning askAndWaitForUserResponse with ${promptInst?.userPrompt ?? '-na'}',
    );
    // int pInstIdx = -1;
    while (promptInst != null) {
      // pInstIdx++;
      print(
        'askAndWaitForUserResponse debug ${promptInst.shouldAutoAnswer} with ${promptInst.autoAnswerIfAppropriate}',
      );
      if (promptInst.shouldAutoAnswer &&
          (promptInst.autoAnswerIfAppropriate ?? "").isNotEmpty) {
        promptInst.collectResponse(promptInst.autoAnswerIfAppropriate!);
        print(
          'askAndWaitForUserResponse answered ${promptInst.userPrompt} with ${promptInst.autoAnswerIfAppropriate}',
        );
      } else {
        _askAndStoreAnswer(dialoger, quest, promptInst);
        // print(
        //   'cont askAndWaitForUserResponse with ${promptInst.userPrompt}',
        // );
      }
      promptInst = quest.getNextUserPromptIfExists();
    }
    // user answer might generate new questions
    if (!quest.isRuleDetailQuestion) {
      dialoger.generateNewQuestionsFromUserResponse(quest);
    }
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

    _printQPrompt(promptInst);
    _printPromptChoices(promptInst);
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
    // make the next command throw if response is invalid
    promptInst.collectResponse(userResp);
  }

  void _printQPrompt(QuestPromptInstance promptInst) {
    // show the Question
    print(promptInst.userPrompt + "(select from options below)");
  }

  void _printPromptChoices(QuestPromptInstance promptInst) {
    //
    if (!promptInst.hasChoices) return;

    // print('Select from these options:\n');
    // int defltIdx = promptInst.answChoiceCollection.idxOfDefaultAnsw;
    promptInst.answerOptions.forEach((ResponseAnswerOption opt) {
      // String forDflt = '';
      // promptInst.a == idx ? '  (default: just press return)' : '';
      print('\t${opt.selectVal}) ${opt.displayStr}');
    });
  }

  void _printInstructions(QuestBase quest, QuestPromptInstance promptInst) {
    //
    if (quest.isEventConfigScreenEntryPointQuest) {
      // user will enter string or comma delimited list of ints
    } else if (quest.isRegionTargetQuestion) {
      // causes Quest2s to be added or removed from future queue
      // user may enter int or comma delimited list of ints
    } else if (quest.isRuleSelectionQuestion) {
      //
    } else if (quest.isRulePrepQuestion) {
      // needs to produce visual formatting rules
      // user will select a widget display option
    } else if (quest.isRuleDetailQuestion) {
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
  void showErrorAndRePresentQuestion(String errTxt, String questHelpMsg) {
    //
  }

  @override
  void informUiThatDialogIsComplete() {}
}
