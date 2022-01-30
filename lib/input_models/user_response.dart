part of InputModels;

abstract class RuleResponseWrapperIfc {
  //
  void castResponsesToAnswerTypes(Map<VisRuleQuestType, String> responses);
}

class UserResponse<AnsTyp> {
  /*
  AnsTyp can be a value or list of values

  this class captures and retains user answers to every question
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

class UserRuleResponse<AnsTyp extends RuleResponseWrapperIfc>
    extends UserResponse<AnsTyp> implements RuleResponseWrapperIfc {
  // both this class and it's dynamic type BOTH implement RuleResponseWrapperIfc
  // this class also inherits properties from UserResponse

  final VisualRuleType ruleType;
  final Map<VisRuleQuestType, String> userResponses = {};

  // constructor
  UserRuleResponse(this.ruleType);

  // getters
  List<VisRuleQuestType> get requiredQuestions => ruleType.requiredQuestions;

  void castResponsesToAnswerTypes(Map<VisRuleQuestType, String> responses) {
    //
    this.answers.castResponsesToAnswerTypes(responses);
  }
}
