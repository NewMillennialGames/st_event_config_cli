import 'package:logging/logging.dart';

class ConfigLogger {
  ConfigLogger._();

  static void log(Level level, Object message) {
    final logger = Logger('ConfigLogger');
    logger.log(level, message);
  }
}
