part of InputModels;

/*
  RuleResponseWrapper needs to store answers to ALL
  of these possible types of questions:

*/

@JsonSerializable()
class RuleResponseWrapper {
  // holds user answers to rule questions
  final Map<VisRuleQuestType, String> userResponses;

  RuleResponseWrapper(this.userResponses);

  factory RuleResponseWrapper.fromJson(Map<String, dynamic> json) =>
      _$RuleResponseWrapperFromJson(json);
  Map<String, dynamic> toJson() => _$RuleResponseWrapperToJson(this);
}
