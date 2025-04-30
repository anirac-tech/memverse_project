import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:memverse/l10n/arb/app_localizations.dart';
import 'package:memverse/src/features/auth/data/auth_service.dart';
import 'package:memverse/src/features/auth/domain/auth_token.dart';
import 'package:memverse/src/features/auth/presentation/login_page.dart';
import 'package:memverse/src/features/auth/presentation/providers/auth_providers.dart';
import 'package:mocktail/mocktail.dart';

// Mocks
class MockAuthService extends Mock implements AuthService {}

// Mock AuthToken for return values
final mockAuthToken = AuthToken(
  accessToken: 'mock_access_token',
  tokenType: 'Bearer',
  scope: 'read write',
  createdAt: DateTime.now().millisecondsSinceEpoch ~/ 1000,
  userId: 1,
);

// Mock Notifier - Now extends AuthNotifier
class MockAuthNotifier extends AuthNotifier {
  // Constructor receives the pre-mocked service and passes it to super
  MockAuthNotifier(this.passedInMockService) : super(passedInMockService, _mockClientId);

  // Store the service passed in
  final MockAuthService passedInMockService;
  static const String _mockClientId = 'mock_client_id';

  // Override _init to prevent real logic / use mock if needed
  @override
  Future<void> _init() async {
    // Bypass entirely
    state = const AuthState();
    return Future.value();
  }

  // login/logout in AuthNotifier already use _authService (which is passedInMockService)
  // Overrides are only needed if we want to change behavior specifically for the test mock.

  // Add getter for verification
  MockAuthService get serviceForVerification => passedInMockService;
}

// Helper function to pump widget with providers
Widget createLoginPage(MockAuthNotifier mockNotifier) {
  return ProviderScope(
    overrides: [
      authStateProvider.overrideWith((ref) => mockNotifier),
      // We MUST override authServiceProvider to use the SAME mock instance
      authServiceProvider.overrideWithValue(mockNotifier.serviceForVerification),
      clientIdProvider.overrideWithValue(MockAuthNotifier._mockClientId),
    ],
    child: MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: HookBuilder(
        builder: (context) {
          // No need to call mock _init here anymore, constructor handles it.
          return const LoginPage();
        },
      ),
    ),
  );
}

void main() {
  // Use late finals for mocks
  late MockAuthService setUpMockService;
  late MockAuthNotifier mockAuthNotifier;

  setUpAll(() {
    // Register fallback values for mocktail
    registerFallbackValue(const AuthState());
    registerFallbackValue(mockAuthToken);
  });

  setUp(() {
    // 1. Create and mock the service *before* creating the notifier
    setUpMockService = MockAuthService();
    when(() => setUpMockService.isLoggedIn()).thenAnswer((_) async => false);
    when(() => setUpMockService.getToken()).thenAnswer((_) async => null);
    when(() => setUpMockService.login(any(), any(), any())).thenAnswer((_) async => mockAuthToken);
    when(() => setUpMockService.logout()).thenAnswer((_) async {});

    // 2. Create the notifier, passing the pre-mocked service
    mockAuthNotifier = MockAuthNotifier(setUpMockService);
  });

  group('LoginPage Keyboard Interaction Tests', () {
    testWidgets('Pressing "Next" on username field focuses password field', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createLoginPage(mockAuthNotifier));
      await tester.pumpAndSettle(); // Allow potential effects/state changes

      final usernameField = find.byKey(loginUsernameFieldKey);
      final passwordField = find.byKey(loginPasswordFieldKey);

      await tester.tap(usernameField);
      await tester.pumpAndSettle();
      await tester.enterText(usernameField, 'testuser');
      await tester.pump();

      await tester.testTextInput.receiveAction(TextInputAction.next);
      await tester.pumpAndSettle();

      // Verify focus by comparing FocusNodes
      final passwordEditableTextFinder = find.descendant(
        of: passwordField,
        matching: find.byType(EditableText),
      );
      final editableTextWidget = tester.widget<EditableText>(passwordEditableTextFinder);
      expect(
        tester.binding.focusManager.primaryFocus,
        editableTextWidget.focusNode,
        reason: 'Password field should be focused after pressing Next',
      );
    });

    testWidgets('Pressing "Go" on password field triggers login when form is valid', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createLoginPage(mockAuthNotifier));
      await tester.pumpAndSettle();

      final usernameField = find.byKey(loginUsernameFieldKey);
      final passwordField = find.byKey(loginPasswordFieldKey);

      await tester.enterText(usernameField, 'testuser');
      await tester.enterText(passwordField, 'password123');
      await tester.pump();

      await tester.tap(passwordField);
      await tester.pumpAndSettle();

      await tester.testTextInput.receiveAction(TextInputAction.go);
      await tester.pumpAndSettle();

      // 3. Verify using the exposed service instance
      verify(
        () => mockAuthNotifier.serviceForVerification.login(
          'testuser',
          'password123',
          MockAuthNotifier._mockClientId,
        ),
      ).called(1);
    });

    testWidgets(
      'Pressing "Go" on password field does not trigger login when form is invalid (e.g., empty password)',
      (WidgetTester tester) async {
        await tester.pumpWidget(createLoginPage(mockAuthNotifier));
        await tester.pumpAndSettle();

        final usernameField = find.byKey(loginUsernameFieldKey);
        final passwordField = find.byKey(loginPasswordFieldKey);

        await tester.enterText(usernameField, 'testuser');
        await tester.enterText(passwordField, '');
        await tester.pump();

        await tester.tap(passwordField);
        await tester.pumpAndSettle();

        await tester.testTextInput.receiveAction(TextInputAction.go);
        await tester.pumpAndSettle();

        // 4. Verify using the exposed service instance
        verifyNever(() => mockAuthNotifier.serviceForVerification.login(any(), any(), any()));

        final BuildContext context = tester.element(find.byType(LoginPage));
        final l10n = AppLocalizations.of(context);
        expect(find.text(l10n.pleaseEnterYourPassword), findsOneWidget);
      },
    );

    testWidgets(
      'Pressing "Go" on password field does not trigger login when form is invalid (e.g., empty username)',
      (WidgetTester tester) async {
        await tester.pumpWidget(createLoginPage(mockAuthNotifier));
        await tester.pumpAndSettle();

        final usernameField = find.byKey(loginUsernameFieldKey);
        final passwordField = find.byKey(loginPasswordFieldKey);

        await tester.enterText(usernameField, '');
        await tester.enterText(passwordField, 'password123');
        await tester.pump();

        await tester.tap(passwordField);
        await tester.pumpAndSettle();
        await tester.testTextInput.receiveAction(TextInputAction.go);
        await tester.pumpAndSettle();

        // 5. Verify using the exposed service instance
        verifyNever(() => mockAuthNotifier.serviceForVerification.login(any(), any(), any()));

        final BuildContext context = tester.element(find.byType(LoginPage));
        final l10n = AppLocalizations.of(context);
        expect(find.text(l10n.pleaseEnterYourUsername), findsOneWidget);
      },
    );
  });
}
