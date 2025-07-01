import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:memverse/src/features/auth/data/fake_user_repository.dart';
import 'package:memverse/src/features/auth/presentation/login_page.dart';
import 'package:memverse/src/features/auth/presentation/signup_page.dart';

// Mock provider for user repository
final userRepositoryProvider = Provider((ref) => FakeUserRepository());

// Step definitions
Given r'the app is running with fake user repository' {
// This step sets up the fake repository
// Implementation handled in test setup
}

Given r'I am on the login screen' {
await tester.pumpWidget(
ProviderScope(
child: MaterialApp(
home: const LoginPage(),
routes: {
'/signup': (context) => const SignupPage(),
},
),
),
);
await tester.pumpAndSettle();
}

When r'I tap {string}' {
await tester.tap(find.text(text));
await tester.pumpAndSettle();
}

Then r'I should see the signup form' {
expect(find.text('Create Account'), findsOneWidget);
expect(find.text('Enter your email address'), findsOneWidget);
expect(find.text('Choose a username'), findsOneWidget);
expect(find.text('Create a password'), findsOneWidget);
}

When r'I enter {string} in the email field' {
await tester.enterText(
find.byKey(signupEmailFieldKey),
email,
);
await tester.pumpAndSettle();
}

When r'I enter {string} in the username field' {
await tester.enterText(
find.byKey(signupUsernameFieldKey),
username,
);
await tester.pumpAndSettle();
}

When r'I enter {string} in the password field' {
await tester.enterText(
find.byKey(signupPasswordFieldKey),
password,
);
await tester.pumpAndSettle();
}

Then r'I should see {string}' {
expect(find.text(text), findsOneWidget);
}