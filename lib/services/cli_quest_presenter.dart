import "dart:io";
import 'package:collection/collection.dart';
import 'package:eventconfig/interfaces/question_presenter.dart';
//
import '../input_models/all.dart';
import '../dialog/all.dart';
import '../app_entity_enums/all.dart';
import '../enums/all.dart';

class CliQuestionPresenter implements QuestionPresenter {
  // formatter for command-line IO
  CliQuestionPresenter();

  @override
  bool askSectionQuestionAndWaitForUserResponse(
    DialogRunner dialoger,
    DialogSectionCfg sectionCfg,
  ) {
    AppScreen screen = sectionCfg.appScreen;
    if (screen == AppScreen.eventConfiguration) return true;

    if (!screen.isConfigureable) return false;

    print(screen.includeStr + ' (enter y/yes or n/no)');
    var userResp = stdin.readLineSync() ?? 'Y';
    // print("askIfNeeded got: $userResp");
    return userResp.toUpperCase().startsWith('Y');
  }

  @override
  void askAndWaitForUserResponse(
    DialogRunner dialoger,
    Question quest,
  ) {
    if (quest.isRuleQuestion) {
      // rule questions are more complex and handled by
      // looping for multiple answers

      if (quest is VisualRuleQuestion) {
        Map<VisRuleQuestType, String> multiAnswerRespList =
            _handleVisualRuleQuestions(
          dialoger,
          quest,
        );
        quest.castResponseListAndStore(multiAnswerRespList);
      }
      // else if (quest is BehaviorRuleQuestion) {
      //   // else do behavioral question
      // }
      // store response payload on the question

      return;
    }

    // normal question to figure out which rule questions to actually ask user
    _printQuestion(quest);
    _printOptions(quest);
    _printInstructions(quest);
    // now capture user answer

    bool validAnswerProvided = true;
    try {
      // bad user input or incomplete cast function can throw exception
      _getResponseThenCastAndStoreIt(dialoger, quest);
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

  void _getResponseThenCastAndStoreIt(
    DialogRunner dlogRunner,
    Question quest,
  ) {
    //
    quest.configSelfIfNecessary(dlogRunner.getPriorAnswersList);

    String userResp = stdin.readLineSync() ?? '';
    // print("You entered: '$userResp'");
    quest.convertAndStoreUserResponse(userResp);
    // print("You entered: '$userResp' and ${derivedUserResponse.toString()}");
  }

  Map<VisRuleQuestType, String> _handleVisualRuleQuestions(
    DialogRunner dialoger,
    VisualRuleQuestion ruleQuest,
  ) {
    //
    String ruleQuestoverview =
        'Config ${ruleQuest.questDef.ruleTyp.name} in the ${ruleQuest.screenWidgetArea?.name} of app-section ${ruleQuest.appScreen.name}  (please answer each question below)';
    print(ruleQuestoverview);

    Map<VisRuleQuestType, String> accumResponses = {};

    for (VisRuleQuestWithChoices questWithChoices
        in ruleQuest.questsAndChoices) {
      //
      String answer = _showOptionsAndWaitForResponse(questWithChoices) ?? '';
      accumResponses[questWithChoices.ruleQuestType] = answer;
    }
    return accumResponses;
  }

  String? _showOptionsAndWaitForResponse(VisRuleQuestWithChoices rulePart) {
    //
    print(rulePart.ruleQuestType.name);
    print('\n');
    rulePart.ruleQuestChoices.forEachIndexed((idx, opt) {
      print('\t$idx) $opt ');
    });

    String? userResp;
    // todo -- add validation here
    bool inputIsInvalid = true;
    while (inputIsInvalid) {
      userResp = stdin.readLineSync();
      inputIsInvalid = userResp == null || userResp.isEmpty;
      if (inputIsInvalid) print('invalid answer; pls try again');
    }
    return userResp;
  }

  void _printQuestion(Question quest) {
    // show the question
    print(quest.question);
  }

  void _printOptions(Question quest) {
    //
    if (!quest.hasChoices) return;

    print('Select from these options:\n');
    quest.answerChoicesList?.forEachIndexed((idx, opt) {
      String forDflt =
          quest.defaultAnswerIdx == idx ? '  (default: just press return)' : '';
      print('\t$idx) $opt $forDflt');
    });
  }

  void _printInstructions(Question quest) {
    //
    if (quest.addsWhichAreaInEachScreenQuestions) {
      // user will enter string or comma delimited list of ints
    } else if (quest.addsWhichSlotsOfSelectedAreaQuestions) {
      // causes questions to be added or removed from future queue
      // user may enter int or comma delimited list of ints
    } else if (quest.addsVisualRuleQuestions) {
      // needs to produce visual formatting rules
      // user will select a widget display option
    } else if (quest.addsBehavioralRuleQuestions) {
      // needs to produce behavioral rules
      // future;  not yet implemented
    }

    //
    if (quest.hasChoices) {
      if (quest.acceptsMultiResponses) {
        print('Enter row #s of choices (eg 2,3,5) then press enter/return!');
      } else {
        print('Enter row # of preferred choice, then press enter/return!');
      }
    } else {
      print('Type your answer, then press enter/return!');
    }
  }
}
