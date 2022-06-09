part of ConfigDialogRunner;

class QuestionCascadeDispatcher {
  // handles logic for creating new questions
  late final QMatchCollection _qMatchColl;

  QuestionCascadeDispatcher(QMatchCollection? qMatchColl)
      : _qMatchColl =
            qMatchColl != null ? qMatchColl : QMatchCollection.scoretrader() {}

  void appendNewQuestsOrInsertImplicitAnswers(
    QuestListMgr questListMgr,
    QuestBase questJustAnswered,
  ) {}

  void handleNewCascade(
    QuestListMgr questListMgr,
    QuestBase questJustAnswered,
  ) {}
}
