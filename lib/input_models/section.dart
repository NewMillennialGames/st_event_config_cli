part of InputModels;

class DialogSectionCfg {
  /*
  manages top-level grouping of questions
  generally organized around a screen
  (but first instance is top level EventConfig)
  see hierarchy described in readme.MD

  */
  final AppScreen appScreen;
  // int _questionCount = 0;
  // int _processedQuestCount = 0;

  DialogSectionCfg(this.appScreen);

  int get order => appScreen.index;
  String get name => appScreen.name;

  // bool get wasProcessed => _processedQuestCount > 0;
  // set questionCount(int _questionCount) {
  //   this._questionCount = _questionCount;
  // }

  // bool askIfNeeded() {
  //   if (!appSection.isConfigureable) return false;

  //   print(appSection.includeStr + ' (enter y/yes or n/no)');
  //   var userResp = stdin.readLineSync() ?? 'Y';
  //   // print("askIfNeeded got: $userResp");
  //   return userResp.toUpperCase().startsWith('Y');
  // }
}
