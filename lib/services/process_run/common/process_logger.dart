import 'package:dokdok/services/log/interface.dart';

/// Logger adapter class to add more context to process logs
class ProcessLogger {
  final Log _logger;
  final String _processName;
  
  ProcessLogger(this._logger, this._processName);
  
  void debug(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.debug('[$_processName] $message', error, stackTrace);
  }
  
  void info(String message) {
    _logger.info('[$_processName] $message');
  }
  
  void warning(String message, [dynamic error]) {
    _logger.warning('[$_processName] $message', error);
  }
  
  void error(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.error('[$_processName] $message', error, stackTrace);
  }
}
