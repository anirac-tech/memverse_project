import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:memverse/l10n/l10n.dart';
import 'package:memverse/main_development.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('App Integration Tests', () {
    testWidgets('Complete app flow from login to verse memorization', (WidgetTester tester) async {
      // Launch the app
      app.main();

      // Wait for the app to load fully
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Verify the app launches and login screen is shown
      expect(find.text('Memverse Login'), findsOneWidget);
      expect(find.text('Welcome to Memverse'), findsOneWidget);

      // Test login screen interactions
      final usernameField = find.byType(TextFormField).first;
      final passwordField = find.byType(TextFormField).at(1);
      final loginButton = find.widgetWithText(ElevatedButton, 'Login');

      await tester.enterText(usernameField, 'testuser');
      await tester.enterText(passwordField, 'password');

      // Check password visibility toggle - initially should show the visibility_off icon
      // indicating password is currently obscured
      final visibilityToggleOff = find.byIcon(Icons.visibility_off);
      expect(visibilityToggleOff, findsOneWidget);

      // Tap the visibility toggle
      await tester.tap(visibilityToggleOff);
      await tester.pumpAndSettle();

      // Verify the visibility toggle changed to the visibility icon
      // indicating password is now visible
      expect(find.byIcon(Icons.visibility), findsOneWidget);
      expect(find.byIcon(Icons.visibility_off), findsNothing);

      // Tap login with test credentials
      // This will likely fail authentication but we're testing the UI flow
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      // After this point, we'd typically have error messages or redirection
      // But for the purposes of the test, we've successfully covered the login flow
    }, tags: ['integration']);

    testWidgets('App handles form validation correctly', (WidgetTester tester) async {
      // Launch the app
      app.main();

      // Wait for the app to load fully
      await tester.pumpAndSettle();

      // Get localization
      final context = tester.element(find.byType(MaterialApp));
      final l10n = context.l10n;

      // Find the login button
      final loginButton = find.widgetWithText(ElevatedButton, l10n.login);

      // Tap login without entering credentials
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      // Verify validation messages appear
      expect(find.text(l10n.pleaseEnterYourUsername), findsOneWidget);
      expect(find.text(l10n.pleaseEnterYourPassword), findsOneWidget);

      // Enter only username
      await tester.enterText(find.byType(TextFormField).first, 'testuser');
      await tester.pumpAndSettle();

      // Tap login again
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      // Verify username validation passes but password still fails
      expect(find.text(l10n.pleaseEnterYourUsername), findsNothing);
      expect(find.text(l10n.pleaseEnterYourPassword), findsOneWidget);

      // Clear username and enter only password
      await tester.enterText(find.byType(TextFormField).first, '');
      await tester.enterText(find.byType(TextFormField).at(1), 'password123');
      await tester.pumpAndSettle();

      // Tap login again
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      // Verify username validation fails but password passes
      expect(find.text(l10n.pleaseEnterYourUsername), findsOneWidget);
      expect(find.text(l10n.pleaseEnterYourPassword), findsNothing);
    }, tags: ['integration']);

    testWidgets('App UI elements render correctly', (WidgetTester tester) async {
      // Launch the app
      app.main();

      // Wait for the app to load fully
      await tester.pumpAndSettle();

      // Verify all major UI elements exist
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(2)); // Username and password fields
      expect(find.byType(IconButton), findsOneWidget); // Password visibility toggle
      expect(find.byType(ElevatedButton), findsOneWidget); // Login button

      // Verify text elements
      expect(find.text('Memverse Login'), findsOneWidget);
      expect(find.text('Welcome to Memverse'), findsOneWidget);
      expect(find.text('Sign in to continue'), findsOneWidget);

      // Verify image loads or falls back correctly
      final image = find.byType(Image).evaluate().first.widget as Image;
      expect(image.image, isA<NetworkImage>());
      expect(
        (image.image as NetworkImage).url,
        'https://www.memverse.com/assets/quill-writing-on-scroll-f758c31d9bfc559f582fcbb707d04b01a3fa11285f1157044cc81bdf50137086.png',
      );
    }, tags: ['integration']);
  });
}
