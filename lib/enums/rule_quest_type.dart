part of EvCfgEnums;

@JsonEnum()
enum VisRuleQuestType {
  /* general structure of the possible questions to be asked
    for a given Visibility-Rule

    in other words, HOW MANY pieces of data needs to be
    collected to properly build a complete rule
  */
  getValueFromTableAndField,
  selectFieldForSortOrGroup,
  specifyPositionInGroup,
  setSortOrder,
  selectVisualComponentOrStyle,
  controlsVisibilityOfAreaOrSlot,
}

extension VisRuleQuestTypeExt1 on VisRuleQuestType {
  //
  String templateForRuleType(VisualRuleType ruleTyp) {
    /* return question template for each of these rules


    */
    String resp = '_unset';
    switch (this) {
      case VisRuleQuestType.getValueFromTableAndField:
        return 'Specify source for value (table and field)';
      case VisRuleQuestType.selectFieldForSortOrGroup:
        return 'Select sort field (table and field)';
      case VisRuleQuestType.specifyPositionInGroup:
        return 'Select Group position';
      case VisRuleQuestType.setSortOrder:
        return 'Select Sort position';
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
        return 'Should show this area/slot?';
    }
    // return 'DialogRuleQuestType.questionTemplate';
  }

  List<String> get choices {
    switch (this) {
      case VisRuleQuestType.getValueFromTableAndField:
        return DbRowType.values.map((e) => e.name).toList();
      case VisRuleQuestType.selectFieldForSortOrGroup:
        return RowPropertylName.values.map((e) => e.name).toList();
      case VisRuleQuestType.specifyPositionInGroup:
        return MenuSortOrGroupIndex.values.map((e) => e.name).toList();
      case VisRuleQuestType.setSortOrder:
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

  T castStringToExpectedResponseType<T>(
    String userResp, [
    int defaultChoice = -1,
  ]) {
    // variable defaults based on type of this
    defaultChoice = defaultChoice > -1 ? defaultChoice : this._defaultChoice;
    int asIdx = int.tryParse(userResp) ?? defaultChoice;
    switch (this) {
      case VisRuleQuestType.getValueFromTableAndField:
        return DbRowType.values[asIdx] as T;
      case VisRuleQuestType.selectFieldForSortOrGroup:
        return RowPropertylName.values[asIdx] as T;
      case VisRuleQuestType.specifyPositionInGroup:
        return MenuSortOrGroupIndex.values[asIdx] as T;
      case VisRuleQuestType.setSortOrder:
        return ((asIdx == 1) ? true : false) as T;
      case VisRuleQuestType.selectVisualComponentOrStyle:
        return TvAreaRowStyle.values[asIdx] as T;
      case VisRuleQuestType.controlsVisibilityOfAreaOrSlot:
        return ((asIdx == 1) ? true : false) as T;
    }
  }

  Type get expectedTypeOfResponse {
    switch (this) {
      case VisRuleQuestType.getValueFromTableAndField:
        return DbRowType;
      case VisRuleQuestType.selectFieldForSortOrGroup:
        return RowPropertylName;
      case VisRuleQuestType.specifyPositionInGroup:
        return MenuSortOrGroupIndex;
      case VisRuleQuestType.setSortOrder:
        return bool;
      case VisRuleQuestType.selectVisualComponentOrStyle:
        return TvAreaRowStyle;
      case VisRuleQuestType.controlsVisibilityOfAreaOrSlot:
        return bool;
    }
  }

  int get _defaultChoice {
    // each question can have different default choice
    return 0;
  }
}
