enum LogLevel { debug, info, warning, error }

class Logger {
  static const String _prefix = '🤖 Assistant';

  static void log(
    String message, {
    LogLevel level = LogLevel.info,
    dynamic error,
    StackTrace? stackTrace,
  }) {
    final timestamp = DateTime.now().toIso8601String();
    final levelStr = level.toString().split('.').last.toUpperCase();

    print('[$timestamp] $_prefix [$levelStr] $message');

    if (error != null) {
      print('Error: $error');
    }

    if (stackTrace != null) {
      print('StackTrace: $stackTrace');
    }
  }

  static void debug(String message) {
    log(message, level: LogLevel.debug);
  }

  static void info(String message) {
    log(message, level: LogLevel.info);
  }

  static void warning(String message) {
    log(message, level: LogLevel.warning);
  }

  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    log(message, level: LogLevel.error, error: error, stackTrace: stackTrace);
  }
}
