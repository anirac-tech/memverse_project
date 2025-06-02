import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> iEnterUsername(WidgetTester tester, String username) async {
  final usernameField = find.byKey(const ValueKey('login_username_field'));
  expect(usernameField, findsOneWidget);

  await tester.enterText(usernameField, username);
  await tester.pumpAndSettle();
}

Future<void> iEnterPassword(WidgetTester tester, String password) async {
  final passwordField = find.byKey(const ValueKey('login_password_field'));
  expect(passwordField, findsOneWidget);

  await tester.enterText(passwordField, password);
  await tester.pumpAndSettle();
}

Future<void> iTapTheLoginButton(WidgetTester tester) async {
  final loginButton = find.byKey(const ValueKey('login_button'));
  expect(loginButton, findsOneWidget);

  await tester.tap(loginButton);
  await tester.pumpAndSettle();
}

Future<void> iEnterTheReference(WidgetTester tester, String reference) async {
  // Find the text field for verse reference input
  final referenceField = find.byType(TextField).last; // Get the reference input field
  expect(referenceField, findsOneWidget);

  await tester.enterText(referenceField, reference);
  await tester.pumpAndSettle();
}

Future<void> iTapTheSubmitButton(WidgetTester tester) async {
  final submitButton = find.byKey(const Key('submit-ref'));
  expect(submitButton, findsOneWidget);

  await tester.tap(submitButton);
  await tester.pumpAndSettle();
}

Future<void> iWaitForTheNextVerseToLoad(WidgetTester tester) async {
  // Wait for the automatic progression to next verse
  await tester.pump(const Duration(milliseconds: 1500));
  await tester.pumpAndSettle();
}

Future<void> iAnswerTheFirstVerseCorrectlyWith(WidgetTester tester, String reference) async {
  await iEnterTheReference(tester, reference);
  await iTapTheSubmitButton(tester);
}

Future<void> iAnswerTheSecondVerseWith(WidgetTester tester, String reference) async {
  await iEnterTheReference(tester, reference);
  await iTapTheSubmitButton(tester);
}
