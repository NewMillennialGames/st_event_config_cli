part of InputModels;

/*  RuleResponseWrapper holds user answers to rule questions
  it needs to store answers to ALL
  of these possible types of questions:
    VisRuleQuestType:
      whichTable,
      whichField,
      whichLevelPos,
      isAscending,
      whichRowStyle,
      shouldShow,
*/



// abstract class RuleResponseWrapperIfc {
//   //
//   void castResponsesToAnswerTypes(Map<VisRuleQuestType, String> responses);
// }

// @JsonSerializable()
// class RuleResponseWrapper implements RuleResponseWrapperIfc {
//   //
//   // holds user answers to rule questions
//   final VisualRuleType ruleType;
//   final Map<VisRuleQuestType, String> userResponses = {};

//   RuleResponseWrapper(this.ruleType);

//   List<VisRuleQuestType> get requiredQuestions => ruleType.requiredQuestions;

//   void castResponsesToAnswerTypes(Map<VisRuleQuestType, String> responses) {
//     // this.userResponses[key] = val;
//     throw UnimplementedError();
//   }

//   // JsonSerializable
//   factory RuleResponseWrapper.fromJson(Map<String, dynamic> json) =>
//       _$RuleResponseWrapperFromJson(json);
//   Map<String, dynamic> toJson() => _$RuleResponseWrapperToJson(this);
// }
