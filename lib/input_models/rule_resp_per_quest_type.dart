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
    for (MapEntry<VisRuleQuestType, String> e in responses.entries) {
      this.userResponses[e.key] = e.value;
    }
    _castToRealTypes();
  }

  void _castToRealTypes() {
    VisRuleQuestType key = requiredQuestions.first; // ?? ;
    assert(key == VisRuleQuestType.selectVisualComponentOrStyle);
    String uResp = userResponses[key] ?? '0';
    int uRespIdx = int.tryParse(uResp) ?? 0;
    this.selectedRowStyle = TvAreaRowStyle.values[uRespIdx];
  }
}

@JsonSerializable()
class TvSortCfg extends RuleResponseWrapper {
  //
  late DbTableFieldName colName;
  late SortOrGroupIdxOrder order;
  late bool asc;

  TvSortCfg() : super(VisualRuleType.sortCfg);

  @override
  void castResponsesToAnswerTypes(
    Map<VisRuleQuestType, String> responses,
  ) {
    //
    assert(
      this.requiredQuestions.length == responses.length,
      'not enough answers passed',
    );

    for (MapEntry<VisRuleQuestType, String> e in responses.entries) {
      this.userResponses[e.key] = e.value;
    }
    _castToRealTypes();
  }

  void _castToRealTypes() {
    /* for these answers:
        Vrq.selectDataFieldName,
        Vrq.specifyPositionInGroup,
        Vrq.specifySortAscending
    */
    for (MapEntry e in this.userResponses.entries) {
      String resp = e.value;
      int answIdx = int.tryParse(resp) ?? 0;

      switch (e.key) {
        case VisRuleQuestType.selectDataFieldName:
          this.colName = DbTableFieldName.values[answIdx];
          break;
        case VisRuleQuestType.specifySortAscending:
          this.order = SortOrGroupIdxOrder.values[answIdx];
          break;
        case VisRuleQuestType.specifySortAscending:
          this.asc = answIdx == 1;
          break;
      }
    }
  }
}
