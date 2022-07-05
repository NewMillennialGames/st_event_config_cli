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
  bool get requiresVisRulePrepQuestion => [
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
    if (!this.requiresVisRulePrepQuestion) return '{0}';

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
    if (!this.requiresVisRulePrepQuestion) return '{0}';

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

  List<VisRuleQuestType> get requPrepQuests {
    // prep question required BEFORE you can ask
    // rule detail questions
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
        return [];
      case VisualRuleType.showOrHide:
        return [];
      case VisualRuleType.themePreference:
        return [];
    }
  }

  List<VisRuleQuestType> get requRuleDetailCfgQuests {
    // its helpful that only one config type is returned
    // DerivedQuestGenerator could have problems if this changes
    switch (this) {
      case VisualRuleType.generalDialogFlow:
        return [];
      case VisualRuleType.sortCfg:
        return [
          Vrq.selectDataFieldName,
          // Vrq.specifySortAscending // leave this out here
        ];
      case VisualRuleType.groupCfg:
        return [
          Vrq.selectDataFieldName,
          // Vrq.specifySortAscending // leave this out here
        ];
      case VisualRuleType.filterCfg:
        return [
          Vrq.selectDataFieldName,
          // Vrq.specifySortAscending // leave this out here
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
    QTargetResolution newQTargRes,
  ) {
    /* 
    some rules (eg hide/show an area) are singular (complete with 1 answer)
    some rules (eg sort a list-view) might have up to 3 fields
    and each of those fields can be sorted asc or descending
    so the entire sorting rule could consist of 3 questions:
      (which field in position # 1,2,3)
    and 2 prompts in each question
      prompt #1:  select 1st {1-3} sort field
      prompt #2:  sort ascending
    answer to prompt #1 is a DbTableFieldName
    answer to prompt #2 is a bool
    
    build & return a question generator that creates new questions
      to get all required answers for:  prevAnswQuest.visRuleTypeForAreaOrSlot!
      required answers found from:   List<VisRuleQuestType> vrt.requConfigQuests;

      note that prevAnswQuest MUST BE EITHER A:
        isRuleSelectionQuestion || isRulePrepQuestion

    the question generator ALSO needs to know HOW MANY questions to ask
      answer to that ?? is below --- if prevAnswQuest is a: 
        RuleSelectionQuestion == 1
        RulePrepQuestion == prevAnswQuest.mainAnswer as int

      
    */
    assert(
      prevAnswQuest.isRuleSelectionQuestion || prevAnswQuest.isRulePrepQuestion,
      'cant produce detail quests from this prevAnswQuest; ${prevAnswQuest.questId}',
    );
    assert(
      prevAnswQuest.targetPathIsComplete,
      'target (area/slot) for rule must be complete to call this method; ${prevAnswQuest.questId}',
    );

    bool answOnPrevQuestIsIterable = prevAnswQuest.mainAnswer is Iterable;
    if (prevAnswQuest.visRuleTypeForAreaOrSlot == null &&
        !answOnPrevQuestIsIterable) {
      print(
        'err: user selected 1-n rules but $name not set yet on current question',
      );
    } else if (prevAnswQuest.visRuleTypeForAreaOrSlot != null &&
        prevAnswQuest.visRuleTypeForAreaOrSlot != this) {
      throw UnimplementedError(
        'err: impossible condition!  $name != ${prevAnswQuest.visRuleTypeForAreaOrSlot!.name}',
      );
    }
    VisualRuleType visRT = this;

    List<VisRuleQuestType> visRequiredSubQuests = this.requRuleDetailCfgQuests;
    if (visRequiredSubQuests.isEmpty) {
      throw UnimplementedError(
        'Warn:  building DerQuesGen for ${this.name} when requConfigQuests.isEmpty; ${prevAnswQuest.questId}',
      );
    }

    print('makeQuestGenForRuleType is looping on:');
    print(visRequiredSubQuests);

    int newQuestCountToGenerate = answOnPrevQuestIsIterable
        ? (prevAnswQuest.mainAnswer as Iterable).length
        : 1;

    if (newQuestCountToGenerate > 1) {
      print(
        'warn:  ${prevAnswQuest.questId} will generate $newQuestCountToGenerate questions  (prob an error?)',
      );
    }
    String ruleTypeName = this.name;
    String newQuestNamePrefix = prevAnswQuest.questId;

    // collect question prompts for construction of the generator
    List<NewQuestPerPromptOpts> newPerPromptDetails = [];

    List<String> _accumSubQuestNames = [];
    // create 1-n NewQuestPerPromptOpts for each required subQuest
    // as needed by VisualRuleType visRT
    for (VisRuleQuestType ruleSubtypeNewQuest in visRequiredSubQuests) {
      //
      _accumSubQuestNames.add(ruleSubtypeNewQuest.name);
      switch (ruleSubtypeNewQuest) {
        case VisRuleQuestType.dialogStruct:
          throw UnimplementedError('err: not a real rule');

        case VisRuleQuestType.askCountOfSlotsToConfigure:
          //

          newPerPromptDetails.add(NewQuestPerPromptOpts<int>(
            'How many $ruleTypeName fields do you need for ${prevAnswQuest.targetPath}?',
            promptTemplArgGen: (prevQuest, newQuestIdx) => [],
            answerChoiceGenerator: (prevQuest, newQuestIdx, int promptIdx) =>
                ['0', '1', '2', '3'],
            newRespCastFunc: (QuestBase qb, String ans) {
              return ans as int;
            },
            visRuleType: visRT,
            visRuleQuestType: VisRuleQuestType.askCountOfSlotsToConfigure,
          ));
          break;

        case VisRuleQuestType.controlsVisibilityOfAreaOrSlot:
          newPerPromptDetails.add(NewQuestPerPromptOpts<bool>(
            'Do you want to hide the element at ${prevAnswQuest.targetPath}?',
            promptTemplArgGen: (prevQuest, newQuestIdx) => [],
            answerChoiceGenerator: (prevQuest, newQuestIdx, int promptIdx) =>
                ['no', 'yes'],
            newRespCastFunc: (QuestBase qb, String ans) {
              int n = int.tryParse(ans) ?? 0;
              return n > 0;
            },
            visRuleType: visRT,
            visRuleQuestType: VisRuleQuestType.controlsVisibilityOfAreaOrSlot,
          ));
          break;

        case VisRuleQuestType.selectDataFieldName:
          int promptCountEachQuestion = 1;
          if (prevAnswQuest.isRulePrepQuestion) {
            // we may have different types of rule-prep quests in the future
            // promptCountEachQuestion = prevAnswQuest.mainAnswer as int;
            var lastResp = prevAnswQuest.mainAnswer as List<String>;
            promptCountEachQuestion = int.tryParse(lastResp.first) ?? 1;
          }

          List<NewQuestPerPromptOpts> qps = _getQuestPromptOptsForDataFieldName(
            visRT,
            promptCountEachQuestion,
          );
          newPerPromptDetails.addAll(qps);
          print(
            'promptCountEachQuestion: $promptCountEachQuestion    newPerPromptDetails: ${newPerPromptDetails.length}',
          );
          break;

        case VisRuleQuestType.selectVisualComponentOrStyle:
          // specify desired style on area or slot

          // List<TvAreaRowStyle> possibleVisStyles = prevAnswQuest
          // .qTargetResolution
          // .possibleVisCompStylesForTarget as List<TvAreaRowStyle>;

          // List<TvAreaRowStyle> possibleVisStyles = newQTargRes
          //     .possibleVisCompStylesForTarget as List<TvAreaRowStyle>;
          // hack
          List<TvAreaRowStyle> possibleVisStyles = TvAreaRowStyle.values;

          newPerPromptDetails.add(NewQuestPerPromptOpts<TvAreaRowStyle>(
            'Select preferred style for ${prevAnswQuest.targetPath}?',
            promptTemplArgGen: (prevQuest, newQuestIdx) => [],
            answerChoiceGenerator: (prevQuest, newQuestIdx, int promptIdx) =>
                possibleVisStyles.map((e) => e.name).toList(),
            newRespCastFunc: (QuestBase qb, String ans) {
              int n = int.tryParse(ans) ?? 0;
              return possibleVisStyles[n];
            },
            visRuleType: visRT,
            visRuleQuestType: VisRuleQuestType.selectVisualComponentOrStyle,
          ));
          break;
        //
        case VisRuleQuestType.specifySortAscending:
          throw UnimplementedError(
            'err: not a real rule; hidden under selectDataFieldName',
          );
      }
    }
    assert(newPerPromptDetails.length > 0, 'err: no prompts in question');

    String qIdSuffix =
        _accumSubQuestNames.reduce((value, element) => value + '-' + element);

    return DerivedQuestGenerator.multiPrompt(newPerPromptDetails,
        newQuestCountCalculator: ((QuestBase qb) => newQuestCountToGenerate),
        genBehaviorOfDerivedQuests: DerivedGenBehaviorOnMatchEnum.noop,
        newQuestIdGenFromPriorQuest: (qb, idx) =>
            qb.questId + '-rdt-$qIdSuffix-$idx',
        newQuestConstructor: QuestBase.visualRuleDetailQuest,
        deriveTargetFromPriorRespCallbk: (QuestBase qb, int newQidx) {
          /*  using QTargetResolution newQTargRes
              passed as argument above
          */
          return newQTargRes.copyWith(visRuleTypeForAreaOrSlot: this);
        });
  }
}

List<NewQuestPerPromptOpts> _getQuestPromptOptsForDataFieldName(
  VisualRuleType ruleType,
  int numOfFieldsToSpecify,
) {
  // create upvals for constructors below
  var questTempl =
      VisRuleQuestType.selectDataFieldName.questTemplByRuleType(ruleType);

  List<String> _promptTemplArgGenFunc(
    QuestBase priorAnsweredQuest,
    int promptIdx,
  ) {
    var fldNumLookup = {0: '1st', 1: '2nd', 2: '3rd'};
    String pos = fldNumLookup[promptIdx] ?? '-$promptIdx-';
    return [
      pos,
      priorAnsweredQuest.targetPath,
    ];
  }

  List<String> _answerChoiceGeneratorFunc(
    QuestBase priorAnsweredQuest,
    int newQuestIdx,
    int promptIdx,
  ) {
    // in future it might be nice to filter out fields user has already selected
    return DbTableFieldName.values.map((e) => e.name).toList();
  }

  DbTableFieldName _newRespCastFunc(
    QuestBase newQuest,
    String lstAreaIdxs,
  ) {
    List<int> l = castStrOfIdxsToIterOfInts(lstAreaIdxs).toList();
    assert(l.length == 1, 'exactly 1 response required');
    return DbTableFieldName.values[l.first];
  }

  List<NewQuestPerPromptOpts> perPromptDetails = [];
  for (int i = 1; i <= numOfFieldsToSpecify; i++) {
    // adds 2 prompts for each field question
    perPromptDetails.addAll([
      NewQuestPerPromptOpts<DbTableFieldName>(
        questTempl,
        visRuleQuestType: VisRuleQuestType.selectDataFieldName,
        promptTemplArgGen: _promptTemplArgGenFunc,
        answerChoiceGenerator: _answerChoiceGeneratorFunc,
        newRespCastFunc: _newRespCastFunc,
      ),
      NewQuestPerPromptOpts<bool>(
        'Sort Ascending?',
        visRuleQuestType: VisRuleQuestType.specifySortAscending,
        promptTemplArgGen: (_, __) => [],
        newRespCastFunc: (
          QuestBase newQuest,
          String lstAreaIdxs,
        ) {
          List<int> l = castStrOfIdxsToIterOfInts(lstAreaIdxs).toList();
          return l.first > 0;
        },
        answerChoiceGenerator: (
          QuestBase priorAnsweredQuest,
          int newQuestIdx,
          int promptIdx,
        ) {
          return ['no', 'yes'];
        },
      ),
    ]);
  }
  return perPromptDetails;
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
