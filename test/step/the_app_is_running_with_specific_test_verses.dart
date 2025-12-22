import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memverse/src/app/app.dart';
import 'package:memverse/src/common/services/analytics_service.dart';
import 'package:memverse/src/features/auth/domain/auth_token.dart';
import 'package:memverse/src/features/auth/presentation/providers/auth_providers.dart';
import 'package:memverse/src/features/verse/data/verse_repository.dart';
import 'package:memverse/src/features/verse/domain/verse.dart';

// Create a test verse repository with specific verses for happy path testing
class HappyPathVerseRepository implements VerseRepository {
  @override
  Future<List<Verse>> getVerses() async {
    await Future<void>.delayed(const Duration(milliseconds: 100));

    return [
      // First verse for testing "Col 1:17" (correct answer)
      const Verse(
        text: 'He is before all things, and in him all things hold together.',
        reference: 'Colossians 1:17',
      ),
      // Second verse for testing "Gal 5:1" (almost correct answer)
      const Verse(
        text:
            'It is for freedom that Christ has set us free. Stand firm, then, and do not let yourselves be burdened again by a yoke of slavery.',
        reference: 'Galatians 5:1',
      ),
    ];
  }
}

// Create a test auth notifier class
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

Future<void> theAppIsRunningWithSpecificTestVerses(WidgetTester tester) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        verseRepositoryProvider.overrideWith((ref) => HappyPathVerseRepository()),
        // Use a wrapper function for the notifier
        authStateProvider.overrideWith(
          (ref) => TestAuthNotifier(
            ref.watch(authServiceProvider),
            ref.watch(clientIdProvider),
            ref.watch(analyticsServiceProvider),
          ),
        ),
        // Override isLoggedInProvider to return true immediately for logged-in scenarios
        isLoggedInProvider.overrideWith((ref) => Future.value(true)),
      ],
      child: const App(),
    ),
  );

  // Wait for the app to stabilize and for async operations to complete
  await tester.pumpAndSettle(const Duration(milliseconds: 300));
}
