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

  // see VisualRuleType.questCountToIterByType
  // to understand value below
  int get questCountToIterByType => ruleType.questCountToIterByType;

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
    // ConfigLogger.log(Level.FINER,'######  RuleResponseBaseToJson:  did run this');
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
class SortFilterEntry {
  // describes field & order to sort/group/filter with
  DbTableFieldName colName;
  bool asc = false;
  String? menuTitleIfFilter;

  SortFilterEntry(this.colName, this.asc, {this.menuTitleIfFilter});

  String colNameOrFilterMenuTitle([bool isTeam = true]) {
    /* configurator NOW allows setting
      filter-menu title
      so this func only applies as failover
      if config value is empty or missing
    */

    if (menuTitleIfFilter != null && menuTitleIfFilter!.isNotEmpty)
      return menuTitleIfFilter!;

    // if (fieldName == null) return "_fld_title";

    switch (this.colName) {
      case DbTableFieldName.assetName:
      case DbTableFieldName.assetShortName:
        return isTeam ? 'Team' : 'Player';
      case DbTableFieldName.assetOrgName:
        return 'Team';
      case DbTableFieldName.leagueGrouping:
        return 'Conference';
      case DbTableFieldName.competitionDate:
        return 'All Dates';
      case DbTableFieldName.competitionTime:
        return 'Game Time';
      case DbTableFieldName.competitionLocation:
        return 'Location';
      case DbTableFieldName.imageUrl:
        return 'Avatar';
      case DbTableFieldName.assetOpenPrice:
        return 'Open Price';
      case DbTableFieldName.assetCurrentPrice:
        return 'Current Price';
      case DbTableFieldName.assetRankOrScore:
        return 'Rank';
      case DbTableFieldName.assetPosition:
        return 'Position';
      case DbTableFieldName.competitionName:
        return 'Game Name';
      case DbTableFieldName.basedOnEventDelimiters:
        return 'Grouping';
      // default:
      //   return '_naLabel';
    }
  }

  bool get sortingDisabled => colName == DbTableFieldName.imageUrl;

  @override
  String toString() {
    return colName.name + ': asc: $asc';
  }

  // JsonSerializable
  factory SortFilterEntry.fromJson(Map<String, dynamic> json) =>
      _$SortFilterEntryFromJson(json);
  Map<String, dynamic> toJson() => _$SortFilterEntryToJson(this);
}

@JsonSerializable()
class GroupCfgEntry extends SortFilterEntry {
  /*

  */
  DisplayJustification justification;
  bool collapsible;

  GroupCfgEntry(
    DbTableFieldName colName,
    bool asc,
    this.justification,
    this.collapsible,
  ) : super(
          colName,
          asc,
          menuTitleIfFilter: null,
        );

  // JsonSerializable
  factory GroupCfgEntry.fromJson(Map<String, dynamic> json) =>
      _$GroupCfgEntryFromJson(json);
  Map<String, dynamic> toJson() => _$GroupCfgEntryToJson(this);
}

// base for all rule classes that involve db fields & ordering
class TvSortGroupFilterBase<T extends SortFilterEntry>
    extends RuleResponseBase {
  // <T extends SortFilterEntry>
  List<T> fieldList = [];

  TvSortGroupFilterBase(
    VisualRuleType rt,
  ) : super(rt);
  //

  bool get configEmpty => fieldList.length < 1;
  DbTableFieldName get l1ColName =>
      configEmpty ? DbTableFieldName.imageUrl : fieldList.first.colName;
  DbTableFieldName? get l2ColName =>
      fieldList.length < 2 ? null : item2!.colName;
  DbTableFieldName? get l3ColName =>
      fieldList.length < 3 ? null : item3!.colName;

  T? get item1 => fieldList.length > 0 ? fieldList.first : null;
  T? get item2 => fieldList.length > 1 ? fieldList[1] : null;
  T? get item3 => fieldList.length > 2 ? fieldList[2] : null;

  @override
  void _castToRealTypes(List<PairedQuestAndResp> userResponses) {
    throw UnimplementedError(
      'implement in subclass for different answer counts',
    );
  }

  @override
  String toString() {
    String className = this.runtimeType.toString();
    return '$className (${ruleType.name}) w cfg:\n$_answerSummary';
  }

  String get _answerSummary {
    Iterable<String> xx = fieldList.map((T fldEntry) => fldEntry.toString());
    String summary = '\t'; // this.runtimeType.toString() +
    for (String fieldCfg in xx) {
      summary += fieldCfg + ';  ';
    }
    return summary;
  }
}

@JsonSerializable()
class TvSortCfg extends TvSortGroupFilterBase<SortFilterEntry> {
  //
  TvSortCfg._() : super(VisualRuleType.sortCfg);
  TvSortCfg() : super(VisualRuleType.sortCfg);

  factory TvSortCfg.noop() {
    // cancels all sorting when this is the first sort-param
    return TvSortCfg._();
  }

  @override
  void _castToRealTypes(List<PairedQuestAndResp> userResponses) {
    // ConfigLogger.log(Level.FINER,
    //   'TvSortGroupFilter.castToRealTypes got ${userResponses.length} userResponses',
    // );

    print("#####   Got ${userResponses.length} answers ");
    for (int i = 0; i < userResponses.length - 1; i += questCountToIterByType) {
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

      fieldList.add(
        SortFilterEntry(
          _curSelField,
          sortAsc,
          menuTitleIfFilter: null,
        ),
      );
    }
    // ConfigLogger.log(Level.FINER,
    //   '${fieldList.length} entries (contains 2 vals) added to TvSortGroupFilterBase!  (${this.runtimeType})',
    // );
  }

  bool get disableSorting => configEmpty;

  SortFilterEntry? get first => fieldList.length < 1 ? null : fieldList.first;
  SortFilterEntry? get second => fieldList.length < 2 ? null : fieldList[1];
  SortFilterEntry? get third => fieldList.length < 3 ? null : fieldList[2];
  //
  // JsonSerializable
  factory TvSortCfg.fromJson(Map<String, dynamic> json) =>
      _$TvSortCfgFromJson(json);
  Map<String, dynamic> toJson() => _$TvSortCfgToJson(this);
}

@JsonSerializable()
class TvFilterCfg extends TvSortGroupFilterBase<SortFilterEntry> {
  /* constructed from answers to:
    fieldName, asc, menuName
    int get questCountForType => 3
  */
  TvFilterCfg() : super(VisualRuleType.filterCfg);
  //
  bool get disableFiltering => configEmpty;

  @override
  void _castToRealTypes(List<PairedQuestAndResp> userResponses) {
    /* for various answers depending on rule-type
    */

    // ConfigLogger.log(Level.FINER,
    //   'TvSortGroupFilter.castToRealTypes got ${userResponses.length} userResponses',
    // );

    print("#####   Got ${userResponses.length} answers ");
    for (int i = 0; i < userResponses.length - 1; i += questCountToIterByType) {
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

      PairedQuestAndResp menuTitleEntry = userResponses[i + 2];
      String? filterMenuTitle = menuTitleEntry.userAnswer as String;

      fieldList.add(
        SortFilterEntry(
          _curSelField,
          sortAsc,
          menuTitleIfFilter: filterMenuTitle,
        ),
      );
    }
    // ConfigLogger.log(Level.FINER,
    //   '${fieldList.length} entries (contains 2 vals) added to TvSortGroupFilterBase!  (${this.runtimeType})',
    // );
  }

  // JsonSerializable
  factory TvFilterCfg.fromJson(Map<String, dynamic> json) =>
      _$TvFilterCfgFromJson(json);
  Map<String, dynamic> toJson() => _$TvFilterCfgToJson(this);
}

@JsonSerializable()
class TvGroupCfg extends TvSortGroupFilterBase<GroupCfgEntry> {
  /* constructed from answers to:
    fieldName, sort-asc, askJustification, collapsible
  */
  TvGroupCfg() : super(VisualRuleType.groupCfg) {
    // throw UnimplementedError('when constructed?');
  }
  //
  bool get disableGrouping => configEmpty;

  DisplayJustification get h1Justification => disableGrouping
      ? DisplayJustification.center
      : fieldList.first.justification;

  DisplayJustification? get h2Justification =>
      (disableGrouping || this.item2 == null)
          ? null
          : this.item2!.justification;

  DisplayJustification? get h3Justification =>
      (disableGrouping || this.item3 == null)
          ? null
          : this.item3!.justification;

  bool get isCollapsible =>
      disableGrouping ? false : fieldList.first.collapsible;

  bool get sortAscending => disableGrouping ? false : fieldList.first.asc;

  void removeColName(DbTableFieldName colName) {
    // TODO:
    // fieldList = fieldList.map((e) => e).toList();
  }

  @override
  void _castToRealTypes(List<PairedQuestAndResp> userResponses) {
    /* for various answers depending on rule-type
    */

    // ConfigLogger.log(Level.FINER,
    //   'TvSortGroupFilter.castToRealTypes got ${userResponses.length} userResponses',
    // );

    print("#####   Got ${userResponses.length} answers ");
    for (int i = 0; i < userResponses.length - 1; i += questCountToIterByType) {
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

      PairedQuestAndResp justifyEntry = userResponses[i + 2];
      String justificationStr = justifyEntry.userAnswer;
      DisplayJustification justification =
          DisplayJustification.values[int.tryParse(justificationStr) ?? 0];

      PairedQuestAndResp collapsibleEntry = userResponses[i + 3];
      String collapsibleStr = collapsibleEntry.userAnswer;
      bool collapsible = (int.tryParse(collapsibleStr) ?? 0) > 0;

      fieldList.add(
        GroupCfgEntry(
          _curSelField,
          sortAsc,
          justification,
          collapsible,
        ),
      );
    }
    // ConfigLogger.log(Level.FINER,
    //   '${fieldList.length} entries (contains 2 vals) added to TvSortGroupFilterBase!  (${this.runtimeType})',
    // );
  }

  // JsonSerializable
  factory TvGroupCfg.fromJson(Map<String, dynamic> json) =>
      _$TvGroupCfgFromJson(json);
  Map<String, dynamic> toJson() => _$TvGroupCfgToJson(this);
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
