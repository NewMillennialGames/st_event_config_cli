part of CfgInputModels;

class PropertyMap {
  //
  DbRowType recType;
  UiComponentSlotName property;
  String propertyName;
  MenuSortOrGroupIndex menuIdx;
  bool sortDescending;

  PropertyMap(
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
