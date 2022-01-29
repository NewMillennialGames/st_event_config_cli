part of EvCfgEnums;

@JsonEnum()
enum VisRuleQuestType {
  /* describes
    general structure of the possible questions to be asked
    for a given Visibility-Rule

    in other words, HOW MANY pieces of data needs to be
    collected to properly build a complete rule
  */
  // getTableName,
  selectDataFieldName,
  specifyPositionInGroup,
  specifySortAscending,
  selectVisualComponentOrStyle,
  controlsVisibilityOfAreaOrSlot,
}

extension VisRuleQuestTypeExt1 on VisRuleQuestType {
  //

  String questTemplByRuleType(VisualRuleType ruleTyp) {
    /* return question template for each of these rules


    */
    String resp = '_unset';
    switch (this) {
      // case VisRuleQuestType.getTableName:
      //   return 'Select Table that contains required value';
      case VisRuleQuestType.selectDataFieldName:
        return 'Select field containg (sort, group, filter) value';
      case VisRuleQuestType.specifyPositionInGroup:
        return 'Select Group/Sort/Filter position';
      case VisRuleQuestType.specifySortAscending:
        return 'Sort Ascending';
      case VisRuleQuestType.selectVisualComponentOrStyle:
        switch (ruleTyp) {
          case VisualRuleType.styleOrFormat:
            resp =
                'Pick the Component or Style that applies to {slot} on {area} of {screen} screen';
            break;
          default:
            resp =
                'err: Pick the Component or Style that applies to {slot} {area} of {screen} screen';
        }
        return resp;
      case VisRuleQuestType.controlsVisibilityOfAreaOrSlot:
        return 'Show this area/slot?';
    }
  }

  List<String> get choices {
    switch (this) {
      // case VisRuleQuestType.getTableName:
      //   return DbRowType.values.map((e) => e.name).toList();
      case VisRuleQuestType.selectDataFieldName:
        return RowPropertylName.values.map((e) => e.name).toList();
      case VisRuleQuestType.specifyPositionInGroup:
        return SortOrGroupIdxOrder.values.map((e) => e.name).toList();
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

  int get _defaultChoice {
    // each question can have different default choice
    return 0;
  }
}


// T castStringToExpectedResponseType<T>(
  //   String userResp, [
  //   int defaultChoice = -1,
  // ]) {
  //   // variable defaults based on type of this
  //   defaultChoice = defaultChoice > -1 ? defaultChoice : this._defaultChoice;
  //   int asIdx = int.tryParse(userResp) ?? defaultChoice;
  //   switch (this) {
  //     case VisRuleQuestType.getValueFromTableAndField:
  //       return DbRowType.values[asIdx] as T;
  //     case VisRuleQuestType.selectFieldForSortOrGroup:
  //       return RowPropertylName.values[asIdx] as T;
  //     case VisRuleQuestType.specifyPositionInGroup:
  //       return MenuSortOrGroupIndex.values[asIdx] as T;
  //     case VisRuleQuestType.setSortOrder:
  //       return ((asIdx == 1) ? true : false) as T;
  //     case VisRuleQuestType.selectVisualComponentOrStyle:
  //       return TvAreaRowStyle.values[asIdx] as T;
  //     case VisRuleQuestType.controlsVisibilityOfAreaOrSlot:
  //       return ((asIdx == 1) ? true : false) as T;
  //   }
  // }

  // Type get expectedTypeOfResponse {
  //   switch (this) {
  //     case VisRuleQuestType.getValueFromTableAndField:
  //       return DbRowType;
  //     case VisRuleQuestType.selectFieldForSortOrGroup:
  //       return RowPropertylName;
  //     case VisRuleQuestType.specifyPositionInGroup:
  //       return MenuSortOrGroupIndex;
  //     case VisRuleQuestType.setSortOrder:
  //       return bool;
  //     case VisRuleQuestType.selectVisualComponentOrStyle:
  //       return TvAreaRowStyle;
  //     case VisRuleQuestType.controlsVisibilityOfAreaOrSlot:
  //       return bool;
  //   }
  // }