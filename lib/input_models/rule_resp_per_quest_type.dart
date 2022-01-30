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

  @override
  String toString() {
    return 'RuleResponseBase for ${ruleType.name} with ${userResponses.length} responses';
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

  @override
  String toString() {
    return 'TvRowStyleCfg for ${ruleType.name} applying rowstyle: ${selectedRowStyle.name}';
  }

  // JsonSerializable
  factory TvRowStyleCfg.fromJson(Map<String, dynamic> json) =>
      _$TvRowStyleCfgFromJson(json);
  Map<String, dynamic> toJson() => _$TvRowStyleCfgToJson(this);
}

@JsonSerializable()
class TvSortOrGroupCfg extends RuleResponseBase {
  //
  late DbTableFieldName colName;
  late SortOrGroupIdxOrder order;
  late bool asc = false;

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
        case VisRuleQuestType.specifyPositionInGroup:
          this.order = SortOrGroupIdxOrder.values[answIdx];
          break;
        case VisRuleQuestType.specifySortAscending:
          this.asc = answIdx == 1;
          break;
      }
    }
  }

  @override
  String toString() {
    return 'TvSortOrGroupCfg for ${ruleType.name} with responses: $_answerSummary';
  }

  String get _answerSummary => '${colName.name}-${order.name}-$asc';

  // JsonSerializable
  factory TvSortOrGroupCfg.fromJson(Map<String, dynamic> json) =>
      _$TvSortOrGroupCfgFromJson(json);
  Map<String, dynamic> toJson() => _$TvSortOrGroupCfgToJson(this);
}
