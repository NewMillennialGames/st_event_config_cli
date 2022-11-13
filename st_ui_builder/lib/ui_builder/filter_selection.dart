import 'package:st_ev_cfg/app_entity_enums/all.dart';

class FilterSelection {
  final DbTableFieldName filterColumn;
  final String selectedValue;

  const FilterSelection({
    required this.filterColumn,
    required this.selectedValue,
  });

  @override
  bool operator ==(Object other) {
    return other is FilterSelection &&
        other.filterColumn == filterColumn &&
        other.selectedValue == selectedValue;
  }

  @override
  int get hashCode => Object.hashAll([filterColumn, selectedValue]);

  @override
  String toString() {
    return "FilterSelection(filterColumn: $filterColumn, selectedValue: $selectedValue)";
  }
}
