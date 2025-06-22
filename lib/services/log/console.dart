import 'package:dokdok/services/log/interface.dart';
import 'package:flutter/foundation.dart';

class ConsoleLog implements Log {
  @override
  void debug(String message, [dynamic error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      print('DEBUG: $message');
      if (error != null) print('  ERROR: $error');
      if (stackTrace != null) print('  STACK: $stackTrace');
    }
  }
  
  @override
  void error(String message, [dynamic error, StackTrace? stackTrace]) {
    print('ERROR: $message');
    if (error != null) print('  ERROR: $error');
    if (stackTrace != null) print('  STACK: $stackTrace');
  }
  
  @override
  void info(String message) {
    print('INFO: $message');
  }
  
  @override
  void warning(String message, [dynamic error]) {
    print('WARNING: $message');
    if (error != null) print('  ERROR: $error');
  }
}