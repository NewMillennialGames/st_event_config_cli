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
  final GroupingRules groupByRules;
  final SortingRules sortRules;
  final FilterRules filterRules;

  TableviewConfigPayload._(
    this.appScreen,
    this.rowStyle,
    this.groupByRules,
    this.sortRules,
    this.filterRules,
  );

  factory TableviewConfigPayload(
    AppScreen appScreen,
    CfgForAreaAndNestedSlots tableAreaCfg,
  ) {
    //
    assert(tableAreaCfg.screenArea == ScreenWidgetArea.tableview, 'oops!');
    //
    SlotOrAreaRuleCfg tableAreaRules =
        tableAreaCfg.areaRuleByRuleType(VisualRuleType.styleOrFormat);
    TvRowStyleCfg tvRowStyleRule = tableAreaRules
        .rulesOfType(VisualRuleType.styleOrFormat) as TvRowStyleCfg;

    return TableviewConfigPayload._(
      appScreen,
      tvRowStyleRule.selectedRowStyle,
      tableAreaRules.groupingRules!,
      tableAreaRules.sortingRules!,
      tableAreaRules.filterRules!,
    );
  }

  TvRowBuilder get rowConstructor {
    // TODO:  implement remaining row styles

    switch (rowStyle) {
      case TvAreaRowStyle.assetVsAsset:
        return AssetVsAssetRow.new;
      case TvAreaRowStyle.assetVsAssetRanked:
        return AssetVsAssetRankedRow.new;
      case TvAreaRowStyle.teamVsField:
        return TeamVsFieldRow.new;
      case TvAreaRowStyle.teamVsFieldRanked:
        return TeamVsFieldRankedRow.new;

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
