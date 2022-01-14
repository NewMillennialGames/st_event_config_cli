part of EventOutput;

class SectionCfg {
  //
  AppSection appSection;
  Map<SectionComponent, ComponentCfg> screenConfig;

  SectionCfg(this.appSection, this.screenConfig);
}
