part of EvCfgEnums;

enum VisRuleQuestType {
  // possible questions to be asked
  // for a given Vis-Rule
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
        return [
          'yes',
          'no',
        ];
      case VisRuleQuestType.whichRowStyle:
        return TvAreaRowStyle.values.map((e) => e.name).toList();
      case VisRuleQuestType.shouldShow:
        return [
          'yes',
          'no',
        ];
    }
    // return [];
  }
}
