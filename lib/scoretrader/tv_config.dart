part of StUiController;

/*

*/

class TableviewConfigPayload {
  /* needs to provide data for 
      grouping options
      sorting options
      row-style
  */

  final TvAreaRowStyle rowStyle;
  final GroupingRules groupByRules;
  final SortingRules sortRules;

  TableviewConfigPayload._(
    this.rowStyle,
    this.groupByRules,
    this.sortRules,
  );

  factory TableviewConfigPayload(CfgForAreaAndNestedSlots tableAreaCfg) {
    //
    assert(tableAreaCfg.screenArea == ScreenWidgetArea.tableview, 'oops!');
    SlotOrAreaRuleCfg tableRules =
        tableAreaCfg.areaRuleByRuleType(VisualRuleType.styleOrFormat);

    TvRowStyleCfg styleRule =
        tableRules.rulesOfType(VisualRuleType.styleOrFormat) as TvRowStyleCfg;

    GroupingRules groupRules = tableRules.groupingRules!;
    SortingRules sortRules = tableRules.sortingRules!;

    return TableviewConfigPayload._(
      styleRule.selectedRowStyle,
      groupRules,
      sortRules,
    );
  }

  TvRowBuilder get rowConstructor {
    // TODO:  implement remaining row styles

    switch (rowStyle) {
      case TvAreaRowStyle.teamVsTeam:
        return TeamVsTeamRow.new;
      case TvAreaRowStyle.teamVsTeamRanked:
        return TeamVsTeamRankedRow.new;
      case TvAreaRowStyle.teamVsField:
        return TeamVsFieldRow.new;
      case TvAreaRowStyle.teamVsFieldRanked:
        return TeamVsFieldRow.new;

      case TvAreaRowStyle.teamDraft:
        return TeamVsTeamRow.new;
      case TvAreaRowStyle.teamLine:
        return TeamVsTeamRow.new;
      case TvAreaRowStyle.teamPlayerVsField:
        return TeamVsTeamRow.new;
      case TvAreaRowStyle.playerVsField:
        return TeamVsTeamRow.new;
      case TvAreaRowStyle.playerVsFieldRanked:
        return TeamVsTeamRow.new;
      case TvAreaRowStyle.playerDraft:
        return TeamVsTeamRow.new;
      case TvAreaRowStyle.driverVsField:
        return TeamVsTeamRow.new;
      // default:
      //   return TeamVsTeamRow.new;
    }
  }
}
