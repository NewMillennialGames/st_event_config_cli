part of QuestionsLib;

class CaptureAndCast<T> {
  /* _castFunc signature is:
      typedef CastStrToAnswTypCallback<T> = T Function(List<String>);

    IMPORTANT note!!!
      each question prompt (QuestPromptInstance) only receives
      one user-response, provided as a string

  */
  CastStrToAnswTypCallback<T> _castFunc;
  String _answers = '';
  // List<String> _answers = [];

  CaptureAndCast(this._castFunc);

  void captureUserRespStr(String s) {
    _answers = s;
  }

  T cast(QuestBase qb) {
    return _castFunc(qb, _answers);
  }

  // getters  (use == not "is")
  bool get asksWhichScreensToConfig =>
      (T == Iterable<AppScreen>) || T == List<AppScreen>;
  bool get asksWhichAreasOfScreenToConfig =>
      (T == Iterable<ScreenWidgetArea>) || T == List<ScreenWidgetArea>;
  bool get asksWhichSlotsOfAreaToConfig =>
      (T == Iterable<ScreenAreaWidgetSlot>) || T == List<ScreenAreaWidgetSlot>;
}
