import 'dart:math';
import 'package:decimal/decimal.dart';
import 'package:fixnum/fixnum.dart' show Int64;

double _roundDouble(
  double value,
  int places,
) {
  final num mod = pow(10.00, places);
  return ((value * mod).round().toDouble() / mod);
}

extension Int64ExtPrice on Int64 {
  //
  // double get _priceWithDecimals => toDouble() / 100.00;
  Decimal get asPrice2d => (Decimal.parse('$this') / Decimal.fromInt(100)).toDecimal();

  String get asPrice2dStr => asPrice2d.toStringAsFixed(2);
}

extension IntExtPrice on int {
  //
  double get _priceWithDecimals => toDouble() / 100.00;

  double get asPrice2d => _roundDouble(_priceWithDecimals, 2);

  String get asPrice2dStr => asPrice2d.toStringAsFixed(2);
}
