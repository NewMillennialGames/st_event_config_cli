part of EvCfgEnums;

@JsonEnum()
enum VisRuleQuestType {
  /* describes
    general structure of the possible Quest2s to be asked
    for a given Visibility-Rule

    in other words, HOW MANY pieces of data needs to be
    collected to properly build a complete rule

  */
  dialogStruct,
  selectDataFieldName,
  askCountOfSlotsToConfigure,
  specifySortAscending,
  selectVisualComponentOrStyle,
  controlsVisibilityOfAreaOrSlot,
}

extension VisRuleQuestTypeExt1 on VisRuleQuestType {
  //

  String questTemplByRuleType(VisualRuleType ruleTyp) {
    /* return Question template for each of these rules


    */
    String resp = '_unset';
    switch (this) {
      case VisRuleQuestType.dialogStruct:
        return 'Only relates to dialog structure;  not building real config rules';
      case VisRuleQuestType.selectDataFieldName:
        return 'Select field containing the value you wish to use for {0}';
      case VisRuleQuestType.askCountOfSlotsToConfigure:
        return 'How many Group/Sort/Filter positions do you want to set on {0}';
      case VisRuleQuestType.specifySortAscending:
        return 'Sort Ascending';
      case VisRuleQuestType.selectVisualComponentOrStyle:
        switch (ruleTyp) {
          case VisualRuleType.styleOrFormat:
            resp = 'Pick the Component or Style that applies to target {0}';
            break;
          default:
            resp =
                'err: Pick the Component or Style that applies to {slot} {area} of {screen} screen';
        }
        return resp;
      case VisRuleQuestType.controlsVisibilityOfAreaOrSlot:
        return 'Show this area/slot within {0}?';
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

  List<VisRuleQuestType> subquestionsForEachPrepInstance(VisualRuleType vrt) {
    /* sub-questions to ask for a given combo of 
        VisualRuleType and VisRuleQuestType
    */
    switch (this) {
      case VisRuleQuestType.dialogStruct:
        // placeholder;  related to a top-level question
        return [];
      case VisRuleQuestType.selectDataFieldName:
        return [];
      case VisRuleQuestType.askCountOfSlotsToConfigure:
        return [
          VisRuleQuestType.selectDataFieldName,
          VisRuleQuestType.specifySortAscending,
        ];
      case VisRuleQuestType.specifySortAscending:
        return [];
      case VisRuleQuestType.selectVisualComponentOrStyle:
        return [];
      case VisRuleQuestType.controlsVisibilityOfAreaOrSlot:
        return [];
    }
  }

  int get defaultChoice {
    // each Quest2 can have different default choice
    return 0;
  }
}
