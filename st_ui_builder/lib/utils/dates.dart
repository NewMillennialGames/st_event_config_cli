// helper methods for date formatting and other logic

// https://pub.dev/documentation/intl/latest/intl/DateFormat-class.html

import 'package:intl/intl.dart' show DateFormat;

final appDateFormat = DateFormat('MM-dd-yyyy');
final asDtwMmDyFormat = DateFormat('E, MMM dd');
final appTimeFormat = DateFormat.Hm();

extension DateTimeExt1 on DateTime {
  //
  DateTime get truncateTime => DateTime(year, month, day);
  String get asShortDtStr => appDateFormat.format(this);
  String get asTimeOnlyStr => appTimeFormat.format(this);
  // asDtwMmDyStr == Header format
  String get asDtwMmDyStr => asDtwMmDyFormat.format(this);
}
