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

  Map<String, List<TableviewDataRowTuple>>? get rowsGroupedByTitles =>
      _groupRowsByTitle(_filteredAssetRows);

  List<TableviewDataRowTuple> get listData => _sortRows(_filteredAssetRows);
  TvGroupCfg? get groupRules => _tableViewCfg.groupByRules;
  TvSortCfg get sortingRules => _tableViewCfg.sortRules;
  TvFilterCfg? get filterRules => _tableViewCfg.filterRules;

  String get fm1Title =>
      filterRules?.item1?.menuTitleIfFilter ??
      filterRules?.item1?.colName.name ??
      '';
  String get fm2Title =>
      filterRules?.item2?.menuTitleIfFilter ??
      filterRules?.item2?.colName.name ??
      '';
  String get fm3Title =>
      filterRules?.item3?.menuTitleIfFilter ??
      filterRules?.item3?.colName.name ??
      '';

  GetGroupHeaderLblsFromAssetGameData? get groupBy {
    return GroupHeaderData.groupHeaderPayloadConstructor(
      _tableViewCfg.groupByRules!,
    );
  }

  // groupHeaderBuilder is function to return header widget
  // defining groupHeaderBuilder will cause groupSeparatorBuilder to be ignored
  GroupHeaderBuilder get groupHeaderBuilder {
    if (disableAllGrouping || groupBy == null)
      return (_) => const SizedBox.shrink();

    // copy groupBy getter to save a lookup
    final TvAreaRowStyle rowStyle = _tableViewCfg.rowStyle;
    final GetGroupHeaderLblsFromAssetGameData gbFunc = groupBy!;
    return (TableviewDataRowTuple rowData) =>
        TvGroupHeader(rowStyle, appScreen, gbFunc(rowData));
  }

  // natural sorting will use my Comparator; dont need this
  // GroupComparatorCallback? get groupComparator => null;
  GroupComparatorCallback? get groupComparator {
    // GroupHeaderData implements comparable
    if (disableAllGrouping || groupBy == null) return null;

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
        int i, {
        Function(TableviewDataRowTuple)? onTap,
      }) {
        return _tableViewCfg.rowConstructor(assets, onTap: onTap);
      };

  // for sorting recs into order WITHIN groups/sections
  SectionSortComparator get itemComparator => GroupHeaderData.sortComparator(
      sortingRules, sortOrder == GroupedListOrder.ASC);

  bool get hasColumnFilters {
    return filterRules?.item1 != null && !disableAllGrouping;
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

    SortGroupFilterEntry? i1 = filterRules!.item1;
    SortGroupFilterEntry? i2 = filterRules!.item2;
    SortGroupFilterEntry? i3 = filterRules!.item3;

    Set<String> listItems1 = i1 == null ? {} : _getListItemsByCfgField(i1);
    Set<String> listItems2 = i2 == null ? {} : _getListItemsByCfgField(i2);
    Set<String> listItems3 = i3 == null ? {} : _getListItemsByCfgField(i3);

    const int _kLstMin = 2;

    bool has2ndList =
        i2 != null && listItems2.length > _kLstMin && i2.colName != i1?.colName;
    bool has3rdList =
        i3 != null && listItems3.length > _kLstMin && i3.colName != i2!.colName;

    int dropLstCount = 1 + (has2ndList ? 1 : 0) + (has3rdList ? 1 : 0);
    // allocate dropdown button width
    double allocBtnWidth = totAvailWidth / dropLstCount;
    // one list can take 86% of space
    allocBtnWidth = dropLstCount < 2 ? totAvailWidth * 0.86 : allocBtnWidth;

    if (i1 == null) return const SizedBox.shrink();

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
            titleName: i1.menuTitleIfFilter ??
                _filterTitleExtractor(i1.colName, i1.menuTitleIfFilter),
            curSelection: _filter1Selection,
            valSetter: (s) => _filter1Selection = s,
            width: allocBtnWidth,
            doFilteringFor: _doFilteringFor,
            // filterTitleExtractor: _filterTitleExtractor,
          ),
          if (has2ndList)
            _DropDownMenuList(
              listItems: listItems2,
              colName: i2.colName,
              titleName: i2.menuTitleIfFilter ??
                  _filterTitleExtractor(i2.colName, i2.menuTitleIfFilter),
              curSelection: _filter2Selection,
              valSetter: (s) => _filter2Selection = s,
              width: allocBtnWidth,
              doFilteringFor: _doFilteringFor,
              // filterTitleExtractor: _filterTitleExtractor,
            ),
          if (has3rdList)
            _DropDownMenuList(
              listItems: listItems3,
              colName: i3.colName,
              titleName: i3.menuTitleIfFilter ??
                  _filterTitleExtractor(i3.colName, i3.menuTitleIfFilter),
              curSelection: _filter3Selection,
              valSetter: (s) => _filter3Selection = s,
              width: allocBtnWidth,
              doFilteringFor: _doFilteringFor,
              // filterTitleExtractor: _filterTitleExtractor,
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

  String _filterTitleExtractor(
    DbTableFieldName fieldName,
    String? titleName,
  ) {
    bool isTeam = false;
    if (_allAssetRows.isNotEmpty) {
      isTeam = _allAssetRows.first.item1.isTeam;
    }
    if (titleName != null) return titleName;

    switch (fieldName) {
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
      default:
        return '_naLabel';
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
      case DbTableFieldName.competitionDate:
      case DbTableFieldName.competitionTime:
        rows.sort((a, b) => a.competitionDate.compareTo(b.competitionDate));
        break;

      case DbTableFieldName.assetOpenPrice:
      case DbTableFieldName.assetCurrentPrice:
      case DbTableFieldName.assetRankOrScore:
        rows.sort((a, b) {
          num item1Value = num.parse(a.valueExtractor(colName));
          num item2Value = num.parse(b.valueExtractor(colName));
          return item1Value.compareTo(item2Value);
        });
        break;
      default:
        rows.sort((a, b) => a.valueExtractor(colName).compareTo(
              b.valueExtractor(colName),
            ));
    }

    return rows;
  }

  Set<String> _getListItemsByCfgField(SortGroupFilterEntry filterItem) {
    /* build title and values for filter menu dropdown list

    */
    List<AssetRowPropertyIfc> sortedAssetRows =
        _getSortedAssetRows(filterItem.colName);

    List<String> labels = [
      _filterTitleExtractor(filterItem.colName, filterItem.menuTitleIfFilter),
      ...sortedAssetRows.map((e) => e.valueExtractor(filterItem.colName)),
    ];
    labels.removeWhere((label) => label.isEmpty);

    return <String>{...labels};
  }

  ///If groupings exist, this will arrange rows into groups
  ///and return a map of `groupTitle -> rows`
  Map<String, List<TableviewDataRowTuple>>? _groupRowsByTitle(
    List<TableviewDataRowTuple> rows,
  ) {
    if (rows.isEmpty ||
        (rows.isNotEmpty && rows.first.item1.groupName == null)) {
      return null;
    }

    rows = _sortRows(rows);

    Map<String, List<TableviewDataRowTuple>> rowsMap = {};

    for (var row in rows) {
      if (row.item1.groupName == null) continue;

      if (rowsMap[row.item1.groupName] == null) {
        rowsMap[row.item1.groupName!] = [row];
      } else {
        final tempRows = rowsMap[row.item1.groupName!]!;
        rowsMap[row.item1.groupName!] = [...tempRows, row];
      }
    }

    return rowsMap;
  }

  List<TableviewDataRowTuple> _sortRows(List<TableviewDataRowTuple> rows) {
    List<TableviewDataRowTuple> nonTradeableRows = [];
    List<TableviewDataRowTuple> tradeableRows = [];

    for (var row in rows) {
      if ([
        CompetitionStatus.compFinal,
        CompetitionStatus.compFinished,
        CompetitionStatus.compCanceled,
      ].contains(row.item1.competitionStatus)) {
        nonTradeableRows.add(row);
      } else {
        tradeableRows.add(row);
      }
    }

    return [...tradeableRows, ...nonTradeableRows];
  }

  final Set<FilterSelection> _currentFilters = {};

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
        .removeWhere((selection) => selection.filterColumn == colName);
    _currentFilters.add(filterSelection);

    if ([fm1Title, fm2Title, fm3Title].contains(selectedVal)) {
      // sloppy test above;  prob creates a bug
      // .toUpperCase() == colName.name.toUpperCase()
      _currentFilters
          .removeWhere((selection) => selection.filterColumn == colName);

      if (_currentFilters.isEmpty) {
        clearFilters();
        return;
      }
    }

    List<TableviewDataRowTuple> filterResults = [];

    for (var asset in _allAssetRows) {
      bool added = false;
      for (var filter in _currentFilters) {
        if (asset.item1.valueExtractor(filter.filterColumn) ==
                filter.selectedValue ||
            asset.item2?.valueExtractor(filter.filterColumn) ==
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

  ///ListView of rows typically displayed in MarketView.
  ///This is implemented internally as opposed to just exposing
  ///the row builder in order to implement the nested grouping structure
  ///for some rows.
  Widget assetRowsListView({
    required Future<void> Function() onRefresh,
    ScrollController? scrollController,
    Function(TableviewDataRowTuple)? onRowTapped,
  }) {
    List<TableviewDataRowTuple>? assets;
    Map<String, List<TableviewDataRowTuple>>? groupedAssets =
        rowsGroupedByTitles;

    if (groupedAssets == null) {
      assets = listData;
    }

    return _GroupedAssetsListView(
      onRefresh: onRefresh,
      scrollController: scrollController,
      onRowTapped: onRowTapped,
      groupBy: groupBy!,
      groupHeaderBuilder: groupHeaderBuilder,
      rowBuilder: indexedItemBuilder,
      groupComparator: groupComparator,
      groupedAssets: groupedAssets,
      assets: assets,
    );
  }
}

class _GroupedAssetsListView extends StatelessWidget {
  final Future<void> Function() onRefresh;
  final ScrollController? scrollController;
  final GetGroupHeaderLblsFromAssetGameData groupBy;
  final GroupComparatorCallback? groupComparator;
  final GroupHeaderBuilder groupHeaderBuilder;
  final IndexedItemRowBuilder rowBuilder;
  final Function(TableviewDataRowTuple)? onRowTapped;
  final Map<String, List<TableviewDataRowTuple>>? groupedAssets;
  final List<TableviewDataRowTuple>? assets;

  const _GroupedAssetsListView({
    Key? key,
    required this.onRefresh,
    required this.groupBy,
    required this.groupHeaderBuilder,
    required this.rowBuilder,
    this.groupedAssets,
    this.assets,
    this.onRowTapped,
    this.scrollController,
    this.groupComparator,
  })  : assert(
          groupedAssets != null || assets != null,
          "groupedAssets and assets cannot both be null",
        ),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    if (groupedAssets != null) {
      return _ExpandableGroupedAssetRowsListView(
        onRefresh: onRefresh,
        groupBy: groupBy,
        groupHeaderBuilder: groupHeaderBuilder,
        rowBuilder: rowBuilder,
        groupedAssets: groupedAssets!,
        onRowTapped: onRowTapped,
        scrollController: scrollController,
        groupComparator: groupComparator,
      );
    }
    return _AssetRowsListView(
      onRefresh: onRefresh,
      assets: assets!,
      groupBy: groupBy,
      groupHeaderBuilder: groupHeaderBuilder,
      rowBuilder: rowBuilder,
      onRowTapped: onRowTapped,
      scrollController: scrollController,
      groupComparator: groupComparator,
    );
  }
}

class _ExpandableGroupedAssetRowsListView extends StatefulWidget {
  final Future<void> Function() onRefresh;
  final ScrollController? scrollController;
  final GetGroupHeaderLblsFromAssetGameData groupBy;
  final GroupComparatorCallback? groupComparator;
  final GroupHeaderBuilder groupHeaderBuilder;
  final IndexedItemRowBuilder rowBuilder;
  final Function(TableviewDataRowTuple)? onRowTapped;
  final Map<String, List<TableviewDataRowTuple>> groupedAssets;

  const _ExpandableGroupedAssetRowsListView({
    Key? key,
    required this.onRefresh,
    required this.groupBy,
    required this.groupHeaderBuilder,
    required this.rowBuilder,
    required this.groupedAssets,
    this.onRowTapped,
    this.scrollController,
    this.groupComparator,
  }) : super(key: key);

  @override
  State<_ExpandableGroupedAssetRowsListView> createState() =>
      _ExpandableGroupedAssetRowsListViewState();
}

class _ExpandableGroupedAssetRowsListViewState
    extends State<_ExpandableGroupedAssetRowsListView> {
  late List<String> _groupTitles = widget.groupedAssets.keys.toList();

  @override
  void didUpdateWidget(_ExpandableGroupedAssetRowsListView oldWidget) {
    if (oldWidget.groupedAssets != widget.groupedAssets) {
      setState(() {
        _groupTitles = widget.groupedAssets.keys.toList();
      });
    }
    super.didUpdateWidget(oldWidget);
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
            for (int i = 0; i < widget.groupedAssets.keys.length; i++) ...{
              ExpansionTile(
                initiallyExpanded: true,
                iconColor: Colors.white,
                collapsedIconColor: Colors.white,
                textColor: Colors.white,
                title: Text(
                  _groupTitles[i],
                  style: StTextStyles.h4,
                ),
                children: [
                  _AssetRowsListView(
                    scrollable: false,
                    onRefresh: widget.onRefresh,
                    assets: widget.groupedAssets[_groupTitles[i]] ?? [],
                    groupBy: widget.groupBy,
                    groupComparator: widget.groupComparator,
                    groupHeaderBuilder: widget.groupHeaderBuilder,
                    rowBuilder: widget.rowBuilder,
                    onRowTapped: widget.onRowTapped,
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

class _AssetRowsListView extends StatelessWidget {
  final Future<void> Function() onRefresh;
  final ScrollController? scrollController;
  final List<TableviewDataRowTuple> assets;
  final GetGroupHeaderLblsFromAssetGameData groupBy;
  final GroupComparatorCallback? groupComparator;
  final GroupHeaderBuilder groupHeaderBuilder;
  final IndexedItemRowBuilder rowBuilder;
  final Function(TableviewDataRowTuple)? onRowTapped;
  final bool scrollable;

  const _AssetRowsListView({
    Key? key,
    required this.onRefresh,
    required this.assets,
    required this.groupBy,
    required this.groupHeaderBuilder,
    required this.rowBuilder,
    this.scrollable = true,
    this.onRowTapped,
    this.scrollController,
    this.groupComparator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (scrollable) {
      return RefreshIndicator(
        onRefresh: onRefresh,
        child: GroupedListView<TableviewDataRowTuple, GroupHeaderData>(
          controller: scrollController,
          key: const PageStorageKey<String>('market-view-list'),
          physics: const AlwaysScrollableScrollPhysics(),
          elements: assets,
          groupBy: groupBy,
          groupHeaderBuilder: groupHeaderBuilder,
          indexedItemBuilder: (
            BuildContext ctx,
            TableviewDataRowTuple assets,
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
          //logic to display date header for grouped assets
          if (i == 0 ||
              groupBy(assets[i])._sortKey !=
                  groupBy(assets[i - 1])._sortKey) ...{
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
