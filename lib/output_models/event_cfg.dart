part of OutputModels;

/*
  this is the top level object
  to export as the complete
  Event configuration tree
*/

@JsonSerializable()
class EventCfgTree {
  //
  String evTemplateName;
  String evTemplateDescription;
  EvType evType;
  EvCompetitorType evCompetitorType;
  EvOpponentType evOpponentType;
  EvDuration evDuration;
  EvEliminationStrategy evEliminationType;
  // area and slot level data filled below in fillFromRuleAnswers
  Map<AppScreen, ScreenCfg> screenConfig = {};

  EventCfgTree._(
    this.evTemplateName,
    this.evTemplateDescription,
    this.evType, {
    this.evCompetitorType = EvCompetitorType.team,
    this.evOpponentType = EvOpponentType.sameAsCompetitorType,
    this.evDuration = EvDuration.oneGame,
    this.evEliminationType = EvEliminationStrategy.roundRobin,
  });

  factory EventCfgTree.fromEventLevelConfig(Iterable<Question> responses) {
    //
    String evTemplateName = '';
    String evTemplateDescription = '';
    EvType evType = EvType.standard;
    //
    EvCompetitorType? evCompetitorType;
    EvOpponentType? evOpponentType;
    EvDuration? evDuration;
    EvEliminationStrategy? evEliminationType;

    return EventCfgTree._(evTemplateName, evTemplateDescription, evType);
  }

  void fillFromRuleAnswers(Iterable<VisualRuleQuestion> answeredQuestions) {
    //
    for (VisualRuleQuestion rQuest in answeredQuestions) {
      switch (rQuest.visRuleTypeForAreaOrSlot) {
        case VisualRuleType.styleOrFormat:
          _createStyleOrFormatRule(rQuest);
      }
    }
  }

  void _createStyleOrFormatRule(VisualRuleQuestion rQuest) {}

  void dump(String? filename) {
    // write data out to file
    var fn = filename ?? evTemplateName;
    var outFile = File('$fn.json');

    // outFile.writeAsStringSync(this.toJson());
  }
}
