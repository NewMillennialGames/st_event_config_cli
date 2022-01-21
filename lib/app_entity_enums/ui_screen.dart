part of AppEntities;

/*
  lists below let you configure what sections of the app
  can be configured

  and for each section, which specific components

  and for each component, what types of customization rules apply
*/

enum AppScreen {
  // major screens or app-areas that user may wish to configure
  eventConfiguration, // general setup; not really a section
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

extension AppScreenExt1 on AppScreen {
  //
  String get includeStr => 'Configure ${this.name} section of app?';

  List<AppScreen> get _tempNotConfigurable => [
        // list of app sections with no configurable appAreas as yet
        AppScreen.eventConfiguration,
        AppScreen.eventSelection,
        AppScreen.news,
        AppScreen.socialPools,
        AppScreen.poolSelection,
        AppScreen.trading,
      ];

  bool get isConfigureable =>
      this.configurableScreenAreas.length > 0 ||
      this == AppScreen.eventConfiguration;

  // AppSection.values.map((as) => as).toList();
  List<AppScreen> get sectionConfigOptions => AppScreen.values
      .where(
        (as) => as.isConfigureable && !this._tempNotConfigurable.contains(as),
      )
      .toList();

  List<ScreenWidgetArea> convertIdxsToComponentList(String commaLstOfInts) {
    // since we dont show EVERY UiComponent, the choice indexes are offset
    // need to fix that
    List<int> providedIdxs =
        commaLstOfInts.split(",").map((e) => int.tryParse(e) ?? -1).toList();
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
    // customize this list to control what sections
    // of each screen can be customized for
    // THIS SECTION of the app
    switch (this) {
      case AppScreen.eventConfiguration:
        return [];
      case AppScreen.eventSelection:
        return [ScreenWidgetArea.header, ScreenWidgetArea.banner];
      case AppScreen.poolSelection:
        return [];
      case AppScreen.marketView:
        return [ScreenWidgetArea.filterBar, ScreenWidgetArea.tableRow];
      case AppScreen.socialPools:
        return [];
      case AppScreen.news:
        return [ScreenWidgetArea.header, ScreenWidgetArea.banner];
      case AppScreen.leaderboard:
        return [ScreenWidgetArea.header, ScreenWidgetArea.banner];
      case AppScreen.portfolio:
        return [ScreenWidgetArea.header, ScreenWidgetArea.banner];
      case AppScreen.trading:
        return [ScreenWidgetArea.header, ScreenWidgetArea.banner];
      case AppScreen.marketResearch:
        return [ScreenWidgetArea.header, ScreenWidgetArea.banner];
    }
  }
}


// [
//         AppSection.eventConfiguration,
//         AppSection.marketView,
//         AppSection.leaderboard,
//         AppSection.portfolio,
//         AppSection.marketResearch,
//       ].contains(this) &&
