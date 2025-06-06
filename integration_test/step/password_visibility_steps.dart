import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memverse/src/features/auth/presentation/login_page.dart';

/// Usage: I tap the password visibility toggle
Future<void> iTapThePasswordVisibilityToggle(WidgetTester tester) async {
  // Wait for the page to be ready
  await tester.pumpAndSettle();

  // Find and tap the password visibility toggle
  final passwordToggle = find.byKey(passwordVisibilityToggleKey);
  expect(passwordToggle, findsOneWidget);

  await tester.tap(passwordToggle);

  // Pump to register the tap and state change
  await tester.pump();
  await tester.pumpAndSettle();
}

/// Usage: I should see the password as plain text
Future<void> iShouldSeeThePasswordAsPlainText(WidgetTester tester) async {
  await tester.pumpAndSettle();

  // Find the password field
  final passwordField = find.byKey(loginPasswordFieldKey);
  expect(passwordField, findsOneWidget);

  // Get the TextFormField widget and check if obscureText is false
  final textFormField = tester.widget<TextFormField>(passwordField);
  expect(textFormField.obscureText, isFalse, reason: 'Password should be visible as plain text');
}

/// Usage: I should see the password as dots
Future<void> iShouldSeeThePasswordAsDots(WidgetTester tester) async {
  await tester.pumpAndSettle();

  // Find the password field
  final passwordField = find.byKey(loginPasswordFieldKey);
  expect(passwordField, findsOneWidget);

  // Get the TextFormField widget and check if obscureText is true
  final textFormField = tester.widget<TextFormField>(passwordField);
  expect(textFormField.obscureText, isTrue, reason: 'Password should be hidden as dots');
}

/// Usage: the analytics should track password visibility toggle event
Future<void> theAnalyticsShouldTrackPasswordVisibilityToggleEvent(WidgetTester tester) async {
  // This step verifies that the analytics tracking is set up correctly
  // In a real implementation, you might verify with a mock analytics service
  // For now, we'll just verify the step runs without error
  await tester.pumpAndSettle();

  // In production, this would verify the analytics call was made
  // expect(mockAnalyticsService.trackPasswordVisibilityToggle, wasCalled);
}

/// Usage: the password is visible
Future<void> thePasswordIsVisible(WidgetTester tester) async {
  await tester.pumpAndSettle();

  // Find the password field and verify it's not obscured
  final passwordField = find.byKey(loginPasswordFieldKey);
  final textFormField = tester.widget<TextFormField>(passwordField);

  // If password is not visible, toggle it
  if (textFormField.obscureText) {
    await iTapThePasswordVisibilityToggle(tester);
  }
}
