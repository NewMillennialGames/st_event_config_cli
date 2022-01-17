part of EventCfgEnums;

enum UiComponentSlotName {
  /*  key to describing field-name
    on some ApiMsg entity (asset, team, player, game)
    so we know which field to get to show in 
  */
  header,
  footer,
  name,
  title,
  subtitle,
  iconPath,
  occurDt,
  startTime,
  bannerUrl,
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
