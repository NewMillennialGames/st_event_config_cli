part of Quest2sLib;

class UserResponse<AnsTyp> {
  /*  holds answers to normal (NON Rule-Based) Quest2s
  AnsTyp can be a value or list of values

  this class captures and retains user answers to every Quest2
  */
  late AnsTyp answers;
  UserResponse([AnsTyp? _answers]) {
    if (_answers != null) {
      this.answers = _answers;
    }
  }

  bool get hasMultiple => answers is Iterable;
  bool get isScalar => !hasMultiple;
}







// class UserRuleResponse<AnsTyp extends RuleResponseWrapperIfc>
//     extends UserResponse<AnsTyp> implements RuleResponseWrapperIfc {
//   // both this class and it's dynamic type BOTH implement RuleResponseWrapperIfc
//   // this class also inherits properties from UserResponse

//   final VisualRuleType ruleType;
//   final Map<VisRuleQuestType, String> userResponses = {};

//   // constructor
//   UserRuleResponse(this.ruleType);

//   // getters
//   List<VisRuleQuestType> get requiredQuest2s => ruleType.requiredQuest2s;

//   List<AppVisualRuleBase> asVisualRules() {
//     //
//     return [];
//   }

//   void castResponsesToAnswerTypes(Map<VisRuleQuestType, String> responses) {
//     //
//     this.answers.castResponsesToAnswerTypes(responses);
//   }
// }
