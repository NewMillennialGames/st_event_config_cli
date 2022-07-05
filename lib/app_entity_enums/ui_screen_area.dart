part of AppEntities;

@JsonEnum()
enum ScreenWidgetArea {
  // each configurable area in a screen/section of the app
  // each below has subset of UiComponentSlotName
  navBar,
  filterBar,
  header,
  banner,
  tableview,
  footer,
  // ticker,
  // tabBar
}

extension ScreenWidgetAreaExt1 on ScreenWidgetArea {
  //
  // String includeStr(AppScreen section) =>
  //     'On Section ${section.name}, do you want to configure the ${this.name}?';

  bool get hasNoRuleEnabledSlots => [ScreenWidgetArea.tableview].contains(this);
  bool get requiresPrepQuestion => [ScreenWidgetArea.filterBar].contains(this);

  // intentionally checking rules here (in addition to slots)
  // an area can be configurable EVEN IF it has ZERO
  // configurable slots (if it just has rules available)
  bool get isConfigureable => true;
  // this.applicableRuleTypes.length > 0 ||
  // this.applicableWigetSlots.length > 0;

  List<ScreenAreaWidgetSlot> applicableWigetSlots(AppScreen screen) {
    //
    switch (this) {
      case ScreenWidgetArea.navBar:
        return [
          ScreenAreaWidgetSlot.title,
          ScreenAreaWidgetSlot.subtitle,
        ];
      case ScreenWidgetArea.filterBar:
        return [
          // ScreenAreaWidgetSlot.slot1,
          // ScreenAreaWidgetSlot.slot2,
          // ScreenAreaWidgetSlot.slot3,
        ];
      case ScreenWidgetArea.header:
        return [
          ScreenAreaWidgetSlot.title,
          ScreenAreaWidgetSlot.subtitle,
        ];
      case ScreenWidgetArea.banner:
        return [
          ScreenAreaWidgetSlot.bannerUrl,
        ];
      case ScreenWidgetArea.tableview:
        return [];
      case ScreenWidgetArea.footer:
        return [
          ScreenAreaWidgetSlot.title,
          ScreenAreaWidgetSlot.subtitle,
        ];
      // case UiComponent.ticker:
      //   return [VisualRuleType.show];
      // case UiComponent.tabBar:
      //   return [];
    }
  }

  List<VisualRuleType> applicableRuleTypes(AppScreen screen) {
    // customize this list to control what customization
    // rules go with this ui component
    switch (this) {
      case ScreenWidgetArea.navBar:
        return [VisualRuleType.styleOrFormat];
      case ScreenWidgetArea.filterBar:
        return [
          VisualRuleType.filterCfg,
        ];
      case ScreenWidgetArea.header:
        return [
          // VisualRuleType.styleOrFormat,
          VisualRuleType.showOrHide,
        ];
      case ScreenWidgetArea.banner:
        return [VisualRuleType.showOrHide];
      case ScreenWidgetArea.tableview:
        // tables (listviews) have no slots
        // if user picks any of (filter, sort, group)
        // we'll ask how many (of 0-3 options) they wish to configure
        // for that specific rule
        return [
          VisualRuleType.styleOrFormat,
          VisualRuleType.sortCfg,
          VisualRuleType.groupCfg,
        ];
      case ScreenWidgetArea.footer:
        return [VisualRuleType.showOrHide];
      // case UiComponent.ticker:
      //   return [VisualRuleType.show];
      // case UiComponent.tabBar:
      //   return [];
    }
  }

  List<Enum> possibleVisualStyles(
    AppScreen appScreen,
  ) {
    /* what are the visual style options
    for this area in this screen
    */
    switch (this) {
      case ScreenWidgetArea.navBar:
        return [];
      case ScreenWidgetArea.filterBar:
        return [];
      case ScreenWidgetArea.header:
        return [];
      case ScreenWidgetArea.banner:
        return [];
      case ScreenWidgetArea.tableview:
        return TvAreaRowStyle.values;
      case ScreenWidgetArea.footer:
        return [];
    }
  }

  //
  List<VisualRuleType> convertIdxsToRuleList(
    AppScreen screen,
    String commaLstOfInts,
  ) {
    /* this == a ScreenWidgetArea
    
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
    applicableRuleTypes(screen)
        .forEach((rt) => idxToModifiableRuleTyps[++tempIdx] = rt);
    //
    idxToModifiableRuleTyps.removeWhere(
      (int idx, VisualRuleType uic) => !providedIdxs.contains(idx),
    );
    return idxToModifiableRuleTyps.values.toList();
  }
}
