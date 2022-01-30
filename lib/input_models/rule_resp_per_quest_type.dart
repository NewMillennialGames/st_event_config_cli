part of InputModels;

@JsonSerializable()
class RuleResponseBase implements RuleResponseWrapperIfc {
  //
  // holds user answers to rule questions
  final VisualRuleType ruleType;
  final Map<VisRuleQuestType, String> userResponses = {};

  RuleResponseBase(this.ruleType);

  List<VisRuleQuestType> get requiredQuestions => ruleType.requiredQuestions;

  void castResponsesToAnswerTypes(Map<VisRuleQuestType, String> responses) {
    throw UnimplementedError('impl in subclass');
  }

  // JsonSerializable
  factory RuleResponseBase.fromJson(Map<String, dynamic> json) =>
      _$RuleResponseBaseFromJson(json);
  Map<String, dynamic> toJson() => _$RuleResponseBaseToJson(this);
}

// TODO:
// enum VisualRuleType {
//   groupCfg,
//   filterCfg,
//   showOrHide,

@JsonSerializable()
class TvRowStyleCfg extends RuleResponseBase implements RuleResponseWrapperIfc {
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
class TvSortOrGroupCfg extends RuleResponseBase {
  //
  late DbTableFieldName colName;
  late SortOrGroupIdxOrder order;
  late bool asc;

  TvSortOrGroupCfg() : super(VisualRuleType.sortCfg);
  TvSortOrGroupCfg.byType(VisualRuleType rt) : super(rt);

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
