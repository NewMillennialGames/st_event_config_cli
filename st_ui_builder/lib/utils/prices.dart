import 'dart:math';
import 'package:fixnum/fixnum.dart' show Int64;

double _roundDouble(
  double value,
  int places,
) {
  final num mod = pow(10.0, places);
  return ((value * mod).round().toDouble() / mod);
}

extension Int64ExtPrice on Int64 {
  //
  double get _priceWithDecimals => toDouble() / 100;
  double get asPrice2d => _roundDouble(_priceWithDecimals, 2);
  String get asPrice2dStr => asPrice2d.toStringAsPrecision(2);
}
