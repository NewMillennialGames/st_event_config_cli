part of InputModels;

abstract class RuleResponseWrapperIfc {
  // handles answers for real Rule questions
  void castResponsesToAnswerTypes(Map<VisRuleQuestType, String> responses);
  List<AppVisualRuleBase> asVisualRules();
}

@JsonSerializable()
class RuleResponseBase implements RuleResponseWrapperIfc {
  /* base class for user answers to rule questions

  */
  final VisualRuleType ruleType;
  final Map<VisRuleQuestType, String> userResponses = {};

  RuleResponseBase(this.ruleType);

  List<VisRuleQuestType> get requiredQuestions => ruleType.requiredQuestions;

  List<AppVisualRuleBase> asVisualRules() {
    // run subclass method
    return _castToVisualRules();
  }

  List<AppVisualRuleBase> _castToVisualRules() {
    throw UnimplementedError('impl in subclass');
  }

  void _checkArgs(Map<VisRuleQuestType, String> responses) {
    assert(
      this.requiredQuestions.length == responses.length,
      'not enough answers passed: got ${responses.length} exp: ${this.requiredQuestions.length}',
    );
  }

  void castResponsesToAnswerTypes(Map<VisRuleQuestType, String> responses) {
    /* can probably let this method fill the userResponses map
    (same for all rule-types)
    and then call a subclass method to parse the strings
    into actual data-types
    */
    _checkArgs(responses);
    for (MapEntry<VisRuleQuestType, String> e in responses.entries) {
      this.userResponses[e.key] = e.value;
    }
    _castToRealTypes();
  }

  void _castToRealTypes() {
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

@JsonSerializable()
class TvRowStyleCfg extends RuleResponseBase {
  //
  late TvAreaRowStyle selectedRowStyle;

  TvRowStyleCfg() : super(VisualRuleType.styleOrFormat);

  @override
  List<StyleOrFormatRule> _castToVisualRules() {
    return [this.ruleType.castPropertyMapToRule(this) as StyleOrFormatRule];
  }

  // void castResponsesToAnswerTypes(Map<VisRuleQuestType, String> responses) {
  //   //
  //   _checkArgs(responses);
  //   for (MapEntry<VisRuleQuestType, String> e in responses.entries) {
  //     this.userResponses[e.key] = e.value;
  //   }
  //   _castToRealTypes();
  // }

  @override
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

  // @override
  // void castResponsesToAnswerTypes(
  //   Map<VisRuleQuestType, String> responses,
  // ) {
  //   //
  //   _checkArgs(responses);

  //   for (MapEntry<VisRuleQuestType, String> e in responses.entries) {
  //     this.userResponses[e.key] = e.value;
  //   }
  //   _castToRealTypes();
  // }

  @override
  List<GroupRule> _castToVisualRules() {
    return [this.ruleType.castPropertyMapToRule(this) as GroupRule];
  }

  @override
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

@JsonSerializable()
class TvFilterCfg extends RuleResponseBase {
  //
  late DbTableFieldName colName;
  late SortOrGroupIdxOrder order;
  late bool asc = false;

  TvFilterCfg() : super(VisualRuleType.filterCfg);
  TvFilterCfg.byType(VisualRuleType rt) : super(rt);

  // @override
  // void castResponsesToAnswerTypes(
  //   Map<VisRuleQuestType, String> responses,
  // ) {
  //   //
  //   _checkArgs(responses);
  //   for (MapEntry<VisRuleQuestType, String> e in responses.entries) {
  //     this.userResponses[e.key] = e.value;
  //   }
  //   _castToRealTypes();
  // }

  @override
  List<FilterRule> _castToVisualRules() {
    return [this.ruleType.castPropertyMapToRule(this) as FilterRule];
  }

  @override
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
  factory TvFilterCfg.fromJson(Map<String, dynamic> json) =>
      _$TvFilterCfgFromJson(json);
  Map<String, dynamic> toJson() => _$TvFilterCfgToJson(this);
}

@JsonSerializable()
class ShowHideCfg extends RuleResponseBase {
  //
  late bool shouldShow;

  ShowHideCfg() : super(VisualRuleType.styleOrFormat);

  // @override
  // void castResponsesToAnswerTypes(Map<VisRuleQuestType, String> responses) {
  //   //
  //   _checkArgs(responses);
  //   for (MapEntry<VisRuleQuestType, String> e in responses.entries) {
  //     this.userResponses[e.key] = e.value;
  //   }
  //   _castToRealTypes();
  // }

  @override
  List<ShowRule> _castToVisualRules() {
    return [this.ruleType.castPropertyMapToRule(this) as ShowRule];
  }

  @override
  void _castToRealTypes() {
    this.shouldShow =
        userResponses[VisRuleQuestType.controlsVisibilityOfAreaOrSlot] != '0';
  }

  @override
  String toString() {
    return 'ShowHideCfg for ${ruleType.name} should show: $shouldShow';
  }

  // JsonSerializable
  factory ShowHideCfg.fromJson(Map<String, dynamic> json) =>
      _$ShowHideCfgFromJson(json);
  Map<String, dynamic> toJson() => _$ShowHideCfgToJson(this);
}
