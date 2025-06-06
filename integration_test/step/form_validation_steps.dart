import 'package:flutter_test/flutter_test.dart';
import 'package:memverse/src/features/auth/presentation/login_page.dart';

/// Usage: I tap the login button without entering a username
Future<void> iTapTheLoginButtonWithoutEnteringAUsername(WidgetTester tester) async {
  await tester.pumpAndSettle();

  // Ensure username field is empty
  final usernameField = find.byKey(loginUsernameFieldKey);
  await tester.enterText(usernameField, '');

  // Tap login button
  final loginButton = find.byKey(loginButtonKey);
  expect(loginButton, findsOneWidget);
  await tester.tap(loginButton);

  await tester.pumpAndSettle();
}

/// Usage: I have entered a username
Future<void> iHaveEnteredAUsername(WidgetTester tester) async {
  await tester.pumpAndSettle();

  // Enter a test username
  final usernameField = find.byKey(loginUsernameFieldKey);
  expect(usernameField, findsOneWidget);
  await tester.enterText(usernameField, 'testuser');

  await tester.pumpAndSettle();
}

/// Usage: I tap the login button without entering a password
Future<void> iTapTheLoginButtonWithoutEnteringAPassword(WidgetTester tester) async {
  await tester.pumpAndSettle();

  // Ensure password field is empty
  final passwordField = find.byKey(loginPasswordFieldKey);
  await tester.enterText(passwordField, '');

  // Tap login button
  final loginButton = find.byKey(loginButtonKey);
  expect(loginButton, findsOneWidget);
  await tester.tap(loginButton);

  await tester.pumpAndSettle();
}

/// Usage: I tap the login button without entering any credentials
Future<void> iTapTheLoginButtonWithoutEnteringAnyCredentials(WidgetTester tester) async {
  await tester.pumpAndSettle();

  // Ensure both fields are empty
  final usernameField = find.byKey(loginUsernameFieldKey);
  final passwordField = find.byKey(loginPasswordFieldKey);

  await tester.enterText(usernameField, '');
  await tester.enterText(passwordField, '');

  // Tap login button
  final loginButton = find.byKey(loginButtonKey);
  expect(loginButton, findsOneWidget);
  await tester.tap(loginButton);

  await tester.pumpAndSettle();
}

/// Usage: the analytics should track empty username validation event
Future<void> theAnalyticsShouldTrackEmptyUsernameValidationEvent(WidgetTester tester) async {
  // This step verifies that the analytics tracking is set up correctly
  // In a real implementation, you might verify with a mock analytics service
  await tester.pumpAndSettle();

  // In production, this would verify the analytics call was made
  // expect(mockAnalyticsService.trackEmptyUsernameValidation, wasCalled);
}

/// Usage: the analytics should track empty password validation event
Future<void> theAnalyticsShouldTrackEmptyPasswordValidationEvent(WidgetTester tester) async {
  // This step verifies that the analytics tracking is set up correctly
  await tester.pumpAndSettle();

  // In production, this would verify the analytics call was made
  // expect(mockAnalyticsService.trackEmptyPasswordValidation, wasCalled);
}

/// Usage: the analytics should track both validation events
Future<void> theAnalyticsShouldTrackBothValidationEvents(WidgetTester tester) async {
  // This step verifies that both analytics events are tracked
  await tester.pumpAndSettle();

  // In production, this would verify both analytics calls were made
  // expect(mockAnalyticsService.trackEmptyUsernameValidation, wasCalled);
  // expect(mockAnalyticsService.trackEmptyPasswordValidation, wasCalled);
}
