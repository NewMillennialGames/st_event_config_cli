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
    // TODO:  lets swap order of the switch to test appScreen first
    // that will let us simplifly and consolidate logic for identical rows
    switch (appScreen) {
      case AppScreen.marketView:
        switch (rowStyle) {
          case TvAreaRowStyle.assetVsAsset:
            return AssetVsAssetRow_MktView.new;
          case TvAreaRowStyle.assetVsAssetRanked:
            return AssetVsAssetRowRanked_MktView.new;
          case TvAreaRowStyle.teamVsField:
            return TeamVsFieldRow_MktView.new;
          case TvAreaRowStyle.playerVsFieldRanked:
            return PlayerVsFieldRankedRow_MktView.new;
          case TvAreaRowStyle.driverVsField:
            return DriverVsFieldRow_MktView.new;
          case TvAreaRowStyle.teamPlayerVsField:
            return TeamPlayerVsFieldRow_MktView.new;
          default:
            return AssetVsAssetRow_MktView.new;
        }
      case AppScreen.marketResearch:
        switch (rowStyle) {
          case TvAreaRowStyle.assetVsAsset:
            return AssetVsAssetRow_MktResrch.new;
          case TvAreaRowStyle.assetVsAssetRanked:
            return AssetVsAssetRow_MktResrch.new;
          case TvAreaRowStyle.teamVsField:
            return TeamVsFieldRow_MktView.new;
          case TvAreaRowStyle.playerVsFieldRanked:
            return TeamVsFieldRow_MktView.new;
          case TvAreaRowStyle.driverVsField:
            return DriverVsFieldRow_MktView.new;
          case TvAreaRowStyle.teamPlayerVsField:
            return TeamPlayerVsFieldRow_MktView.new;
          default:
            return AssetVsAssetRow_MktResrch.new;
        }
      case AppScreen.portfolio:
        switch (rowStyle) {
          case TvAreaRowStyle.assetVsAsset:
            return AssetVsAssetRow_Portfolio.new;
          case TvAreaRowStyle.assetVsAssetRanked:
            return AssetVsAssetRow_Portfolio.new;
          case TvAreaRowStyle.teamVsField:
            return AssetVsAssetRow_Portfolio.new;
          case TvAreaRowStyle.playerVsFieldRanked:
            return AssetVsAssetRow_Portfolio.new;
          case TvAreaRowStyle.driverVsField:
            return DriverVsFieldRow_Portfolio.new;
          case TvAreaRowStyle.teamPlayerVsField:
            return TeamPlayerVsFieldRow_Portfolio.new;
          default:
            return AssetVsAssetRow_Portfolio.new;
        }

      default:
        return AssetVsAssetRow_MktView.new;
      // case AppScreen.portfolioHistory:

      //   return TeamVsTeamRow.new;
    }
  }
}