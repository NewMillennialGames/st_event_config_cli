part of EvCfgEnums;

@JsonEnum()
enum VisRuleQuestType {
  /* describes
    general structure of the possible Quest2s to be asked
    for a given Visibility-Rule

    in other words, HOW MANY pieces of data needs to be
    collected to properly build a complete rule

  */
  dialogStruct, // noop
  askCountOfSlotsToConfigure, // possibly niu
  selectDataFieldName,
  specifySortAscending,
  selectVisualComponentOrStyle,
  controlsVisibilityOfAreaOrSlot,
}

extension VisRuleQuestTypeExt1 on VisRuleQuestType {
  //

  String questTemplByRuleType(VisualRuleType visRuleTyp) {
    /* return Question template for each of these rules

    */
    assert(visRuleTyp != VisualRuleType.filterCfg, 'caught you!!');
    String resp = '_unset';
    switch (this) {
      case VisRuleQuestType.dialogStruct:
        return 'Err: Only relates to dialog structure;  not building real config rules';
      case VisRuleQuestType.askCountOfSlotsToConfigure:
        return 'How many {0} (Group/Sort/Filter) fields do you want to use on {1}';
      case VisRuleQuestType.selectDataFieldName:
        switch (visRuleTyp) {
          case VisualRuleType.groupCfg:
            resp = 'Select {0} field you wish to use for grouping on {1}';
            break;
          case VisualRuleType.sortCfg:
            resp = 'Select {0} field you wish to use for sorting on {1}';
            break;
          case VisualRuleType.filterCfg:
            resp = 'Select {0} field you wish to use for filtering on {1}';
            break;
          default:
            resp = 'err: Select {0} field you wish to use for ??? on {1}';
        }
        return resp;

      case VisRuleQuestType.specifySortAscending:
        return 'Sort Ascending';
      case VisRuleQuestType.selectVisualComponentOrStyle:
        switch (visRuleTyp) {
          case VisualRuleType.styleOrFormat:
            resp = 'Pick the Component or Style to apply on target {0}';
            break;
          default:
            resp =
                'err: Pick the Component or Style that applies to {slot} {area} of {screen} screen';
        }
        return resp;
      case VisRuleQuestType.controlsVisibilityOfAreaOrSlot:
        return 'Show this region within {0} (area or slot)?';
    }
  }

  List<String> get answPromptChoices {
    switch (this) {
      case VisRuleQuestType.dialogStruct:
        // placeholder;  related to a top-level question
        return [];
      case VisRuleQuestType.selectDataFieldName:
        return DbTableFieldName.values.map((e) => e.name).toList();
      case VisRuleQuestType.askCountOfSlotsToConfigure:
        return ['0', '1', '2', '3'];
      case VisRuleQuestType.specifySortAscending:
        // idx 0 == no;  1 == yes;  dont reverse these
        return [
          'no',
          'yes',
        ];
      case VisRuleQuestType.selectVisualComponentOrStyle:
        return TvAreaRowStyle.values.map((e) => e.name).toList();
      case VisRuleQuestType.controlsVisibilityOfAreaOrSlot:
        // idx 0 == no;  1 == yes;  dont reverse these
        return [
          'no',
          'yes',
        ];
    }
  }

  // List<VisRuleQuestType> subquestionsForEachPrepInstance(VisualRuleType vrt) {
  //   /* sub-questions to ask for a given combo of
  //       VisualRuleType and VisRuleQuestType
  //   */
  //   switch (this) {
  //     case VisRuleQuestType.dialogStruct:
  //       // placeholder;  related to a top-level question
  //       return [];
  //     case VisRuleQuestType.selectDataFieldName:
  //       return [];
  //     case VisRuleQuestType.askCountOfSlotsToConfigure:
  //       return [
  //         VisRuleQuestType.selectDataFieldName,
  //         VisRuleQuestType.specifySortAscending,
  //       ];
  //     case VisRuleQuestType.specifySortAscending:
  //       return [];
  //     case VisRuleQuestType.selectVisualComponentOrStyle:
  //       return [];
  //     case VisRuleQuestType.controlsVisibilityOfAreaOrSlot:
  //       return [];
  //   }
  // }

  int get defaultChoice {
    // each Quest2 can have different default choice
    return 0;
  }
}
