part of CfgInputModels;

class PropertyMap {
  //
  DbRowType recType;
  UiComponentSlotName property;
  String propertyName;

  PropertyMap(
    this.recType,
    this.property,
    this.propertyName,
  );
}
