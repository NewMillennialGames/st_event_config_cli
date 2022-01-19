part of AppEntities;

enum UiAreaSlotName {
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
