part of ConfigDialogRunner;

/*   not sure if this is needed
  QuestMatcher() may be all we need


  AutoAnswer is responsible
  for looking at questJustAnswered
  and creating any implicit answers
  that we dont need to ask

*/

class DerivedQuestions {
  //

  static List<Question> pendingQuestsFromAnswer(Question quest) {
    List<VisualRuleType> vrts = quest.qQuantify.relatedSubVisualRules(quest);
    return [];
  }

  static List<Question> impliedAnswersFromAnswer(Question quest) {
    return [];
  }
}
