part of EventCfgModels;

class DialogSectionCfg {
  //
  String name;

  DialogSectionCfg(this.name);

  bool askIfNeeded() {
    return true;
  }

  Question? getNextQuestion() {
    return null;
  }
}
