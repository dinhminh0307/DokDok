abstract class Log {
  void debug(String message, [dynamic error, StackTrace? stackTrace]);
  void info(String message);
  void warning(String message, [dynamic error]);
  void error(String message, [dynamic error, StackTrace? stackTrace]);
}