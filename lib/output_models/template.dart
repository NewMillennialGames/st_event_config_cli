part of OutputModels;

class EventCfgTemplate {
  //
  String templateName;
  String templateDescription;
  Map<AppScreen, SectionCfg> screenConfig;

  EventCfgTemplate(
    this.templateName,
    this.templateDescription,
    this.screenConfig,
  );
}
