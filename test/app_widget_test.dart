import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:memverse/src/app/view/app.dart';
import 'package:memverse/src/features/auth/domain/auth_token.dart';
import 'package:memverse/src/features/auth/presentation/providers/auth_providers.dart';
import 'package:memverse/src/features/verse/data/verse_repository.dart';

// Test AuthNotifier that's pre-authenticated
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

void main() {
  group('App', () {
    testWidgets('renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authStateProvider.overrideWith(
              (ref) =>
                  TestAuthNotifier(ref.watch(authServiceProvider), ref.watch(clientIdProvider)),
            ),
            verseRepositoryProvider.overrideWith((ref) => FakeVerseRepository()),
          ],
          child: const App(),
        ),
      );
      await tester.pumpAndSettle();

      // Verify the App contains the correct components
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('uses correct theme', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authStateProvider.overrideWith(
              (ref) =>
                  TestAuthNotifier(ref.watch(authServiceProvider), ref.watch(clientIdProvider)),
            ),
            verseRepositoryProvider.overrideWith((ref) => FakeVerseRepository()),
          ],
          child: const App(),
        ),
      );
      await tester.pumpAndSettle();

      final context = tester.element(find.byType(MaterialApp));
      final theme = Theme.of(context);
      expect(theme, isNotNull);
      expect(theme.colorScheme.primary, isNotNull);
    });
  });
}
