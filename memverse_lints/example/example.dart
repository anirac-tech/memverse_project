// This file demonstrates how the lint rules work.
// You should see lint errors for the debugPrint and log calls.

import 'dart:developer';

void main() {
  // This will be flagged by the avoid_debug_print rule
  debugPrint('This is a debug message');

  // This will be flagged by the avoid_log rule
  log('This is a log message');

  // This is the correct way to log messages
  // AppLogger.d('This is how you should log debug messages');
  // AppLogger.e('This is how you should log errors', error, stackTrace);
}
