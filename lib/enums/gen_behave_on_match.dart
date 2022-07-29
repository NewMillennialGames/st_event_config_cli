part of EvCfgEnums;

enum DerivedGenBehaviorOnMatchEnum {
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
