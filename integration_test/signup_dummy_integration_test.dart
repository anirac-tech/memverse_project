import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:memverse/src/features/auth/presentation/signup_page.dart';

import 'util/test_app_wrapper.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Signup Integration Tests', () {
    testWidgets('should successfully signup with dummy email', (tester) async {
      // Build the signup page
      await tester.pumpWidget(buildTestApp(home: const SignupPage()));
      await tester.pumpAndSettle();

      // Verify we're on the signup page
      expect(find.text('Create Account'), findsOneWidget);
      expect(find.text('Join the Memverse community'), findsOneWidget);

      // Fill in dummy signup data
      await tester.enterText(find.byKey(signupEmailFieldKey), 'dummynewuser@dummy.com');
      await tester.enterText(find.byKey(signupNameFieldKey), 'Test User');
      await tester.enterText(find.byKey(signupPasswordFieldKey), 'password123');

      // Take a screenshot
      await takeScreenshot(tester, 'signup_form_filled');

      // Submit form
      await tester.tap(find.byKey(signupSubmitButtonKey));
      await tester.pump();

      // Verify loading state
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Take a screenshot
      await takeScreenshot(tester, 'signup_loading');

      // Wait for success screen (2 second delay)
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // Verify success screen
      expect(find.text('Welcome to Memverse!'), findsOneWidget);
      expect(find.text('Account created successfully for'), findsOneWidget);
      expect(find.textContaining('dummynewuser@dummy.com'), findsOneWidget);

      // Take a screenshot
      await takeScreenshot(tester, 'signup_success');
    });

    testWidgets('should show validation errors for empty fields', (tester) async {
      // Build the signup page
      await tester.pumpWidget(buildTestApp(home: const SignupPage()));
      await tester.pumpAndSettle();

      // Submit form without filling in any fields
      await tester.tap(find.byKey(signupSubmitButtonKey));
      await tester.pump();

      // Verify validation errors
      expect(find.text('Please enter your email'), findsOneWidget);
      expect(find.text('Please enter your name'), findsOneWidget);
      expect(find.text('Please enter a password'), findsOneWidget);

      // Take a screenshot
      await takeScreenshot(tester, 'signup_validation_errors');
    });

    testWidgets('should show error message for non-dummy email', (tester) async {
      // Build the signup page
      await tester.pumpWidget(buildTestApp(home: const SignupPage()));
      await tester.pumpAndSettle();

      // Fill in non-dummy signup data
      await tester.enterText(find.byKey(signupEmailFieldKey), 'real@example.com');
      await tester.enterText(find.byKey(signupNameFieldKey), 'Test User');
      await tester.enterText(find.byKey(signupPasswordFieldKey), 'password123');

      // Submit form
      await tester.tap(find.byKey(signupSubmitButtonKey));
      await tester.pump();

      // Verify loading state
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Wait for error message (2 second delay)
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // Verify error message
      expect(find.text('Signup not yet implemented for real emails'), findsOneWidget);

      // Verify the error is orange
      final snackBarFinder = find.byType(SnackBar);
      expect(snackBarFinder, findsOneWidget);
      final snackBar = tester.widget<SnackBar>(snackBarFinder);
      expect(snackBar.backgroundColor, Colors.orange);

      // Take a screenshot
      await takeScreenshot(tester, 'signup_error_message');
    });
  });
}

/// Helper method to take a screenshot during integration tests
Future<void> takeScreenshot(WidgetTester tester, String name) async {
  await tester.pumpAndSettle();
  // Note: The actual screenshot saving implementation would be added later
  // (Debug: Taking screenshot)
}
