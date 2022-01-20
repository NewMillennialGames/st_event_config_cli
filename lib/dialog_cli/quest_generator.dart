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
        quest.appSection == AppSection.eventConfiguration) {
      dlogRunner.addQuestionsForAreasInSelectedSections(
        quest.response as UserResponse<List<AppSection>>,
      );
      //
    } else if (quest.addsAreaQuestions) {
      //
    } else if (quest.producesVisualRules && quest.visRuleTypeForComp != null) {
      dlogRunner.generateAssociatedUiRuleTypeQuestions(
        quest.qQuantify.uiCompInSection!,
        quest.response as UserResponse<List<VisualRuleType>>,
      );
      //
    } else if (quest.producesBehavioralRules &&
        quest.behRuleTypeForComp != null) {
      dlogRunner.generateAssociatedBehRuleTypeQuestions(
        quest.qQuantify.uiCompInSection!,
        quest.response as UserResponse<List<BehaviorRuleType>>,
      );
      //
    }
  }
}
