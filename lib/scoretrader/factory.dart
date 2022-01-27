part of StUiController;

class RowStyleFactory {
  //
  final AppScreen screen;
  RowStyleFactory(this.screen);
}

class AbstractUiFactory {
  //
  EventCfgTree? _eConfig;
  //
  AbstractUiFactory();

  void setConfigForCurrentEvent(Map<String, dynamic> eCfgJsonMap) {
    this._eConfig = EventCfgTree.fromJson(eCfgJsonMap);
  }

  RowStyleFactory rowFactoryForScreen(AppScreen screen) =>
      RowStyleFactory(screen);
}
