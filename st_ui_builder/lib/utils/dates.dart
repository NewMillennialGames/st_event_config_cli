// helper methods for date formatting and other logic

// https://pub.dev/documentation/intl/latest/intl/DateFormat-class.html
import 'package:fixnum/fixnum.dart' show Int64;
//
import 'package:intl/intl.dart' show DateFormat;

final _appDateFormat = DateFormat('MM-dd-yyyy');
final _asDtwMmDyFormat = DateFormat('E, MMM dd');
final _appTimeFormat = DateFormat.Hm();

extension DateTimeExt1 on DateTime {
  //
  DateTime get truncateTime => DateTime(year, month, day);
  DateTime get timeOnly => DateTime(2022, 1, 1, hour, minute);
  String get asShortDtStr => _appDateFormat.format(this);
  String get asTimeOnlyStr => _appTimeFormat.format(this);
  // asDtwMmDyStr == Header format
  String get asDtwMmDyStr => _asDtwMmDyFormat.format(this);
}

extension Int64ExtDate on Int64 {
  // dates come as Int64 with NANO precision
  // divide by million to get millisecs, or billion (9 0's) to get seconds
  int get toSecsSinceEpoch => toInt() ~/ 1000000000;
  int get _toMilliSecsSinceEpoch => toInt() ~/ 1000000;
  DateTime get asDtTm =>
      DateTime.fromMillisecondsSinceEpoch(_toMilliSecsSinceEpoch);

  DateTime get truncateTime => asDtTm.truncateTime;
  String get asShortDtStr => asDtTm.asShortDtStr;
  String get asTimeOnlyStr => asDtTm.asTimeOnlyStr;
  // asDtwMmDyStr == Header format
  String get asDtwMmDyStr => asDtTm.asDtwMmDyStr;
}
