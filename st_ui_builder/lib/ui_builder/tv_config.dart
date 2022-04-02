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
  final FilterRules? filterRules;
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
    CfgForAreaAndNestedSlots? filterBarAreaCfg,
  ) {
    //
    assert(tableAreaCfg.screenArea == ScreenWidgetArea.tableview, 'oops!');
    assert(
      filterBarAreaCfg == null ||
          filterBarAreaCfg.screenArea == ScreenWidgetArea.filterBar,
      'oops!',
    );

    return TableviewConfigPayload._(
      appScreen,
      tableAreaCfg.rowStyleCfg.selectedRowStyle,
      tableAreaCfg.sortingRules ?? SortingRules(TvSortCfg.noop(), null, null),
      filterBarAreaCfg?.filterRules!,
    );
  }

  TvRowBuilder get rowConstructor {
    /* row-style returned depends on the screen on this instance
       TODO:  implement remaining row styles

      this is an easy place to return the correct row
      for every screen, based on what was selected for the market-view screen
    */
    print(
      '@@@@ getting rowStyle constructor for ${rowStyle.name} on ${appScreen.name} screen',
    );
    switch (rowStyle) {
      case TvAreaRowStyle.assetVsAsset:
        switch (appScreen) {
          case AppScreen.marketView:
            return AssetVsAssetRow_MktView.new;
          case AppScreen.marketResearch:
            return AssetVsAssetRow_MktResrch.new;
          default:
            return AssetVsAssetRow_MktView.new;
        }
      case TvAreaRowStyle.assetVsAssetRanked:
        return AssetVsAssetRowRanked_MktView.new;
      case TvAreaRowStyle.teamVsField:
        return TeamVsFieldRow_MktView.new;
      // print(
      //   'rowConstructor runnning test code with TeamVsFieldRowTest',
      // );
      // return TeamVsFieldRowTest.new;
      case TvAreaRowStyle.teamVsFieldRanked:
        return TeamVsFieldRowRanked_MktView.new;
      // print(
      //   'rowConstructor runnning test code with TeamVsFieldRankedRowTest',
      // );
      // return TeamVsFieldRankedRowTest.new;
      case TvAreaRowStyle.teamDraft:
        return TeamDraftRow.new;
      case TvAreaRowStyle.teamLine:
        return TeamLineRow.new;
      case TvAreaRowStyle.teamPlayerVsField:
        return TeamPlayerVsFieldRow_MktView.new;
      case TvAreaRowStyle.playerVsField:
        return PlayerVsFieldRow.new;
      case TvAreaRowStyle.playerVsFieldRanked:
        return PlayerVsFieldRankedRow.new;
      case TvAreaRowStyle.playerDraft:
        return PlayerDraftRow.new;
      case TvAreaRowStyle.driverVsField:
        return DriverVsFieldRow_MktView.new;
      // default:
      //   return TeamVsTeamRow.new;
    }
  }
}
