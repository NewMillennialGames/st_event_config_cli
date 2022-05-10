part of RandDee;

/*
  for questions that contain multi-answers
  AnswType is the top (wrapped) version of those multi-answers
*/

class QFactory {
  /*
  steps to building a question
    create response accumulator (RA)
    create list of prompt and choices (P&C)
    RA + P&C can be constructed as part of QDefCollection


  now specify intent and target of the question

  now specify cascade effects from the question

  */
  late QIntentCfg intent;
  late QDefCollection iterDef;
  late QTargetQuantify targetArea;
  late List<QuestPromptInstance> promptIters;

  QFactory startGroupWithIntent<AnswType>(
    QIntentWrapper intentWrapper,
    QTargetLevel level,
  ) {
    intent = QIntentCfg(intentWrapper, level);
    return this;
  }

  QFactory setPrompts(QDefCollection _iterDef) {
    iterDef = _iterDef;
    return this;
  }

  QFactory setTargetArea() {
    return this;
  }

  QFactory setResponseHandling<AnswType>() {
    return this;
  }

  Quest2 getAssembledQuestion() {
    return Quest2(intent, targetArea, iterDef);
  }
}

// void exampleFactory() {
//   //
//   var f = QFactory();
//   f.startGroupWithIntent();
//   _createTopLevelQuestions(f);

//   f.setTargetScreen();
// }

// void _createTopLevelQuestions(QFactory f) {
//   //
// }

// void _createTopLevelQuestions(QFactory f) {
//   //
// }