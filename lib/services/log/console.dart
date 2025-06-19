import 'package:dokdok/services/log/interface.dart';
import 'package:logger/logger.dart';

class ConsoleLog implements Log {
  late Logger _logger;

  ConsoleLog() {
    _logger = Logger(
      printer: PrettyPrinter(
        methodCount: 2,
        colors: true,
        printEmojis: true,
        printTime: true,
      ),
    );
  }

  
  @override
  void debug(String message, [error, StackTrace? stackTrace]) {
    _logger.d(message, error: error, stackTrace: stackTrace);
  }
  
  @override
  void error(String message, [error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }
  
  @override
  void info(String message) {
    _logger.i(message);
  }
  
  @override
  void warning(String message, [error]) {
    _logger.w(message, error: error);
  }
}