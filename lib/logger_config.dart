import 'package:logger/logger.dart';

class LoggerConfig {
  static Logger getLogger({bool isDebug = false}) {
    if (isDebug) {
      // Use a more verbose logging configuration for debug builds
      return Logger(
        level: Level.debug,
        printer: PrettyPrinter(),
      );
    } else {
      // Use a minimal logging configuration for release builds
      return Logger(
        level: Level.warning, // Change to Level.error or Level.none as needed
      );
    }
  }
}
