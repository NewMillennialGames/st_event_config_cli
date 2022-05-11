part of RandDee;

class CaptureAndCast<T> {
  /* _castFunc signature is:
      typedef CastStrToAnswTypCallback<T> = T Function(List<String>);

  */
  List<String> _answers = [];
  CastStrToAnswTypCallback<T> _castFunc;

  CaptureAndCast(this._castFunc);

  void capture(String s) {
    _answers.add(s);
  }

  T cast() {
    return _castFunc(_answers);
  }
}
