part of RandDee;

/*
  for Quest2s that contain multi-answers
  AnswType is the top (wrapped) version of those multi-answers
*/

class QFactory {
  /*
  steps to building a Quest2
    create response accumulator (RA)
    create list of prompt and choices (P&C)
    RA + P&C can be constructed as part of QDefCollection


  now specify intent and target of the Quest2

  now specify cascade effects from the Quest2

  */
  // late QIntentCfg intent;
  late QDefCollection iterDef;
  late QTargetIntent targetArea;
  late List<QuestPromptInstance> promptIters;

  QFactory startGroupWithTarget<AnswType>(
    QTargetIntent _targetArea,
  ) {
    targetArea = _targetArea;
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

  Quest1Response getAssembledQuest2() {
    return Quest1Response(targetArea, iterDef);
  }
}

// void exampleFactory() {
//   //
//   var f = QFactory();
//   f.startGroupWithIntent();
//   _createTopLevelQuest2s(f);

//   f.setTargetScreen();
// }

// void _createTopLevelQuest2s(QFactory f) {
//   //
// }

// void _createTopLevelQuest2s(QFactory f) {
//   //
// }