part of EventOutput;

class SectionCfg {
  //
  AppSection appSection;
  Map<UiComponent, ComponentCfg> screenConfig;

  SectionCfg(this.appSection, this.screenConfig);
}
