part of EvCfgEnums;

enum VisRuleQuestType {
  // possible questions to be asked
  // for a given Visibility-Rule
  whichTable,
  whichField,
  whichLevelPos,
  isAscending,
  whichRowStyle,
  shouldShow,
}

extension VisRuleQuestTypeExt1 on VisRuleQuestType {
  //
  String questionTemplate() {
    return 'DialogRuleQuestType.questionTemplate';
  }

  List<String> get choices {
    switch (this) {
      case VisRuleQuestType.whichTable:
        return DbRowType.values.map((e) => e.name).toList();
      case VisRuleQuestType.whichField:
        return RowPropertylName.values.map((e) => e.name).toList();
      case VisRuleQuestType.whichLevelPos:
        return MenuSortOrGroupIndex.values.map((e) => e.name).toList();
      case VisRuleQuestType.isAscending:
        // idx 0 == no;  1 == yes;  dont reverse these
        return [
          'no',
          'yes',
        ];
      case VisRuleQuestType.whichRowStyle:
        return TvAreaRowStyle.values.map((e) => e.name).toList();
      case VisRuleQuestType.shouldShow:
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
      case VisRuleQuestType.whichTable:
        return DbRowType.values[asIdx] as T;
      case VisRuleQuestType.whichField:
        return RowPropertylName.values[asIdx] as T;
      case VisRuleQuestType.whichLevelPos:
        return MenuSortOrGroupIndex.values[asIdx] as T;
      case VisRuleQuestType.isAscending:
        return ((asIdx == 1) ? true : false) as T;
      case VisRuleQuestType.whichRowStyle:
        return TvAreaRowStyle.values[asIdx] as T;
      case VisRuleQuestType.shouldShow:
        return ((asIdx == 1) ? true : false) as T;
    }
  }

  Type get expectedTypeOfResponse {
    switch (this) {
      case VisRuleQuestType.whichTable:
        return DbRowType;
      case VisRuleQuestType.whichField:
        return RowPropertylName;
      case VisRuleQuestType.whichLevelPos:
        return MenuSortOrGroupIndex;
      case VisRuleQuestType.isAscending:
        return bool;
      case VisRuleQuestType.whichRowStyle:
        return TvAreaRowStyle;
      case VisRuleQuestType.shouldShow:
        return bool;
    }
  }

  int get _defaultChoice {
    // each question can have different default choice
    return 0;
  }
}
