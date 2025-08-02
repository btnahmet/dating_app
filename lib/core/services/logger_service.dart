import 'package:flutter/foundation.dart';

class LoggerService {
  static void init() {
    log('Logger initialized 🚀');
  }

  static void log(String message) {
    if (kDebugMode) {
      print('[LOG]: $message');
    }
  }

  static void error(String message, [Object? error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      print('[ERROR]: $message');
      if (error != null) print('Details: $error');
      if (stackTrace != null) print(stackTrace);
    }
  }
}
