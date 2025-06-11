import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memverse/src/app/app.dart';
import 'package:memverse/src/common/services/analytics_service.dart';
import 'package:memverse/src/features/auth/presentation/providers/auth_providers.dart';
import 'package:memverse/src/features/verse/data/verse_repository.dart';

// Create a test auth notifier class
class TestAuthNotifier extends AuthNotifier {
  TestAuthNotifier(super.authService, super.clientId, super.analyticsService) {
    state = const AuthState();
  }
}

Future<void> theAppIsRunning(WidgetTester tester) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        verseRepositoryProvider.overrideWith((ref) => FakeVerseRepository()),
        // Override analytics service with logging service for testing
        analyticsServiceProvider.overrideWith((ref) => LoggingAnalyticsService()),
        // Use a wrapper function for the notifier
        authStateProvider.overrideWith(
          (ref) => TestAuthNotifier(
            ref.watch(authServiceProvider),
            ref.watch(clientIdProvider),
            ref.watch(analyticsServiceProvider),
          ),
        ),
      ],
      child: const App(),
    ),
  );

  // Wait for the app to stabilize and for async operations to complete
  await tester.pumpAndSettle(const Duration(milliseconds: 300));
}
