import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:memverse/src/features/auth/presentation/signup_page.dart';

import 'util/test_app_wrapper.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('User Signup Feature', () {
    // Define steps
    Future<void> givenIAmOnTheSignupPage(WidgetTester tester) async {
      await tester.pumpWidget(buildTestApp(home: const SignupPage()));
      await tester.pumpAndSettle();
      expect(find.text('Create Account'), findsOneWidget);
      expect(find.text('Join the Memverse community'), findsOneWidget);
    }

    Future<void> whenIEnterAsEmail(WidgetTester tester, String email) async {
      await tester.enterText(find.byKey(const ValueKey('signup_email_field')), email);
      await tester.pump();
    }

    Future<void> whenIEnterAsName(WidgetTester tester, String name) async {
      await tester.enterText(find.byKey(const ValueKey('signup_name_field')), name);
      await tester.pump();
    }

    Future<void> whenIEnterAsPassword(WidgetTester tester, String password) async {
      await tester.enterText(find.byKey(const ValueKey('signup_password_field')), password);
      await tester.pump();
    }

    Future<void> whenITapTheCreateAccountButton(WidgetTester tester) async {
      await tester.tap(find.byKey(const ValueKey('signup_submit_button')));
      await tester.pump();
    }

    Future<void> thenIShouldSeeTheWelcomeMessage(WidgetTester tester) async {
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();
      expect(find.text('Welcome to Memverse!'), findsOneWidget);
    }

    Future<void> thenIShouldSeeMyEmailDisplayed(WidgetTester tester, String email) async {
      expect(find.text('Account created successfully for'), findsOneWidget);
      expect(find.textContaining(email), findsOneWidget);
    }

    Future<void> thenIShouldBeRedirectedToTheMainApp(WidgetTester tester) async {
      expect(find.text('Redirecting to app...'), findsOneWidget);
    }

    Future<void> thenIShouldSeeError(WidgetTester tester, String errorText) async {
      expect(find.text(errorText), findsOneWidget);
    }

    Future<void> thenIShouldSeeAnOrangeErrorMessage(WidgetTester tester) async {
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      expect(find.text('Signup not yet implemented for real emails'), findsOneWidget);

      final snackBarFinder = find.byType(SnackBar);
      expect(snackBarFinder, findsOneWidget);
      final snackBar = tester.widget<SnackBar>(snackBarFinder);
      expect(snackBar.backgroundColor, Colors.orange);
    }

    // Scenario 1: Successful signup with dummy credentials
    testWidgets('Successful signup with dummy credentials', (tester) async {
      await givenIAmOnTheSignupPage(tester);
      await whenIEnterAsEmail(tester, 'dummynewuser@dummy.com');
      await whenIEnterAsName(tester, 'Test User');
      await whenIEnterAsPassword(tester, 'password123');
      await whenITapTheCreateAccountButton(tester);
      await thenIShouldSeeTheWelcomeMessage(tester);
      await thenIShouldSeeMyEmailDisplayed(tester, 'dummynewuser@dummy.com');
      await thenIShouldBeRedirectedToTheMainApp(tester);
    });

    // Scenario 2: Form validation for empty fields
    testWidgets('Form validation for empty fields', (tester) async {
      await givenIAmOnTheSignupPage(tester);
      await whenITapTheCreateAccountButton(tester);
      await thenIShouldSeeError(tester, 'Please enter your email');
      await thenIShouldSeeError(tester, 'Please enter your name');
      await thenIShouldSeeError(tester, 'Please enter a password');
    });

    // Scenario 3: Form validation for invalid email
    testWidgets('Form validation for invalid email', (tester) async {
      await givenIAmOnTheSignupPage(tester);
      await whenIEnterAsEmail(tester, 'invalid-email');
      await whenITapTheCreateAccountButton(tester);
      await thenIShouldSeeError(tester, 'Please enter a valid email');
    });

    // Scenario 4: Form validation for short password
    testWidgets('Form validation for short password', (tester) async {
      await givenIAmOnTheSignupPage(tester);
      await whenIEnterAsEmail(tester, 'dummynewuser@dummy.com');
      await whenIEnterAsName(tester, 'Test User');
      await whenIEnterAsPassword(tester, 'short');
      await whenITapTheCreateAccountButton(tester);
      await thenIShouldSeeError(tester, 'Password must be at least 6 characters');
    });

    // Scenario 5: Error message for non-dummy email
    testWidgets('Error message for non-dummy email', (tester) async {
      await givenIAmOnTheSignupPage(tester);
      await whenIEnterAsEmail(tester, 'real@example.com');
      await whenIEnterAsName(tester, 'Test User');
      await whenIEnterAsPassword(tester, 'password123');
      await whenITapTheCreateAccountButton(tester);
      await thenIShouldSeeAnOrangeErrorMessage(tester);
    });
  });
}
