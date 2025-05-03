import 'dart:developer';

import 'package:flutter/foundation.dart';

/// This file is used to test the custom lint rules.
/// It contains examples of prohibited logging methods that should be detected.
void testLoggingMethods() {
  // This should trigger the avoid_debug_print rule
  debugPrint('This is a debug message');

  // This should trigger the avoid_log rule
  log('This is a log message');

  // These are examples of proper logging methods
  // AppLogger.d('Proper debug message');
  // AppLogger.e('Error message', error, stackTrace);
}
