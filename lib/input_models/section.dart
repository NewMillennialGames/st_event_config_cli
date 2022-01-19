part of InputModels;

class DialogSectionCfg {
  //
  final AppSection appSection;
  // int _questionCount = 0;
  // int _processedQuestCount = 0;

  DialogSectionCfg(this.appSection);

  int get order => appSection.index;
  String get name => appSection.name;

  // bool get wasProcessed => _processedQuestCount > 0;
  // set questionCount(int _questionCount) {
  //   this._questionCount = _questionCount;
  // }

  bool askIfNeeded() {
    if (!appSection.isConfigureable) return false;

    print(appSection.includeStr + ' (enter y/yes or n/no)');
    var userResp = stdin.readLineSync() ?? 'Y';
    // print("askIfNeeded got: $userResp");
    return userResp.toUpperCase().startsWith('Y');
  }
}
