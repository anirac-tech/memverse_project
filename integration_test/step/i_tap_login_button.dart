import 'package:flutter_test/flutter_test.dart';
import 'package:memverse/src/features/auth/presentation/login_page.dart';

/// Usage: I tap login button
Future<void> iTapLoginButton(WidgetTester tester) async {
  // Wait for the page to be ready
  await tester.pumpAndSettle();

  // Find and tap the login button
  final loginButton = find.byKey(loginButtonKey);
  expect(loginButton, findsOneWidget);

  await tester.tap(loginButton);

  // Pump to register the tap
  await tester.pump();
}
