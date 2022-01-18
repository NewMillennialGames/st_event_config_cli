part of EventCfgEnums;

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
    UiComponent uiComp,
  ) {
    return 'Select field name for ${this.name} rule in the ${uiComp.name} area of ${section.name}';
  }

  List<String> choiceOptions(
    AppSection section,
    UiComponent uiComp,
  ) {
    /*

    */
    switch (this) {
      case VisualRuleType.sort:
        return [];
      case VisualRuleType.group:
        return [];
      case VisualRuleType.filter:
        return [];
      case VisualRuleType.format:
        return [];
      case VisualRuleType.show:
        return [];
    }
    // return [];
  }

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
}

enum BehaviorRuleType {
  navigate,
}

extension BehaviorRuleTypeExt1 on BehaviorRuleType {
  //

}
