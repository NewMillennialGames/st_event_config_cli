part of StUiController;

/*  GroupHeaderData is an important struct
    it's used for unique ID, sort-order
    and arguments needed to build the Widget UI

    todo: replace Tuple3 with a reall class
*/

// final _gameStateProvider = StreamProvider<ActiveGameDetails>(
//   (ref) => throw UnimplementedError(''),
// );

class GroupedTableDataMgr {
  /*
    this is the object returned when you want to build
    a table-view with custom grouping, sorting and row-styles

    produces the arguments needed to use the "GroupedListView" package

  designed specifically to work with:
    GroupedListView<TableviewDataRowTuple, GroupHeaderData>

  TODO:  all the getters below must be completed to return real methods
  */

  final AppScreen appScreen;
  // _allAssetRows will need to be updated as Event-rounds change
  final List<TableviewDataRowTuple> _allAssetRows;
  final TableviewConfigPayload _tableViewCfg;
  RedrawTvCallback? redrawCallback;
  GroupedListOrder sortOrder = GroupedListOrder.ASC;
  // rows actually rendered from _filteredAssetRows
  List<TableviewDataRowTuple> _filteredAssetRows = [];
  bool disableAllGrouping = false;
  // disableGroupingBeyondDate: regions no longer matter when you get to final 4
  bool disableGroupingBeyondDate = false;

  GroupedTableDataMgr(
    this.appScreen,
    this._allAssetRows,
    this._tableViewCfg, {
    this.redrawCallback,
    this.disableAllGrouping = false,
    bool ascending = true,
  })  : sortOrder = ascending ? GroupedListOrder.ASC : GroupedListOrder.DESC,
        _filteredAssetRows = _allAssetRows.toList();

  List<TableviewDataRowTuple> get listData => _filteredAssetRows;
  TvGroupCfg? get groupRules => _tableViewCfg.groupByRules;
  TvSortCfg get sortingRules => _tableViewCfg.sortRules;
  TvFilterCfg? get filterRules => _tableViewCfg.filterRules;

  GetGroupHeaderLblsFromCompetitionRow get groupBy {
    return GroupHeaderData.groupHeaderPayloadConstructor(
      _tableViewCfg.sortRules,
    );
  }

  // groupHeaderBuilder is function to return header widget
  // defining groupHeaderBuilder will cause groupSeparatorBuilder to be ignored
  GroupHeaderBuilder get groupHeaderBuilder {
    if (disableAllGrouping) return (_) => const SizedBox.shrink();

    // copy groupBy getter to save a lookup
    final TvAreaRowStyle rowStyle = _tableViewCfg.rowStyle;
    final GetGroupHeaderLblsFromCompetitionRow gbFunc = groupBy;
    return (TableviewDataRowTuple rowData) =>
        TvGroupHeader(rowStyle, appScreen, gbFunc(rowData));
  }

  // natural sorting will use my Comparator; dont need this
  // GroupComparatorCallback? get groupComparator => null;
  GroupComparatorCallback? get groupComparator {
    // GroupHeaderData implements comparable
    if (disableAllGrouping) return null;

    if (sortOrder == GroupedListOrder.DESC) {
      return (GroupHeaderData hd1Val, GroupHeaderData hd2Val) =>
          hd2Val.compareTo(hd1Val);
    } else {
      return (GroupHeaderData hdVal1, GroupHeaderData hdVal2) =>
          hdVal1.compareTo(hdVal2);
    }
  }

  // indexedItemBuilder is function to return a Tv-Row for this screen
  IndexedItemRowBuilder get indexedItemBuilder => (
        BuildContext ctx,
        TableviewDataRowTuple assets,
        int i,
      ) {
        return _tableViewCfg.rowConstructor(assets);
      };

  // for sorting recs into order WITHIN groups/sections
  SectionSortComparator get itemComparator => GroupHeaderData.sortComparator(
      sortingRules, sortOrder == GroupedListOrder.ASC);

  bool get hasColumnFilters {
    // set imageUrl as first filter field to hide/disable the whole filter bar
    return filterRules?.item1.colName != DbTableFieldName.imageUrl &&
        !disableAllGrouping;
  }

  void endGeographicGrouping() {
    // games now happening between/across regions
    // so it not longer makes sense to group or sort geographically
    _tableViewCfg.endGeographicGrouping();
  }

  String? _filter1Selection;
  String? _filter2Selection;
  String? _filter3Selection;

  Widget columnFilterBarWidget({
    double totAvailWidth = 360,
    double barHeight = 46,
    Color backColor = Colors.transparent,
  }) {
    // dont call this method without first checking this.hasColumnFilters
    if (filterRules == null || disableAllGrouping) {
      return const SizedBox.shrink();
    }

    SortGroupFilterEntry i1 = filterRules!.item1;
    SortGroupFilterEntry? i2 = filterRules!.item2;
    SortGroupFilterEntry? i3 = filterRules!.item3;

    Set<String> listItems1 = _getListItemsByCfgField(i1);
    Set<String> listItems2 = i2 == null ? {} : _getListItemsByCfgField(i2);
    Set<String> listItems3 = i3 == null ? {} : _getListItemsByCfgField(i3);

    const _kLstMin = 2;

    bool has2ndList =
        i2 != null && listItems2.length > _kLstMin && i2.colName != i1.colName;
    bool has3rdList =
        i3 != null && listItems3.length > _kLstMin && i3.colName != i2!.colName;

    int dropLstCount = 1 + (has2ndList ? 1 : 0) + (has3rdList ? 1 : 0);
    // allocate dropdown button width
    double allocBtnWidth = totAvailWidth / dropLstCount;
    // one list can take 86% of space
    allocBtnWidth = dropLstCount < 2 ? totAvailWidth * 0.86 : allocBtnWidth;

    return Container(
      height: barHeight,
      width: totAvailWidth,
      color: backColor,
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _DropDownMenuList(
            listItems: listItems1,
            colName: i1.colName,
            curSelection: _filter1Selection,
            valSetter: (s) => _filter1Selection = s,
            width: allocBtnWidth,
            clearFilters: clearFilters,
            doFilteringFor: (colName, selectedValue) =>
                _doFilteringFor(colName, selectedValue),
            filterTitleExtractor: (colName) => _filterTitleExtractor(colName),
          ),
          if (has2ndList)
            _DropDownMenuList(
              listItems: listItems2,
              colName: i2.colName,
              curSelection: _filter2Selection,
              valSetter: (s) => _filter2Selection = s,
              width: allocBtnWidth,
              clearFilters: clearFilters,
              doFilteringFor: (colName, selectedValue) =>
                  _doFilteringFor(colName, selectedValue),
              filterTitleExtractor: (colName) => _filterTitleExtractor(colName),
            ),
          if (has3rdList)
            _DropDownMenuList(
              listItems: listItems3,
              colName: i3.colName,
              curSelection: _filter3Selection,
              valSetter: (s) => _filter3Selection = s,
              width: allocBtnWidth,
              clearFilters: clearFilters,
              doFilteringFor: (colName, selectedValue) =>
                  _doFilteringFor(colName, selectedValue),
              filterTitleExtractor: (colName) => _filterTitleExtractor(colName),
            ),
        ],
      ),
    );
  }

  void setFilteredData(
    Iterable<TableviewDataRowTuple> assetRows, {
    bool redraw = false,
  }) {
    /* external filtering
    used by search (watched or owned) feature
    */
    _filteredAssetRows = assetRows.toList();
    if (redraw && redrawCallback != null) {
      redrawCallback!();
    }
  }

  String _filterTitleExtractor(DbTableFieldName fieldName) {
    bool isTeam = false;
    if (_allAssetRows.isNotEmpty) {
      isTeam = _allAssetRows.first.item1.isTeam;
    }
    switch (fieldName) {
      case DbTableFieldName.assetName:
      case DbTableFieldName.assetShortName:
        return isTeam ? 'Team' : 'Player';
      case DbTableFieldName.assetOrgName:
        return 'Org';
      case DbTableFieldName.conference:
        return 'Conference';
      case DbTableFieldName.region:
        return 'All Regions';
      case DbTableFieldName.gameDate:
        return 'All Dates';
      case DbTableFieldName.gameTime:
        return 'Game Time';
      case DbTableFieldName.gameLocation:
        return 'Location';
      case DbTableFieldName.imageUrl:
        return 'Avatar (select this to hide filter bar)';
      case DbTableFieldName.assetOpenPrice:
        return 'Open Price';
      case DbTableFieldName.assetCurrentPrice:
        return 'Current Price';
      case DbTableFieldName.assetRankOrScore:
        return 'Rank';
      case DbTableFieldName.assetPosition:
        return 'Position';
    }
  }

  List<AssetRowPropertyIfc> _getSortedAssetRows(DbTableFieldName colName) {
    List<AssetRowPropertyIfc> rows = [];

    for (var row in _allAssetRows) {
      rows.add(row.item1);
      if (row.item2 != null) {
        rows.add(row.item2!);
      }
    }

    //perform sorting based on actual value types
    //for non String values rather than on labels
    switch (colName) {
      case DbTableFieldName.gameDate:
      case DbTableFieldName.gameTime:
        rows.sort((a, b) => a.gameDate.compareTo(b.gameDate));
        break;

      case DbTableFieldName.assetOpenPrice:
      case DbTableFieldName.assetCurrentPrice:
      case DbTableFieldName.assetRankOrScore:
      case DbTableFieldName.assetPosition:
        rows.sort((a, b) {
          final item1Value = num.parse(a.labelExtractor(colName));
          final item2Value = num.parse(b.labelExtractor(colName));
          return item1Value.compareTo(item2Value);
        });
        break;
      default:
        rows.sort((a, b) => a.labelExtractor(colName).compareTo(
              b.labelExtractor(colName),
            ));
    }

    return rows;
  }

  Set<String> _getListItemsByCfgField(SortGroupFilterEntry filterItem) {
    List<AssetRowPropertyIfc> sortedAssetRows =
        _getSortedAssetRows(filterItem.colName);

    List<String> labels = [
      _filterTitleExtractor(filterItem.colName),
      ...sortedAssetRows.map((e) => e.labelExtractor(filterItem.colName)),
    ];

    return <String>{...labels};
  }

  void _doFilteringFor(DbTableFieldName colName, String selectedVal) {
    //
    if (selectedVal.toUpperCase() ==
        _filterTitleExtractor(colName).toUpperCase()) {
      clearFilters();
      return;
    }
    List<TableviewDataRowTuple> filterResults = [];

    for (var asset in _allAssetRows) {
      if (asset.item1.labelExtractor(colName) == selectedVal ||
          asset.item2?.labelExtractor(colName) == selectedVal) {
        filterResults.add(asset);
      }
    }
    _filteredAssetRows = filterResults;

    // print('you must reload your list after calling this');
    if (redrawCallback != null) redrawCallback!();
  }

  void clearFilters() {
    _filteredAssetRows = _allAssetRows;
    // print('you must reload your list after calling this');
    if (redrawCallback != null) redrawCallback!();
  }

  void replaceGameStatusForRowRebuildTest(String round) {
    //
    // TableviewDataRowTuple drt = _allAssetRows[2];
    // ActiveGameDetails agd = drt.item3;
    // var ci = CompetitionInfo(
    //   key: agd.competitionKey,
    //   competitionStatus: null,
    //   currentRoundName: round,
    // );
    // agd = agd.cloneWithUpdates(ci);

    // _allAssetRows[2] = TableviewDataRowTuple(drt.item1, drt.item2, agd);
    print('ActiveGameDetails replaced on 2 with $round  (did row repaint?)');
  }
}

class _DropDownMenuList extends StatefulWidget {
  final Set<String> listItems;
  final DbTableFieldName colName;
  final String? curSelection;
  final SelectedFilterSetter valSetter;
  final double width;
  final VoidCallback clearFilters;
  final void Function(DbTableFieldName, String) doFilteringFor;
  final String Function(DbTableFieldName) filterTitleExtractor;

  _DropDownMenuList({
    Key? key,
    required this.listItems,
    required this.colName,
    required this.curSelection,
    required this.valSetter,
    required this.width,
    required this.clearFilters,
    required this.doFilteringFor,
    required this.filterTitleExtractor,
  }) : super(key: key);

  @override
  State<_DropDownMenuList> createState() => _DropDownMenuListState();
}

class _DropDownMenuListState extends State<_DropDownMenuList> {
  bool _useDefaultState = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      decoration: BoxDecoration(
        color: _useDefaultState ? Colors.transparent : StColors.primaryDarkGray,
        border: _useDefaultState
            ? Border.all(
                color: StColors.lightGray,
                width: 0.8,
              )
            : null,
        borderRadius: BorderRadius.all(
          Radius.circular(6.w),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: widget.curSelection ?? widget.listItems.first,
          items: widget.listItems
              .map(
                (String val) => DropdownMenuItem<String>(
                  value: val,
                  alignment: AlignmentDirectional.centerStart,
                  child: Container(
                    color: widget.curSelection == val
                        ? StColors.primaryDarkGray
                        : StColors.black,
                    child: Text(val.toUpperCase()),
                  ),
                ),
              )
              .toList(),
          selectedItemBuilder: (BuildContext context) {
            return widget.listItems.map((String value) {
              return ConstrainedBox(
                constraints: BoxConstraints(maxWidth: widget.width * .75),
                child: Center(
                  child: Text(
                    value.toUpperCase(),
                  ),
                ),
              );
            }).toList();
          },
          onChanged: (String? selectedVal) {
            // store selected value for state mgmt
            widget.valSetter(selectedVal);
            if (selectedVal == null ||
                selectedVal == widget.filterTitleExtractor(widget.colName) ||
                selectedVal.startsWith(CLEAR_FILTER_LABEL)) {
              setState(() {
                _useDefaultState = true;
              });
              widget.clearFilters();
              return;
            }
            setState(() {
              _useDefaultState = false;
            });
            widget.doFilteringFor(widget.colName, selectedVal);
          },
          dropdownColor: StColors.black,
          iconEnabledColor: _useDefaultState ? StColors.gray : StColors.white,
          style: TextStyle(
            color: StColors.lightGray,
            fontSize: 16.sp,
          ),
        ),
      ),
    );
  }
}
