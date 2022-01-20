part of AppEntities;

enum ScreenWidgetArea {
  // each part in a section of the app
  // each below has subset of UiComponentSlotName
  navBar,
  filterBar,
  header,
  banner,
  tableRow,
  footer,
  // ticker,
  // tabBar
}

extension ScreenWidgetAreaExt1 on ScreenWidgetArea {
  //
  String includeStr(AppScreen section) =>
      'On Section ${section.name}, do you want to configure the ${this.name}?';

  bool get isConfigureable => this.applicableRuleTypes.length > 0;

  List<SubWidgetInScreenArea> get applicablePropertySlots {
    //
    switch (this) {
      case ScreenWidgetArea.navBar:
        return [
          SubWidgetInScreenArea.title,
          SubWidgetInScreenArea.subtitle,
        ];
      case ScreenWidgetArea.filterBar:
        return [
          SubWidgetInScreenArea.slot1,
          SubWidgetInScreenArea.slot2,
        ];
      case ScreenWidgetArea.header:
        return [
          SubWidgetInScreenArea.title,
          SubWidgetInScreenArea.subtitle,
        ];
      case ScreenWidgetArea.banner:
        return [
          SubWidgetInScreenArea.bannerUrl,
        ];
      case ScreenWidgetArea.tableRow:
        return [
          SubWidgetInScreenArea.rowStyle,
        ];
      case ScreenWidgetArea.footer:
        return [
          SubWidgetInScreenArea.title,
          SubWidgetInScreenArea.subtitle,
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
      case ScreenWidgetArea.tableRow:
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
