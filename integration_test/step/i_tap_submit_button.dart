import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

/// Usage: I tap submit button
Future<void> iTapSubmitButton(WidgetTester tester) async {
  // Wait for the page to be ready
  await tester.pumpAndSettle();

  // Find and tap the submit button
  final submitButton = find.byKey(const Key('submit-ref'));
  expect(submitButton, findsOneWidget);

  await tester.tap(submitButton);

  // Pump to register the tap
  await tester.pump();
}
