import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:memverse/l10n/l10n.dart';
import 'package:memverse/main_development.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Password Visibility Integration Test', () {
    testWidgets('Password visibility toggle works correctly', (WidgetTester tester) async {
      // Launch the app
      app.main();

      // Wait for the app to load fully
      await tester.pumpAndSettle();

      // Verify login page is loaded
      expect(find.text('Memverse Login'), findsOneWidget);

      // Find the password field and enter text
      final passwordField = find.byType(TextFormField).at(1);
      expect(passwordField, findsOneWidget);

      // Enter a test password
      const testPassword = 'SecretPassword123!';
      await tester.enterText(passwordField, testPassword);
      await tester.pumpAndSettle();

      // Verify initially password is obscured
      var textField = tester.widget(passwordField);
      expect(textField.obscureText, isTrue);

      // Find the visibility icon button (initially visibility_off)
      final visibilityButton = find.byIcon(Icons.visibility_off);
      expect(visibilityButton, findsOneWidget);

      // Tap the visibility icon to show the password
      await tester.tap(visibilityButton);
      await tester.pumpAndSettle();

      // Verify password is now visible
      textField = tester.widget(passwordField);
      expect(textField.obscureText, isFalse);

      // Find the visibility icon button (now visibility)
      final visibilityOnButton = find.byIcon(Icons.visibility);
      expect(visibilityOnButton, findsOneWidget);
      expect(find.byIcon(Icons.visibility_off), findsNothing);

      // Tap the visibility icon again to hide the password
      await tester.tap(visibilityOnButton);
      await tester.pumpAndSettle();

      // Verify password is obscured again
      textField = tester.widget(passwordField);
      expect(textField.obscureText, isTrue);
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);
      expect(find.byIcon(Icons.visibility), findsNothing);

      // Check that the text field still contains the password
      expect(
        textField.controller?.text ?? '',
        equals(testPassword),
        reason: 'Password should not be cleared when visibility is toggled',
      );
    });

    testWidgets('Password visibility tooltip changes correctly', (WidgetTester tester) async {
      // Launch the app
      app.main();

      // Wait for the app to load fully
      await tester.pumpAndSettle();

      // Get the localizations
      final context = tester.element(find.byType(MaterialApp));
      final l10n = context.l10n;

      // Find the visibility icon button
      final visibilityButton = tester.widget(
        find.descendant(of: find.byType(TextFormField).at(1), matching: find.byType(IconButton)),
      );

      // Verify the tooltip is initially "Show Password"
      expect(visibilityButton.tooltip, equals(l10n.showPassword));

      // Tap the button to show the password
      await tester.tap(find.byIcon(Icons.visibility_off));
      await tester.pumpAndSettle();

      // Find the updated button and check its tooltip
      final updatedButton = tester.widget(
        find.descendant(of: find.byType(TextFormField).at(1), matching: find.byType(IconButton)),
      );

      // Verify the tooltip changed to "Hide Password"
      expect(updatedButton.tooltip, equals(l10n.hidePassword));
    });

    testWidgets('Form validation still works with password visibility toggle', (
      WidgetTester tester,
    ) async {
      // Launch the app
      app.main();

      // Wait for the app to load fully
      await tester.pumpAndSettle();

      // Get the localizations
      final context = tester.element(find.byType(MaterialApp));
      final l10n = context.l10n;

      // Find the login button and tap it without entering credentials
      final loginButton = find.widgetWithText(ElevatedButton, l10n.login);
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      // Verify validation errors appear
      expect(find.text(l10n.pleaseEnterYourPassword), findsOneWidget);

      // Find the password field and toggle visibility
      final passwordField = find.byType(TextFormField).at(1);
      await tester.tap(find.descendant(of: passwordField, matching: find.byType(IconButton)));
      await tester.pumpAndSettle();

      // Enter a password while password is visible
      await tester.enterText(passwordField, 'VisiblePassword123!');
      await tester.pumpAndSettle();

      // Tap login button again
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      // Verify password validation error is gone but username error remains
      expect(find.text(l10n.pleaseEnterYourPassword), findsNothing);
      expect(find.text(l10n.pleaseEnterYourUsername), findsOneWidget);
    });
  });
}
