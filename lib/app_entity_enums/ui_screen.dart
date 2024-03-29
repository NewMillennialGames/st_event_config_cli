part of AppEntities;

/*
  lists below let you configure what sections of the app
  can be configured

  and for each section, which specific components

  and for each component, what types of customization rules apply
*/

const List<AppScreen> _notCurrentlyConfigurable = [
  // list of app sections with no configurable appAreas as yet
  // created to speed data entry without clearing out config code below
  AppScreen.eventConfiguration, // not really a screen;  top-level grouping only
  AppScreen.eventSelection,
  AppScreen.news,
  AppScreen.socialPools,
  AppScreen.poolSelection,
  AppScreen.trading,
];

@JsonEnum()
enum AppScreen {
  // top-level screens or app-section that user may wish to configure
  eventConfiguration, // general rules setup; not really a screen or
  // below are true app screens or app-sections
  eventSelection,
  poolSelection,
  marketView,
  socialPools,
  news,
  leaderboardTraders, // pools
  leaderboardAssets, // football & Fantasy
  portfolioPositions,
  portfolioHistory,
  trading,
  marketResearch,
}

extension AppScreenExt1 on AppScreen {
  //
  String get includeStr => 'Configure ${this.name} section of app?';

  // used to track what screen is displayed
  AppScreen fromTabBarIndex(int idx) {
    return AppScreen.values[idx + 1];
  }

  bool get isConfigurable =>
      this.configurableScreenAreas.length > 0 ||
      this == AppScreen.eventConfiguration;

  List<AppScreen> get configurableAppScreens => AppScreen.values
      .where(
        (as) => as.isConfigurable && !_notCurrentlyConfigurable.contains(as),
      )
      .toList();

  List<ScreenWidgetArea> convertIdxsToComponentList(String commaLstOfInts) {
    // since we dont show EVERY UiComponent, the choice indexes are offset
    // need to fix that
    List<int> providedIdxs = castStrOfIdxsToIterOfInts(commaLstOfInts).toList();
    //
    Map<int, ScreenWidgetArea> idxToModifiableUic = {};
    int tempIdx = 0;
    this
        .configurableScreenAreas
        .forEach((uic) => idxToModifiableUic[++tempIdx] = uic);
    idxToModifiableUic.removeWhere((idx, uic) => !providedIdxs.contains(idx));
    return idxToModifiableUic.values.toList();
  }

  List<ScreenWidgetArea> get configurableScreenAreas {
    // customize this list to control what areas
    // of each screen can be customized
    switch (this) {
      case AppScreen.eventConfiguration:
        return [];
      case AppScreen.eventSelection:
        return [
          ScreenWidgetArea.header,
          ScreenWidgetArea.banner,
        ];
      case AppScreen.poolSelection:
        return [];
      case AppScreen.marketView:
        return [
          ScreenWidgetArea.filterBar,
          ScreenWidgetArea.tableview,
        ];
      case AppScreen.socialPools:
        return [];
      case AppScreen.news:
        return [
          ScreenWidgetArea.header,
          ScreenWidgetArea.banner,
        ];
      case AppScreen.leaderboardTraders:
        return [
          // ScreenWidgetArea.header,
          // ScreenWidgetArea.banner,
          ScreenWidgetArea.tableview,
        ];
      case AppScreen.leaderboardAssets:
        return [
          // ScreenWidgetArea.header,
          // ScreenWidgetArea.banner,
          ScreenWidgetArea.tableview,
        ];
      case AppScreen.portfolioPositions:
        return [
          ScreenWidgetArea.header,
          ScreenWidgetArea.tableview,
          ScreenWidgetArea.footer,
        ];
      case AppScreen.portfolioHistory:
        return [
          ScreenWidgetArea.header,
          // ScreenWidgetArea.banner,
          ScreenWidgetArea.tableview,
        ];
      case AppScreen.trading:
        return [
          ScreenWidgetArea.header,
          // ScreenWidgetArea.banner,
        ];
      case AppScreen.marketResearch:
        return [
          ScreenWidgetArea.header,
          // ScreenWidgetArea.banner,
        ];
    }
  }
}
