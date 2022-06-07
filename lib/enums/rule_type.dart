part of EvCfgEnums;

//
const List<VisualRuleType> _unconfigurableFutureRules = [
  VisualRuleType.showOrHide,
];

@JsonEnum()
enum VisualRuleType {
  topDialogStruct, // not a real rule at all.  Quest2 at higher level
  sortCfg, // global or within groups
  groupCfg, // how to group rows
  filterCfg, // to create filter menus
  styleOrFormat, // select rowStyle for ListView
  showOrHide, // control visibility
  themePreference,
}

extension VisualRuleTypeExt1 on VisualRuleType {
  //

  bool get hasVariableSubRuleCount => [
        // these rules can configure 0-3 slots
        VisualRuleType.sortCfg,
        VisualRuleType.groupCfg,
        VisualRuleType.filterCfg
      ].contains(this);

  RuleResponseBase get ruleResponseContainer {
    // return special types to contain answers
    // instance of the class that parses user response
    switch (this) {
      case VisualRuleType.topDialogStruct:
        return TvSortCfg();
      case VisualRuleType.sortCfg:
        return TvSortCfg();
      case VisualRuleType.groupCfg:
        return TvGroupCfg();
      case VisualRuleType.filterCfg:
        return TvFilterCfg();
      case VisualRuleType.styleOrFormat:
        return TvRowStyleCfg();
      case VisualRuleType.showOrHide:
        return ShowHideCfg();
      case VisualRuleType.themePreference:
        return ShowHideCfg();
    }
  }

  bool get isConfigurable => !_unconfigurableFutureRules.contains(this);

  String get friendlyName {
    //
    String nm = this.name;
    switch (this) {
      case VisualRuleType.topDialogStruct:
        return nm + ' (configs cfg dialog)';
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
      case VisualRuleType.themePreference:
        return nm + ' (themePreference)';
    }
  }
  //

  List<VisRuleQuestType> get requConfigQuests {
    // its helpful that only one config type is returned
    // DerivedQuestGenerator could have problems if this changes
    switch (this) {
      case VisualRuleType.topDialogStruct:
        return [];
      case VisualRuleType.sortCfg:
        return [
          Vrq.askCountOfSlotsToConfigure,
        ];
      case VisualRuleType.groupCfg:
        return [
          Vrq.askCountOfSlotsToConfigure,
          // Vrq.selectDataFieldName,
          // Vrq.specifySortAscending
        ];
      case VisualRuleType.filterCfg:
        return [
          Vrq.selectDataFieldName,
        ];
      case VisualRuleType.styleOrFormat:
        return [
          Vrq.selectVisualComponentOrStyle,
        ];
      case VisualRuleType.showOrHide:
        return [
          Vrq.controlsVisibilityOfAreaOrSlot,
        ];
      case VisualRuleType.themePreference:
        return [];
    }
  }

  DerivedQuestGenerator derQuestGenFromSubtype(
    QuestBase prevAnswQuest,
    VisRuleQuestType questTypeNewQuestion,
  ) {
    /*

    */
    assert(this.requConfigQuests.contains(questTypeNewQuestion), '');
    switch (questTypeNewQuestion) {
      case VisRuleQuestType.askCountOfSlotsToConfigure:
        return DerivedQuestGenerator<int>(
          'How many sort/filter/group fields do you need for ${prevAnswQuest.targetPath}?',
          newQuestCountCalculator: (qb) => qb.mainAnswer as int,
          newQuestPromptArgGen: (prevQuest, newQuestIdx) => [],
          answerChoiceGenerator: (prevQuest, newQuestIdx) => ['1', '2', '3'],
          newQuestIdGenFromPriorQuest: (prevQuest, newQuestIdx) => '',
          perQuestGenOptions: [
            PerQuestGenResponsHandlingOpts(newRespCastFunc: (qb, ans) {
              //
            })
          ],
        );
      case VisRuleQuestType.controlsVisibilityOfAreaOrSlot:
        break;
      case VisRuleQuestType.dialogStruct:
        break;
      case VisRuleQuestType.selectDataFieldName:
        break;
      case VisRuleQuestType.selectVisualComponentOrStyle:
        break;
      case VisRuleQuestType.specifySortAscending:
        break;
    }
    return DerivedQuestGenerator.noop();
  }
}

enum BehaviorRuleType {
  navigate,
}

extension BehaviorRuleTypeExt1 on BehaviorRuleType {
  //

}

// String Quest2Str(
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
//       return RuleTemplStr.sort.makeRuleQuest2Str(
//         this,
//         isAreaScopedRule,
//         valsDyn,
//       );
//     case VisualRuleType.group:
//       return RuleTemplStr.group.makeRuleQuest2Str(
//         this,
//         isAreaScopedRule,
//         valsDyn,
//       );
//     case VisualRuleType.filter:
//       return RuleTemplStr.filter.makeRuleQuest2Str(
//         this,
//         isAreaScopedRule,
//         valsDyn,
//       );
//     case VisualRuleType.format:
//       return RuleTemplStr.format.makeRuleQuest2Str(
//         this,
//         isAreaScopedRule,
//         valsDyn,
//       );
//     case VisualRuleType.show:
//       return RuleTemplStr.show.makeRuleQuest2Str(
//         this,
//         isAreaScopedRule,
//         valsDyn,
//       );
//   }
// }
