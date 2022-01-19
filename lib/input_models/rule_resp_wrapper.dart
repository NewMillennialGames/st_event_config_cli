part of InputModels;

class RuleResponseWrapper {
  //
  DbRowType recType;
  UiAreaSlotName property;
  String propertyName;
  MenuSortOrGroupIndex menuIdx;
  bool sortDescending;

  RuleResponseWrapper(
    this.recType,
    this.property,
    this.propertyName,
    this.menuIdx, {
    this.sortDescending = true,
  });

  // factory PropertyMap.fromUserInput(String userInput) {
  //   return PropertyMap();
  // }
}
