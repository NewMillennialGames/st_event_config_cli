part of InputModels;

class UserResponse<AnsTyp> {
  // AnsTyp can be a value or list of values
  AnsTyp answers;
  UserResponse(this.answers);
  //
  bool get hasMultiple => answers is Iterable;
}
