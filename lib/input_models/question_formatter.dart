part of InputModels;

class FlutterQuestionFormatter {
  // TODO:  future
  // to render widget views of the question
  // move this class to the parent flutter project
}

class CliQuestionFormatter {
  // formatter for command-line IO
  CliQuestionFormatter();

  bool askSectionQuestionAndWaitForUserResponse(
    DialogRunner dialoger,
    DialogSectionCfg sectionCfg,
  ) {
    if (sectionCfg.appSection == AppSection.eventConfiguration) return true;

    return sectionCfg.askIfNeeded();
  }

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
      quest.askAndWait(dialoger);
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

  Map<VisRuleQuestType, String> _handleVisualRuleQuestions(
    DialogRunner dialoger,
    VisualRuleQuestion ruleQuest,
  ) {
    //
    String ruleQuestoverview =
        'Config ${ruleQuest.questDef.ruleTyp.name} in the ${ruleQuest.uiComponent?.name} of app-section ${ruleQuest.appSection.name}  (please answer each question below)';
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
    if (quest.addsPerSectionQuestions) {
      // user will enter string or comma delimited list of ints
    } else if (quest.addsAreaQuestions) {
      // causes questions to be added or removed from future queue
      // user may enter int or comma delimited list of ints
    } else if (quest.producesVisualRules) {
      // needs to produce visual formatting rules
      // user will select a widget display option
    } else if (quest.producesBehavioralRules) {
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
