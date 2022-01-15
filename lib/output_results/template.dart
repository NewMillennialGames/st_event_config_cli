part of EvTemplateOutput;

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
