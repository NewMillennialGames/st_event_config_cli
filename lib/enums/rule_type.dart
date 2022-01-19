part of EvCfgEnums;

//

enum VisualRuleType {
  sort,
  group,
  filter,
  format,
  show,
}

extension VisualRuleTypeExt1 on VisualRuleType {
  //
  String questionStr(
    AppSection section,
    SectionUiArea uiComp,
  ) {
    return 'Select field name for ${this.name} rule in the ${uiComp.name} area of ${section.name}';
  }

  List<VisRuleQuestType> get questionsRequired {
    switch (this) {
      case VisualRuleType.sort:
        return [
          Vrq.whichTable,
          Vrq.whichField,
          Vrq.whichLevelPos,
          Vrq.isAscending
        ];
      case VisualRuleType.group:
        return [
          Vrq.whichTable,
          Vrq.whichField,
          Vrq.whichLevelPos,
          Vrq.isAscending
        ];
      case VisualRuleType.filter:
        return [
          Vrq.whichTable,
          Vrq.whichField,
          Vrq.whichLevelPos,
        ];
      case VisualRuleType.format:
        return [
          Vrq.whichTable,
          Vrq.whichRowStyle,
        ];
      case VisualRuleType.show:
        return [
          Vrq.shouldShow,
        ];
    }
  }
}

enum BehaviorRuleType {
  navigate,
}

extension BehaviorRuleTypeExt1 on BehaviorRuleType {
  //

}






// List<String> choiceOptions(
  //   AppSection section,
  //   SectionUiArea uiComp,
  // ) {
  //   /*

  //   */
  //   switch (this) {
  //     case VisualRuleType.sort:
  //       return [];
  //     case VisualRuleType.group:
  //       return [];
  //     case VisualRuleType.filter:
  //       return [];
  //     case VisualRuleType.format:
  //       return [];
  //     case VisualRuleType.show:
  //       return [];
  //   }
  //   // return [];
  // }

  // AppConfigRule castInputToRule(String userInput) {
  //   switch (this) {
  //     case VisualRuleType.sort:
  //       return AppConfigRule.sort();
  //     case VisualRuleType.group:
  //       return AppConfigRule.group();
  //     case VisualRuleType.filter:
  //       return AppConfigRule.filter();
  //     case VisualRuleType.format:
  //       return AppConfigRule.format();
  //     case VisualRuleType.show:
  //       return AppConfigRule.show();
  //   }
  // }