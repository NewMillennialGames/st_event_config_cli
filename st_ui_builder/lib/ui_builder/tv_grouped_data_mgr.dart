part of StUiController;

/*  GroupHeaderData is an important struct
    it's used for unique ID, sort-order
    and arguments needed to build the Widget UI

    todo: replace Tuple3 with a reall class

    note to Lucky:
    technically, the widgets below can server list-views for any screen
    not just market view;  so is there any harm in naming 
    the widget key:  "market-view-list"
*/

class GroupedTableDataMgr {
  /*
    this is the object returned when you want to build
    a table-view with custom grouping, sorting, filtering and row-styles

   uses the "GroupedListView" package

  designed specifically to work with:
    GroupedListView<TableviewDataRowTuple, GroupHeaderData>
  */

  final AppScreen appScreen;
  // _allAssetRows will need to be updated as Event-rounds change
  final List<TvRowDataContainer> _allAssetRows;
  final TableviewConfigPayload _tableViewCfg;
  RedrawTvCallback? redrawCallback;
  // rows actually rendered from _filteredAssetRows
  List<TvRowDataContainer> _filteredAssetRows = [];
  bool _disableAllGrouping = false;
  // disableGroupingBeyondDate: regions no longer matter when you get to final 4
  bool disableGroupingBeyondDate = false;

  GroupedTableDataMgr(
    this.appScreen,
    this._allAssetRows,
    this._tableViewCfg, {
    this.redrawCallback,
    bool disableAllGrouping = false,
    bool ascending = true,
  })  : _disableAllGrouping = disableAllGrouping,
        // sortOrder = ascending ? GroupedListOrder.ASC : GroupedListOrder.DESC,
        _filteredAssetRows = _allAssetRows.toList();

  List<RowGroup>? get rowsGroupedByTopConfig =>
      _groupRowsBasedOnCfgTopColName(_filteredAssetRows);

  List<TvRowDataContainer> get sortedListData {
    if (sortingRules.disableSorting) {
      return _rowsAutoSortedByTradable(_filteredAssetRows);
    }
    return List.of(_filteredAssetRows)..sort(sortItemComparator);
  }

  bool _canFilterWatchedAssets = false;
  bool _canFilterOwnedAssets = false;
  String _searchQuery = "";

  void updateFilterRules({
    bool filterWatchedAssets = false,
    bool filterOwnedAssets = false,
    String searchQuery = "",
  }) {
    _canFilterWatchedAssets = filterWatchedAssets;
    _canFilterOwnedAssets = filterOwnedAssets;
    _searchQuery = searchQuery;
  }

  TvGroupCfg? get groupRules => _tableViewCfg.groupByRules;
  TvSortCfg get sortingRules => _tableViewCfg.sortRules;
  TvFilterCfg? get filterRules => _tableViewCfg.filterRules;

  bool get disableAllGrouping =>
      _disableAllGrouping || (groupRules?.disableGrouping ?? true);

  bool get topGroupIsCollapsible =>
      (groupRules?.isCollapsible ?? false) && !disableAllGrouping;
  GroupedListOrder get topSortOrder => (groupRules?.sortAscending ?? true)
      ? GroupedListOrder.ASC
      : GroupedListOrder.DESC;

  bool get assetTypeIsTeam =>
      _allAssetRows.isEmpty ? false : _allAssetRows.first.team1.isTeam;

  // filter menu titles
  String get fm1Title =>
      filterRules?.item1?.colNameOrFilterMenuTitle(assetTypeIsTeam) ?? "Menu 1";
  String get fm2Title =>
      filterRules?.item2?.colNameOrFilterMenuTitle(assetTypeIsTeam) ?? "Menu 2";
  String get fm3Title =>
      filterRules?.item3?.colNameOrFilterMenuTitle(assetTypeIsTeam) ?? "Menu 3";

  GetGroupHeaderDataFromAssetRow? get groupHeaderPayloadBuilder {
    /* return function to build group header data payload
      from each row of data (1 or 2 assets)
      includes GroupHeaderMetaCfg to drive UI layout
    */
    if (groupRules == null || groupRules!.disableGrouping) {
      return null;
    }

    final headerMetaCfg = GroupHeaderMetaCfg(
      topGroupIsCollapsible,
      topSortOrder,
      h1DisplayJust: groupRules?.h1Justification ?? DisplayJustification.center,
      h2DisplayJust: groupRules?.h2Justification,
      h3DisplayJust: groupRules?.h3Justification,
    );

    return GroupHeaderData.groupHeaderPayloadConstructor(
      groupRules!,
      sortingRules,
      headerMetaCfg,
      assetTypeIsTeam,
    );
  }

  // groupHeaderBuilder is function to return header widget
  // defining groupHeaderBuilder will cause groupSeparatorBuilder to be ignored
  GroupHeaderWidgetBuilder get groupHeaderWidgetBuilder {
    if (disableAllGrouping) return (_) => const SizedBox.shrink();

    // copy groupBy getter to save a lookup
    final TvAreaRowStyle rowStyle = _tableViewCfg.rowStyle;
    final GetGroupHeaderDataFromAssetRow gbFunc = groupHeaderPayloadBuilder!;
    return (TvRowDataContainer rowData) {
      //

      return TvGroupHeader(
        rowStyle,
        appScreen,
        gbFunc(rowData),
      );
    };
  }

  // natural sorting will use Comparator on GroupHeaderData
  GroupHeaderSortCompareCallback? get groupHeaderSortComparator {
    // GroupHeaderData implements comparable
    if (disableAllGrouping) return null;

    if (topSortOrder == GroupedListOrder.DESC) {
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
        TvRowDataContainer assets,
        int i, {
        void Function(TvRowDataContainer)? onTap,
      }) {
        return _tableViewCfg.rowConstructor(assets, onTap: onTap);
      };

  // for sorting TableviewDataRowTuple rows into config defined sort order
  ConfigDefinedSortComparator get sortItemComparator =>
      GroupHeaderData.rowSortComparatorFromCfg(sortingRules);

  bool get hasColumnFilters {
    return filterRules?.item1 != null && !_disableAllGrouping;
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
    required double barWidth,
    double barHeight = 46,
    Color backColor = Colors.transparent,
    Function? callback,
  }) {
    // dont call this method without first checking this.hasColumnFilters
    if (filterRules == null || _disableAllGrouping) {
      return const SizedBox.shrink();
    }

    SortFilterEntry? i1 = filterRules!.item1;
    SortFilterEntry? i2 = filterRules!.item2;
    SortFilterEntry? i3 = filterRules!.item3;

    Set<String> listItems1 = i1 == null ? {} : _getListItemsByCfgField(i1);
    Set<String> listItems2 = i2 == null ? {} : _getListItemsByCfgField(i2);
    Set<String> listItems3 = i3 == null ? {} : _getListItemsByCfgField(i3);

    const int kLstMin = 2;

    bool has2ndList =
        i2 != null && listItems2.length > kLstMin && i2.colName != i1?.colName;
    bool has3rdList =
        i3 != null && listItems3.length > kLstMin && i3.colName != i2!.colName;

    int dropLstCount = 1 + (has2ndList ? 1 : 0) + (has3rdList ? 1 : 0);
    // allocate dropdown button width
    double dropDownWidth = barWidth / dropLstCount;
    // one list can take 86% of space
    dropDownWidth = dropLstCount < 2 ? barWidth * 0.86 : dropDownWidth;

    if (i1 == null) return const SizedBox.shrink();

    return Container(
      height: barHeight,
      width: barWidth,
      color: backColor,
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _DropDownMenuList(
            listItems: listItems1,
            colName: i1.colName,
            titleName: fm1Title,
            curSelection: _filter1Selection,
            valSetter: (s) => _filter1Selection = s,
            width: dropDownWidth,
            doFilteringFor: (fld, s) {
              _doFilteringFor(fld, s);
              callback?.call();
            },
          ),
          if (has2ndList)
            _DropDownMenuList(
              listItems: listItems2,
              colName: i2.colName,
              titleName: fm2Title,
              curSelection: _filter2Selection,
              valSetter: (s) => _filter2Selection = s,
              width: dropDownWidth,
              doFilteringFor: (fld, s) {
                _doFilteringFor(fld, s);
                callback?.call();
              },
            ),
          if (has3rdList)
            _DropDownMenuList(
              listItems: listItems3,
              colName: i3.colName,
              titleName: fm3Title,
              curSelection: _filter3Selection,
              valSetter: (s) => _filter3Selection = s,
              width: dropDownWidth,
              doFilteringFor: (fld, s) {
                _doFilteringFor(fld, s);
                callback?.call();
              },
            ),
        ],
      ),
    );
  }

  bool _hasSetData = false;

  void setFilteredData(
    Iterable<TvRowDataContainer> assetRows, {
    bool redraw = false,
    bool reapplyFilters = false,
  }) {
    /* external filtering
    used by search (watched or owned) feature
    */
    _hasSetData = true;

    if (_allAssetRows.isEmpty) {
      _allAssetRows.addAll(assetRows);
    }
    _filteredAssetRows = assetRows.toList();

    if (reapplyFilters) {
      _filter(assetRows);
      return;
    }

    if (redraw && redrawCallback != null) {
      redrawCallback!();
    }
  }

  List<AssetRowPropertyIfc> _filterDropDnGetDistinctAssets(
    DbTableFieldName colName, {
    bool sortList = false,
  }) {
    /*  called by a method that returns an UNORDERED set
      so sorting would normally be a waste of time
    */
    List<AssetRowPropertyIfc> assetRows = [];

    for (TvRowDataContainer row in _allAssetRows) {
      assetRows.add(row.team1);
      if (row.team2 != null) {
        assetRows.add(row.team2!);
      }
    }

    if (sortList) {
      //perform sorting based on actual value types
      //for non String values rather than on labels
      switch (colName) {
        case DbTableFieldName.competitionDate:
        case DbTableFieldName.competitionTime:
          assetRows
              .sort((a, b) => a.competitionDate.compareTo(b.competitionDate));
          break;

        case DbTableFieldName.assetOpenPrice:
        case DbTableFieldName.assetCurrentPrice:
        case DbTableFieldName.assetRankOrScore:
          assetRows.sort((a, b) {
            num item1Value = num.parse(a.valueExtractor(colName));
            num item2Value = num.parse(b.valueExtractor(colName));
            return item1Value.compareTo(item2Value);
          });
          break;
        default:
          assetRows.sort((a, b) => a.valueExtractor(colName).compareTo(
                b.valueExtractor(colName),
              ));
      }
    }

    return assetRows;
  }

  Set<String> _getListItemsByCfgField(SortFilterEntry filterItem) {
    /* build title and values for filter menu dropdown list
      return set of strings
    */
    List<AssetRowPropertyIfc> sortedAssetRows = _filterDropDnGetDistinctAssets(
      filterItem.colName,
      sortList: filterItem.asc,
    );

    List<String> filterMenuItemLabels = [
      filterItem.colNameOrFilterMenuTitle(assetTypeIsTeam),
      ...sortedAssetRows.map((e) => e.valueExtractor(filterItem.colName)),
    ];
    filterMenuItemLabels.removeWhere((label) => label.isEmpty);
    // return set of strings
    return <String>{...filterMenuItemLabels};
  }

  ///If groupings exist, this will arrange rows into groups
  ///and return a map of `groupTitle -> rows`
  List<RowGroup>? _groupRowsBasedOnCfgTopColName(
    List<TvRowDataContainer> rows,
  ) {
    /*  this method ONLY applies when using top-level groupings

      use config to decide WHICH
      field causes the rows to group together ..
    */

    if (groupRules?.disableGrouping ?? true) return null;

    DbTableFieldName topGroupColName =
        groupRules?.item1?.colName ?? DbTableFieldName.competitionDate;
    bool usingServerGroupings =
        topGroupColName == DbTableFieldName.basedOnEventDelimiters;

    if (rows.isEmpty ||
        (usingServerGroupings && rows.first.team1.groupName == null)) {
      return null;
    }

    List<RowGroup> groups = [];

    for (TvRowDataContainer drt in rows) {
      String grpKeyVal = drt.team1.valueExtractor(topGroupColName);
      final index = groups.indexWhere((e) => e.groupName == grpKeyVal);

      if (index < 0) {
        groups.add(
          RowGroup(
            items: [drt],
            groupName: grpKeyVal,
            sortingField: drt.team1.sortValueExtractor(topGroupColName),
          ),
        );
      } else {
        groups[index].appendRowItem(drt);
      }
    }
    groups.sort();
    return groups;

    // not sure why we need to sort here??
    // if (groupRules?.disableGrouping ?? true) {
    //   rows = _rowsAutoSortedByTradable(rows);
    // } else {
    //   rows = [];
    // }

    // Set<String> l1GroupHeaders = {};
    // for (TableviewDataRowTuple drt in rows) {
    //   l1GroupHeaders.add(drt.item1.valueExtractor(topGroupColName));
    // }
  }

  List<TvRowDataContainer> _rowsAutoSortedByTradable(
    List<TvRowDataContainer> rows,
  ) {
    List<TvRowDataContainer> nonTradeableRows = [];
    List<TvRowDataContainer> tradeableRows = [];

    for (var row in rows) {
      if ([
        CompetitionStatus.compFinal,
        CompetitionStatus.compFinished,
        CompetitionStatus.compCanceled,
      ].contains(row.team1.competitionStatus)) {
        nonTradeableRows.add(row);
      } else {
        tradeableRows.add(row);
      }
    }

    return [...tradeableRows, ...nonTradeableRows];
  }

  final Set<FilterSelection> _currentFilters = {};

  // var xx = _tableViewCfg.filterRules?.item1?.menuTitleIfFilter;

  void _doFilteringFor(
    DbTableFieldName colName,
    String selectedVal,
  ) {
    //
    final filterSelection = FilterSelection(
      filterColumn: colName,
      selectedValue: selectedVal,
    );
    _currentFilters
        .removeWhere((selFilter) => selFilter.filterColumn == colName);
    _currentFilters.add(filterSelection);

    // print("selectedVal:  $selectedVal");
    // print("filter menu title #1:  $fm1Title");
    // print("filter menu title #2:  $fm2Title");
    // print("filter menu title #3:  $fm3Title");
    if (selectedVal.isEmpty ||
        [fm1Title, fm2Title, fm3Title].contains(selectedVal)) {
      // sloppy test above;  prob creates a bug
      // .toUpperCase() == colName.name.toUpperCase()
      _currentFilters.removeWhere(
        (selFilter) => selFilter.filterColumn == colName,
      );
    }

    _filter();
  }

  void _filter([Iterable<TvRowDataContainer>? rows]) {
    final filterBase = rows ?? _allAssetRows;

    List<TvRowDataContainer> filterResults = [];

    for (TvRowDataContainer asset in filterBase) {
      bool added = false;
      for (FilterSelection filter in _currentFilters) {
        if (asset.team1.valueExtractor(filter.filterColumn) ==
                filter.selectedValue ||
            asset.team2?.valueExtractor(filter.filterColumn) ==
                filter.selectedValue) {
          if (!added) {
            filterResults.add(asset);
            added = true;
          }
        } else {
          filterResults.remove(asset);
          added = false;
          break;
        }
      }
    }

    if (_currentFilters.isEmpty) filterResults = filterBase.toList();

    _filteredAssetRows = _filterOwnnedAssets(
      _filterWatchedAssets(
        _filterAssetsBySearchQuery(
          filterResults,
        ),
      ),
    ).toList();

    // print('you must reload your list after calling this');
    if (redrawCallback != null) redrawCallback!();
  }

  Iterable<TvRowDataContainer> _filterWatchedAssets(
    Iterable<TvRowDataContainer> rows,
  ) {
    if (!_canFilterWatchedAssets) return rows;

    List<TvRowDataContainer> filterResults = [];

    for (var row in rows) {
      if (_isWatched(row)) {
        filterResults.add(row);
      }
    }

    return filterResults;
  }

  Iterable<TvRowDataContainer> _filterOwnnedAssets(
    Iterable<TvRowDataContainer> rows,
  ) {
    if (!_canFilterOwnedAssets) return rows;

    List<TvRowDataContainer> filterResults = [];

    for (var row in rows) {
      if (_isOwned(row)) {
        filterResults.add(row);
      }
    }

    return filterResults;
  }

  Iterable<TvRowDataContainer> _filterAssetsBySearchQuery(
    Iterable<TvRowDataContainer> rows,
  ) {
    if (_searchQuery.isEmpty) return rows;

    List<TvRowDataContainer> filterResults = [];

    for (var row in rows) {
      if (_doesRowMatchSearchQuery(row)) {
        filterResults.add(row);
      }
    }

    return filterResults;
  }

  bool _isWatched(TvRowDataContainer row) {
    final isFirstAssetWatched = row.team1.assetStateUpdates.isWatched;
    final isSecondAssetWatched =
        row.team2?.assetStateUpdates.isWatched ?? false;

    return isFirstAssetWatched || isSecondAssetWatched;
  }

  bool _isOwned(TvRowDataContainer row) {
    final isFirstAssetOwned = row.team1.assetHoldingsSummary.sharesOwned > 0;
    final isSecondAssetOwned =
        ((row.team2?.assetHoldingsSummary.sharesOwned ?? 0) > 0);

    return isFirstAssetOwned || isSecondAssetOwned;
  }

  bool _doesRowMatchSearchQuery(TvRowDataContainer row) {
    bool doesMatchSoFar = false;

    if (_searchQuery.isNotEmpty) {
      var upperSrchVal = _searchQuery.toUpperCase();
      doesMatchSoFar = ((row.team1.searchText.contains(upperSrchVal)) ||
          ((row.team2?.searchText ?? '').contains(upperSrchVal)));
    }
    return doesMatchSoFar;
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

  ///Indicates whether there's no asset to display.
  ///This doesn't mean that [_allAssetRows].
  ///Instead, it could be mean that there are no assets
  ///to show as a result of applying filtering rules.
  bool get _hasNoAsset => topGroupIsCollapsible
      ? (rowsGroupedByTopConfig ?? []).isEmpty
      : sortedListData.isEmpty;

  ///Truw when [GroupedTableDataMgr] has an empty list of assets.
  ///Otherwise, false.
  bool get hasNoSetAsset => _allAssetRows.isEmpty;

  ///ListView of rows typically displayed in MarketView.
  ///This is implemented internally as opposed to just exposing
  ///the row builder in order to implement the nested & collapsible
  /// grouping structure for some rows.
  Widget assetRowsListView({
    required Future<void> Function() onRefresh,
    ScrollController? scrollController,
    void Function(TvRowDataContainer)? onRowTapped,
  }) {
    if (!_hasSetData && _hasNoAsset) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    if (_hasSetData && _hasNoAsset) {
      return Center(
        child: Text(
          "No Assets Available to Trade",
          style: StTextStyles.h5,
        ),
      );
    }
    if (disableAllGrouping) {
      // normal sorted list
      // List<TableviewDataRowTuple> sortedListData;
      return _AssetRowsSortedListView(
        onRefresh: onRefresh,
        assets: sortedListData,
        rowBuilder: indexedItemBuilder,
        onRowTapped: onRowTapped,
        scrollController: scrollController,
      );
    } else if (topGroupIsCollapsible) {
      // grouped list WITH collapsing headers
      return _ExpandableGroupedAssetRowsListView(
        onRefresh: onRefresh,
        scrollController: scrollController,
        onRowTapped: onRowTapped,
        groupByHeadDataCallback: groupHeaderPayloadBuilder ??
            (TvRowDataContainer _) => GroupHeaderData.noop(),
        groupHeaderBuilder: groupHeaderWidgetBuilder,
        rowBuilder: indexedItemBuilder,
        groupComparator: groupHeaderSortComparator,
        groupedAssets: rowsGroupedByTopConfig ?? [],
        groupingLevels: groupRules?.fieldList.length ?? 1,
      );
    } else {
      // grouped list without collapsing headers
      return _AssetRowsGroupedListView(
        onRefresh: onRefresh,
        scrollController: scrollController,
        onRowTapped: onRowTapped,
        extractHeaderPayload: groupHeaderPayloadBuilder ??
            (TvRowDataContainer _) => GroupHeaderData.noop(),
        groupHeaderBuilder: groupHeaderWidgetBuilder,
        rowBuilder: indexedItemBuilder,
        groupComparator: groupHeaderSortComparator,
        assets: _filteredAssetRows,
      );
    }
  }
}

extension AssetHeadTransExt1 on List<TvRowDataContainer> {
  //
  bool sortKeyHasChangedFromPriorRow(
    int rowIdx,
    GetGroupHeaderDataFromAssetRow extractHeaderPayload,
    int groupingLevels,
  ) {
    /* when we have multiple levels of grouping, the sortKey should be compared back that many levels
    */
    // String priorRowSortKey = (rowIdx >= groupingLevels
    //     ? extractHeaderPayload(this[rowIdx - groupingLevels]).sortKey
    //     : extractHeaderPayload(this[rowIdx - 1]).sortKey);
    return rowIdx == 0 ||
        extractHeaderPayload(this[rowIdx]).sortKey !=
            extractHeaderPayload(this[rowIdx - 1]).sortKey;
  }
}

class _ExpandableGroupedAssetRowsListView extends StatefulWidget {
  final Future<void> Function() onRefresh;
  final ScrollController? scrollController;
  final GetGroupHeaderDataFromAssetRow groupByHeadDataCallback;
  final GroupHeaderSortCompareCallback? groupComparator;
  final GroupHeaderWidgetBuilder groupHeaderBuilder;
  final IndexedItemRowBuilder rowBuilder;
  final Function(TvRowDataContainer)? onRowTapped;
  final List<RowGroup> groupedAssets;
  final int groupingLevels;

  const _ExpandableGroupedAssetRowsListView({
    Key? key,
    required this.onRefresh,
    required this.groupByHeadDataCallback,
    required this.groupHeaderBuilder,
    required this.rowBuilder,
    required this.groupedAssets,
    this.onRowTapped,
    this.scrollController,
    this.groupComparator,
    this.groupingLevels = 1,
  }) : super(key: key);

  @override
  State<_ExpandableGroupedAssetRowsListView> createState() =>
      _ExpandableGroupedAssetRowsListViewState();
}

class _ExpandableGroupedAssetRowsListViewState
    extends State<_ExpandableGroupedAssetRowsListView> {
  //
  late List<String> _groupTitles =
      widget.groupedAssets.map((e) => e.groupName).toList();

  @override
  void didUpdateWidget(_ExpandableGroupedAssetRowsListView oldWidget) {
    if (oldWidget.groupedAssets != widget.groupedAssets) {
      setState(() {
        final assets = widget.groupedAssets;
        assets.sort();
        _groupTitles = assets.map((e) => e.groupName).toList();
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  List<TvRowDataContainer> _getAssetsForGroup(String groupTitle) {
    try {
      final rows = widget.groupedAssets
          .where((e) => e.groupName == groupTitle)
          .first
          .items;

      // sort assets here if necessary since
      // sorting is disabled in the GroupedListView
      if (widget.groupComparator != null) {
        rows.sort((a, b) => widget.groupComparator!(
            widget.groupByHeadDataCallback(a),
            widget.groupByHeadDataCallback(b)));
      }

      return rows;
    } catch (e) {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: widget.onRefresh,
      child: SingleChildScrollView(
        controller: widget.scrollController,
        padding: EdgeInsets.only(bottom: 90.h),
        child: Column(
          children: [
            for (int i = 0; i < _groupTitles.length; i++) ...{
              ExpansionTile(
                initiallyExpanded: true,
                iconColor: Colors.white,
                collapsedIconColor: Colors.white,
                textColor: Colors.white,
                // Justifiication here is automatically LEFT; ignores user-cfg
                title: Text(
                  _groupTitles[i], // collapsible header value
                  style: StTextStyles.h4,
                ),
                children: [
                  // because grp config-metadata shows "collapsible"
                  // the header data rows created by groupByHeadDataCallback
                  // will OFFSET label values so they are not duplicated
                  // on the header row
                  _AssetRowsGroupedListView(
                    scrollable: false,
                    onRefresh: widget.onRefresh,
                    assets: _getAssetsForGroup(_groupTitles[i]),
                    extractHeaderPayload: widget.groupByHeadDataCallback,
                    groupComparator: widget.groupComparator,
                    groupHeaderBuilder: widget.groupHeaderBuilder,
                    rowBuilder: widget.rowBuilder,
                    onRowTapped: widget.onRowTapped,
                    groupingLevels: widget.groupingLevels,
                  ),
                ],
              ),
            }
          ],
        ),
      ),
    );
  }
}

class _AssetRowsGroupedListView extends StatelessWidget {
  final Future<void> Function() onRefresh;
  final ScrollController? scrollController;
  final List<TvRowDataContainer> assets;
  final GetGroupHeaderDataFromAssetRow extractHeaderPayload;
  final GroupHeaderSortCompareCallback? groupComparator;
  final GroupHeaderWidgetBuilder groupHeaderBuilder;
  final IndexedItemRowBuilder rowBuilder;
  final Function(TvRowDataContainer)? onRowTapped;
  final bool scrollable;
  final int groupingLevels;

  const _AssetRowsGroupedListView({
    Key? key,
    required this.onRefresh,
    required this.assets,
    required this.extractHeaderPayload,
    required this.groupHeaderBuilder,
    required this.rowBuilder,
    this.scrollable = true,
    this.onRowTapped,
    this.scrollController,
    this.groupComparator,
    this.groupingLevels = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (scrollable) {
      return RefreshIndicator(
        onRefresh: onRefresh,
        child: GroupedListView<TvRowDataContainer, GroupHeaderData>(
          controller: scrollController,
          key: const PageStorageKey<String>('market-view-list'),
          physics: const AlwaysScrollableScrollPhysics(),
          elements: assets,
          groupBy: extractHeaderPayload,
          groupHeaderBuilder: groupHeaderBuilder,
          indexedItemBuilder: (
            BuildContext ctx,
            TvRowDataContainer assets,
            int i,
          ) {
            return rowBuilder(
              ctx,
              assets,
              i,
              onTap: onRowTapped,
            );
          },
          sort: false,
          useStickyGroupSeparators: true,
          padding: EdgeInsets.only(bottom: 90.h),
          // next line should not be needed??
          groupComparator: groupComparator,
        ),
      );
    }

    return Column(
      children: [
        for (int i = 0; i < assets.length; i++) ...{
          //logic to display 2nd tier (usually date) header for grouped assets
          // if (i == 0 ||
          //     extractHeaderPayload(assets[i]).sortKey !=
          //         extractHeaderPayload(assets[i - 1]).sortKey)

          if (assets.sortKeyHasChangedFromPriorRow(
            i,
            extractHeaderPayload,
            groupingLevels,
          )) ...{
            groupHeaderBuilder(assets[i]),
          },
          rowBuilder(
            context,
            assets[i],
            i,
            onTap: onRowTapped,
          )
        }
      ],
    );
  }
}

class _AssetRowsSortedListView extends StatelessWidget {
  final Future<void> Function() onRefresh;
  final ScrollController? scrollController;
  final List<TvRowDataContainer> assets;
  final IndexedItemRowBuilder rowBuilder;
  final Function(TvRowDataContainer)? onRowTapped;
  final bool scrollable;

  const _AssetRowsSortedListView({
    Key? key,
    required this.onRefresh,
    required this.assets,
    required this.rowBuilder,
    this.scrollable = true,
    this.onRowTapped,
    this.scrollController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (scrollable) {
      return RefreshIndicator(
        onRefresh: onRefresh,
        child: ListView.builder(
          controller: scrollController,
          key: const PageStorageKey<String>('market-view-list'),
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: assets.length,
          itemBuilder: (BuildContext ctx, int idx) {
            return rowBuilder(
              ctx,
              assets[idx],
              idx,
              onTap: onRowTapped,
            );
          },
          padding: EdgeInsets.only(bottom: 90.h),
        ),
      );
    }

    return Column(
      children: [
        for (int i = 0; i < assets.length; i++) ...{
          rowBuilder(
            context,
            assets[i],
            i,
            onTap: onRowTapped,
          )
        }
      ],
    );
  }
}

class _DropDownMenuList extends StatefulWidget {
  final Set<String> listItems;
  final DbTableFieldName colName;
  final String titleName;
  final String? curSelection;
  final SelectedFilterSetter valSetter;
  final double width;
  final void Function(DbTableFieldName, String) doFilteringFor;
  // final String Function(DbTableFieldName) filterTitleExtractor;

  const _DropDownMenuList({
    Key? key,
    required this.listItems,
    required this.colName,
    required this.titleName,
    required this.curSelection,
    required this.valSetter,
    required this.width,
    required this.doFilteringFor,
    // required this.filterTitleExtractor,
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
                  child: Container(
                    color: widget.curSelection == val
                        ? StColors.primaryDarkGray
                        : StColors.black,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          val.toUpperCase(),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (val != widget.listItems.first)
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 0.5,
                            color: StColors.lightGray,
                          ),
                      ],
                    ),
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
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              );
            }).toList();
          },
          onChanged: (String? selectedVal) {
            // store selected value for state mgmt
            widget.valSetter(selectedVal);
            // print('changed: $selectedVal  ${widget.titleName}');
            if (selectedVal == null || selectedVal == widget.titleName) {
              // || selectedVal.startsWith(CLEAR_FILTER_LABEL)
              setState(() {
                _useDefaultState = true;
              });
              widget.doFilteringFor(widget.colName, "");
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

// class _GroupedAssetsListView extends StatelessWidget {
//   /*  logic should use the:
//       GroupedTableDataMgr.groupIsCollapsible property

//     group should NOT be collapsible if false
//   */
//   final Future<void> Function() onRefresh;
//   final ScrollController? scrollController;
//   final GetGroupHeaderLblsFromAssetGameData groupBy;
//   final GroupComparatorCallback? groupComparator;
//   final GroupHeaderBuilder groupHeaderBuilder;
//   final IndexedItemRowBuilder rowBuilder;
//   final Function(TableviewDataRowTuple)? onRowTapped;
//   final Map<String, List<TableviewDataRowTuple>>? groupedAssets;
//   final List<TableviewDataRowTuple>? assets;

//   const _GroupedAssetsListView({
//     Key? key,
//     required this.onRefresh,
//     required this.groupBy,
//     required this.groupHeaderBuilder,
//     required this.rowBuilder,
//     this.groupedAssets,
//     this.assets,
//     this.onRowTapped,
//     this.scrollController,
//     this.groupComparator,
//   })  : assert(
//           groupedAssets != null || assets != null,
//           "groupedAssets and assets cannot both be null",
//         ),
//         super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     if (groupedAssets != null) {
//       return _ExpandableGroupedAssetRowsListView(
//         onRefresh: onRefresh,
//         groupBy: groupBy,
//         groupHeaderBuilder: groupHeaderBuilder,
//         rowBuilder: rowBuilder,
//         groupedAssets: groupedAssets!,
//         onRowTapped: onRowTapped,
//         scrollController: scrollController,
//         groupComparator: groupComparator,
//       );
//     }
//     return _AssetRowsGroupedListView(
//       onRefresh: onRefresh,
//       assets: assets!,
//       groupBy: groupBy,
//       groupHeaderBuilder: groupHeaderBuilder,
//       rowBuilder: rowBuilder,
//       onRowTapped: onRowTapped,
//       scrollController: scrollController,
//       groupComparator: groupComparator,
//     );
//   }
// }
