import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart' as integration;
import 'package:integration_test/integration_test.dart';
import 'package:memverse/main_development.dart' as app;
import 'package:memverse/src/features/auth/presentation/providers/auth_providers.dart';

/// Live login test that makes actual network calls to authenticate
/// Run with:
/// flutter test integration_test/live_login_test.dart --flavor development \
///   --dart-define=USERNAME=$MEMVERSE_USERNAME \
///   --dart-define=PASSWORD=$MEMVERSE_PASSWORD \
///   --dart-define=CLIENT_ID=$MEMVERSE_CLIENT_ID
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  final binding = IntegrationTestWidgetsFlutterBinding.instance;

  group('Live Login Flow Test', () {
    // Get credentials from environment variables passed via --dart-define
    const username = String.fromEnvironment('USERNAME');
    const password = String.fromEnvironment('PASSWORD');
    const clientId = String.fromEnvironment('CLIENT_ID');

    testWidgets('Login with real credentials and verify token is received', (
      WidgetTester tester,
    ) async {
      // Verify that all required credentials are provided
      if (username.isEmpty) {
        fail(
          'USERNAME environment variable must be set. Please run this test with:\n'
          'flutter test integration_test/live_login_test.dart --dart-define=USERNAME=xxx',
        );
      }

      if (password.isEmpty) {
        fail(
          'PASSWORD environment variable must be set. Please run this test with:\n'
          'flutter test integration_test/live_login_test.dart --dart-define=PASSWORD=xxx',
        );
      }

      if (clientId.isEmpty) {
        fail(
          'CLIENT_ID environment variable must be set. Please run this test with:\n'
          'flutter test integration_test/live_login_test.dart --dart-define=CLIENT_ID=xxx',
        );
      }

      // Log the username being used (not private information)
      debugPrint(
        'Running test with username: $username and client ID is non-empty: ${clientId.isNotEmpty}',
      );

      // Launch the app
      app.main();
      await tester.pumpAndSettle();

      // Find login form elements
      final usernameField = find.byType(TextFormField).first;
      final passwordField = find.byType(TextFormField).at(1);
      final loginButton = find.widgetWithText(ElevatedButton, 'Login');

      // Verify login page is loaded
      expect(find.text('Memverse Login'), findsOneWidget);
      expect(usernameField, findsOneWidget);
      expect(passwordField, findsOneWidget);
      expect(loginButton, findsOneWidget);

      // Take a screenshot before login
      await _takeScreenshot(binding, 'before_login');

      // Enter credentials
      await tester.enterText(usernameField, username);
      await tester.enterText(passwordField, password);
      await tester.pumpAndSettle();

      // Tap login button
      await tester.tap(loginButton);

      // Wait for login process
      await tester.pump(); // Start animations

      // Authentication can take some time - use extended timeout
      var authenticated = false;
      var attempts = 0;
      const maxAttempts = 30; // 15 seconds total

      while (!authenticated && attempts < maxAttempts) {
        await tester.pump(const Duration(milliseconds: 500));
        authenticated = _isAuthenticated(tester);
        attempts++;
      }

      // Take a screenshot after login attempt
      await _takeScreenshot(binding, 'after_login');

      // Verify authentication was successful
      expect(
        authenticated,
        isTrue,
        reason:
            'Failed to authenticate after ${maxAttempts * 0.5} seconds. '
            'Please check your credentials and network connection.',
      );

      // Verify token was received by checking access token provider
      final providerContainer = _getProviderContainer(tester);
      if (providerContainer != null) {
        final accessToken = providerContainer.read(accessTokenProvider);
        expect(
          accessToken,
          isNotEmpty,
          reason: 'Access token should not be empty after successful login',
        );

        // Also verify user ID if available in the token
        final authState = providerContainer.read(authStateProvider);
        if (authState.token?.userId != null) {
          debugPrint('Successfully authenticated for user ID: ${authState.token?.userId}');
        }

        // Log success
        debugPrint('✓ Successfully authenticated and received a token');
      }
    });
  });
}

/// Helper to check if authentication state shows as authenticated
bool _isAuthenticated(WidgetTester tester) {
  final providerContainer = _getProviderContainer(tester);
  if (providerContainer == null) return false;

  final authState = providerContainer.read(authStateProvider);
  return authState.isAuthenticated && !authState.isLoading;
}

/// Helper to get the ProviderContainer from the widget tree
ProviderContainer? _getProviderContainer(WidgetTester tester) {
  try {
    final element = tester.element(find.byType(ProviderScope));
    return ProviderScope.containerOf(element);
  } catch (e) {
    // If we can't find the container, return null
    return null;
  }
}

/// Take screenshot using the IntegrationTestWidgetsFlutterBinding
Future<void> _takeScreenshot(
  integration.IntegrationTestWidgetsFlutterBinding binding,
  String name,
) async {
  try {
    await binding.takeScreenshot(name);
    debugPrint('Screenshot taken: $name');
  } catch (e) {
    debugPrint('Could not take screenshot: $e');
  }
}
