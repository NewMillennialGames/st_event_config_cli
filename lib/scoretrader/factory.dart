part of StUiController;

class RowStyleFactory {
  //
  final AppScreen screen;
  final EventCfgTree _eConfig;
  RowStyleFactory(this.screen, this._eConfig);

  Widget rowForAsset(List<RowPropertyInterface> competitors) {
    //
    switch (_eConfig.tableFormatRule(screen)) {
    }
    return Widget();
  }
}

class AbstractUiFactory {
  //
  EventCfgTree? _eConfig;
  //
  AbstractUiFactory();

  void setConfigForCurrentEvent(Map<String, dynamic> eCfgJsonMap) {
    /*
      send api payload (upon event switching) here
      to reconfigure the factory
    */
    this._eConfig = EventCfgTree.fromJson(eCfgJsonMap);
  }

  RowStyleFactory rowFactoryForScreen(AppScreen screen) =>
      RowStyleFactory(screen, _eConfig!);
}
