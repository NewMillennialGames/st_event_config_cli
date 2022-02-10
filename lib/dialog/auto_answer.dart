part of ConfigDialogRunner;

/*
  AutoAnswer is responsible
  for looking at questJustAnswered
  and creating any implicit answers
  that we dont need to ask
*/

class AutoAnswer {
  //

  bool fillImpliedAnswers(
    QuestListMgr _questMgr,
  ) {
    Question questJustAnswered = _questMgr._currentOrLastQuestion;

    return false;
  }
}
