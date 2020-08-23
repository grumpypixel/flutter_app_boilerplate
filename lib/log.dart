class Log {
  static bool enabled = false;

  static void debug(String message) {
    _printMessage(message);
  }

  static void info(String message) {
    _printMessage(message);
  }

  static void warning(String message) {
    _printMessage(message);
  }

  static void error(String message) {
    _printMessage(message);
  }

  static void _printMessage(String message) {
    if (enabled) {
      print(message);
    }
  }
}
