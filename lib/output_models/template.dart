part of CfgOutputModels;

class EventCfgTemplate {
  //
  String templateName;
  String templateDescription;
  Map<AppSection, SectionCfg> screenConfig;

  EventCfgTemplate(
    this.templateName,
    this.templateDescription,
    this.screenConfig,
  );
}
