import "dart:io";
import 'package:collection/collection.dart';
//
import '../interfaces/q_presenter.dart';
import '../questions/all.dart';
import '../dialog/all.dart';
import '../enums/all.dart';

class CliQuest2Presenter implements Quest2Presenter {
  // formatter for command-line IO
  CliQuest2Presenter();

  // @override
  // bool askSectionQuest2AndWaitForUserResponse(
  //   DialogRunner dialoger,
  //   DialogSectionCfg sectionCfg,
  // ) {
  //   // no longer needed
  //   return true;
  //   AppScreen screen = sectionCfg.appScreen;
  //   if (screen == AppScreen.eventConfiguration) return true;

  //   if (!screen.isConfigurable) return false;

  //   print(screen.includeStr + ' (enter y/yes or n/no)');
  //   var userResp = stdin.readLineSync() ?? 'Y';
  //   // print("askIfNeeded got: $userResp");
  //   return userResp.toUpperCase().startsWith('Y');
  // }

  @override
  void askAndWaitForUserResponse(
    DialogRunner dialoger,
    Quest2 quest,
  ) {
    // rule Quest2s are more complex and handled by
    // looping for multiple answers
    if (quest is Quest2) {
      Map<VisRuleQuestType, String> multiAnswerRespList = _handleQuest2s(
        dialoger,
        quest,
      );
      // store response payload on the Quest2
      quest.castResponseListAndStore(multiAnswerRespList);
      return;
    }
    // else if (quest is BehaviorRuleQuest2) {
    //   // else do behavioral Quest2
    // return;
    // }

    // normal Quest2 to figure out which rule Quest2s to actually ask user
    _printQuest2(quest);
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
    Quest2 quest,
  ) {
    //
    // quest.configSelfIfNecessary(dlogRunner.getPriorAnswersList);

    String userResp = stdin.readLineSync() ?? '';
    // print("You entered: '$userResp'");
    quest.convertAndStoreUserResponse(userResp);
    // print("You entered: '$userResp' and ${derivedUserResponse.toString()}");
  }

  Map<VisRuleQuestType, String> _handleQuest2s(
    DialogRunner dialoger,
    Quest2 ruleQuest,
  ) {
    //
    String ruleQuestoverview =
        'Config ${ruleQuest.questDef.ruleTyp.name} in the ${ruleQuest.screenWidgetArea?.name} of ${ruleQuest.appScreen.name} screen  (please answer each Quest2 below)';
    print(ruleQuestoverview);

    Map<VisRuleQuestType, String> accumResponses = {};

    for (VisRuleQuestWithChoices questWithChoices
        in ruleQuest.questsAndChoices) {
      //
      String answer =
          _showOptionsAndWaitForResponse(ruleQuest, questWithChoices) ?? '';
      accumResponses[questWithChoices.ruleQuestType] = answer;
    }
    return accumResponses;
  }

  String? _showOptionsAndWaitForResponse(
    Quest2 rQuest,
    VisRuleQuestWithChoices rQuestAndChoices,
  ) {
    //
    String questForuser = rQuestAndChoices.createFormattedQuest2(rQuest);
    print(questForuser);
    print('\n');
    rQuestAndChoices.choices.forEachIndexed((idx, opt) {
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
    print('' * 4); // create space after answer
    return userResp;
  }

  void _printQuest2(Quest2 quest) {
    // show the Quest2
    print(quest.questStr);
  }

  void _printOptions(Quest2 quest) {
    //
    if (!quest.hasChoices) return;

    print('Select from these options:\n');
    quest.answerChoicesList?.forEachIndexed((idx, opt) {
      String forDflt =
          quest.defaultAnswerIdx == idx ? '  (default: just press return)' : '';
      print('\t$idx) $opt $forDflt');
    });
  }

  void _printInstructions(Quest2 quest) {
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
    if (quest.hasChoices) {
      if (quest.acceptsMultiResponses) {
        print('Enter row #s of choices (eg 0,1,2) then press enter/return!');
      } else {
        print('Enter row # of preferred choice, then press enter/return!');
      }
    } else {
      print('Type your answer, then press enter/return!');
    }
  }

  void informUiThatDialogIsComplete() {}
}
