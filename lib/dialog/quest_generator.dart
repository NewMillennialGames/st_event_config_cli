part of ConfigDialogRunner;

class NewQuestionComposer {
  //

  void handleAcquiringNewQuestions(
    DialogRunner dlogRunner,
    Question quest,
  ) {
    // ruleQuestions don't currently generate new questions
    if (quest.isRuleQuestion || quest.generatesNoQuestions) return;

    if (quest.addsPerSectionQuestions &&
        quest.appSection == AppScreen.eventConfiguration) {
      dlogRunner.addQuestionsForAreasInSelectedSections(
        quest.response as UserResponse<List<AppScreen>>,
      );
      //
    } else if (quest.addsAreaQuestions) {
      //
    } else if (quest.producesVisualRules && quest.visRuleTypeForComp != null) {
      dlogRunner.generateAssociatedUiRuleTypeQuestions(
        quest.qQuantify.sectionWidgetArea!,
        quest.response as UserResponse<List<VisualRuleType>>,
      );
      //
    } else if (quest.producesBehavioralRules &&
        quest.behRuleTypeForComp != null) {
      dlogRunner.generateAssociatedBehRuleTypeQuestions(
        quest.qQuantify.sectionWidgetArea!,
        quest.response as UserResponse<List<BehaviorRuleType>>,
      );
      //
    }
  }
}
