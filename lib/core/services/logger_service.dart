import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class LoggerService {
  static void init() {
    info('Logger initialized 🚀');
  }

  static String _timestamp() {
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
  }

  static void log(String message) {
    if (kDebugMode) {
      print('[${_timestamp()}] [LOG] $message');
    }
  }

  static void info(String message) {
    if (kDebugMode) {
      print('[${_timestamp()}] [INFO] $message');
    }
  }

  static void debug(String message) {
    if (kDebugMode) {
      print('[${_timestamp()}] [DEBUG] $message');
    }
  }

  static void warning(String message) {
    if (kDebugMode) {
      print('[${_timestamp()}] [WARNING] $message');
    }
  }

  static void success(String message) {
    if (kDebugMode) {
      print('[${_timestamp()}] [SUCCESS] $message');
    }
  }

  static void error(String message, [Object? error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      print('[${_timestamp()}] [ERROR] $message');
      if (error != null) print('Details: $error');
      if (stackTrace != null) print(stackTrace);
    }
  }
}
