part of InputModels;

class UserResponse<AnsTyp> {
  /*
  AnsTyp can be a value or list of values

  this class captures and retains user answers to every question
  */
  AnsTyp answers;
  UserResponse(this.answers);
  //
  bool get hasMultiple => answers is Iterable;
  bool get isScalar => !hasMultiple;
}
