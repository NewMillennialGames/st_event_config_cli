part of EventCfgEnums;

/*
  lists below let you configure what sections of the app
  can be configured

  and for each section, which specific components

  and for each component, what types of customization rules apply
*/

enum AppSection {
  // major screens or app-areas that user may wish to configure
  eventConfiguration,
  eventSelection,
  poolSelection,
  marketView,
  socialPools,
  news,
  leaderboard,
  portfolio,
  trading,
  marketResearch,
}

extension AppSectionExt1 on AppSection {
  //
  String get includeStr => 'Configure ${this.name} section of app?';
  bool get isConfigureable =>
      this.applicableComponents.length > 0 ||
      this == AppSection.eventConfiguration;

  List<UiComponent> convertIdxsToComponentList(String commaLstOfInts) {
    // since we dont show EVERY UiComponent, the choice indexes are offset
    // need to fix that
    List<int> providedIdxs =
        commaLstOfInts.split(",").map((e) => int.tryParse(e) ?? -1).toList();
    //
    Map<int, UiComponent> idxToModifiableUic = {};
    int tempIdx = 0;
    this
        .applicableComponents
        .forEach((uic) => idxToModifiableUic[++tempIdx] = uic);
    idxToModifiableUic.removeWhere((idx, uic) => !providedIdxs.contains(idx));
    return idxToModifiableUic.values.toList();
  }

  List<UiComponent> get applicableComponents {
    // customize this list to control what sections
    // of each screen can be customized for
    // THIS SECTION of the app
    switch (this) {
      case AppSection.eventConfiguration:
        return [];
      case AppSection.eventSelection:
        return [UiComponent.header, UiComponent.banner];
      case AppSection.poolSelection:
        return [];
      case AppSection.marketView:
        return [UiComponent.filterBar1, UiComponent.tableView];
      case AppSection.socialPools:
        return [];
      case AppSection.news:
        return [UiComponent.header, UiComponent.banner];
      case AppSection.leaderboard:
        return [UiComponent.header, UiComponent.banner];
      case AppSection.portfolio:
        return [UiComponent.header, UiComponent.banner];
      case AppSection.trading:
        return [UiComponent.header, UiComponent.banner];
      case AppSection.marketResearch:
        return [UiComponent.header, UiComponent.banner];
    }
  }
}

enum UiComponent {
  // each part
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

// [
//         AppSection.eventConfiguration,
//         AppSection.marketView,
//         AppSection.leaderboard,
//         AppSection.portfolio,
//         AppSection.marketResearch,
//       ].contains(this) &&
