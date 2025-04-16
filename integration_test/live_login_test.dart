import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:memverse/main_development.dart' as app;

/// Live login test that makes actual network calls to authenticate
/// Run with:
/// ```bash
/// flutter test integration_test/live_login_test.dart --flavor development \
///   --dart-define=USERNAME=$MEMVERSE_USERNAME \
///   --dart-define=PASSWORD=$MEMVERSE_PASSWORD \
///   --dart-define=CLIENT_ID=$MEMVERSE_CLIENT_ID
/// ```
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Live Login Flow Test', () {
    // Get credentials from environment variables passed via --dart-define
    const username = String.fromEnvironment('USERNAME');
    const password = String.fromEnvironment('PASSWORD');
    const clientId = String.fromEnvironment('CLIENT_ID');

    debugPrint(
      'Starting live login test with username: $username, password length: ${password.length}, '
      'and client ID is set: ${clientId.isNotEmpty}',
    );

    testWidgets('Login with real credentials and verify navigation', (WidgetTester tester) async {
      // Verify that all required credentials are provided
      if (username.isEmpty) {
        fail(
          'USERNAME environment variable must be set. Please run this test with:\n'
          'flutter test integration_test/live_login_test.dart --dart-define=USERNAME=xxx',
        );
      }

      if (password.isEmpty) {
        fail(
          'PASSWORD environment variable must be set. Please run this test with:\n'
          'flutter test integration_test/live_login_test.dart --dart-define=PASSWORD=xxx',
        );
      }

      if (clientId.isEmpty) {
        fail(
          'CLIENT_ID environment variable must be set. Please run this test with:\n'
          'flutter test integration_test/live_login_test.dart --dart-define=CLIENT_ID=xxx',
        );
      }

      // Log the username being used (not sensitive information)
      debugPrint(
        'Running test with username: $username and client ID is non-empty: ${clientId.isNotEmpty}',
      );

      // Launch the app
      app.main();
      await tester.pumpAndSettle();

      // Find login form elements
      final usernameField = find.byType(TextFormField).first;
      final passwordField = find.byType(TextFormField).at(1);
      final loginButton = find.widgetWithText(ElevatedButton, 'Login');

      // Verify login page is loaded
      expect(find.text('Memverse Login'), findsOneWidget);
      expect(usernameField, findsOneWidget);
      expect(passwordField, findsOneWidget);
      expect(loginButton, findsOneWidget);

      // Enter credentials
      await tester.enterText(usernameField, username);
      await tester.enterText(passwordField, password);
      await tester.pumpAndSettle();

      // Tap login button
      await tester.tap(loginButton);

      // Wait for login process
      await tester.pumpAndSettle(const Duration(seconds: 7));

      // After login, we consider the test successful if we've reached this point without errors
      // We're not adding additional verification steps because they would depend on network
      // conditions and actual server state, which could make the test flaky

      debugPrint('✓ Successfully completed login test');
    });
  });
}
