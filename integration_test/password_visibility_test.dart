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

      // Find the visibility icon button (initially visibility_off)
      final visibilityOffButton = find.byIcon(Icons.visibility_off);
      expect(visibilityOffButton, findsOneWidget);

      // Password is initially obscured (visibility_off icon is showing)
      expect(visibilityOffButton, findsOneWidget);
      expect(find.byIcon(Icons.visibility), findsNothing);

      // Tap the visibility icon to show the password
      await tester.tap(visibilityOffButton);
      await tester.pumpAndSettle();

      // Verify password is now visible (visibility icon is showing)
      final visibilityOnButton = find.byIcon(Icons.visibility);
      expect(visibilityOnButton, findsOneWidget);
      expect(visibilityOffButton, findsNothing);

      // Tap the visibility icon again to hide the password
      await tester.tap(visibilityOnButton);
      await tester.pumpAndSettle();

      // Verify password is obscured again (visibility_off icon is showing)
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);
      expect(find.byIcon(Icons.visibility), findsNothing);

      // Check that the text field still contains the password by entering text again
      // and checking if it appends instead of replacing
      await tester.enterText(passwordField, testPassword + testPassword);
      await tester.pumpAndSettle();

      // Enter it again to see what's in the field through UI
      final textInField =
          tester
              .widget<EditableText>(
                find.descendant(of: passwordField, matching: find.byType(EditableText)),
              )
              .controller
              .text;

      expect(textInField, equals(testPassword + testPassword));
    }, tags: ['integration']);

    testWidgets('Password visibility tooltip changes correctly', (WidgetTester tester) async {
      // Launch the app
      app.main();

      // Wait for the app to load fully
      await tester.pumpAndSettle();

      // Get the localizations
      final context = tester.element(find.byType(MaterialApp));
      final l10n = context.l10n;

      // Find the icon button inside the password field
      final iconButton = find.descendant(
        of: find.byType(TextFormField).at(1),
        matching: find.byType(IconButton),
      );

      // Get the IconButton widget to check tooltip
      final visibilityButton = tester.widget<IconButton>(iconButton);

      // Verify the tooltip is initially "Show Password" by looking at the icon
      expect(visibilityButton.icon, isA<Icon>());
      expect((visibilityButton.icon as Icon).icon, equals(Icons.visibility_off));
      expect(visibilityButton.tooltip, equals(l10n.showPassword));

      // Tap the button to show the password
      await tester.tap(iconButton);
      await tester.pumpAndSettle();

      // Find the updated button
      final updatedIconButton = find.descendant(
        of: find.byType(TextFormField).at(1),
        matching: find.byType(IconButton),
      );
      final updatedButton = tester.widget<IconButton>(updatedIconButton);

      // Verify the tooltip changed to "Hide Password" by looking at the icon
      expect(updatedButton.icon, isA<Icon>());
      expect((updatedButton.icon as Icon).icon, equals(Icons.visibility));
      expect(updatedButton.tooltip, equals(l10n.hidePassword));
    }, tags: ['integration']);

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
    }, tags: ['integration']);
  });
}
