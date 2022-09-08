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
  // which screen this cfg applies to
  final AppScreen appScreen;
  // style / appearance of rows in its listview
  final TvAreaRowStyle rowStyle;
  //
  final TvSortCfg sortRules;
  final TvFilterCfg? filterRules;
  final TvGroupCfg? groupByRules;

  TableviewConfigPayload(
    // private constructor
    this.appScreen,
    this.rowStyle,
    this.sortRules,
    this.filterRules,
    this.groupByRules,
  );

  factory TableviewConfigPayload.orig(
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

    return TableviewConfigPayload(
      appScreen,
      tableAreaCfg.rowStyleCfg.selectedRowStyle,
      tableAreaCfg.sortingRules ?? TvSortCfg.noop(),
      filterBarAreaCfg?.filterRules, // ?? TvFilterCfg.noop()
      tableAreaCfg.groupingRules,
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
          case TvAreaRowStyle.teamVsFieldRanked:
            return TeamVsFieldRowRankedMktView.new;
          case TvAreaRowStyle.playerVsField:
            return PlayerVsFieldRowMktView.new;
          case TvAreaRowStyle.playerVsFieldRanked:
            return PlayerVsFieldRankedRowMktView.new;
          case TvAreaRowStyle.driverVsField:
            return DriverVsFieldRowMktView.new;
          case TvAreaRowStyle.teamPlayerVsField:
            return TeamPlayerVsFieldRowMktView.new;
          case TvAreaRowStyle.teamLine:
            return TeamLineRowMktView.new;
          case TvAreaRowStyle.teamDraft:
            return DraftTeamRowMktView.new;
          case TvAreaRowStyle.playerDraft:
            return DraftPlayerRowMktView.new;
          default:
            return AssetVsAssetRowMktView.new;
        }
      case AppScreen.marketResearch:
        switch (rowStyle) {
          case TvAreaRowStyle.assetVsAsset:
            return AssetVsAssetRowMktResearchView.new;
          case TvAreaRowStyle.assetVsAssetRanked:
            return AssetVsAssetRankedRowMktResearchView.new;
          case TvAreaRowStyle.teamVsField:
            return TeamVsFieldRowMktResearchView.new;
          case TvAreaRowStyle.teamVsFieldRanked:
            return TeamVsFieldRankedRowMktResearchView.new;
          case TvAreaRowStyle.playerVsField:
            return PlayerVsFieldRowMktResearchView.new;
          case TvAreaRowStyle.playerVsFieldRanked:
            return PlayerVsFieldRankedMktResearchView.new;
          case TvAreaRowStyle.driverVsField:
            return DriverVsFieldRowMktResearchView.new;
          case TvAreaRowStyle.teamPlayerVsField:
            return TeamPlayerVsFieldRowMktResearchView.new;
          case TvAreaRowStyle.teamLine:
            return TeamLineRowMktResearchView.new;
          case TvAreaRowStyle.teamDraft:
            return DraftTeamRowMktResearchView.new;
          case TvAreaRowStyle.playerDraft:
            return DraftPlayerRowMktResearchView.new;
          default:
            return AssetVsAssetRowMktResearchView.new;
        }
      case AppScreen.portfolioPositions:
        switch (rowStyle) {
          case TvAreaRowStyle.assetVsAsset:
            return AssetVsAssetRowPortfolioView.new;
          case TvAreaRowStyle.assetVsAssetRanked:
            return AssetVsAssetRowRankedPortfolioView.new;
          case TvAreaRowStyle.teamVsField:
            return TeamVsFieldRowPortfolioView.new;
          case TvAreaRowStyle.teamVsFieldRanked:
            return TeamVsFieldRankedRowPortfolioView.new;
          case TvAreaRowStyle.playerVsField:
            return PlayerVsFieldRowPortfolioView.new;
          case TvAreaRowStyle.playerVsFieldRanked:
            return PlayerVsFieldRankedPortfolioView.new;
          case TvAreaRowStyle.driverVsField:
            return DriverVsFieldRowPortfolio.new;
          case TvAreaRowStyle.teamPlayerVsField:
            return TeamPlayerVsFieldRowPortfolio.new;
          case TvAreaRowStyle.teamLine:
            return TeamLineRowPortfolioView.new;
          case TvAreaRowStyle.teamDraft:
            return DraftTeamRowPortfolioView.new;
          case TvAreaRowStyle.playerDraft:
            return DraftPlayerRowPortfolioView.new;
          default:
            return AssetVsAssetRowPortfolioView.new;
        }
      case AppScreen.portfolioHistory:
        switch (rowStyle) {
          case TvAreaRowStyle.assetVsAsset:
            return AssetVsAssetRowPortfolioHistory.new;
          case TvAreaRowStyle.assetVsAssetRanked:
            return AssetVsAssetRankedRowPortfolioHistory.new;
          case TvAreaRowStyle.teamVsField:
            return TeamVsFieldRowPortfolioHistoryView.new;
          case TvAreaRowStyle.teamVsFieldRanked:
            return TeamVsFieldRankedRowPortfolioHistoryView.new;
          case TvAreaRowStyle.playerVsField:
            return PlayerVsFieldRowPortfolioHistoryView.new;
          case TvAreaRowStyle.playerVsFieldRanked:
            return PlayerVsFieldRankedPortfolioHistoryView.new;
          case TvAreaRowStyle.driverVsField:
            return DriverVsFieldRowPortfolioHistory.new;
          case TvAreaRowStyle.teamPlayerVsField:
            return TeamPlayerVsFieldRowPortfolioHistory.new;
          case TvAreaRowStyle.teamLine:
            return TeamLineRowPortfolioHistoryView.new;
          case TvAreaRowStyle.teamDraft:
            return DraftTeamRowPortfolioHistoryView.new;
          case TvAreaRowStyle.playerDraft:
            return DraftPlayerRowPortfolioHistoryView.new;
          default:
            return AssetVsAssetRowPortfolioHistory.new;
        }
      default:
        return AssetVsAssetRowMktView.new;
    }
  }
}
