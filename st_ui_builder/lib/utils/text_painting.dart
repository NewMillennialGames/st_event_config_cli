import 'package:flutter/widgets.dart';
import 'package:st_ui_builder/config/styles.dart';

class TextPaintingUtil {
  ///Returns `true` if [text] will be painted
  ///on more than one line. Otherwise, returns `false`.
  static bool isTextMultiLine(
    String text,
    double width, {
    int maxLines = 4,
    TextStyle? style,
  }) {
    final painter = TextPainter(
      textDirection: TextDirection.ltr,
      maxLines: maxLines,
      text: TextSpan(
        text: text,
        style: style ?? StTextStyles.h5,
      ),
    )..layout();

    return painter.size.width >= width * 0.46;
  }
}
