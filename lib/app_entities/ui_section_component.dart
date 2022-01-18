part of AppEntities;

enum UiComponent {
  // each part in a section of the app
  // each below has subset of xxx
  navBar,
  filterBar1,
  filterBar2,
  header,
  banner,
  tableView,
  footer,
  ticker,
  tabBar
}

extension UiComponentExt1 on UiComponent {
  //
  String includeStr(AppSection section) =>
      'On Section ${section.name}, do you want to configure the ${this.name}?';

  bool get isConfigureable => this.applicableRuleTypes.length > 0;

  List<VisualRuleType> get applicableRuleTypes {
    // customize this list to control what customization
    // rules go with this ui component
    switch (this) {
      case UiComponent.navBar:
        return [VisualRuleType.format];
      case UiComponent.filterBar1:
        return [VisualRuleType.filter];
      case UiComponent.filterBar2:
        return [];
      case UiComponent.header:
        return [VisualRuleType.format, VisualRuleType.show];
      case UiComponent.banner:
        return [VisualRuleType.show];
      case UiComponent.tableView:
        return [
          VisualRuleType.format,
          VisualRuleType.group,
          VisualRuleType.sort
        ];
      case UiComponent.footer:
        return [VisualRuleType.show];
      case UiComponent.ticker:
        return [VisualRuleType.show];
      case UiComponent.tabBar:
        return [];
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
