import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memverse/src/app/app.dart';
import 'package:memverse/src/features/auth/domain/auth_token.dart';
import 'package:memverse/src/features/auth/presentation/providers/auth_providers.dart';
import 'package:memverse/src/features/verse/presentation/memverse_page.dart';

// Create a test auth notifier class
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

/// Usage: the app is running with verses error
Future<void> theAppIsRunningWithVersesError(WidgetTester tester) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        verseListProvider.overrideWith((ref) => throw Exception('Verses error')),
        // Use a wrapper function for the notifier
        authStateProvider.overrideWith(
          (ref) => TestAuthNotifier(ref.watch(authServiceProvider), ref.watch(clientIdProvider)),
        ),
      ],
      child: const App(),
    ),
  );

  // Wait for the app to stabilize
  await tester.pumpAndSettle();
}
