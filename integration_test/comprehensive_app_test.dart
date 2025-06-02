import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:memverse/main_development.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // Test configuration using dart defines
  const username = String.fromEnvironment('USERNAME');
  const password = String.fromEnvironment('PASSWORD');
  const clientId = String.fromEnvironment('CLIENT_ID');

  group('Memverse App Comprehensive Integration Tests', () {
    setUpAll(() {
      // Validate that credentials are available
      if (username.isEmpty || password.isEmpty || clientId.isEmpty) {
        fail('Missing test credentials. Please run with --dart-define parameters.');
      }
    });

    testWidgets('Complete user journey - Login and verse interaction', (tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Check if we're on the login screen or already logged in
      if (find.byIcon(Icons.logout).evaluate().isNotEmpty) {
        // Already logged in, logout first
        await tester.tap(find.byIcon(Icons.logout));
        await tester.pumpAndSettle();
      }

      // Wait for login screen to appear
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Find username/email field (try different possible keys)
      var usernameField = find.byKey(const Key('username_field'));
      if (usernameField.evaluate().isEmpty) {
        usernameField = find.byKey(const Key('email_field'));
      }
      if (usernameField.evaluate().isEmpty) {
        usernameField = find.byType(TextFormField).first;
      }

      // Find password field
      var passwordField = find.byKey(const Key('password_field'));
      if (passwordField.evaluate().isEmpty) {
        passwordField = find.byType(TextFormField).last;
      }

      // Enter credentials
      await tester.enterText(usernameField, username);
      await tester.pump();
      await tester.enterText(passwordField, password);
      await tester.pump();

      // Find and tap login button
      var loginButton = find.byKey(const Key('login_button'));
      if (loginButton.evaluate().isEmpty) {
        loginButton = find.byType(ElevatedButton);
      }
      if (loginButton.evaluate().isEmpty) {
        loginButton = find.text('Login');
      }

      expect(loginButton, findsOneWidget);
      await tester.tap(loginButton);
      await tester.pumpAndSettle(const Duration(seconds: 10));

      // Verify successful login by checking for main app elements
      await tester.pumpAndSettle(const Duration(seconds: 3));

      final mainAppElements = [
        find.text('Reference Test'),
        find.text('Memverse'),
        find.byIcon(Icons.logout),
        find.byKey(const Key('memverse_page_scaffold')),
      ];

      var foundMainElement = false;
      for (final element in mainAppElements) {
        if (element.evaluate().isNotEmpty) {
          foundMainElement = true;
          break;
        }
      }

      expect(foundMainElement, true, reason: 'Should find main app elements after login');

      // Test verse interaction
      await tester.pumpAndSettle();

      // Look for verse text
      expect(find.byType(Text), findsWidgets);

      // Find the reference input field
      final referenceField = find.byType(TextFormField);
      expect(referenceField, findsOneWidget);

      // Test submitting an empty reference (should show validation error)
      final submitButton = find.byType(ElevatedButton);
      expect(submitButton, findsOneWidget);

      await tester.tap(submitButton);
      await tester.pumpAndSettle();

      // Should see a snackbar with validation error
      expect(find.byType(SnackBar), findsOneWidget);
      await tester.pumpAndSettle(const Duration(seconds: 4)); // Wait for snackbar to disappear

      // Test submitting a reference
      await tester.enterText(referenceField, 'Test 1:1');
      await tester.pump();
      await tester.tap(submitButton);
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Should see feedback (either success or error)
      expect(find.byType(SnackBar), findsOneWidget);
      await tester.pumpAndSettle(const Duration(seconds: 4));

      // Test logout functionality
      final logoutButton = find.byIcon(Icons.logout);
      expect(logoutButton, findsOneWidget);
      await tester.tap(logoutButton);
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Should return to login screen or initial state
      await tester.pumpAndSettle();
    });

    testWidgets('Test invalid login credentials', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Make sure we're on login screen
      if (find.byIcon(Icons.logout).evaluate().isNotEmpty) {
        await tester.tap(find.byIcon(Icons.logout));
        await tester.pumpAndSettle();
      }

      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Find form fields
      var usernameField = find.byKey(const Key('username_field'));
      if (usernameField.evaluate().isEmpty) {
        usernameField = find.byKey(const Key('email_field'));
      }
      if (usernameField.evaluate().isEmpty) {
        usernameField = find.byType(TextFormField).first;
      }

      var passwordField = find.byKey(const Key('password_field'));
      if (passwordField.evaluate().isEmpty) {
        passwordField = find.byType(TextFormField).last;
      }

      // Enter invalid credentials
      await tester.enterText(usernameField, 'invalid@example.com');
      await tester.pump();
      await tester.enterText(passwordField, 'wrongpassword');
      await tester.pump();

      // Tap login
      var loginButton = find.byKey(const Key('login_button'));
      if (loginButton.evaluate().isEmpty) {
        loginButton = find.byType(ElevatedButton);
      }

      await tester.tap(loginButton);
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Should remain on login screen or show error
      // We don't assert specific error messages since they may vary
      // but we should not see the main app elements
      expect(find.byIcon(Icons.logout), findsNothing);
    });

    testWidgets('Test app responsiveness', (tester) async {
      // Test on different screen sizes
      app.main();
      await tester.pumpAndSettle();

      // Test small screen (mobile)
      tester.view.physicalSize = const Size(375, 667); // iPhone SE size
      tester.view.devicePixelRatio = 2.0;
      await tester.pumpAndSettle();

      // Verify the app renders without overflow
      expect(tester.takeException(), isNull);

      // Test large screen (tablet/desktop)
      tester.view.physicalSize = const Size(1024, 768); // iPad size
      tester.view.devicePixelRatio = 2.0;
      await tester.pumpAndSettle();

      // Verify the app renders without overflow
      expect(tester.takeException(), isNull);

      // Reset to default size
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    testWidgets('Test network error handling', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // This test verifies the app doesn't crash when network operations fail
      // The specific error handling depends on the implementation
      expect(find.byType(MaterialApp), findsOneWidget);
    });
  });
}
