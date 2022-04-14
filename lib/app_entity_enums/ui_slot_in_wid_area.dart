part of AppEntities;

@JsonEnum()
enum ScreenAreaWidgetSlot {
  /*  key to describing field-name
    on some ApiMsg entity (asset, team, player, game)
    so we know which field to get to show in 
  */

  // ui-sub-area of the UI component
  header,
  footer,
  // fixme:  slots on tableview should be sort or group
  // below should only apply to parts of filter bar
  menuSortPosOrSlot1,
  menuSortPosOrSlot2,
  menuSortPosOrSlot3,

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

  bool get isConfigurable => true; //this.possibleConfigRules.length > 0;

  String get choiceName => this.name;

  List<VisualRuleType> possibleConfigRules(ScreenWidgetArea forArea) {
    switch (this) {
      case ScreenAreaWidgetSlot.header:
        return [
          VisualRuleType.showOrHide,
        ];
      case ScreenAreaWidgetSlot.footer:
        return [
          VisualRuleType.showOrHide,
        ];
      case ScreenAreaWidgetSlot.menuSortPosOrSlot1:
        return [
          if (forArea == ScreenWidgetArea.filterBar) VisualRuleType.filterCfg,
          if (forArea == ScreenWidgetArea.tableview) VisualRuleType.sortCfg,
        ];
      case ScreenAreaWidgetSlot.menuSortPosOrSlot2:
        return [
          if (forArea == ScreenWidgetArea.filterBar) VisualRuleType.filterCfg,
          if (forArea == ScreenWidgetArea.tableview) VisualRuleType.sortCfg,
        ];
      case ScreenAreaWidgetSlot.menuSortPosOrSlot3:
        return [
          if (forArea == ScreenWidgetArea.filterBar) VisualRuleType.filterCfg,
          if (forArea == ScreenWidgetArea.tableview) VisualRuleType.sortCfg,
        ];
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
