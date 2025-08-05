import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class LoggerService {
  static void init() {
    info('Logger initialized...');
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
    
    // Crashlytics'e gönder
    try {
      FirebaseCrashlytics.instance.log('[$message]');
      if (error != null) {
        FirebaseCrashlytics.instance.recordError(error, stackTrace, reason: message);
      }
    } catch (e) {
      // Crashlytics hatası durumunda sadece print
      if (kDebugMode) {
        print('[${_timestamp()}] [CRASHLYTICS_ERROR] $e');
      }
    }
  }
}
