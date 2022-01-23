part of EvCfgEnums;

//
const List<VisualRuleType> _unconfigurableFutureRules = [
  VisualRuleType.show,
];

enum VisualRuleType {
  sort,
  group,
  filter,
  format,
  show,
}

extension VisualRuleTypeExt1 on VisualRuleType {
  //
  bool get isConfigurable => !_unconfigurableFutureRules.contains(this);
  //
  // String questionStr(
  //   AppScreen screen,
  //   ScreenWidgetArea screenArea,
  //   ScreenAreaWidgetSlot? slotInArea,
  // ) {
  //   bool isAreaScopedRule = slotInArea == null;
  //   final List<dynamic> valsDyn = [
  //     screen,
  //     screenArea,
  //     // valsDyn.length (of 2 or3) will inform depth of rule being created
  //     if (!isAreaScopedRule) slotInArea,
  //   ];

  //   switch (this) {
  //     case VisualRuleType.sort:
  //       return RuleTemplStr.sort.makeRuleQuestionStr(
  //         this,
  //         isAreaScopedRule,
  //         valsDyn,
  //       );
  //     case VisualRuleType.group:
  //       return RuleTemplStr.group.makeRuleQuestionStr(
  //         this,
  //         isAreaScopedRule,
  //         valsDyn,
  //       );
  //     case VisualRuleType.filter:
  //       return RuleTemplStr.filter.makeRuleQuestionStr(
  //         this,
  //         isAreaScopedRule,
  //         valsDyn,
  //       );
  //     case VisualRuleType.format:
  //       return RuleTemplStr.format.makeRuleQuestionStr(
  //         this,
  //         isAreaScopedRule,
  //         valsDyn,
  //       );
  //     case VisualRuleType.show:
  //       return RuleTemplStr.show.makeRuleQuestionStr(
  //         this,
  //         isAreaScopedRule,
  //         valsDyn,
  //       );
  //   }
  // }

  List<VisRuleQuestType> get questionsRequired {
    switch (this) {
      case VisualRuleType.sort:
        return [
          Vrq.selectFieldForSortOrGroup,
          Vrq.specifyPositionInGroup,
          Vrq.setSortOrder
        ];
      case VisualRuleType.group:
        return [
          Vrq.selectFieldForSortOrGroup,
          Vrq.specifyPositionInGroup,
          Vrq.setSortOrder
        ];
      case VisualRuleType.filter:
        return [
          Vrq.getValueFromTableAndField,
          Vrq.specifyPositionInGroup,
        ];
      case VisualRuleType.format:
        return [
          Vrq.selectVisualComponentOrStyle,
        ];
      case VisualRuleType.show:
        return [
          Vrq.controlsVisibilityOfAreaOrSlot,
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