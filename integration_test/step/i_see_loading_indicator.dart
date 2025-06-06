import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Usage: I see loading indicator
Future<void> iSeeLoadingIndicator(WidgetTester tester) async {
  // Look for various types of loading indicators
  final loadingIndicators = [
    find.byType(CircularProgressIndicator),
    find.byType(CircularProgressIndicator.adaptive),
    find.byType(LinearProgressIndicator),
  ];

  // Check if any loading indicator is present
  var loadingIndicatorFound = false;
  for (final indicator in loadingIndicators) {
    if (indicator.evaluate().isNotEmpty) {
      loadingIndicatorFound = true;
      break;
    }
  }

  expect(loadingIndicatorFound, isTrue, reason: 'Loading indicator should be visible');
}
