part of RandDee;

class QTypeWrapper<RespOutTyp> {
  /*
    describes the type of question encoded under:
    SingleQuestIteration
    and RespOutTyp tells you the kind of answer expected
  */
  final bool topLevelQuest;
  final VisRuleQuestType? visRuleQuestType;
  // final BehRuleQuestType? behRuleQuestType;

  QTypeWrapper({
    this.topLevelQuest = true,
    this.visRuleQuestType = null,
  });

  String get ruleName => topLevelQuest
      ? VisRuleQuestType.dialogStruct.name
      : (visRuleQuestType != null
          ? visRuleQuestType!.name
          : 'behRuleQuestTypeName');
}
