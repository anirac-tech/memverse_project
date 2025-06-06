import 'package:flutter_test/flutter_test.dart';
import 'package:memverse/src/features/auth/presentation/login_page.dart';

/// Usage: I am logged in as test user
Future<void> iAmLoggedInAsTestUser(WidgetTester tester) async {
  // Get test credentials from environment variables
  const username = String.fromEnvironment('USERNAME', defaultValue: 'test_user');
  const password = String.fromEnvironment('PASSWORD', defaultValue: 'test_password');

  // Wait for any initial loading to complete
  await tester.pumpAndSettle();

  // Check if we're on the login page
  final loginPageFinder = find.byType(LoginPage);
  if (loginPageFinder.evaluate().isNotEmpty) {
    // Enter username
    final usernameField = find.byKey(loginUsernameFieldKey);
    await tester.enterText(usernameField, username);

    // Enter password
    final passwordField = find.byKey(loginPasswordFieldKey);
    await tester.enterText(passwordField, password);

    // Tap login button
    final loginButton = find.byKey(loginButtonKey);
    await tester.tap(loginButton);

    // Wait for login process to complete
    await tester.pumpAndSettle(const Duration(seconds: 5));
  }
}
