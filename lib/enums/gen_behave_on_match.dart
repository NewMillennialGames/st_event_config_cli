part of EvCfgEnums;

enum DerivedGenBehaviorOnMatchEnum {
  /*  describes how the ANSWERS to a Question
    will impact the future config-tree
    an answer might generate:
      1. new empty questions
      2. questions with implicit answers
      3.  both 1 & 2 above
      4.  no generation from answer
  */
  addPendingQuestions,
  addImplicitAnswers,
  addQuestsAndAnswers, // aka BOTH
  noop,
}

extension MatcherBehaviorEnumExt1 on DerivedGenBehaviorOnMatchEnum {
  //
  bool get addsPendingQuestions => [
        DerivedGenBehaviorOnMatchEnum.addPendingQuestions,
        DerivedGenBehaviorOnMatchEnum.addQuestsAndAnswers
      ].contains(this);

  bool get createsImplicitAnswers => [
        DerivedGenBehaviorOnMatchEnum.addImplicitAnswers,
        DerivedGenBehaviorOnMatchEnum.addQuestsAndAnswers
      ].contains(this);
}
