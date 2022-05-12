// import '../enums/all.dart';

extension StringFormating on String {
  // hacky templating system for rule templates

  String format(List<String> values) {
    int index = 0;
    return replaceAllMapped(new RegExp(r'{.*?}'), (_) {
      final value = values[index];
      index++;
      return value;
    });
  }

  String formatWithMap(Map<String, String> mappedValues) {
    return replaceAllMapped(new RegExp(r'{(.*?)}'), (match) {
      final mapped = mappedValues[match[1]];
      if (mapped == null)
        throw ArgumentError(
          '$mappedValues does not contain the key "${match[1]}"',
        );
      return mapped;
    });
  }

  // String makeRuleQuest2Str(
  //   VisualRuleType rt,
  //   bool isAreaScopedRule, // not a slot-level rule
  //   List<dynamic> valsDyn,
  // ) {
  //   List<String> valsStr = valsDyn.map((e) => e.toString()).toList();

  //   return this.format(valsStr);
  // }
}
