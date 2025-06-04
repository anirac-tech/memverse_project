import 'package:flutter_test/flutter_test.dart';
import 'package:memverse/src/features/auth/presentation/login_page.dart';

/// Usage: I see login page
Future<void> iSeeLoginPage(WidgetTester tester) async {
  // Wait for the page to load
  await tester.pumpAndSettle();

  // Verify the login page is displayed
  expect(find.byType(LoginPage), findsOneWidget);

  // Verify key login elements are present
  expect(find.byKey(loginUsernameFieldKey), findsOneWidget);
  expect(find.byKey(loginPasswordFieldKey), findsOneWidget);
  expect(find.byKey(loginButtonKey), findsOneWidget);

  // Verify login-specific text
  expect(find.text('Welcome to Memverse'), findsOneWidget);
  expect(find.text('Sign in to continue'), findsOneWidget);
}
