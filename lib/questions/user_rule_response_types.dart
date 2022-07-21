part of QuestionsLib;

/*
  data-types of all user answers must implement RuleResponseWrapperIfc Ifc
*/

abstract class RuleResponseWrapperIfc {
  // handles answers for real Rule Quest2s
  // receive user-answers IN
  void castResponsesToAnswerTypes(Map<VisRuleQuestType, String> responses);
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
    // each subclass should impl its own _castToRealTypes() method
    _castToRealTypes(responses);
  }

  void _castToRealTypes(Map<VisRuleQuestType, String> userResponses) {
    throw UnimplementedError('impl in subclass');
  }

  @override
  String toString() {
    return 'RuleResponseBase for ${ruleType.name}';
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

  // TvRowStyleCfg get asRuleResponse => this;

  // receive str data into instance & make it structured data
  @override
  void _castToRealTypes(Map<VisRuleQuestType, String> userResponses) {
    //
    MapEntry<VisRuleQuestType, String> _ruleData = userResponses.entries.first;
    assert(_ruleData.key == VisRuleQuestType.selectVisualComponentOrStyle);
    String rowStyleIdxStr = _ruleData.value;
    int rowStyleIdx = int.tryParse(rowStyleIdxStr) ?? 0;
    this.selectedRowStyle = TvAreaRowStyle.values[rowStyleIdx];
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
class SortGroupFilterEntry {
  // describes field & order to sort/group/filter with
  DbTableFieldName colName;
  bool asc = false;

  SortGroupFilterEntry(this.colName, this.asc);

  @override
  String toString() {
    return colName.name + ': asc: $asc; ';
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
  void _castToRealTypes(Map<VisRuleQuestType, String> userResponses) {
    /* for these answers:
        Vrq.selectDataFieldName,
        Vrq.specifySortAscending
    */
    // empty fieldList
    this.fieldList = [];

    List<MapEntry<VisRuleQuestType, String>> usrEntries =
        userResponses.entries.toList();

    for (int i = 0; i > userResponses.length - 2; i + 2) {
      MapEntry<VisRuleQuestType, String> fldNameEntry = usrEntries[i];
      assert(
        fldNameEntry.key == VisRuleQuestType.selectDataFieldName,
        'list is in bad order',
      );
      String fldIdx = fldNameEntry.value;
      int answIdx = int.tryParse(fldIdx) ?? 0;
      DbTableFieldName _curSelField = DbTableFieldName.values[answIdx];

      MapEntry<VisRuleQuestType, String> ascendEntry = usrEntries[i + 1];
      assert(
        ascendEntry.key == VisRuleQuestType.specifySortAscending,
        'list is in bad order',
      );
      String ascBool = ascendEntry.value;
      bool sortAsc = (int.tryParse(ascBool) ?? 0) > 0;

      fieldList.add(SortGroupFilterEntry(_curSelField, sortAsc));
    }
  }

  @override
  String toString() {
    String className = this.runtimeType.toString();
    return '$className for ${ruleType.name} with responses: $_answerSummary';
  }

  String get _answerSummary {
    Iterable<String> xx = fieldList.map((e) => e.toString());
    String summary = this.runtimeType.toString() + '';
    for (String fieldCfg in xx) {
      summary += fieldCfg;
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
  // ShowHideCfg get asRuleResponse => this;

  @override
  void _castToRealTypes(Map<VisRuleQuestType, String> userResponses) {
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



      // DbTableFieldName _curSelField = DbTableFieldName.imageUrl;
    // for (MapEntry e in userResponses.entries) {
    //   /* FIXME:
    //     this loop depends on userResponses.entries order being:
    //     field1 + ascend;  field2 + asc;  field3 + asc
    //   */
    //   String resp = e.value;
    //   int answIdx = int.tryParse(resp) ?? 0;

    //   switch (e.key) {
    //     case VisRuleQuestType.selectDataFieldName:
    //       _curSelField = DbTableFieldName.values[answIdx];
    //       break;
    //     // case VisRuleQuestType.specifyPositionInGroup:
    //     //   this.order = SortOrGroupIdxOrder.values[answIdx];
    //     //   break;
    //     case VisRuleQuestType.specifySortAscending:
    //       fieldList.add(SortGroupFilterEntry(_curSelField, answIdx > 0));
    //       break;
    //   }
    // }

  // // JsonSerializable
  // factory TvSortGroupFilterBase.fromJson(Map<String, dynamic> json) {
  //   return _$TvSortGroupFilterBaseFromJson(json);
  // }

  // Map<String, dynamic> toJson() {
  //   return _$TvSortGroupFilterBaseToJson(this);
  // }