// part of Quest2sLib;

// class BehaveRuleQuest2<ConvertTyp, AnsTyp extends RuleResponseBase>
//     extends Quest2<ConvertTyp, AnsTyp> {
//   /*
//     not implemented or tested ...
//     DO NOT use until fully built ...
//   */
//   late final VisRuleChoiceConfig _questDef;

//   BehaveRuleQuest2(
//     AppScreen appSection,
//     ScreenWidgetArea screenArea,
//     VisualRuleType visRuleType,
//     ScreenAreaWidgetSlot? slot,
//     // CastUserInputToTyp<ConvertTyp, AnsTyp>? castFunc,
//   ) : super(
//           QTargetQuantify.ruleDetailMultiResponse(
//             appSection,
//             screenArea,
//             visRuleType,
//             slot,
//             null,
//           ),
//           'niu--sub Quest2s will be used',
//           null,
//           null,
//         ) {
//     this._questDef = VisRuleChoiceConfig.fromRuleTyp(visRuleType);
//   }

//   VisRuleChoiceConfig get questDef => _questDef;
//   List<VisRuleQuestWithChoices> get questsAndChoices =>
//       _questDef.questsAndChoices;

//   void castResponseListAndStore(Map<VisRuleQuestType, String> multiAnswerMap) {
//     // store user answers
//     // this.response = UserResponse(RuleResponseWrapper(multiAnswerMap) as AnsTyp);
//   }
// }
