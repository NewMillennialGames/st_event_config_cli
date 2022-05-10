part of RandDee;

class CaptureAndCast<T> {
  //
  List<String> _answers = [];
  CastStrToAnswTypCallback<T> castFunc;

  CaptureAndCast(this.castFunc);

  void capture(String s) {
    _answers.add(s);
  }

  T cast() {
    return castFunc(_answers);
  }
}
