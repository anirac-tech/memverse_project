import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:memverse/l10n/arb/app_localizations.dart';
import 'package:memverse/src/features/auth/data/fake_user_repository.dart';
import 'package:memverse/src/features/auth/domain/user_repository.dart';
import 'package:memverse/src/features/auth/presentation/signup_page.dart';

// Provider for user repository
final userRepositoryProvider = Provider<UserRepository>((ref) => FakeUserRepository());

void main() {
  group('SignupPage Widget Tests', () {
    testWidgets('should display signup form correctly', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [userRepositoryProvider.overrideWith((ref) => FakeUserRepository())],
          child: const MaterialApp(
            home: SignupPage(),
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: [Locale('en', '')],
          ),
        ),
      );

      // Verify form elements are displayed
      expect(find.text('Join the Memverse community'), findsOneWidget);
      expect(find.byKey(signupEmailFieldKey), findsOneWidget);
      expect(find.byKey(signupNameFieldKey), findsOneWidget);
      expect(find.byKey(signupPasswordFieldKey), findsOneWidget);
      expect(find.byKey(signupSubmitButtonKey), findsOneWidget);
      expect(find.text('Test Account'), findsOneWidget);
    });

    testWidgets('should show validation errors for empty fields', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [userRepositoryProvider.overrideWith((ref) => FakeUserRepository())],
          child: const MaterialApp(
            home: SignupPage(),
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: [Locale('en', '')],
          ),
        ),
      );

      // Tap submit button without filling fields
      await tester.tap(find.byKey(signupSubmitButtonKey));
      await tester.pumpAndSettle();

      // Verify validation errors
      expect(find.text('Please enter your email'), findsOneWidget);
      expect(find.text('Please enter your name'), findsOneWidget);
      expect(find.text('Please enter a password'), findsOneWidget);
    });

    testWidgets('should successfully signup with dummy email', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [userRepositoryProvider.overrideWith((ref) => FakeUserRepository())],
          child: const MaterialApp(
            home: SignupPage(),
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: [Locale('en', '')],
          ),
        ),
      );

      // Fill in dummy signup data
      await tester.enterText(find.byKey(signupEmailFieldKey), 'dummynewuser@dummy.com');
      await tester.enterText(find.byKey(signupNameFieldKey), 'Test User');
      await tester.enterText(find.byKey(signupPasswordFieldKey), 'test123');

      // Submit form
      await tester.tap(find.byKey(signupSubmitButtonKey));
      await tester.pump();

      // Verify loading state
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Wait for success screen (2 second delay)
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // Verify success screen
      expect(find.text('Welcome to Memverse!'), findsOneWidget);
      expect(find.text('Account created successfully for'), findsOneWidget);
      expect(find.textContaining('dummynewuser@dummy.com'), findsOneWidget);
    });

    testWidgets('should show error for invalid email', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [userRepositoryProvider.overrideWith((ref) => FakeUserRepository())],
          child: const MaterialApp(
            home: SignupPage(),
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: [Locale('en', '')],
          ),
        ),
      );

      // Fill in invalid email
      await tester.enterText(find.byKey(signupEmailFieldKey), 'invalid@test.com');
      await tester.enterText(find.byKey(signupNameFieldKey), 'Test User');
      await tester.enterText(find.byKey(signupPasswordFieldKey), 'test123');

      // Submit form
      await tester.tap(find.byKey(signupSubmitButtonKey));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Verify error message
      expect(find.text('Signup not yet implemented for real emails'), findsOneWidget);
    });
  });
}
