part of OutputModels;

class SectionCfg {
  //
  AppSection appSection;
  Map<SectionUiArea, ComponentCfg> screenConfig;

  SectionCfg(this.appSection, this.screenConfig);
}
