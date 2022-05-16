part of RandDee;

class CaptureAndCast<T> {
  /* _castFunc signature is:
      typedef CastStrToAnswTypCallback<T> = T Function(List<String>);

    IMPORTANT note!!!
      each question prompt (QuestPromptInstance) only receives
      one user-response, provided as a string
      
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

  // getters
  bool get asksWhichScreensToConfig => T is List<AppScreen>;
  bool get asksWhichAreasOfScreenToConfig => T is List<ScreenWidgetArea>;
  bool get asksWhichSlotsOfAreaToConfig => T is List<ScreenAreaWidgetSlot>;
}
