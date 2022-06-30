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

  String get prepTemplate {
    //
    if (!this.requiresPrepQuestion) return '{0}';

    switch (this) {
      case VisualRuleType.generalDialogFlow:
        return '';
      case VisualRuleType.sortCfg:
        return 'How many sort fields on {0}?';
      case VisualRuleType.groupCfg:
        return 'How many grouping fields on {0}?';
      case VisualRuleType.filterCfg:
        return 'How many filter menus on {0}?';
      case VisualRuleType.styleOrFormat:
        return '';
      case VisualRuleType.showOrHide:
        return '';
      case VisualRuleType.themePreference:
        return '';
    }
  }

  String get detailTemplate {
    //
    if (!this.requiresPrepQuestion) return '{0}';

    switch (this) {
      case VisualRuleType.generalDialogFlow:
        return '';
      case VisualRuleType.sortCfg:
        return 'Select sort field #{0} for the {1} on {2}.';
      case VisualRuleType.groupCfg:
        return 'Select group field #{0} for the {1} on {2}.';
      case VisualRuleType.filterCfg:
        return 'Select filter field #{0} for the {1} on {2}.';
      case VisualRuleType.styleOrFormat:
        return '';
      case VisualRuleType.showOrHide:
        return '';
      case VisualRuleType.themePreference:
        return '';
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

  DerivedQuestGenerator makeQuestGenForRuleType(
    QuestBase prevAnswQuest,
    // VisRuleQuestType ruleSubtypeNewQuest,
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
    // assert(
    //   this.requConfigQuests.isEmpty ||
    //       this.requConfigQuests.contains(ruleSubtypeNewQuest),
    //   'sub type not valid for ruletype',
    // );
    VisualRuleType vrt = prevAnswQuest.visRuleTypeForAreaOrSlot!;
    List<VisRuleQuestType> qts = vrt.requConfigQuests;
    if (qts.isEmpty) {
      print(
        'Warn:  building DerQuesGen for ${this.name} when requConfigQuests.isEmpty',
      );
    }
    String ruleTypeName = this.name;
    String newQuestNamePrefix = prevAnswQuest.questId;
    List<NewQuestPerPromptOpts> perPromptDetails = [];

    for (VisRuleQuestType ruleSubtypeNewQuest in qts) {
      //
      switch (ruleSubtypeNewQuest) {
        case VisRuleQuestType.dialogStruct:
          throw UnimplementedError('err: not a real rule');
        // return DerivedQuestGenerator.noop();

        case VisRuleQuestType.askCountOfSlotsToConfigure:
          return DerivedQuestGenerator.singlePrompt(
            // <VisualRuleType>
            'How many $ruleTypeName fields do you need for ${prevAnswQuest.targetPath}?',
            newQuestCountCalculator: (qb) => 1,
            newQuestPromptArgGen: (prevQuest, newQuestIdx) => [],
            answerChoiceGenerator: (prevQuest, newQuestIdx, int promptIdx) =>
                ['0', '1', '2', '3'],
            newQuestIdGenFromPriorQuest: (prevQuest, newQuestIdx) =>
                newQuestNamePrefix + '_askCount_$newQuestIdx',
            deriveTargetFromPriorRespCallbk: (QuestBase qb, int __) {
              return qb.qTargetResolution.copyWith();
            },
            newRespCastFunc: (QuestBase qb, String ans) {
              return ans as int;
            },
            // perPromptDetails: [
            //   NewQuestPerPromptOpts<int>(

            //     visRuleType: this,
            //     visRuleQuestType: ruleSubtypeNewQuest,
            //   ),
            // ],
          );
        case VisRuleQuestType.controlsVisibilityOfAreaOrSlot:
          return DerivedQuestGenerator.singlePrompt(
            // <VisualRuleType>
            'Do you want to hide the element at ${prevAnswQuest.targetPath}?',
            newQuestCountCalculator: (qb) => 1,
            newQuestPromptArgGen: (prevQuest, newQuestIdx) => [],
            answerChoiceGenerator: (prevQuest, newQuestIdx, int promptIdx) =>
                ['no', 'yes'],
            newQuestIdGenFromPriorQuest: (prevQuest, newQuestIdx) =>
                newQuestNamePrefix + '_hide_$newQuestIdx',
            deriveTargetFromPriorRespCallbk: (QuestBase qb, int __) {
              return qb.qTargetResolution.copyWith();
            },
            newRespCastFunc: (QuestBase qb, String ans) {
              return ans as bool;
            },
            // perPromptDetails: [
            //   NewQuestPerPromptOpts<bool>(

            //     visRuleType: this,
            //     visRuleQuestType: ruleSubtypeNewQuest,
            //   ),
            // ],
          );
        //

        case VisRuleQuestType.selectDataFieldName:
          return DerivedQuestGenerator.singlePrompt(
            // <int>
            'Select field #{0} for ${prevAnswQuest.targetPath}?',
            newQuestCountCalculator: (qb) => qb.mainAnswer as int,
            newQuestPromptArgGen: (prevQuest, newQuestIdx) => ['$newQuestIdx'],
            answerChoiceGenerator: (prevQuest, newQuestIdx, int promptIdx) =>
                DbTableFieldName.values.map((e) => e.name).toList(),
            newQuestIdGenFromPriorQuest: (prevQuest, newQuestIdx) =>
                newQuestNamePrefix + '_selFld_$newQuestIdx',
            deriveTargetFromPriorRespCallbk: (QuestBase qb, int __) {
              return qb.qTargetResolution.copyWith();
            },
            newRespCastFunc: (QuestBase qb, String ans) {
              int respIdx = int.tryParse(ans) ?? 0;
              return DbTableFieldName.values[respIdx];
            },
            // perPromptDetails: [
            //   NewQuestPerPromptOpts<DbTableFieldName>(

            //     visRuleType: this,
            //     visRuleQuestType: ruleSubtypeNewQuest,
            //   ),
            // ],
          );
        case VisRuleQuestType.selectVisualComponentOrStyle:
          // specify desired style on area or slot
          List<dynamic> possibleVisStyles =
              prevAnswQuest.qTargetResolution.possibleVisCompStylesForTarget;

          return DerivedQuestGenerator.singlePrompt(
            // <int>
            'Select preferred style for ${prevAnswQuest.targetPath}?',
            newQuestCountCalculator: (qb) => 1,
            newQuestPromptArgGen: (prevQuest, newQuestIdx) => [],
            answerChoiceGenerator: (prevQuest, newQuestIdx, int promptIdx) =>
                possibleVisStyles.map((e) => e.toString()).toList(),
            newQuestIdGenFromPriorQuest: (prevQuest, newQuestIdx) =>
                newQuestNamePrefix + '_selStyle_$newQuestIdx',
            deriveTargetFromPriorRespCallbk: (QuestBase qb, int __) {
              return qb.qTargetResolution.copyWith();
            },
            newRespCastFunc: (QuestBase qb, String ans) {
              int respIdx = int.tryParse(ans) ?? 0;
              return possibleVisStyles[respIdx];
            },
            // perPromptDetails: [
            //   NewQuestPerPromptOpts<dynamic>(

            //     visRuleType: this,
            //     visRuleQuestType: ruleSubtypeNewQuest,
            //   ),
            // ],
          );
        //
        case VisRuleQuestType.specifySortAscending:
          return DerivedQuestGenerator.singlePrompt(
            // <dynamic>
            'Do you want to sort ${prevAnswQuest.targetPath} ascending? (large vals at end)',
            newQuestCountCalculator: (qb) => 1,
            newQuestPromptArgGen: (prevQuest, newQuestIdx) => [],
            answerChoiceGenerator: (prevQuest, newQuestIdx, int promptIdx) =>
                ['no', 'yes'],
            newQuestIdGenFromPriorQuest: (prevQuest, newQuestIdx) =>
                newQuestNamePrefix + '_sort_$newQuestIdx',
            deriveTargetFromPriorRespCallbk: (QuestBase qb, int __) {
              return qb.qTargetResolution.copyWith();
            },
            newRespCastFunc: (QuestBase qb, String ans) {
              return ans as bool;
            },
            // perPromptDetails: [
            //   NewQuestPerPromptOpts<bool>(

            //     visRuleType: this,
            //     visRuleQuestType: ruleSubtypeNewQuest,
            //   ),
            // ],
          );
      }
    }

    return DerivedQuestGenerator.multiPrompt(perPromptDetails,
        newQuestCountCalculator: ((p0) => 1));
  }
}

DerivedQuestGenerator _getDerQuestGen() {
  //
  return DerivedQuestGenerator.multiPrompt(
    [
      NewQuestPerPromptOpts<DbTableFieldName>(
        '',
        visRuleQuestType: VisRuleQuestType.selectDataFieldName,
        promptTemplArgGen: (
          QuestBase priorAnsweredQuest,
          int idx,
        ) {
          var areaName = priorAnsweredQuest.screenWidgetArea?.name ?? 'area';
          var screenName = priorAnsweredQuest.appScreen.name;
          var templ =
              priorAnsweredQuest.visRuleTypeForAreaOrSlot!.detailTemplate;
          var msg = templ.format(
            [
              '$idx',
              areaName.toUpperCase(),
              screenName.toUpperCase(),
            ],
          );
          return [msg];
        },
        answerChoiceGenerator:
            (QuestBase priorAnsweredQuest, int newQuestIdx, int promptIdx) {
          return DbTableFieldName.values.map((e) => e.name).toList();
        },
        newRespCastFunc: (
          QuestBase newQuest,
          String lstAreaIdxs,
        ) {
          List<int> l = castStrOfIdxsToIterOfInts(lstAreaIdxs).toList();
          return DbTableFieldName.values[l.first];
        },
      ),
      NewQuestPerPromptOpts<bool>(
        '',
        // promptOverride: 'Sort Ascending (yes == 1)',
        visRuleQuestType: VisRuleQuestType.specifySortAscending,
        promptTemplArgGen: (
          QuestBase priorAnsweredQuest,
          int idx,
        ) {
          return [];
        },
        newRespCastFunc: (
          QuestBase newQuest,
          String lstAreaIdxs,
        ) {
          List<int> l = castStrOfIdxsToIterOfInts(lstAreaIdxs).toList();
          return l.first > 0;
        },
        answerChoiceGenerator:
            (QuestBase priorAnsweredQuest, int newQuestIdx, int promptIdx) {
          return DbTableFieldName.values.map((e) => e.name).toList();
        },
      ),
    ],
    newQuestConstructor: QuestBase.visualRuleDetailQuest,
    newQuestCountCalculator: (QuestBase priorAnsweredQuest) {
      return (priorAnsweredQuest.mainAnswer as int);
    },
    newQuestIdGenFromPriorQuest: (
      QuestBase priorAnsweredQuest,
      int newQuIdx,
    ) {
      String scrName = priorAnsweredQuest.appScreen.name;
      String area = priorAnsweredQuest.screenWidgetArea?.name ?? '-na';
      return QuestionIdStrings.specRuleDetailsForAreaOnScreen +
          '-' +
          (priorAnsweredQuest.visRuleTypeForAreaOrSlot?.name ?? 'lv_rule') +
          '-' +
          area +
          '-' +
          scrName;
    },
  );
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
