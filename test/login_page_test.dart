import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memverse/l10n/arb/app_localizations.dart';
import 'package:memverse/src/features/auth/data/auth_service.dart';
import 'package:memverse/src/features/auth/domain/auth_token.dart';
import 'package:memverse/src/features/auth/presentation/login_page.dart';
import 'package:memverse/src/features/auth/presentation/providers/auth_providers.dart';
import 'package:mocktail/mocktail.dart';
import 'package:patrol_finders/patrol_finders.dart';

// Mock AuthService
class MockAuthService extends Mock implements AuthService {}

// Correctly mock AuthNotifier
class MockAuthNotifier extends StateNotifier<AuthState> with Mock implements AuthNotifier {
  MockAuthNotifier(super.initialState);

  @override
  Future<void> login(String username, String password) async {
    return super.noSuchMethod(Invocation.method(#login, [username, password]));
  }

  @override
  Future<void> logout() async {
    return super.noSuchMethod(Invocation.method(#logout, []));
  }
}

void main() {
  setUpAll(() {
    registerFallbackValue(const AuthState()); // Use const
    registerFallbackValue(MockAuthService());
  });

  late MockAuthNotifier mockAuthNotifier;

  const authStateInitial = AuthState();
  const authStateError = AuthState(error: 'Test Error');
  final testToken = AuthToken(
    accessToken: 'test_token',
    tokenType: 'Bearer',
    scope: 'public',
    createdAt: DateTime(2023).millisecondsSinceEpoch ~/ 1000,
  );
  final authStateSuccess = AuthState(isAuthenticated: true, token: testToken);

  setUp(() {
    mockAuthNotifier = MockAuthNotifier(authStateInitial);
    when(() => mockAuthNotifier.login(any(), any())).thenAnswer((_) async {});
    when(() => mockAuthNotifier.logout()).thenAnswer((_) async {});
  });

  // Helper function to pump the LoginPage using PatrolTester
  Future<AppLocalizations> pumpLoginPage(
    PatrolTester $, { // Use PatrolTester
    required AuthState authState,
  }) async {
    mockAuthNotifier = MockAuthNotifier(authState);
    when(() => mockAuthNotifier.login(any(), any())).thenAnswer((_) async {});
    when(() => mockAuthNotifier.logout()).thenAnswer((_) async {});

    const testLocale = Locale('en');

    await $.pumpWidget(
      // Use $.pumpWidget
      ProviderScope(
        overrides: [authStateProvider.overrideWith((ref) => mockAuthNotifier)],
        child: const MaterialApp(
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          locale: testLocale,
          home: LoginPage(),
        ),
      ),
    );
    await $.pumpAndSettle(); // Use $.pumpAndSettle

    // Load AppLocalizations using the delegate
    final l10n = await AppLocalizations.delegate.load(testLocale);
    return l10n;
  }

  // --- Test Cases using patrolWidgetTest ---

  patrolWidgetTest('LoginPage renders correctly in initial state', ($) async {
    final l10n = await pumpLoginPage($, authState: authStateInitial);
    await $.pumpAndSettle();
    expect($('Memverse Login').exists, isTrue);
    expect($('Welcome to Memverse').exists, isTrue);
    expect($('Sign in to continue').exists, isTrue);
    expect($(TextFormField).containing(l10n.username).exists, isTrue);
    expect($(TextFormField).containing(l10n.password).exists, isTrue);
    expect($(ElevatedButton).containing(l10n.login).exists, isTrue);
    expect($(Icons.visibility_off).exists, isTrue);
    expect($(CircularProgressIndicator).exists, isFalse);
    expect($('Test Error').exists, isFalse);
  });

  /* // Skipping fallback icon test as requested
  patrolWidgetTest('Shows fallback icon when image fails to load', ($) async {
    await pumpLoginPage($, authState: authStateInitial);
    await $.pumpAndSettle();
    expect($(Icons.menu_book).exists, isTrue);

    // Use $(Type).which() with null-aware checks
    final errorBuilderText = $(Text).which(
      (widget) =>
          widget.data == 'Memverse' &&
          widget.style?.color == Colors.white && // Null-aware access
          widget.style?.fontWeight == FontWeight.bold, // Null-aware access
    );
    final gradientContainerFinder = $(Container).which(
      // Safe cast and null check for decoration
      (widget) => ((widget as Container?)?.decoration as BoxDecoration?)?.gradient is LinearGradient,
    );
    expect(gradientContainerFinder.containing(errorBuilderText).exists, isTrue);
  });
  */

  patrolWidgetTest('Username and Password validation works', ($) async {
    final l10n = await pumpLoginPage($, authState: authStateInitial);
    final loginButton = $(ElevatedButton).containing(l10n.login);
    final usernameField = $(TextFormField).containing(l10n.username);
    final passwordField = $(TextFormField).containing(l10n.password);

    await $.pumpAndSettle();
    await loginButton.tap();
    await $.pump();
    expect($(l10n.pleaseEnterYourUsername).exists, isTrue);
    expect($(l10n.pleaseEnterYourPassword).exists, isTrue);

    await usernameField.enterText('user');
    await loginButton.tap();
    await $.pump();
    expect($(l10n.pleaseEnterYourUsername).exists, isFalse);
    expect($(l10n.pleaseEnterYourPassword).exists, isTrue);

    await usernameField.enterText('');
    await passwordField.enterText('pass');
    await loginButton.tap();
    await $.pump();
    expect($(l10n.pleaseEnterYourUsername).exists, isTrue);
    expect($(l10n.pleaseEnterYourPassword).exists, isFalse);
  });

  patrolWidgetTest('Password visibility toggle works', ($) async {
    final l10n = await pumpLoginPage($, authState: authStateInitial);
    final passwordTextFormFieldFinder = $(TextFormField).containing(l10n.password);
    final visibilityOffIcon = $(Icons.visibility_off);
    final visibilityOnIcon = $(Icons.visibility);

    await $.pumpAndSettle();

    // Helper to check obscureText on the inner EditableText
    bool isObscured(PatrolFinder textFormFieldFinder) {
      final editableTextFinder = textFormFieldFinder.$(EditableText);
      expect(editableTextFinder.exists, isTrue);
      return $.tester.widget<EditableText>(editableTextFinder.finder).obscureText;
    }

    expect(isObscured(passwordTextFormFieldFinder), isTrue);
    await visibilityOffIcon.tap();
    await $.pump();
    expect(isObscured(passwordTextFormFieldFinder), isFalse);
    // Use await finder.waitUntilVisible()
    await visibilityOnIcon.waitUntilVisible();
    expect(visibilityOffIcon.exists, isFalse); // Check if off icon is gone

    await visibilityOnIcon.tap();
    await $.pump();
    expect(isObscured(passwordTextFormFieldFinder), isTrue);
    // Use await finder.waitUntilVisible()
    await visibilityOffIcon.waitUntilVisible();
    expect(visibilityOnIcon.exists, isFalse); // Check if on icon is gone
  });

  patrolWidgetTest('Shows error message when auth state has error', ($) async {
    final l10n = await pumpLoginPage($, authState: authStateError);
    await $.pumpAndSettle();
    expect($('Test Error').exists, isTrue);
    final loginButtonFinder = $(ElevatedButton).containing(l10n.login);
    expect(loginButtonFinder.exists, isTrue);
    // Check enabled property via tester.widget
    expect($.tester.widget<ElevatedButton>(loginButtonFinder.finder).enabled, isTrue);
    expect($(CircularProgressIndicator).exists, isFalse);
  });

  patrolWidgetTest('Calls login method on notifier when form is valid and button tapped', (
    $,
  ) async {
    final l10n = await pumpLoginPage($, authState: authStateInitial);
    await $.pumpAndSettle();
    const testUsername = 'testuser';
    const testPassword = 'password123';

    await $(TextFormField).containing(l10n.username).enterText(testUsername);
    await $(TextFormField).containing(l10n.password).enterText(testPassword);
    await $(ElevatedButton).containing(l10n.login).tap();
    await $.pumpAndSettle();

    verify(() => mockAuthNotifier.login(testUsername, testPassword)).called(1);
  });

  patrolWidgetTest('UI reflects successful authentication state', ($) async {
    final l10n = await pumpLoginPage($, authState: authStateSuccess);
    await $.pumpAndSettle();

    expect($(ElevatedButton).containing(l10n.login).exists, isTrue);
    expect($('Test Error').exists, isFalse);
    expect($('Memverse Login').exists, isTrue);
  });
}
