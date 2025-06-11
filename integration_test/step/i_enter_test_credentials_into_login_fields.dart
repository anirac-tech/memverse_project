import 'package:flutter_test/flutter_test.dart';
import 'package:memverse/src/features/auth/presentation/login_page.dart';

/// Usage: I enter test credentials into login fields
Future<void> iEnterTestCredentialsIntoLoginFields(WidgetTester tester) async {
  // Get test credentials from environment variables
  const username = String.fromEnvironment('USERNAME', defaultValue: 'test_user');
  const password = String.fromEnvironment('PASSWORD', defaultValue: 'test_password');

  // Wait for the page to be ready
  await tester.pumpAndSettle();

  // Enter username
  final usernameField = find.byKey(loginUsernameFieldKey);
  await tester.enterText(usernameField, username);

  // Enter password
  final passwordField = find.byKey(loginPasswordFieldKey);
  await tester.enterText(passwordField, password);

  // Pump to ensure text is entered
  await tester.pump();
}
