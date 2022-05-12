part of Quest2sLib;

// class VisualNiuRuleQuest2<ConvertTyp, AnsTyp extends RuleResponseWrapperIfc>
//     extends Quest2 {
//   /*
//     Quest2 Quest2s are multi-part Quest2s
//     need to ask user:
//       depending on visRuleType, the Quest2s required are one of:
//         VisRuleQuestType enum

//     must collect enough data to render the full rule
//   */
//   late VisRuleChoiceConfig _questDef;

//   VisualNiuRuleQuest2(
//     AppScreen appSection,
//     ScreenWidgetArea screenArea,
//     VisualRuleType visRuleType,
//     ScreenAreaWidgetSlot? slot,
//     // CastUserInputToTyp<ConvertTyp, AnsTyp>? castFunc,
//   ) : super(
//           QTargetIntent.ruleDetailMultiResponse(
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
//     // derive Quest2/choices config
//     this._questDef = VisRuleChoiceConfig.fromRuleTyp(visRuleType);
//     // create empty response container
//     this.response = UserResponse(visRuleType.ruleResponseContainer as AnsTyp);
//   }

//   VisRuleChoiceConfig get questDef => _questDef;
//   List<VisRuleQuestWithChoices> get questsAndChoices =>
//       _questDef.questsAndChoices;

//   @override
//   String get questStr => _questDef.questStr;

//   // @override
//   // bool get gens2ndOr3rdSortGroupFilterQuests {
//   //   return this.response?.answers.gens2ndOr3rdSortGroupFilterQuests ?? false;
//   // }

//   RuleResponseWrapperIfc get asVisualRules {
//     // doing the hard work of converting answers
//     // into a structured data representation
//     // var vrs = response!.answers;
//     return response!.answers;
//   }

//   void castResponseListAndStore(Map<VisRuleQuestType, String> multiAnswerMap) {
//     // store user answers
//     (this.response?.answers as RuleResponseWrapperIfc)
//         .castResponsesToAnswerTypes(multiAnswerMap);
//   }

//   static Quest2 makeFromExisting(
//     Quest2 ques,
//     String newQuestStr,
//     PerQuestGenOptions genOpt,
//   ) {
//     //
//     QTargetIntent qq = ques.qQuantify.copyWith();
//     var vrq = Quest2(
//       ques.appScreen,
//       ques.screenWidgetArea!,
//       qq.visRuleTypeForAreaOrSlot!,
//       ques.slotInArea,
//     );
//     vrq._questDef = VisRuleChoiceConfig.fromGenOptions(genOpt);

//     return vrq;
//   }
// }
