part of AppEntities;

@JsonEnum()
enum ScreenAreaWidgetSlot {
  /*  key to describing field-name
    on some ApiMsg entity (asset, team, player, game)
    so we know which field to get to show in 
  */

  // ui-sub-area of the UI component
  header,
  footer,
  slot1, // aka menu position 1 on filter-bar
  slot2,
  slot3,

  // data property of the component
  title,
  subtitle,
  bannerUrl,
  // name,
  // iconPath,
  // occurDt,
  // startTime,
}

extension ScreenAreaWidgetSlotExt1 on ScreenAreaWidgetSlot {
  //

  // getters
  // none currently require prep
  // bool get requiresPrepQuestion => [].contains(this);
  String get choiceName => this.name;

  // methods
  // all currently configurable
  bool isConfigurableOn(ScreenWidgetArea forArea) =>
      this.possibleConfigRules(forArea).length > 0;

  List<VisualRuleType> possibleConfigRules(ScreenWidgetArea forArea) {
    switch (this) {
      case ScreenAreaWidgetSlot.header:
        return [
          VisualRuleType.showOrHide,
        ];
      case ScreenAreaWidgetSlot.footer:
        return [
          VisualRuleType.showOrHide,
        ];
      case ScreenAreaWidgetSlot.slot1:
        return [
          if (forArea == ScreenWidgetArea.filterBar) VisualRuleType.filterCfg,
          if (forArea == ScreenWidgetArea.tableview) VisualRuleType.sortCfg,
        ];
      case ScreenAreaWidgetSlot.slot2:
        return [
          if (forArea == ScreenWidgetArea.filterBar) VisualRuleType.filterCfg,
          if (forArea == ScreenWidgetArea.tableview) VisualRuleType.sortCfg,
        ];
      case ScreenAreaWidgetSlot.slot3:
        return [
          if (forArea == ScreenWidgetArea.filterBar) VisualRuleType.filterCfg,
          if (forArea == ScreenWidgetArea.tableview) VisualRuleType.sortCfg,
        ];
      case ScreenAreaWidgetSlot.title:
        return [
          VisualRuleType.styleOrFormat,
        ];
      case ScreenAreaWidgetSlot.subtitle:
        return [
          VisualRuleType.showOrHide,
        ];
      case ScreenAreaWidgetSlot.bannerUrl:
        return [
          VisualRuleType.showOrHide,
        ];
    }
  }

  List<Enum> possibleVisualStyles(
    AppScreen appScreen,
    ScreenWidgetArea screenWidgetArea,
  ) {
    switch (this) {
      case ScreenAreaWidgetSlot.header:
        return TvAreaRowStyle.values;
      case ScreenAreaWidgetSlot.footer:
        return [];
      case ScreenAreaWidgetSlot.slot1:
        return [];
      case ScreenAreaWidgetSlot.slot2:
        return [];
      case ScreenAreaWidgetSlot.slot3:
        return [];
      case ScreenAreaWidgetSlot.title:
        return [];
      case ScreenAreaWidgetSlot.subtitle:
        return [];
      case ScreenAreaWidgetSlot.bannerUrl:
        return [];
    }
  }

  List<VisualRuleType> convertIdxsToRuleList(
    AppScreen screen,
    ScreenWidgetArea area,
    String commaLstOfInts,
  ) {
    /* this == a ScreenAreaWidgetSlot
    
      since we dont show EVERY RuleType, 
      eg we skip VisualRuleType.generalDialogFlow  (zero)
      the choice indexes are offset by -1
      in other words Vrt.xxx.index of 1 is SHOWN in the zero position
      or its ACTUAL index is +1 from what the user user entered
      this code adjusts for that by using:    ++tempIdx
    */
    Set<int> providedIdxs = castStrOfIdxsToIterOfInts(commaLstOfInts).toSet();
    //
    int tempIdx = 0;
    Map<int, VisualRuleType> idxToModifiableRuleTyps = {};
    possibleConfigRules(area)
        .forEach((rt) => idxToModifiableRuleTyps[++tempIdx] = rt);
    //
    idxToModifiableRuleTyps.removeWhere(
      (
        int idx,
        VisualRuleType uic,
      ) =>
          !providedIdxs.contains(idx),
    );
    return idxToModifiableRuleTyps.values.toList();
  }
}
