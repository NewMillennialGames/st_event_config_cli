import 'package:st_ui_builder/st_ui_builder.dart';

class RowGroup implements Comparable<RowGroup> {
  final String groupName;
  final List<TvRowDataContainer> items;
  final Comparable sortingField;

  RowGroup({
    required this.groupName,
    required this.items,
    required this.sortingField,
  });

  RowGroup appendRowItem(TvRowDataContainer row) {
    final newItems = items;
    newItems.add(row);

    return RowGroup(
      groupName: groupName,
      items: newItems,
      sortingField: sortingField,
    );
  }

  @override
  int compareTo(other) {
    return sortingField.compareTo(other.sortingField);
  }
}
