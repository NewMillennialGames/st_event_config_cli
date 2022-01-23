part of AppEntities;

enum ScreenAreaWidgetSlot {
  /*  key to describing field-name
    on some ApiMsg entity (asset, team, player, game)
    so we know which field to get to show in 
  */

  // ui-sub-area of the UI component
  header,
  footer,
  slot1,
  slot2,

  // data property of the component
  title,
  subtitle,
  bannerUrl,
  // name,
  // iconPath,
  // occurDt,
  // startTime,
}

extension ScreenAreaWidgetSlotExt1 on ScreenAreaWidgetSlot {
  //

  bool get isConfigurable => this.possibleConfigRules.length > 0;

  String get choiceName => this.name;

  List<VisualRuleType> get possibleConfigRules {
    switch (this) {
      case ScreenAreaWidgetSlot.header:
        return [
          VisualRuleType.showOrHide,
        ];
      case ScreenAreaWidgetSlot.footer:
        return [
          VisualRuleType.showOrHide,
        ];
      case ScreenAreaWidgetSlot.slot1:
        return [
          VisualRuleType.filterCfg,
        ];
      case ScreenAreaWidgetSlot.slot2:
        return [
          VisualRuleType.filterCfg,
        ];
      // case ScreenAreaWidgetSlot.rowStyle:
      //   return [
      //     VisualRuleType.format,
      //   ];
      case ScreenAreaWidgetSlot.title:
        return [
          VisualRuleType.styleOrFormat,
        ];
      case ScreenAreaWidgetSlot.subtitle:
        return [
          VisualRuleType.showOrHide,
        ];
      case ScreenAreaWidgetSlot.bannerUrl:
        return [
          VisualRuleType.showOrHide,
        ];
    }
  }
}

enum MenuSortOrGroupIndex {
  /* describes whether some rule record applies to:
    the n (eg 1st) filter menu
    the n sort field
    the n group-by key

  */
  first,
  second,
  third,
}
