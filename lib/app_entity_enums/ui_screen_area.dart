part of AppEntities;

enum ScreenWidgetArea {
  // each part in a section of the app
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
  bool get isConfigureable =>
      this.applicableRuleTypes.length > 0 ||
      this.applicableWigetSlots.length > 0;

  List<ScreenAreaWidgetSlot> get applicableWigetSlots {
    //
    switch (this) {
      case ScreenWidgetArea.navBar:
        return [
          ScreenAreaWidgetSlot.title,
          ScreenAreaWidgetSlot.subtitle,
        ];
      case ScreenWidgetArea.filterBar:
        return [
          ScreenAreaWidgetSlot.slot1,
          ScreenAreaWidgetSlot.slot2,
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
          ScreenAreaWidgetSlot.rowStyle,
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

  List<VisualRuleType> get applicableRuleTypes {
    // customize this list to control what customization
    // rules go with this ui component
    switch (this) {
      case ScreenWidgetArea.navBar:
        return [VisualRuleType.format];
      case ScreenWidgetArea.filterBar:
        return [VisualRuleType.filter];
      case ScreenWidgetArea.header:
        return [VisualRuleType.format, VisualRuleType.show];
      case ScreenWidgetArea.banner:
        return [VisualRuleType.show];
      case ScreenWidgetArea.tableview:
        return [
          VisualRuleType.format,
          VisualRuleType.group,
          VisualRuleType.sort
        ];
      case ScreenWidgetArea.footer:
        return [VisualRuleType.show];
      // case UiComponent.ticker:
      //   return [VisualRuleType.show];
      // case UiComponent.tabBar:
      //   return [];
    }
  }

  //
  List<VisualRuleType> convertIdxsToRuleList(String commaLstOfInts) {
    // since we dont show EVERY RuleType, the choice indexes are offset
    // need to fix that
    List<int> providedIdxs =
        commaLstOfInts.split(",").map((e) => int.tryParse(e) ?? -1).toList();
    //
    Map<int, VisualRuleType> idxToModifiableRuleTyps = {};
    int tempIdx = 0;
    this
        .applicableRuleTypes
        .forEach((rt) => idxToModifiableRuleTyps[++tempIdx] = rt);
    idxToModifiableRuleTyps
        .removeWhere((idx, uic) => !providedIdxs.contains(idx));
    return idxToModifiableRuleTyps.values.toList();
  }
}
