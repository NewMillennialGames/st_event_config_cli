// helper methods for date formatting and other logic

import 'package:intl/intl.dart' show DateFormat;

final appDateFormat = DateFormat('MM-dd-yyyy');
final appTimeFormat = DateFormat.Hm();

extension DateTimeExt1 on DateTime {
  //
  DateTime get truncateTime => DateTime(this.year, this.month, this.day);
  String get asShortDtStr => appDateFormat.format(this);
  String get asTimeOnlyStr => appTimeFormat.format(this);
}
