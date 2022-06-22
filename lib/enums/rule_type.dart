part of EvCfgEnums;

// vals not to show in config UI
// const List<VisualRuleType> _unconfigurableFutureRules = [
//   VisualRuleType.generalDialogFlow,
//   VisualRuleType.showOrHide,
//   VisualRuleType.themePreference,
// ];

@JsonEnum()
enum VisualRuleType {
  /*  generalDialogFlow is a placeholder value
      its not a real rule at all
      Dont show it in configurator
      it used for Questions at Event level
  */
  generalDialogFlow,
  sortCfg, // applies to area or filter-menu
  groupCfg, // how to group rows in listview; applies to listview area only
  filterCfg, // to create filter menus
  styleOrFormat, // select rowStyle for ListView
  showOrHide, // control visibility
  themePreference,
}

extension VisualRuleTypeExt1 on VisualRuleType {
  //

  bool get requiresPrepQuestion => requiresRulePrepQuestion;
  bool get requiresRulePrepQuestion => [
        // hasVariableSubRuleCount
        // these rules can configure 0-3 slots
        VisualRuleType.sortCfg,
        VisualRuleType.groupCfg,
        VisualRuleType.filterCfg
      ].contains(this);

  // List<VisualRuleType> get activeValues =>
  //     VisualRuleType.values.where((e) => e.isConfigurable).toList();

  RuleResponseBase get ruleResponseContainer {
    // return special types to contain answers
    // instance of the class that parses user response
    switch (this) {
      case VisualRuleType.generalDialogFlow:
        throw UnimplementedError('not a real rule; no cfg container exists');
      // return TvSortCfg();
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

  // bool get isConfigurable => !_unconfigurableFutureRules.contains(this);

  String get friendlyName {
    //
    String nm = this.name;
    switch (this) {
      case VisualRuleType.generalDialogFlow:
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
      case VisualRuleType.generalDialogFlow:
        return [];
      case VisualRuleType.sortCfg:
        return [
          Vrq.askCountOfSlotsToConfigure,
        ];
      case VisualRuleType.groupCfg:
        return [
          Vrq.askCountOfSlotsToConfigure,
        ];
      case VisualRuleType.filterCfg:
        return [
          Vrq.askCountOfSlotsToConfigure,
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

  DerivedQuestGenerator derQuestGenFromSubtypeForRuleGen(
    QuestBase prevAnswQuest,
    VisRuleQuestType ruleSubtypeNewQuest,
  ) {
    /* build a question generator that creates new questions
      to get all required answers for:  ruleSubtypeNewQuest

      if user answers all those, it will be sufficient data for rule-config
    */
    assert(
      prevAnswQuest.isRuleSelectionQuestion || prevAnswQuest.isRulePrepQuestion,
      'cant produce detail quests from this prevAnswQuest',
    );
    assert(
      prevAnswQuest.visRuleTypeForAreaOrSlot != null,
      'must have a rule specified',
    );
    assert(
      this.requConfigQuests.isEmpty ||
          this.requConfigQuests.contains(ruleSubtypeNewQuest),
      'sub type not valid for ruletype',
    );
    if (this.requConfigQuests.isEmpty) {
      print(
        'Warn:  building DerQuesGen for ${this.name} on ${ruleSubtypeNewQuest.name} when requConfigQuests.isEmpty',
      );
    }
    String ruleTypeName = this.name;
    String newQuestNamePrefix = prevAnswQuest.questId;
    switch (ruleSubtypeNewQuest) {
      case VisRuleQuestType.dialogStruct:
        throw UnimplementedError('err: not a real rule');
      // return DerivedQuestGenerator.noop();

      case VisRuleQuestType.askCountOfSlotsToConfigure:
        return DerivedQuestGenerator<VisualRuleType>(
          'How many $ruleTypeName fields do you need for ${prevAnswQuest.targetPath}?',
          newQuestCountCalculator: (qb) => 1,
          newQuestPromptArgGen: (prevQuest, newQuestIdx) => [],
          answerChoiceGenerator: (prevQuest, newQuestIdx) =>
              ['0', '1', '2', '3'],
          newQuestIdGenFromPriorQuest: (prevQuest, newQuestIdx) =>
              newQuestNamePrefix + '_askCount_$newQuestIdx',
          deriveTargetFromPriorRespCallbk: (QuestBase qb, int __) {
            return qb.qTargetIntent.copyWith();
          },
          perNewQuestGenOpts: [
            PerQuestGenResponsHandlingOpts<int>(
              newRespCastFunc: (QuestBase qb, String ans) {
                return ans as int;
              },
              visRuleType: this,
              visRuleQuestType: ruleSubtypeNewQuest,
            ),
          ],
        );
      case VisRuleQuestType.controlsVisibilityOfAreaOrSlot:
        return DerivedQuestGenerator<VisualRuleType>(
          'Do you want to hide the element at ${prevAnswQuest.targetPath}?',
          newQuestCountCalculator: (qb) => 1,
          newQuestPromptArgGen: (prevQuest, newQuestIdx) => [],
          answerChoiceGenerator: (prevQuest, newQuestIdx) => ['no', 'yes'],
          newQuestIdGenFromPriorQuest: (prevQuest, newQuestIdx) =>
              newQuestNamePrefix + '_hide_$newQuestIdx',
          deriveTargetFromPriorRespCallbk: (QuestBase qb, int __) {
            return qb.qTargetIntent.copyWith();
          },
          perNewQuestGenOpts: [
            PerQuestGenResponsHandlingOpts<bool>(
              newRespCastFunc: (QuestBase qb, String ans) {
                return ans as bool;
              },
              visRuleType: this,
              visRuleQuestType: ruleSubtypeNewQuest,
            ),
          ],
        );
      //

      case VisRuleQuestType.selectDataFieldName:
        return DerivedQuestGenerator<int>(
          'Select field #{0} for ${prevAnswQuest.targetPath}?',
          newQuestCountCalculator: (qb) => qb.mainAnswer as int,
          newQuestPromptArgGen: (prevQuest, newQuestIdx) => ['$newQuestIdx'],
          answerChoiceGenerator: (prevQuest, newQuestIdx) =>
              DbTableFieldName.values.map((e) => e.name).toList(),
          newQuestIdGenFromPriorQuest: (prevQuest, newQuestIdx) =>
              newQuestNamePrefix + '_selFld_$newQuestIdx',
          deriveTargetFromPriorRespCallbk: (QuestBase qb, int __) {
            return qb.qTargetIntent.copyWith();
          },
          perNewQuestGenOpts: [
            PerQuestGenResponsHandlingOpts<DbTableFieldName>(
              newRespCastFunc: (QuestBase qb, String ans) {
                int respIdx = int.tryParse(ans) ?? 0;
                return DbTableFieldName.values[respIdx];
              },
              visRuleType: this,
              visRuleQuestType: ruleSubtypeNewQuest,
            ),
          ],
        );
      case VisRuleQuestType.selectVisualComponentOrStyle:
        // specify desired style on area or slot
        List<dynamic> possibleVisStyles =
            prevAnswQuest.qTargetIntent.possibleVisCompStylesForTarget;

        return DerivedQuestGenerator<int>(
          'Select preferred style for ${prevAnswQuest.targetPath}?',
          newQuestCountCalculator: (qb) => 1,
          newQuestPromptArgGen: (prevQuest, newQuestIdx) => [],
          answerChoiceGenerator: (prevQuest, newQuestIdx) =>
              possibleVisStyles.map((e) => e.toString()).toList(),
          newQuestIdGenFromPriorQuest: (prevQuest, newQuestIdx) =>
              newQuestNamePrefix + '_selStyle_$newQuestIdx',
          deriveTargetFromPriorRespCallbk: (QuestBase qb, int __) {
            return qb.qTargetIntent.copyWith();
          },
          perNewQuestGenOpts: [
            PerQuestGenResponsHandlingOpts<dynamic>(
              newRespCastFunc: (QuestBase qb, String ans) {
                int respIdx = int.tryParse(ans) ?? 0;
                return possibleVisStyles[respIdx];
              },
              visRuleType: this,
              visRuleQuestType: ruleSubtypeNewQuest,
            ),
          ],
        );
      //
      case VisRuleQuestType.specifySortAscending:
        return DerivedQuestGenerator<dynamic>(
          'Do you want to sort ${prevAnswQuest.targetPath} ascending? (large vals at end)',
          newQuestCountCalculator: (qb) => 1,
          newQuestPromptArgGen: (prevQuest, newQuestIdx) => [],
          answerChoiceGenerator: (prevQuest, newQuestIdx) => ['no', 'yes'],
          newQuestIdGenFromPriorQuest: (prevQuest, newQuestIdx) =>
              newQuestNamePrefix + '_sort_$newQuestIdx',
          deriveTargetFromPriorRespCallbk: (QuestBase qb, int __) {
            return qb.qTargetIntent.copyWith();
          },
          perNewQuestGenOpts: [
            PerQuestGenResponsHandlingOpts<bool>(
              newRespCastFunc: (QuestBase qb, String ans) {
                return ans as bool;
              },
              visRuleType: this,
              visRuleQuestType: ruleSubtypeNewQuest,
            ),
          ],
        );
    }
    // return DerivedQuestGenerator.noop();
  }
}

enum BehaviorRuleType {
  navigate,
}

extension BehaviorRuleTypeExt1 on BehaviorRuleType {
  //
  bool get requiresRulePrepQuestion => false;
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
