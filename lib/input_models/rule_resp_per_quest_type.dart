part of InputModels;

// TODO:
// enum VisualRuleType {
//   groupCfg,
//   filterCfg,
//   showOrHide,

@JsonSerializable()
class TvRowStyleCfg extends RuleResponseWrapper {
  //
  late TvAreaRowStyle selectedRowStyle;

  TvRowStyleCfg() : super(VisualRuleType.styleOrFormat);

  @override
  void castResponsesToAnswerTypes(Map<VisRuleQuestType, String> responses) {
    //
    for (MapEntry e in responses.entries) {
      this.userResponses[e.key] = e.value;
    }
    _castToRealTypes();
  }

  void _castToRealTypes() {
    String uResp =
        userResponses[VisRuleQuestType.selectVisualComponentOrStyle] ?? '0';
    int uRespIdx = int.tryParse(uResp) ?? 0;

    this.selectedRowStyle = TvAreaRowStyle.values[uRespIdx];
  }
}

@JsonSerializable()
class TvSortCfg extends RuleResponseWrapper {
  //
  late String tableName;
  late String colName;
  late SortOrGroupIdxOrder order;
  late bool asc;

  TvSortCfg() : super(VisualRuleType.sortCfg);

  @override
  void castResponsesToAnswerTypes(Map<VisRuleQuestType, String> responses) {
    //
    for (MapEntry e in responses.entries) {
      this.userResponses[e.key] = e.value;
    }
    _castToRealTypes();
  }

  void _castToRealTypes() {
    //
    for (VisRuleQuestType qt in VisualRuleType.sortCfg.questionsRequired) {
      String resp = this.userResponses[qt] ?? '';

      switch (qt) {
        case VisRuleQuestType.selectDataFieldName:
          this.tableName = resp;
          break;
        case VisRuleQuestType.specifySortAscending:
          this.order = SortOrGroupIdxOrder.values[int.tryParse(resp) ?? 0];
          break;
        case VisRuleQuestType.specifyPositionInGroup:
          this.order = SortOrGroupIdxOrder.values[int.tryParse(resp) ?? 0];
          break;
      }
    }
  }
}
