part of QuestionsLib;

class CaptureAndCast<T> {
  /* _castFunc signature is:
      typedef CastStrToAnswTypCallback<T> = T Function(QuestBase, String);

    IMPORTANT note!!!
      each question prompt (QuestPromptInstance) only receives
      one user-response, provided as a string

  */
  CastStrToAnswTypCallback<T> _castFunc;
  String _answers = '';

  CaptureAndCast(this._castFunc);

  void captureUserRespStr(String s) {
    _answers = s;
  }

  T cast(QuestBase questFromWhichAnswersOriginated) {
    var ans = _castFunc(questFromWhichAnswersOriginated, _answers);
    // if (castTypeIsList) return ans as List<dynamic>;
    // ConfigLogger.log(Level.FINER,'castAnswer castTypeIsList:  $castTypeIsList');
    return ans;
  }

  // getters  (use == not "is")

  String get answer => _answers;
  bool get hasAnswer => !_answers.isEmpty;
  bool get asksWhichScreensToConfig =>
      (T == Iterable<AppScreen>) || T == List<AppScreen>;
  bool get asksWhichAreasOfScreenToConfig =>
      (T == Iterable<ScreenWidgetArea>) || T == List<ScreenWidgetArea>;
  bool get asksWhichSlotsOfAreaToConfig =>
      (T == Iterable<ScreenAreaWidgetSlot>) || T == List<ScreenAreaWidgetSlot>;
  bool get castTypeIsList =>
      asksWhichScreensToConfig ||
      asksWhichAreasOfScreenToConfig ||
      asksWhichSlotsOfAreaToConfig;
}


  // int derivedQuestionsToProduce(QuestBase qb) {
  //   // not finished
  //   bool hasMulti = (T is Iterable);
  //   if (qb is RegionTargetQuest) {
  //     /*  */
  //     // if (hasMulti) {}
  //   } else if (qb is RuleSelectQuest) {
  //     /*  */

  //   } else if (qb is RulePrepQuest) {
  //     /*  */
  //   }
  //   return 0;
  // }