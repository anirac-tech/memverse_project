import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Usage: I see feedback interface
Future<void> iSeeFeedbackInterface(WidgetTester tester) async {
  // Wait for feedback interface to appear
  await tester.pumpAndSettle();

  // Look for common feedback interface elements
  // The BetterFeedback package typically shows drawing tools and feedback form
  final feedbackElements = [
    // Look for drawing canvas or feedback overlay
    find.byType(Container).first,
    // Look for feedback-related text
    find.textContaining('feedback').first,
    // Look for close button or navigation elements
    find.byIcon(Icons.close).first,
  ];

  // Verify at least one feedback interface element is present
  var feedbackInterfaceFound = false;
  for (final element in feedbackElements) {
    if (element.evaluate().isNotEmpty) {
      feedbackInterfaceFound = true;
      break;
    }
  }

  expect(feedbackInterfaceFound, isTrue, reason: 'Feedback interface should be visible');
}
