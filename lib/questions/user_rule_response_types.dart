part of InputModels;

abstract class RuleResponseWrapperIfc {
  // handles answers for real Rule questions
  // receive user-answers IN
  void castResponsesToAnswerTypes(Map<VisRuleQuestType, String> responses);
  // send user answers OUT as whatever class rule is
  RuleResponseBase get asRuleResponse;
  // bool get gens2ndOr3rdSortGroupFilterQuests;
}

@JsonSerializable()
class RuleResponseBase implements RuleResponseWrapperIfc {
  /* base class for user answers to rule questions
    it implements the interface
    and calls subclass methods to do the hard work
  */
  VisualRuleType ruleType;

  // @JsonKey(ignore: true)
  late final Map<VisRuleQuestType, String> userResponses;

  RuleResponseBase(this.ruleType);

  List<VisRuleQuestType> get requiredQuestions => ruleType.requiredQuestions;
  // @override
  // bool get gens2ndOr3rdSortGroupFilterQuests => false;
  //
  RuleResponseBase get asRuleResponse =>
      throw UnimplementedError('impl in sub class');

  void _checkArgs(Map<VisRuleQuestType, String> responses) {
    assert(
      this.requiredQuestions.length == responses.length,
      'not enough answers passed: got ${responses.length} exp: ${this.requiredQuestions.length}',
    );
  }

  void castResponsesToAnswerTypes(Map<VisRuleQuestType, String> responses) {
    /* let this method fill the userResponses map
    (same for all rule-types)
    and then call a subclass method to parse the strings
    into actual data-types

    only called once per instance so I'm not sure why
    i'm looping instead of assigning; oh, its final
    */
    _checkArgs(responses);
    this.userResponses = responses;
    // for (MapEntry<VisRuleQuestType, String> e in responses.entries) {
    //   this.userResponses[e.key] = e.value;
    // }
    // each subclass should impl its own method
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
  factory RuleResponseBase.fromJson(Map<String, dynamic> json) {
    //
    // return _$RuleResponseBaseFromJson(json);
    VisualRuleType rt =
        VisualRuleType.values.where((e) => e.name == json['ruleType']).first;
    switch (rt) {
      case VisualRuleType.filterCfg:
        return TvFilterCfg.fromJson(json);
      case VisualRuleType.showOrHide:
        return ShowHideCfg.fromJson(json);
      case VisualRuleType.sortCfg:
        return TvSortCfg.fromJson(json);
      case VisualRuleType.styleOrFormat:
        return TvRowStyleCfg.fromJson(json);
    }
  }

  Map<String, dynamic> toJson() {
    // print('######  RuleResponseBaseToJson:  did run this');
    // return _$RuleResponseBaseToJson(this);
    throw UnimplementedError('should only run on subclass');
  }
}

// table row style
@JsonSerializable()
class TvRowStyleCfg extends RuleResponseBase {
  //
  late TvAreaRowStyle selectedRowStyle;

  TvRowStyleCfg() : super(VisualRuleType.styleOrFormat);

  TvRowStyleCfg get asRuleResponse => this;

  // receive str data into instance & make it structured data
  @override
  void _castToRealTypes() {
    VisRuleQuestType key = requiredQuestions.first;
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

// base for all classes that track these 3 fields
// @JsonSerializable()
class TvSortGroupFilterBase extends RuleResponseBase {
  //
  late DbTableFieldName colName;
  late bool asc = false;

  TvSortGroupFilterBase(VisualRuleType rt) : super(rt);
  //
  @override
  TvSortGroupFilterBase get asRuleResponse => this;

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
        // case VisRuleQuestType.specifyPositionInGroup:
        //   this.order = SortOrGroupIdxOrder.values[answIdx];
        //   break;
        case VisRuleQuestType.specifySortAscending:
          this.asc = answIdx == 1;
          break;
      }
    }
  }

  @override
  String toString() {
    String className = this.runtimeType.toString();
    return '$className for ${ruleType.name} with responses: $_answerSummary';
  }

  String get _answerSummary => '${colName.name}-$asc';
}

@JsonSerializable()
class TvSortCfg extends TvSortGroupFilterBase {
  //
  TvSortCfg() : super(VisualRuleType.sortCfg);
  //
  // JsonSerializable
  factory TvSortCfg.fromJson(Map<String, dynamic> json) =>
      _$TvSortCfgFromJson(json);
  Map<String, dynamic> toJson() => _$TvSortCfgToJson(this);
}

// @JsonSerializable()
// class TvGroupCfg extends TvSortGroupFilterBase {
//   //
//   TvGroupCfg() : super(VisualRuleType.groupCfg);
//   //

//   // JsonSerializable
//   factory TvGroupCfg.fromJson(Map<String, dynamic> json) =>
//       _$TvGroupCfgFromJson(json);
//   Map<String, dynamic> toJson() => _$TvGroupCfgToJson(this);
// }

@JsonSerializable()
class TvFilterCfg extends TvSortGroupFilterBase {
  //
  TvFilterCfg() : super(VisualRuleType.filterCfg);
  //
  // JsonSerializable
  factory TvFilterCfg.fromJson(Map<String, dynamic> json) =>
      _$TvFilterCfgFromJson(json);
  Map<String, dynamic> toJson() => _$TvFilterCfgToJson(this);
}

@JsonSerializable()
class ShowHideCfg extends RuleResponseBase {
  //
  late bool shouldShow;

  ShowHideCfg() : super(VisualRuleType.showOrHide);
  //
  ShowHideCfg get asRuleResponse => this;

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
