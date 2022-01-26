part of EvCfgEnums;

//
const List<VisualRuleType> _unconfigurableFutureRules = [
  VisualRuleType.showOrHide,
];

@JsonEnum()
enum VisualRuleType {
  sortCfg,
  groupCfg,
  filterCfg,
  styleOrFormat,
  showOrHide,
}

extension VisualRuleTypeExt1 on VisualRuleType {
  //
  bool get isConfigurable => !_unconfigurableFutureRules.contains(this);

  String get friendlyName {
    //
    String nm = this.name;
    switch (this) {
      case VisualRuleType.sortCfg:
        return nm + ' (config row order)';
      case VisualRuleType.groupCfg:
        return nm + ' (config row grouping)';
      case VisualRuleType.filterCfg:
        return nm + ' (config filtering options)';
      case VisualRuleType.styleOrFormat:
        return nm + ' (set style or appearance)';
      case VisualRuleType.showOrHide:
        return nm + ' (hide or show)';
    }
  }
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
      case VisualRuleType.sortCfg:
        return [
          Vrq.selectFieldForSortOrGroup,
          Vrq.specifyPositionInGroup,
          Vrq.setSortOrder
        ];
      case VisualRuleType.groupCfg:
        return [
          Vrq.selectFieldForSortOrGroup,
          Vrq.specifyPositionInGroup,
          Vrq.setSortOrder
        ];
      case VisualRuleType.filterCfg:
        return [
          Vrq.getValueFromTableAndField,
          Vrq.specifyPositionInGroup,
        ];
      case VisualRuleType.styleOrFormat:
        return [
          Vrq.selectVisualComponentOrStyle,
        ];
      case VisualRuleType.showOrHide:
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
