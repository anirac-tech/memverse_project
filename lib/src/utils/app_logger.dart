// coverage:ignore-file
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// A utility class for logging that only logs in debug mode
class AppLogger {
  /// Creates a new logger instance with customized output
  static final Logger _logger = Logger(
    printer: PrettyPrinter(colors: false, dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart),
    level: kDebugMode ? Level.trace : Level.off,
    filter: ProductionFilter(),
  );

  /// Log a trace message (verbose)
  static void t(String message, [dynamic error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      _logger.t(message, error: error, stackTrace: stackTrace);
    }
  }

  /// Log a debug message
  static void d(String message, [dynamic error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      _logger.d(message, error: error, stackTrace: stackTrace);
    }
  }

  /// Log an info message
  static void i(String message, [dynamic error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      _logger.i(message, error: error, stackTrace: stackTrace);
    }
  }

  /// Log a warning message
  static void w(String message, [dynamic error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      _logger.w(message, error: error, stackTrace: stackTrace);
    }
  }

  /// Log an error message
  static void e(String message, [dynamic error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      _logger.e(message, error: error, stackTrace: stackTrace);
    }
  }

  /// Log a fatal message
  static void f(String message, [dynamic error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      _logger.f(message, error: error, stackTrace: stackTrace);
    }
  }
}
