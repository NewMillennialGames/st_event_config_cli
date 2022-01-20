part of OutputModels;

class SectionCfg {
  //
  AppScreen appSection;
  Map<ScreenWidgetArea, ComponentCfg> screenConfig;

  SectionCfg(this.appSection, this.screenConfig);
}
