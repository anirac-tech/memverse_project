import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memverse/src/app/app.dart';
import 'package:memverse/src/features/auth/domain/auth_token.dart';
import 'package:memverse/src/features/auth/presentation/providers/auth_providers.dart';
import 'package:memverse/src/features/verse/data/verse_repository.dart';
import 'package:memverse/src/features/verse/domain/verse.dart';

// Integration tests to increase coverage to 90%+
void main() {
  group('High Coverage Integration Tests', () {
    testWidgets('Invalid login credentials test', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [verseRepositoryProvider.overrideWith((ref) => FakeVerseRepository())],
          child: const App(),
        ),
      );
      await tester.pumpAndSettle();

      // Find login fields
      final usernameField = find.byKey(const ValueKey('login_username_field'));
      final passwordField = find.byKey(const ValueKey('login_password_field'));
      final loginButton = find.byKey(const ValueKey('login_button'));

      // Enter invalid credentials
      await tester.enterText(usernameField, 'invalid@invalid.com');
      await tester.enterText(passwordField, 'badpassword');
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      // Should show error or remain on login screen
      expect(find.byKey(const ValueKey('login_page')), findsOneWidget);
    });

    testWidgets('Authentication state management test', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [verseRepositoryProvider.overrideWith((ref) => FakeVerseRepository())],
          child: const App(),
        ),
      );
      await tester.pumpAndSettle();

      // Test auth wrapper logic
      expect(find.byKey(const ValueKey('login_page')), findsOneWidget);
    });

    testWidgets('Invalid verse reference format test', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            verseRepositoryProvider.overrideWith((ref) => FakeVerseRepository()),
            authStateProvider.overrideWith(
              (ref) =>
                  TestAuthNotifier(ref.watch(authServiceProvider), ref.watch(clientIdProvider)),
            ),
            isLoggedInProvider.overrideWith((ref) => Future.value(true)),
          ],
          child: const App(),
        ),
      );
      await tester.pumpAndSettle();

      // Find reference input and submit button
      final textFields = find.byType(TextField);
      expect(textFields, findsWidgets);

      final submitButton = find.byKey(const Key('submit-ref'));

      // Enter invalid reference format
      await tester.enterText(textFields.last, 'invalid reference format');
      await tester.tap(submitButton);
      await tester.pumpAndSettle();

      // Should show invalid format error
      expect(find.textContaining('Invalid reference format'), findsOneWidget);
    });

    testWidgets('Empty reference submission test', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            verseRepositoryProvider.overrideWith((ref) => FakeVerseRepository()),
            authStateProvider.overrideWith(
              (ref) =>
                  TestAuthNotifier(ref.watch(authServiceProvider), ref.watch(clientIdProvider)),
            ),
            isLoggedInProvider.overrideWith((ref) => Future.value(true)),
          ],
          child: const App(),
        ),
      );
      await tester.pumpAndSettle();

      // Find submit button and tap without entering text
      final submitButton = find.byKey(const Key('submit-ref'));
      await tester.tap(submitButton);
      await tester.pumpAndSettle();

      // Should show empty reference error
      expect(find.textContaining('cannot be empty'), findsOneWidget);
    });

    testWidgets('Logout functionality test', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            verseRepositoryProvider.overrideWith((ref) => FakeVerseRepository()),
            authStateProvider.overrideWith(
              (ref) =>
                  TestAuthNotifier(ref.watch(authServiceProvider), ref.watch(clientIdProvider)),
            ),
            isLoggedInProvider.overrideWith((ref) => Future.value(true)),
          ],
          child: const App(),
        ),
      );
      await tester.pumpAndSettle();

      // Find logout button in app bar
      final logoutButton = find.byIcon(Icons.logout);
      expect(logoutButton, findsOneWidget);

      await tester.tap(logoutButton);
      await tester.pumpAndSettle();

      // Should redirect to login screen
      expect(find.byKey(const ValueKey('login_page')), findsOneWidget);
    });

    testWidgets('Password visibility toggle test', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [verseRepositoryProvider.overrideWith((ref) => FakeVerseRepository())],
          child: const App(),
        ),
      );
      await tester.pumpAndSettle();

      // Find password field and visibility toggle
      final passwordField = find.byKey(const ValueKey('login_password_field'));
      await tester.enterText(passwordField, 'testpassword');

      final visibilityToggle = find.byIcon(Icons.visibility_off);
      expect(visibilityToggle, findsOneWidget);

      await tester.tap(visibilityToggle);
      await tester.pumpAndSettle();

      // Should show visibility icon (password visible)
      expect(find.byIcon(Icons.visibility), findsOneWidget);
    });

    testWidgets('Verse progression and history test', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            verseRepositoryProvider.overrideWith((ref) => FakeVerseRepository()),
            authStateProvider.overrideWith(
              (ref) =>
                  TestAuthNotifier(ref.watch(authServiceProvider), ref.watch(clientIdProvider)),
            ),
            isLoggedInProvider.overrideWith((ref) => Future.value(true)),
          ],
          child: const App(),
        ),
      );
      await tester.pumpAndSettle();

      // Answer first verse correctly
      final textFields = find.byType(TextField);
      final submitButton = find.byKey(const Key('submit-ref'));

      await tester.enterText(textFields.last, 'Col 1:17');
      await tester.tap(submitButton);
      await tester.pumpAndSettle();

      // Wait for next verse
      await tester.pump(const Duration(milliseconds: 1500));
      await tester.pumpAndSettle();

      // Answer second verse with almost correct
      await tester.enterText(textFields.last, 'Gal 5:2');
      await tester.tap(submitButton);
      await tester.pumpAndSettle();

      // Should show history
      expect(find.textContaining('Past Questions'), findsOneWidget);
    });

    testWidgets('Form validation test', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [verseRepositoryProvider.overrideWith((ref) => FakeVerseRepository())],
          child: const App(),
        ),
      );
      await tester.pumpAndSettle();

      // Try to login with empty username
      final passwordField = find.byKey(const ValueKey('login_password_field'));
      final loginButton = find.byKey(const ValueKey('login_button'));

      await tester.enterText(passwordField, 'password');
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      // Should show validation error for username
      expect(find.textContaining('Please enter your username'), findsOneWidget);
    });

    testWidgets('UI text coverage test', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            verseRepositoryProvider.overrideWith((ref) => FakeVerseRepository()),
            authStateProvider.overrideWith(
              (ref) =>
                  TestAuthNotifier(ref.watch(authServiceProvider), ref.watch(clientIdProvider)),
            ),
            isLoggedInProvider.overrideWith((ref) => Future.value(true)),
          ],
          child: const App(),
        ),
      );
      await tester.pumpAndSettle();

      // Verify various UI text elements are displayed
      expect(find.textContaining('Reference'), findsOneWidget);
      expect(find.textContaining('Submit'), findsOneWidget);
      expect(find.textContaining('He is before all things'), findsOneWidget);
    });

    testWidgets('Error handling coverage test', (tester) async {
      // Test with error-prone verse repository
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            verseRepositoryProvider.overrideWith((ref) => ErrorVerseRepository()),
            authStateProvider.overrideWith(
              (ref) =>
                  TestAuthNotifier(ref.watch(authServiceProvider), ref.watch(clientIdProvider)),
            ),
            isLoggedInProvider.overrideWith((ref) => Future.value(true)),
          ],
          child: const App(),
        ),
      );
      await tester.pumpAndSettle();

      // Should show error loading verses
      expect(find.textContaining('Error loading verses'), findsOneWidget);
    });
  });
}

// Test auth notifier
class TestAuthNotifier extends AuthNotifier {
  TestAuthNotifier(super.authService, super.clientId) {
    state = AuthState(
      isAuthenticated: true,
      token: AuthToken(
        accessToken: 'test_token',
        tokenType: 'bearer',
        scope: 'public',
        createdAt: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      ),
    );
  }
}

// Error-prone verse repository for testing error handling
class ErrorVerseRepository implements VerseRepository {
  @override
  Future<List<Verse>> getVerses() async {
    throw Exception('Test error for coverage');
  }
}
