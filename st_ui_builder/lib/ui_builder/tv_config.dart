part of StUiController;

/*

*/

class TableviewConfigPayload {
  /* needs to provide data for 
      grouping options
      sorting options
      row-style
      and filter options
  */

  final AppScreen appScreen;
  final TvAreaRowStyle rowStyle;
  final SortingRules sortRules;
  final FilterRules filterRules;
  // final GroupingRules groupByRules;

  TableviewConfigPayload._(
    // private constructor
    this.appScreen,
    this.rowStyle,
    this.sortRules,
    this.filterRules,
    // this.groupByRules,
  );

  factory TableviewConfigPayload(
    AppScreen appScreen,
    CfgForAreaAndNestedSlots tableAreaCfg,
    CfgForAreaAndNestedSlots filterBarAreaCfg,
  ) {
    //
    assert(tableAreaCfg.screenArea == ScreenWidgetArea.tableview, 'oops!');
    assert(filterBarAreaCfg.screenArea == ScreenWidgetArea.filterBar, 'oops!');

    return TableviewConfigPayload._(
      appScreen,
      tableAreaCfg.rowStyleCfg.selectedRowStyle,
      tableAreaCfg.sortingRules!,
      filterBarAreaCfg.filterRules!,
    );
  }

  TvRowBuilder get rowConstructor {
    /* row-style returned depends on the screen on this instance
       TODO:  implement remaining row styles

      this is an easy place to return the correct row
      for every screen, based on what was selected for the market-view screen
    */

    switch (rowStyle) {
      case TvAreaRowStyle.assetVsAsset:
        return AssetVsAssetRow.new;
      case TvAreaRowStyle.assetVsAssetRanked:
        return AssetVsAssetRankedRow.new;
      case TvAreaRowStyle.teamVsField:
        // return TeamVsFieldRow.new;
        print(
          'rowConstructor runnning test code with TeamVsFieldRowTest',
        );
        return TeamVsFieldRowTest.new;
      case TvAreaRowStyle.teamVsFieldRanked:
        // return TeamVsFieldRankedRow.new;
        print(
          'rowConstructor runnning test code with TeamVsFieldRankedRowTest',
        );
        return TeamVsFieldRankedRowTest.new;
      case TvAreaRowStyle.teamDraft:
        return TeamDraftRow.new;
      case TvAreaRowStyle.teamLine:
        return TeamLineRow.new;
      case TvAreaRowStyle.teamPlayerVsField:
        return TeamPlayerVsFieldRow.new;
      case TvAreaRowStyle.playerVsField:
        return PlayerVsFieldRow.new;
      case TvAreaRowStyle.playerVsFieldRanked:
        return PlayerVsFieldRankedRow.new;
      case TvAreaRowStyle.playerDraft:
        return PlayerDraftRow.new;
      case TvAreaRowStyle.driverVsField:
        return DriverVsFieldRow.new;
      // default:
      //   return TeamVsTeamRow.new;
    }
  }
}
