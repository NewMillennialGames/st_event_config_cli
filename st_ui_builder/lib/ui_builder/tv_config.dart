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
      filterBarAreaCfg?.filterRules,
    );
  }

  void endGeographicGrouping() {
    // games now happening between/across regions
    // so it not longer makes sense to group or sort geographically
    print('called endGeographicGrouping;  not yet implemented');
    // sortRules.removeByField(DbTableFieldName.gameLocation);
    // groupByRules.removeByField(DbTableFieldName.gameLocation);
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
            return AssetVsAssetRowMktView.new;
          case TvAreaRowStyle.assetVsAssetRanked:
            return AssetVsAssetRowRankedMktView.new;
          case TvAreaRowStyle.teamVsField:
            return TeamVsFieldRowMktView.new;
          case TvAreaRowStyle.playerVsField:
            return PlayerVsFieldRowMktView.new;
          case TvAreaRowStyle.playerVsFieldRanked:
            return PlayerVsFieldRankedRowMktView.new;
          case TvAreaRowStyle.driverVsField:
            return DriverVsFieldRowMktView.new;
          case TvAreaRowStyle.teamPlayerVsField:
            return TeamPlayerVsFieldRowMktView.new;
          default:
            return AssetVsAssetRowMktView.new;
        }
      case AppScreen.marketResearch:
        switch (rowStyle) {
          case TvAreaRowStyle.assetVsAsset:
            return AssetVsAssetRowMktResearchView.new;
          case TvAreaRowStyle.assetVsAssetRanked:
            return AssetVsAssetRowMktResearchView.new;
          case TvAreaRowStyle.teamVsField:
            return TeamVsFieldRowMktResearchView.new;
          case TvAreaRowStyle.playerVsField:
            return PlayerVsFieldRowMktResearchView.new;
          case TvAreaRowStyle.playerVsFieldRanked:
            return PlayerVsFieldRankedMktResearchView.new;
          case TvAreaRowStyle.driverVsField:
            return DriverVsFieldRowMktResearchView.new;
          case TvAreaRowStyle.teamPlayerVsField:
            return TeamPlayerVsFieldRowMktResearchView.new;
          default:
            return AssetVsAssetRowMktResearchView.new;
        }
      case AppScreen.portfolio:
        switch (rowStyle) {
          case TvAreaRowStyle.assetVsAsset:
            return AssetVsAssetRowPortfolioView.new;
          case TvAreaRowStyle.assetVsAssetRanked:
            return AssetVsAssetRowRankedPortfolioView.new;
          case TvAreaRowStyle.teamVsField:
            return TeamVsFieldRowPortfolioView.new;
          case TvAreaRowStyle.playerVsField:
            return PlayerVsFieldRowPortfolioView.new;
          case TvAreaRowStyle.playerVsFieldRanked:
            return PlayerVsFieldRankedPortfolioView.new;
          case TvAreaRowStyle.driverVsField:
            return DriverVsFieldRowPortfolio.new;
          case TvAreaRowStyle.teamPlayerVsField:
            return TeamPlayerVsFieldRowPortfolio.new;
          default:
            return AssetVsAssetRowPortfolioView.new;
        }

      default:
        return AssetVsAssetRowMktView.new;
      // case AppScreen.portfolioHistory:

      //   return TeamVsTeamRow.new;
    }
  }
}
