import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:memverse/main_development.dart' as app;

/// Integration test to verify incorrect password handling
/// This test confirms that outdated/incorrect passwords are properly rejected
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Incorrect Password Handling', () {
    testWidgets('login with outdated password "Help4App" shows error', (tester) async {
      // Given: App is launched
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Verify we're on the login screen
      expect(find.byType(MaterialApp), findsOneWidget);

      // When: User enters valid email but OUTDATED/INCORRECT password
      final usernameField = find.byType(TextFormField).first;
      await tester.enterText(usernameField, 'njwandroid@gmail.com');
      await tester.pumpAndSettle();

      final passwordField = find.byType(TextFormField).last;
      // This is the OUTDATED password that should NOT work
      await tester.enterText(passwordField, 'Help4App');
      await tester.pumpAndSettle();

      // Find and tap the login button
      final loginButton = find.widgetWithText(ElevatedButton, 'Login');
      if (loginButton.evaluate().isEmpty) {
        // Try alternate button text
        final signInButton = find.text('Sign In');
        await tester.tap(signInButton);
      } else {
        await tester.tap(loginButton);
      }
      await tester.pumpAndSettle();

      // Wait for the API response
      await tester.pump(const Duration(seconds: 5));
      await tester.pumpAndSettle();

      // Then: Should see error message indicating invalid credentials
      // The app should NOT successfully log in with this outdated password
      expect(
        find.textContaining('error', findRichText: true),
        findsWidgets,
        reason: 'Should show error message for incorrect password',
      );

      // Verify we're still on login screen (not navigated away)
      expect(
        find.byType(TextFormField),
        findsWidgets,
        reason: 'Should still be on login screen after failed login',
      );
    });

    testWidgets('login with correct environment variable password succeeds', (tester) async {
      // Given: App is launched
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // When: User enters valid credentials from environment
      final usernameField = find.byType(TextFormField).first;
      await tester.enterText(
        usernameField,
        const String.fromEnvironment('MEMVERSE_USERNAME', defaultValue: 'njwandroid@gmail.com'),
      );
      await tester.pumpAndSettle();

      final passwordField = find.byType(TextFormField).last;
      // Use environment variable for the CORRECT password
      await tester.enterText(
        passwordField,
        const String.fromEnvironment(
          'MEMVERSE_PASSWORD',
          defaultValue: 'dummysigninuser@dummy.com',
        ),
      );
      await tester.pumpAndSettle();

      // Find and tap the login button
      final loginButton = find.widgetWithText(ElevatedButton, 'Login');
      if (loginButton.evaluate().isEmpty) {
        final signInButton = find.text('Sign In');
        await tester.tap(signInButton);
      } else {
        await tester.tap(loginButton);
      }
      await tester.pumpAndSettle();

      // Wait for authentication
      await tester.pump(const Duration(seconds: 8));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Then: Should successfully navigate to main app
      // This verifies that the CORRECT password from environment works
      expect(
        find.textContaining('Verses', findRichText: true),
        findsAny,
        reason: 'Should navigate to main app with correct password',
      );
    });
  });
}
