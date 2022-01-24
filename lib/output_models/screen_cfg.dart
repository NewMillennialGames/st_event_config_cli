part of OutputModels;

class ScreenCfg {
  //
  AppScreen appSection;
  Map<ScreenWidgetArea, ScreenAreaCfg> screenConfig;

  ScreenCfg(this.appSection, this.screenConfig);
}
