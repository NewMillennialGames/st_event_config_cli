part of AppEntities;

/*
  lists below let you configure what sections of the app
  can be configured

  and for each section, which specific components

  and for each component, what types of customization rules apply
*/

enum AppSection {
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

extension AppSectionExt1 on AppSection {
  //
  String get includeStr => 'Configure ${this.name} section of app?';

  List<AppSection> get _tempNotConfigurable => [
        // list of app sections with no configurable appAreas as yet
        AppSection.eventConfiguration,
        AppSection.eventSelection,
        AppSection.news,
        AppSection.socialPools,
        AppSection.poolSelection,
        AppSection.trading,
      ];

  bool get isConfigureable =>
      this.applicableComponents.length > 0 ||
      this == AppSection.eventConfiguration;

  // AppSection.values.map((as) => as).toList();
  List<AppSection> get sectionConfigOptions => AppSection.values
      .where(
        (as) => as.isConfigureable && !this._tempNotConfigurable.contains(as),
      )
      .toList();

  List<SectionUiArea> convertIdxsToComponentList(String commaLstOfInts) {
    // since we dont show EVERY UiComponent, the choice indexes are offset
    // need to fix that
    List<int> providedIdxs =
        commaLstOfInts.split(",").map((e) => int.tryParse(e) ?? -1).toList();
    //
    Map<int, SectionUiArea> idxToModifiableUic = {};
    int tempIdx = 0;
    this
        .applicableComponents
        .forEach((uic) => idxToModifiableUic[++tempIdx] = uic);
    idxToModifiableUic.removeWhere((idx, uic) => !providedIdxs.contains(idx));
    return idxToModifiableUic.values.toList();
  }

  List<SectionUiArea> get applicableComponents {
    // customize this list to control what sections
    // of each screen can be customized for
    // THIS SECTION of the app
    switch (this) {
      case AppSection.eventConfiguration:
        return [];
      case AppSection.eventSelection:
        return [SectionUiArea.header, SectionUiArea.banner];
      case AppSection.poolSelection:
        return [];
      case AppSection.marketView:
        return [SectionUiArea.filterBar, SectionUiArea.tableRow];
      case AppSection.socialPools:
        return [];
      case AppSection.news:
        return [SectionUiArea.header, SectionUiArea.banner];
      case AppSection.leaderboard:
        return [SectionUiArea.header, SectionUiArea.banner];
      case AppSection.portfolio:
        return [SectionUiArea.header, SectionUiArea.banner];
      case AppSection.trading:
        return [SectionUiArea.header, SectionUiArea.banner];
      case AppSection.marketResearch:
        return [SectionUiArea.header, SectionUiArea.banner];
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
