import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:memverse/main_development.dart' as app;
import 'package:memverse/src/features/auth/presentation/login_page.dart';
import 'package:memverse/src/features/verse/presentation/memverse_page.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end app test', () {
    testWidgets('Verify app launches and login page appears', (tester) async {
      // Load app widget
      app.main();
      await tester.pumpAndSettle();

      // Should be on the login page initially
      expect(find.byType(LoginPage), findsOneWidget);

      // Verify login form elements are visible
      expect(find.byKey(const Key('username_field')), findsOneWidget);
      expect(find.byKey(const Key('password_field')), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);

      // Enter credentials
      await tester.enterText(find.byKey(const Key('username_field')), 'test_user');
      await tester.enterText(find.byKey(const Key('password_field')), 'password123');

      // Test password visibility toggle
      expect(tester.widget<TextField>(find.byKey(const Key('password_field'))).obscureText, isTrue);
      await tester.tap(find.byIcon(Icons.visibility_off));
      await tester.pump();
      expect(
        tester.widget<TextField>(find.byKey(const Key('password_field'))).obscureText,
        isFalse,
      );
      await tester.tap(find.byIcon(Icons.visibility));
      await tester.pump();
      expect(tester.widget<TextField>(find.byKey(const Key('password_field'))).obscureText, isTrue);

      // Tap login button (assuming successful navigation to MemversePage for this integration test)
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle(const Duration(seconds: 3)); // Give time for auth and navigation

      // Should now be on the MemversePage (main content page)
      // This may not work if real auth is required - mock would be needed for CI
      expect(find.byType(MemversePage), findsOneWidget);

      // Test MemversePage interaction - answer a question
      if (find.byType(TextField).evaluate().isNotEmpty) {
        final referenceField = find.byType(TextField).first;
        await tester.enterText(referenceField, 'John 3:16');
        await tester.tap(find.text('Submit'));
        await tester.pumpAndSettle();
      }

      // Test navigation through bottom navigation
      if (find.byType(BottomNavigationBar).evaluate().isNotEmpty) {
        final bottomNav = find.byType(BottomNavigationBar).first;
        await tester.tap(bottomNav);
        await tester.pumpAndSettle();
      }
    });
  });
}
