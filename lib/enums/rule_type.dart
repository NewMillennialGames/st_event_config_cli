part of EvCfgEnums;

// vals not to show in config UI
// const List<VisualRuleType> _unconfigurableFutureRules = [
//   VisualRuleType.generalDialogFlow,
//   VisualRuleType.showOrHide,
//   VisualRuleType.themePreference,
// ];

// question-prompt-index (adjusted for prompt-count) will select one of these values
const Map<int, String> _fldPosLookupMap = {
  0: '1st',
  1: '2nd',
  2: '3rd',
  3: '4th',
  4: '5th'
};

const String _questGenErrorTemplate =
    "Err: %s is not a top-lvl VisRuleQuestType; its subsummed under %s when VRT is %s";

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
  bool get needsVisRulePrepQuestion => [
        /* for some rules, we must ask "how many"
        before we know how many prompts to create
    these rules can configure between 0-3 slots
        */
        VisualRuleType.sortCfg,
        VisualRuleType.groupCfg,
        VisualRuleType.filterCfg
      ].contains(this);

  bool get appliesToFilterCfg => [VisualRuleType.filterCfg].contains(this);

  bool get appliesToGroupCfg => [VisualRuleType.groupCfg].contains(this);

  bool get appliesToSortCfg => [VisualRuleType.sortCfg].contains(this);

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
        return TvRowStyleCfg();
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
    // throw error rather than returning a bs value
    // if (!this.requiresVisRulePrepQuestion) return '{0}';

    switch (this) {
      case VisualRuleType.generalDialogFlow:
        // return '';
        throw UnimplementedError(
          'generalDialogFlow does not use a prep template',
        );
      case VisualRuleType.sortCfg:
        return 'How many sort fields on {0}?';
      case VisualRuleType.groupCfg:
        return 'How many grouping fields on {0}?';
      case VisualRuleType.filterCfg:
        return 'How many filter menus on {0}?';
      case VisualRuleType.styleOrFormat:
        throw UnimplementedError(
          'styleOrFormat does not use a prep template',
        );
      // return 'styleOrFormat does not use a prep template  ';
      case VisualRuleType.showOrHide:
        // return 'showOrHide does not use a prep template  ';
        throw UnimplementedError(
          'showOrHide does not use a prep template',
        );
      case VisualRuleType.themePreference:
        // return 'themePreference does not use a prep template  ';
        throw UnimplementedError(
          'themePreference does not use a prep template',
        );
    }
  }

  String get detailTemplate {
    //
    switch (this) {
      case VisualRuleType.generalDialogFlow:
        return '{0}';
      case VisualRuleType.sortCfg:
        return 'Select sort field #{0} for the {1} on {2}.';
      case VisualRuleType.groupCfg:
        return 'Select group field #{0} for the {1} on {2}.';
      case VisualRuleType.filterCfg:
        return 'Select filter field #{0} for the {1} on {2}.';
      case VisualRuleType.styleOrFormat:
        return 'Select row-style for {0} from list below: ';
      case VisualRuleType.showOrHide:
        return 'showOrHide does not use a detailTemplate  ';
      case VisualRuleType.themePreference:
        return 'themePreference does not use a detailTemplate  ';
    }
  }
  //

  List<VisRuleQuestType> get requiredPrepQuests {
    /* prep question required BEFORE you can ask rule detail questions
    its important to only return ONE
    */
    switch (this) {
      case VisualRuleType.generalDialogFlow:
        // return [];
        throw UnimplementedError(
          'generalDialogFlow does not use prep questions',
        );
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
        // return []; // [Vrq.selectVisualComponentOrStyle];
        throw UnimplementedError(
          'styleOrFormat does not use prep questions',
        );
      case VisualRuleType.showOrHide:
        // return []; // [Vrq.controlsVisibilityOfAreaOrSlot];
        throw UnimplementedError(
          'showOrHide does not use prep questions',
        );
      case VisualRuleType.themePreference:
        // return []; // [Vrq.selectVisualComponentOrStyle];
        throw UnimplementedError(
          'themePreference does not use prep questions',
        );
    }
  }

  int get subPromptCount {
    /* inform the makeQuestGenForRuleType()
    how many sub-prompts exist, so it can correctly
    create the question indexes (id) in sequential order
    */
    switch (this) {
      case VisualRuleType.generalDialogFlow:
        return 0;
      case VisualRuleType.sortCfg:
        return 2;
      case VisualRuleType.groupCfg:
        return 4;
      case VisualRuleType.filterCfg:
        return 3;
      case VisualRuleType.styleOrFormat:
        return 1;
      case VisualRuleType.showOrHide:
        return 1;
      case VisualRuleType.themePreference:
        return 1;
    }
  }

  int get questCountToIterByType {
    /*
      how many quests are required to compose 
      a complete rule-detail answer

      see code in:
        SortGroupFilterEntry._castToRealTypes
        to understand how this value is used

        when you see extra responses being added
        this int is off
    */
    switch (this) {
      case VisualRuleType.generalDialogFlow:
        return 0;
      case VisualRuleType.sortCfg:
        return 2;
      case VisualRuleType.groupCfg:
        return 4;
      case VisualRuleType.filterCfg:
        return 3;
      case VisualRuleType.styleOrFormat:
        return 1;
      case VisualRuleType.showOrHide:
        return 1;
      case VisualRuleType.themePreference:
        return 1;
    }
  }

  List<VisRuleQuestType> get requRuleDetailCfgQuests {
    /*  IMPORTANT:
      if you adjust the list below, you must also fix "subPromptCount" above

    its helpful that only one (first) config type is returned
    DerivedQuestGenerator could have problems if this changes

    in short, sort, group and filter require multiple
    varying questions and its easier to decide which from within
      _getQuestPromptOptsForDataFieldName (below)
    than it is to return multiple values here

    we may study and revise this at a later point
    */

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
          /* questions below are part of the rule config
            but this logic is handled in the derived question
            constructor, 
            DerivedQuestGenerator makeQuestGenForRuleType  (below)
            and not guided by this property

            TODO: see notes above & study why the above is best approach??
          */
          // Vrq.specifySortAscending
          // Vrq.askJustification,
          // Vrq.isCollapsible,
        ];
      case VisualRuleType.filterCfg:
        return [
          Vrq.selectDataFieldName,
          // Vrq.specifySortAscending // leave this out here
          // Vrq.askMenuName,
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
    int requiredPromptInstances,
  ) {
    /*   this method only ever called on ONE VRT
    so we produce a DerivedQuestGenerator that will generate
    only one question (w possibly multiple prompts)

    some rules (eg hide/show an area) are singular (complete with 1 prompt/answer)
    some rules (eg sort a list-view) might have up to 3 sort-fields (prompts)
    and each of those fields can be sorted asc or descending  (+ 3 sort directions)
    so the entire sorting rule could consist of 6 prompts in 1 question:
      (which field in position # 1,2,3)
    3 times below:
      prompt #1:  select 1st {1-3} sort field
      prompt #2:  sort ascending
    answer to prompt #0 is a DbTableFieldName
    answer to prompt #1 is a bool
    
    build & return a DerivedQuestGenerator that creates ONE new question
      to get all required answers for:  newQTargRes.visRuleTypeForAreaOrSlot!
      required answers found from:   List<VisRuleQuestType> vrt.requConfigQuests;

      note that prevAnswQuest MUST BE EITHER A:
        isRuleSelectionQuestion || isRulePrepQuestion
    */
    assert(
      prevAnswQuest.isRuleSelectionQuestion || prevAnswQuest.isRulePrepQuestion,
      'cant produce detail quests from this prevAnswQuest; ${prevAnswQuest.questId}',
    );
    assert(
      prevAnswQuest.targetPathIsComplete,
      'target (area/slot) for rule must be complete to call this method; ${prevAnswQuest.questId}',
    );

    VisualRuleType thisVisRT = this;
    assert(thisVisRT == newQTargRes.visRuleTypeForAreaOrSlot, 'wtf?');

    String ruleTypeName = thisVisRT.name;
    ConfigLogger.log(Level.INFO, 'ruleTypeName: $ruleTypeName');
    // String newQuestNamePrefix = prevAnswQuest.questId;

    // visRequiredSubQuests should contain exactly 1 value
    List<VisRuleQuestType> visRequiredSubQuests =
        thisVisRT.requRuleDetailCfgQuests;

    assert(
      visRequiredSubQuests.length == 1,
      'each VRT should have 1 main VisRuleQuestType;  other required values will be handled by PROMPTS within the quest',
    );

    // this newQTargRes.copyWith was normally done in the caller but repeating to just be safe!!
    // normally creates a rule-detail question but sometimes (VisRuleQuestType.askCountOfSlotsToConfigure) creates rulePrep
    newQTargRes = newQTargRes.copyWith(
      visRuleTypeForAreaOrSlot: thisVisRT,
      precision: TargetPrecision.ruleDetailVisual,
    );

    // collect question prompts for construction of the der-quest generator
    List<NewQuestPerPromptOpts> perQuestPromptDetails = [];

    List<String> _accumSubQuestNames = [];
    // create 1-n NewQuestPerPromptOpts for each required subQuest
    // as needed by VisualRuleType visRT

    VisRuleQuestType ruleSubtypeNewQuest = visRequiredSubQuests.first;
    //
    _accumSubQuestNames.add(ruleSubtypeNewQuest.name);
    switch (ruleSubtypeNewQuest) {
      case VisRuleQuestType.dialogStruct:
        throw UnimplementedError(
          'err: not a real vis rule (placeholder for event cfg questions)',
        );

      case VisRuleQuestType.askCountOfSlotsToConfigure:
        //
        assert(
          false,
          'This code is never being called; DQG is being built in the matcher',
        );
        assert(
          prevAnswQuest.isRuleSelectionQuestion &&
              thisVisRT.needsVisRulePrepQuestion,
          'oops!! something weird??  ${newQTargRes.targetPath}',
        );

        newQTargRes = newQTargRes.copyWith(
          precision: TargetPrecision.rulePrep,
        );

        String templ = thisVisRT.prepTemplate;
        ConfigLogger.log(
          Level.INFO,
          'askCountOfSlotsToConfigure:  ${thisVisRT} uses $templ   ($ruleTypeName)',
        );
        perQuestPromptDetails.add(NewQuestPerPromptOpts<int>(
          'How many $ruleTypeName fields do you need for ${newQTargRes.targetPath}?',
          promptTemplArgGen: (prevQuest, newQuestIdx, promptIdx) => [],
          answerChoiceGenerator: (prevQuest, newQuestIdx, int promptIdx) =>
              ['0', '1', '2', '3'],
          newRespCastFunc: (QuestBase qb, String ans) {
            return int.tryParse(ans) ?? 0;
            // return ans as int;
          },
          visRuleType: thisVisRT,
          visRuleQuestType: VisRuleQuestType.askCountOfSlotsToConfigure,
        ));
        break;

      case VisRuleQuestType.controlsVisibilityOfAreaOrSlot:
        perQuestPromptDetails.add(NewQuestPerPromptOpts<bool>(
          'Do you want to hide the element at ${newQTargRes.targetPath}?',
          promptTemplArgGen: (prevQuest, newQuestIdx, promptIdx) => [],
          answerChoiceGenerator: (prevQuest, newQuestIdx, int promptIdx) =>
              ['no', 'yes'],
          newRespCastFunc: (QuestBase qb, String ans) {
            int n = int.tryParse(ans) ?? 0;
            return n > 0;
          },
          visRuleType: thisVisRT,
          visRuleQuestType: VisRuleQuestType.controlsVisibilityOfAreaOrSlot,
        ));
        break;

      case VisRuleQuestType.selectDataFieldName:
        /* a set of info-requests (aka prompt-set)
            might be like:
              1) which dataField to sort with?
              2) sort ascending

            we need 1 of that set for each SLOT being configured
          */
        List<NewQuestPerPromptOpts> qps = _getQuestPromptOptsForDataFieldName(
          thisVisRT,
          requiredPromptInstances,
        );
        perQuestPromptDetails.addAll(qps);
        ConfigLogger.log(
          Level.INFO,
          'requiredPromptInstances: $requiredPromptInstances  produced ${qps.length} NewQuestPerPromptOpts for vrt: ${thisVisRT.name}',
        );
        break;

      case VisRuleQuestType.selectVisualComponentOrStyle:
        // specify desired style on area or slot
        // hack
        List<TvAreaRowStyle> possibleVisStyles = TvAreaRowStyle.values;

        perQuestPromptDetails.add(
          NewQuestPerPromptOpts<TvAreaRowStyle>(
            'Select preferred style for ${newQTargRes.targetPath}?',
            promptTemplArgGen: (prevQuest, newQuestIdx, promptIdx) => [],
            answerChoiceGenerator: (prevQuest, newQuestIdx, int promptIdx) =>
                possibleVisStyles.map((e) => e.name).toList(),
            newRespCastFunc: (QuestBase qb, String ans) {
              int n = int.tryParse(ans) ?? 0;
              return possibleVisStyles[n];
            },
            visRuleType: thisVisRT,
            visRuleQuestType: VisRuleQuestType.selectVisualComponentOrStyle,
          ),
        );
        break;
      // error conditions below
      case VisRuleQuestType.specifySortAscending:
      case VisRuleQuestType.askMenuName:
      case VisRuleQuestType.askJustification:
      case VisRuleQuestType.isCollapsible:
        String m = sprintf(_questGenErrorTemplate, [
          ruleSubtypeNewQuest.name,
          VisRuleQuestType.selectDataFieldName.name,
          thisVisRT.name
        ]);
        throw UnimplementedError(m);
    }

    assert(perQuestPromptDetails.length > 0, 'err: no prompts in question');

    // only 1 subquestion per VRT so below reduce is kinda moot
    String qIdSuffix = _accumSubQuestNames.reduce(
        (String compRuleTypeNames, String rtName) =>
            compRuleTypeNames + '-' + rtName);

    return DerivedQuestGenerator.multiPrompt(
      perQuestPromptDetails,
      newQuestCountCalculator: ((QuestBase qb) => 1),
      genBehaviorOfDerivedQuests: DerivedGenBehaviorOnMatchEnum.noop,
      newQuestIdGenFromPriorQuest: (qb, idx) =>
          qb.questId + '-rdt-$qIdSuffix-$idx',
      newQuestConstructor: QuestBase.visualRuleDetailQuest,
      deriveTargetFromPriorRespCallbk: (QuestBase qb, int newQidx) {
        /*  using QTargetResolution newQTargRes
              passed as argument above
          */
        return newQTargRes.copyWith(visRuleTypeForAreaOrSlot: this);
      },
    );
  }
}

List<NewQuestPerPromptOpts> _getQuestPromptOptsForDataFieldName(
  VisualRuleType topVisRuleType,
  int numOfFieldsToSpecify,
) {
  // applies to sort, filter and group-by ruels
  assert(
    numOfFieldsToSpecify > 0 && numOfFieldsToSpecify < 4,
    'min 1; max 3 options (sort, group, filter)',
  );

  // enclosed functions (_promptTemplArgGenFunc & _newRespCastFunc)
  List<String> _promptTemplArgGenFunc(
    QuestBase priorAnsweredQuest,
    int questIdx,
    int promptIdx,
  ) {
    //
    // assert(questIdx == 1, 'should have 1 quest with multi (up to 6) prompts; is failing ... consider why?');
    assert(
      0 <= promptIdx && promptIdx <= 5,
      'between 2 to 6 total prompts (2 prompts per field)',
    );

    int promptCountByType = topVisRuleType.subPromptCount;
    // data field prompts have between 2-4 questions so adjust promptIdx accordingly
    // divide by promptCountByType and round down (other than zero)
    // to get a value in set (0,1,2,3,4,5)

    int fldPos = (promptIdx > 1) ? promptIdx ~/ promptCountByType : 0;

    String subQuestOrderIdx = _fldPosLookupMap[fldPos] ?? '-$promptIdx-';
    return [
      subQuestOrderIdx,
      priorAnsweredQuest.targetPath,
    ];
  }

  DbTableFieldName _newRespCastFunc(
    QuestBase newQuest,
    String lstAreaIdxs,
  ) {
    List<int> l = castStrOfIdxsToIterOfInts(lstAreaIdxs).toList();
    assert(l.length == 1,
        'exactly 1 fldName required per slot in sort/group/filter');
    return DbTableFieldName.values[l.first];
  }

  List<NewQuestPerPromptOpts> perPromptDetails = [];

  for (int fieldIdx = 0; fieldIdx < numOfFieldsToSpecify; fieldIdx++) {
    // adds 2 prompts for each field question
    // int fieldOrder =
    perPromptDetails.addAll([
      NewQuestPerPromptOpts<DbTableFieldName>(
        VisRuleQuestType.selectDataFieldName
            .questTemplByRuleType(topVisRuleType),
        visRuleQuestType: VisRuleQuestType.selectDataFieldName,
        promptTemplArgGen: _promptTemplArgGenFunc,
        answerChoiceGenerator: (_, __, ___) =>
            DbTableFieldName.values.map((e) => e.name).toList(),
        newRespCastFunc: _newRespCastFunc,
        instanceIdx: fieldIdx,
      ),
      NewQuestPerPromptOpts<bool>(
        // 'Sort Ascending?',
        VisRuleQuestType.specifySortAscending
            .questTemplByRuleType(topVisRuleType),
        visRuleQuestType: VisRuleQuestType.specifySortAscending,
        promptTemplArgGen: (_, __, pi) => [],
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
        instanceIdx: fieldIdx,
      ),
      if (topVisRuleType.appliesToFilterCfg) ...[
        NewQuestPerPromptOpts<String>(
          VisRuleQuestType.askMenuName.questTemplByRuleType(topVisRuleType),
          visRuleQuestType: VisRuleQuestType.askMenuName,
          promptTemplArgGen: (_, __, int pi) => [],
          newRespCastFunc: (
            QuestBase newQuest,
            String menuName,
          ) {
            return menuName;
          },
          answerChoiceGenerator: (
            QuestBase priorAnsweredQuest,
            int newQuestIdx,
            int promptIdx,
          ) {
            // will be skipped without some answer choices avail
            return ['type menu name below ...', ''];
          },
          instanceIdx: fieldIdx,
        ),
      ],
      if (topVisRuleType.appliesToGroupCfg) ...[
        NewQuestPerPromptOpts<DisplayJustification>(
          VisRuleQuestType.askJustification
              .questTemplByRuleType(topVisRuleType),
          visRuleQuestType: VisRuleQuestType.askJustification,
          promptTemplArgGen: (_, __, int pi) => [],
          newRespCastFunc: (
            QuestBase newQuest,
            String ansIdx,
          ) {
            return DisplayJustification.values[int.tryParse(ansIdx) ?? 0];
          },
          answerChoiceGenerator: (
            QuestBase priorAnsweredQuest,
            int newQuestIdx,
            int promptIdx,
          ) {
            return DisplayJustification.values.map((e) => e.name).toList();
          },
          instanceIdx: fieldIdx,
        ),
        NewQuestPerPromptOpts<bool>(
          VisRuleQuestType.isCollapsible.questTemplByRuleType(topVisRuleType),
          visRuleQuestType: VisRuleQuestType.isCollapsible,
          promptTemplArgGen: (_, __, int pi) => [],
          newRespCastFunc: (
            QuestBase newQuest,
            String ansIdx,
          ) {
            return ansIdx == '1';
          },
          answerChoiceGenerator: (
            QuestBase priorAnsweredQuest,
            int newQuestIdx,
            int promptIdx,
          ) {
            return ['no', 'yes'];
          },
          instanceIdx: fieldIdx,
        ),
      ],
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

enum RuleSelectionOffsetBehavior {
  /* for handling questions in which user-answer
    is split between multiple matchers
    eg some rules requiring prep-question
      and others going straight for rule-detail
  */
  none,
  selectFromVrtNeedPrep,
  selectFromVrtNoPrep,
}

// extension RuleSelectionOffsetBehaviorExt1 on RuleSelectionOffsetBehavior {
//   // return properties needed on RuleSelectQuest instance
// }

  // List<String> _answerChoiceGeneratorFunc(
  //   QuestBase priorAnsweredQuest,
  //   int newQuestIdx,
  //   int promptIdx,
  // ) {
  //   // in future it might be nice to filter out fields user has already selected
  //   return DbTableFieldName.values.map((e) => e.name).toList();
  // }