part of AppEntities;

enum SubWidgetInScreenArea {
  /*  key to describing field-name
    on some ApiMsg entity (asset, team, player, game)
    so we know which field to get to show in 
  */

  // ui-sub-area of the UI component
  header,
  footer,
  slot1,
  slot2,
  rowStyle,

  // data property of the component
  title,
  subtitle,
  bannerUrl,
  // name,
  // iconPath,
  // occurDt,
  // startTime,
}

extension SubWidgetInScreenAreaExt1 on SubWidgetInScreenArea {
  //
  List<VisualRuleType> get applicableRules {
    switch (this) {
      case SubWidgetInScreenArea.header:
        return [
          VisualRuleType.show,
        ];
      case SubWidgetInScreenArea.footer:
        return [
          VisualRuleType.show,
        ];
      case SubWidgetInScreenArea.slot1:
        return [
          VisualRuleType.filter,
        ];
      case SubWidgetInScreenArea.slot2:
        return [
          VisualRuleType.filter,
        ];
      case SubWidgetInScreenArea.rowStyle:
        return [
          VisualRuleType.format,
        ];
      case SubWidgetInScreenArea.title:
        return [
          VisualRuleType.format,
        ];
      case SubWidgetInScreenArea.subtitle:
        return [
          VisualRuleType.show,
        ];
      case SubWidgetInScreenArea.bannerUrl:
        return [
          VisualRuleType.show,
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
