part of AppEntities;

enum SectionUiArea {
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

extension UiComponentExt1 on SectionUiArea {
  //
  String includeStr(AppSection section) =>
      'On Section ${section.name}, do you want to configure the ${this.name}?';

  bool get isConfigureable => this.applicableRuleTypes.length > 0;

  List<UiAreaSlotName> get applicablePropertySlots {
    //
    switch (this) {
      case SectionUiArea.navBar:
        return [
          UiAreaSlotName.title,
          UiAreaSlotName.subtitle,
        ];
      case SectionUiArea.filterBar:
        return [
          UiAreaSlotName.slot1,
          UiAreaSlotName.slot2,
        ];
      case SectionUiArea.header:
        return [
          UiAreaSlotName.title,
          UiAreaSlotName.subtitle,
        ];
      case SectionUiArea.banner:
        return [
          UiAreaSlotName.bannerUrl,
        ];
      case SectionUiArea.tableRow:
        return [
          UiAreaSlotName.rowStyle,
        ];
      case SectionUiArea.footer:
        return [
          UiAreaSlotName.title,
          UiAreaSlotName.subtitle,
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
      case SectionUiArea.navBar:
        return [VisualRuleType.format];
      case SectionUiArea.filterBar:
        return [VisualRuleType.filter];
      case SectionUiArea.header:
        return [VisualRuleType.format, VisualRuleType.show];
      case SectionUiArea.banner:
        return [VisualRuleType.show];
      case SectionUiArea.tableRow:
        return [
          VisualRuleType.format,
          VisualRuleType.group,
          VisualRuleType.sort
        ];
      case SectionUiArea.footer:
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
