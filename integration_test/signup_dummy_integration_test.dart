import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:integration_test/integration_test.dart';
import 'package:memverse/src/features/auth/data/fake_user_repository.dart';
import 'package:memverse/src/features/auth/domain/user_repository.dart';
import 'package:memverse/src/features/auth/presentation/login_page.dart';
import 'package:memverse/src/features/auth/presentation/signup_page.dart';

// Provider for user repository
final userRepositoryProvider = Provider<UserRepository>((ref) => FakeUserRepository());

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Dummy Signup Integration Tests', () {
    testWidgets('should complete full signup flow with dummy data', (tester) async {
      // Start app with fake repository
      await tester.pumpWidget(
        ProviderScope(
          overrides: [userRepositoryProvider.overrideWith((ref) => FakeUserRepository())],
          child: MaterialApp(
            home: const LoginPage(),
            routes: {'/signup': (context) => const SignupPage()},
          ),
        ),
      );

      // Verify login screen
      expect(find.text('Welcome to Memverse'), findsOneWidget);
      expect(find.text('Sign Up'), findsOneWidget);

      // Navigate to signup
      await tester.tap(find.text('Sign Up'));
      await tester.pumpAndSettle();

      // Verify signup screen
      expect(find.text('Create Account'), findsOneWidget);
      expect(find.text('Join the Memverse community'), findsOneWidget);

      // Fill out signup form
      await tester.enterText(find.byKey(signupEmailFieldKey), 'dummynewuser@dummy.com');
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(signupUsernameFieldKey), 'dummyuser');
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(signupPasswordFieldKey), 'test123');
      await tester.pumpAndSettle();

      // Submit signup
      await tester.tap(find.byKey(signupSubmitButtonKey));
      await tester.pump();

      // Verify loading state
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Wait for success screen
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Verify success screen
      expect(find.text('Welcome to Memverse!'), findsOneWidget);
      expect(find.text('Account created successfully'), findsOneWidget);
      expect(find.text('dummynewuser@dummy.com'), findsOneWidget);

      // Wait for redirect (if implemented)
      await tester.pumpAndSettle(const Duration(seconds: 3));
    });

    testWidgets('should handle invalid email gracefully', (tester) async {
      // Start app with fake repository
      await tester.pumpWidget(
        ProviderScope(
          overrides: [userRepositoryProvider.overrideWith((ref) => FakeUserRepository())],
          child: MaterialApp(
            home: const LoginPage(),
            routes: {'/signup': (context) => const SignupPage()},
          ),
        ),
      );

      // Navigate to signup
      await tester.tap(find.text('Sign Up'));
      await tester.pumpAndSettle();

      // Fill out signup form with invalid email
      await tester.enterText(find.byKey(signupEmailFieldKey), 'invalid@test.com');
      await tester.enterText(find.byKey(signupUsernameFieldKey), 'testuser');
      await tester.enterText(find.byKey(signupPasswordFieldKey), 'test123');

      // Submit signup
      await tester.tap(find.byKey(signupSubmitButtonKey));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Verify error handling
      expect(find.text('Signup not yet implemented for real emails'), findsOneWidget);
    });

    testWidgets('should validate form fields', (tester) async {
      // Start app with fake repository
      await tester.pumpWidget(
        ProviderScope(
          overrides: [userRepositoryProvider.overrideWith((ref) => FakeUserRepository())],
          child: MaterialApp(
            home: const LoginPage(),
            routes: {'/signup': (context) => const SignupPage()},
          ),
        ),
      );

      // Navigate to signup
      await tester.tap(find.text('Sign Up'));
      await tester.pumpAndSettle();

      // Try to submit empty form
      await tester.tap(find.byKey(signupSubmitButtonKey));
      await tester.pumpAndSettle();

      // Verify validation errors
      expect(find.text('Please enter your email'), findsOneWidget);
      expect(find.text('Please enter a username'), findsOneWidget);
      expect(find.text('Please enter a password'), findsOneWidget);
    });
  });
}
