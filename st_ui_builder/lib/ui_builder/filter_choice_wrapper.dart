part of StUiController;

class FilterChoiceData {
  //
  final DbTableFieldName sortKey;
  // final SortOrGroupIdxOrder cfgOrderIdx;
  final List<String> sortedMenuOptions;

  FilterChoiceData._(
    this.sortKey,
    // this.cfgOrderIdx,
    this.sortedMenuOptions,
  );

  String get dropMenuTitle => '';

  factory FilterChoiceData.fromCfg() {
    DbTableFieldName sortKey = DbTableFieldName.conference;
    // SortOrGroupIdxOrder cfgOrderIdx = SortOrGroupIdxOrder.first;
    List<String> sortedMenuOptions = [];

    return FilterChoiceData._(sortKey, sortedMenuOptions);
  }
}
