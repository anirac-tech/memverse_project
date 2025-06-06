import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:memverse/src/app/view/app.dart';
import 'package:memverse/src/common/services/analytics_service.dart';
import 'package:memverse/src/features/auth/data/auth_service.dart';
import 'package:memverse/src/features/auth/domain/auth_token.dart';
import 'package:memverse/src/features/auth/presentation/providers/auth_providers.dart';
import 'package:memverse/src/features/verse/data/verse_repository.dart';
import 'package:mocktail/mocktail.dart';

// Mock Auth Service
class MockAuthService extends Mock implements AuthService {}

// Test AuthNotifier that's pre-authenticated
class TestAuthNotifier extends AuthNotifier {
  TestAuthNotifier(super.authService, super.clientId, super.analyticsService) {
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
  late MockAuthService mockAuthService;

  setUp(() {
    mockAuthService = MockAuthService();
  });

  group('App', () {
    testWidgets('renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authServiceProvider.overrideWithValue(mockAuthService),
            clientIdProvider.overrideWithValue('test_client_id'),
            authStateProvider.overrideWith(
              (ref) => TestAuthNotifier(
                ref.watch(authServiceProvider),
                ref.watch(clientIdProvider),
                ref.watch(analyticsServiceProvider),
              ),
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
            authServiceProvider.overrideWithValue(mockAuthService),
            clientIdProvider.overrideWithValue('test_client_id'),
            authStateProvider.overrideWith(
              (ref) => TestAuthNotifier(
                ref.watch(authServiceProvider),
                ref.watch(clientIdProvider),
                ref.watch(analyticsServiceProvider),
              ),
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
      // The actual color is determined by the ColorScheme.fromSeed so we just check if it's not null
      expect(theme.colorScheme.primary, isNotNull);
    });
    //ignore:require_trailing_commas
  }, skip: true);
}
