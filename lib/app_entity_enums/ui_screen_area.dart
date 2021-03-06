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
  String includeStr(AppScreen section) =>
      'On Section ${section.name}, do you want to configure the ${this.name}?';

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
          ScreenAreaWidgetSlot.menuSortPosOrSlot1,
          ScreenAreaWidgetSlot.menuSortPosOrSlot2,
          ScreenAreaWidgetSlot.menuSortPosOrSlot3,
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
        return [
          ScreenAreaWidgetSlot.menuSortPosOrSlot1,
          ScreenAreaWidgetSlot.menuSortPosOrSlot2,
          ScreenAreaWidgetSlot.menuSortPosOrSlot3,
        ];
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
        // all its rules are under its slots
        return [];
      case ScreenWidgetArea.header:
        return [
          VisualRuleType.styleOrFormat,
          VisualRuleType.showOrHide,
        ];
      case ScreenWidgetArea.banner:
        return [VisualRuleType.showOrHide];
      case ScreenWidgetArea.tableview:
        // sorting rules live under its slots
        // row-style is area level
        return [
          VisualRuleType.styleOrFormat,
        ];
      case ScreenWidgetArea.footer:
        return [VisualRuleType.showOrHide];
      // case UiComponent.ticker:
      //   return [VisualRuleType.show];
      // case UiComponent.tabBar:
      //   return [];
    }
  }

  //
  List<VisualRuleType> convertIdxsToRuleList(
    AppScreen screen,
    String commaLstOfInts,
  ) {
    // since we dont show EVERY RuleType, the choice indexes are offset
    // need to fix that
    Set<int> providedIdxs = castStrOfIdxsToIterOfInts(commaLstOfInts).toSet();
    //
    Map<int, VisualRuleType> idxToModifiableRuleTyps = {};
    int tempIdx = 0;
    this
        .applicableRuleTypes(screen)
        .forEach((rt) => idxToModifiableRuleTyps[++tempIdx] = rt);
    idxToModifiableRuleTyps
        .removeWhere((idx, uic) => !providedIdxs.contains(idx));
    return idxToModifiableRuleTyps.values.toList();
  }
}
