part of QuestionsLib;

/*
  data-types of all user answers must implement RuleResponseWrapperIfc Ifc
*/

abstract class RuleResponseWrapperIfc {
  // handles answers for real Rule Quest2s
  // receive user-answers IN
  void castResponsesToAnswerTypes(List<PairedQuestAndResp> responses);
  // send user answers OUT as whatever class rule is

  VisualRuleType get ruleType;
  List<VisRuleQuestType> get requiredQuestions;
}

@JsonSerializable()
class RuleResponseBase implements RuleResponseWrapperIfc {
  /* base class for user answers to rule Quest2s
    it implements the interface
    and calls subclass methods to do the hard work
  */
  VisualRuleType ruleType;

  RuleResponseBase(this.ruleType);

  List<VisRuleQuestType> get requiredQuestions =>
      ruleType.requRuleDetailCfgQuests;

  void _checkArgs(List<PairedQuestAndResp> responses) {
    assert(
      this.requiredQuestions.length == responses.length,
      'not enough answers passed: got ${responses.length} exp: ${this.requiredQuestions.length}',
    );
  }

  void castResponsesToAnswerTypes(List<PairedQuestAndResp> responses) {
    /* let this method fill the userResponses map
    (same for all rule-types)
    and then call a subclass method to parse the strings
    into actual data-types

    only called once per instance so I'm not sure why
    i'm looping instead of assigning; oh, its final
    */
    _checkArgs(responses);
    // each subclass should impl its own _castToRealTypes() method
    _castToRealTypes(responses);
  }

  void _castToRealTypes(List<PairedQuestAndResp> userResponses) {
    throw UnimplementedError('implement in subclass');
  }

  @override
  String toString() {
    return 'RuleResp for ${ruleType.name}';
  }

  // JsonSerializable
  factory RuleResponseBase.fromJson(Map<String, dynamic> json) {
    //
    VisualRuleType rt =
        VisualRuleType.values.where((e) => e.name == json['ruleType']).first;
    switch (rt) {
      case VisualRuleType.generalDialogFlow:
        // never should run
        assert(false, 'whoops?');
        return TvFilterCfg.fromJson(json);
      case VisualRuleType.filterCfg:
        return TvFilterCfg.fromJson(json);
      case VisualRuleType.showOrHide:
        return ShowHideCfg.fromJson(json);
      case VisualRuleType.sortCfg:
        return TvSortCfg.fromJson(json);
      case VisualRuleType.groupCfg:
        return TvGroupCfg.fromJson(json);
      case VisualRuleType.styleOrFormat:
        return TvRowStyleCfg.fromJson(json);
      case VisualRuleType.themePreference:
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

  TvRowStyleCfg._(this.selectedRowStyle) : super(VisualRuleType.styleOrFormat);
  TvRowStyleCfg() : super(VisualRuleType.styleOrFormat);

  factory TvRowStyleCfg.explicit(TvAreaRowStyle rowStyle) {
    return TvRowStyleCfg._(rowStyle);
  }

  // receive str data into instance & make it structured data
  @override
  void _castToRealTypes(List<PairedQuestAndResp> userResponses) {
    //
    PairedQuestAndResp _ruleData = userResponses.first;
    assert(_ruleData.type == VisRuleQuestType.selectVisualComponentOrStyle);
    String rowStyleIdxStr = _ruleData.userAnswer;
    int rowStyleIdx = int.tryParse(rowStyleIdxStr) ?? 0;
    this.selectedRowStyle = TvAreaRowStyle.values[rowStyleIdx];
  }

  @override
  String toString() {
    return 'TvRowStyleCfg (${ruleType.name}) applying rowstyle: ${selectedRowStyle.name}';
  }

  // JsonSerializable
  factory TvRowStyleCfg.fromJson(Map<String, dynamic> json) =>
      _$TvRowStyleCfgFromJson(json);
  Map<String, dynamic> toJson() => _$TvRowStyleCfgToJson(this);
}

@JsonSerializable()
class SortGroupFilterEntry {
  // describes field & order to sort/group/filter with
  DbTableFieldName colName;
  bool asc = false;

  SortGroupFilterEntry(this.colName, this.asc);

  @override
  String toString() {
    return colName.name + ': asc: $asc';
  }

  // JsonSerializable
  factory SortGroupFilterEntry.fromJson(Map<String, dynamic> json) =>
      _$SortGroupFilterEntryFromJson(json);
  Map<String, dynamic> toJson() => _$SortGroupFilterEntryToJson(this);
}

// base for all rule classes that involve db fields & ordering
class TvSortGroupFilterBase extends RuleResponseBase {
  //
  List<SortGroupFilterEntry> fieldList = [];

  TvSortGroupFilterBase(
    VisualRuleType rt,
  ) : super(rt);
  //
  @override
  void _castToRealTypes(List<PairedQuestAndResp> userResponses) {
    /* for these answers:
        Vrq.selectDataFieldName,
        Vrq.specifySortAscending
    */
    // empty fieldList
    // this.fieldList = [];
    // print(
    //   'TvSortGroupFilter.castToRealTypes got ${userResponses.length} userResponses',
    // );
    for (int i = 0; i < userResponses.length - 1; i += 2) {
      PairedQuestAndResp fldNameEntry = userResponses[i];
      assert(
        fldNameEntry.type == VisRuleQuestType.selectDataFieldName,
        'list is in bad order',
      );
      String fldIdx = fldNameEntry.userAnswer;
      int answIdx = int.tryParse(fldIdx) ?? 0;
      DbTableFieldName _curSelField = DbTableFieldName.values[answIdx];

      PairedQuestAndResp ascendEntry = userResponses[i + 1];
      assert(
        ascendEntry.type == VisRuleQuestType.specifySortAscending,
        'list is in bad order',
      );
      String ascBool = ascendEntry.userAnswer;
      bool sortAsc = (int.tryParse(ascBool) ?? 0) > 0;

      fieldList.add(SortGroupFilterEntry(_curSelField, sortAsc));
    }
    // print(
    //   '${fieldList.length} entries (contains 2 vals) added to TvSortGroupFilterBase!  (${this.runtimeType})',
    // );
  }

  DbTableFieldName get firstColName => fieldList.first.colName;

  @override
  String toString() {
    String className = this.runtimeType.toString();
    return '$className (${ruleType.name}) w cfg:\n$_answerSummary';
  }

  String get _answerSummary {
    Iterable<String> xx =
        fieldList.map((SortGroupFilterEntry fldEntry) => fldEntry.toString());
    String summary = '\t'; // this.runtimeType.toString() +
    for (String fieldCfg in xx) {
      summary += fieldCfg + ';  ';
    }
    return summary;
  }
}

@JsonSerializable()
class TvSortCfg extends TvSortGroupFilterBase {
  //
  TvSortCfg._() : super(VisualRuleType.sortCfg);
  TvSortCfg() : super(VisualRuleType.sortCfg);

  factory TvSortCfg.noop() {
    // cancels all sorting when this is the first sort-param
    return TvSortCfg._();
  }

  bool get disableSorting => fieldList.length < 1;
  //
  // JsonSerializable
  factory TvSortCfg.fromJson(Map<String, dynamic> json) =>
      _$TvSortCfgFromJson(json);
  Map<String, dynamic> toJson() => _$TvSortCfgToJson(this);
}

@JsonSerializable()
class TvGroupCfg extends TvSortGroupFilterBase {
  //
  TvGroupCfg() : super(VisualRuleType.groupCfg);
  //
  bool get disableGrouping => fieldList.length < 1;

  // JsonSerializable
  factory TvGroupCfg.fromJson(Map<String, dynamic> json) =>
      _$TvGroupCfgFromJson(json);
  Map<String, dynamic> toJson() => _$TvGroupCfgToJson(this);
}

@JsonSerializable()
class TvFilterCfg extends TvSortGroupFilterBase {
  //
  TvFilterCfg() : super(VisualRuleType.filterCfg);
  //
  bool get disableFiltering => fieldList.length < 1;

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

  @override
  void _castToRealTypes(List<PairedQuestAndResp> userResponses) {
    PairedQuestAndResp resp = userResponses.first;
    this.shouldShow = resp.userAnswer != '0';
  }

  @override
  String toString() {
    return 'ShowHideCfg (${ruleType.name}) should show: $shouldShow';
  }

  // JsonSerializable
  factory ShowHideCfg.fromJson(Map<String, dynamic> json) =>
      _$ShowHideCfgFromJson(json);
  Map<String, dynamic> toJson() => _$ShowHideCfgToJson(this);
}
