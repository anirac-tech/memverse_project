// Command to run this test (replace <deviceId> if needed, e.g., emulator-5554):
// patrol test --target integration_test/app_integration_test.dart --flavor development --dart-define=PATROL_TEST=true -d <deviceId>
// (Ensure the `--flavor` matches the one you intend to test, e.g., development)
//
// Prerequisites:
// 1. Ensure Patrol CLI is installed (https://patrol.leancode.co/getting-started)
// 2. Ensure `patrol` (dev_dependencies) is in pubspec.yaml. Run `flutter pub get`.
// 3. An Android emulator or device is running and connected (`adb devices`). Make sure it's unlocked.
//
// What to look for:
// - The test should launch the Memverse app (development flavor) on the specified device.
// - If the app starts on a screen with 'Logout' text, it taps 'Logout'.
// - It navigates to the login screen (verifies 'Memverse Login' text).
// - Enters 'testuser'/'password' into the text fields.
// - Toggles the password visibility icon.
// - Taps the 'Login' button.
// - Test completes successfully in the console.
//
// Note: This test still uses native interaction for potential logout/login.

import 'dart:developer' as dev;
import 'dart:io'; // Import dart:io for Platform check

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memverse/main_development.dart' as app;
import 'package:patrol/patrol.dart';

void main() {
  // Using the standard patrolTest signature: description, callback, {timeout, tags}
  // nativeAutomation is enabled via the CLI command (`patrol test --target ...`)
  // Assuming default settle behavior (like andSettle: true) based on patrol version.

  patrolTest(
    'Complete app flow: Logout (if needed), Login', // Updated description
    (PatrolIntegrationTester $) async {
      app.main();
      await $.pumpAndSettle();

      // Runtime check to ensure this test only runs on Android
      if (!Platform.isAndroid) {
        dev.log('Skipping test: Android only');
        return; // Skip test if not on Android
      }

      // App launched automatically by Patrol.
      // Initial wait.

      // --- Check if already logged in and logout if necessary ---
      final logoutFinder = $('Logout');
      if (logoutFinder.exists) {
        dev.log('Already logged in, attempting to log out...');
        await $.tap(logoutFinder);
        // Explicit wait after logout action.
        await $.pump(const Duration(seconds: 3));
        await $.pumpAndSettle();
        dev.log('Logged out.');
      } else {
        dev.log('Not logged in or Logout text not found, proceeding...');
        // Ensure settled state before proceeding.
        await $.pumpAndSettle();
      }

      // --- Login Screen ---
      expect($('Memverse Login'), findsOneWidget, reason: 'Should be on Login screen');
      expect($('Welcome to Memverse'), findsOneWidget, reason: 'Welcome text should be visible');

      final usernameField = $(TextField).at(0);
      final passwordField = $(TextField).at(1);
      final loginButton = $(ElevatedButton).containing(const Text('Login'));

      await $.enterText(usernameField, const String.fromEnvironment('USERNAME'));
      await $.pumpAndSettle(); // Explicit settle after text entry
      await $.enterText(passwordField, const String.fromEnvironment('PASSWORD'));
      await $.pumpAndSettle(); // Explicit settle after text entry
      final visibilityToggleOff = $(Icons.visibility_off);
      expect(
        visibilityToggleOff.exists,
        isTrue,
        reason: 'Password visibility_off icon should exist initially',
      );

      await $.tap(visibilityToggleOff);
      await $.pumpAndSettle(); // Explicit settle after tap

      final visibilityToggleOn = $(Icons.visibility);
      expect(
        visibilityToggleOn.exists,
        isTrue,
        reason: 'Password visibility icon should exist after tap',
      );
      expect(
        visibilityToggleOff.exists,
        isFalse,
        reason: 'Password visibility_off icon should not exist after tap',
      );

      await $.tap(loginButton);
      // Explicit longer wait after login for potential network calls/navigation.
      await $.pump(const Duration(seconds: 5));
      await $.pumpAndSettle();

      // --- Post-Login / End of Flow ---
      // Add checks here to verify successful login if needed.
      // Example: expect($('Welcome testuser'), findsOneWidget);
      dev.log('Login flow complete.');

      // --- Screenshot and Share REMOVED ---
    },
    // Named arguments AFTER the callback
    timeout: const Timeout(Duration(minutes: 5)),
    tags: const ['integration', 'android-only'],
  );

  patrolTest(
    'App handles form validation correctly',
    // Standard signature: description, callback, {timeout, tags}
    (PatrolIntegrationTester $) async {
      app.main();
      await $.pumpAndSettle();

      // App launched automatically.
      // Initial wait.

      const pleaseEnterUsername = 'Please enter your username';
      const pleaseEnterPassword = 'Please enter your password';
      const loginText = 'Login';

      expect($('Memverse Login'), findsOneWidget);

      final loginButton = $(ElevatedButton).containing(const Text(loginText));

      await $.tap(loginButton);
      await $.pumpAndSettle(); // Explicit settle after tap

      expect($(pleaseEnterUsername), findsOneWidget, reason: 'Username validation should appear');
      expect($(pleaseEnterPassword), findsOneWidget, reason: 'Password validation should appear');

      await $.enterText($(TextField).at(0), 'testuser');
      await $.pumpAndSettle(); // Explicit settle after enterText

      await $.tap(loginButton);
      await $.pumpAndSettle(); // Explicit settle after tap

      expect($(pleaseEnterUsername), findsNothing, reason: 'Username validation should disappear');
      expect($(pleaseEnterPassword), findsOneWidget, reason: 'Password validation should remain');

      await $.enterText($(TextField).at(0), '');
      await $.pumpAndSettle(); // Explicit settle after enterText
      await $.enterText($(TextField).at(1), 'password123');
      await $.pumpAndSettle(); // Explicit settle after enterText

      await $.tap(loginButton);
      await $.pumpAndSettle(); // Explicit settle after tap

      expect($(pleaseEnterUsername), findsOneWidget, reason: 'Username validation should reappear');
      expect($(pleaseEnterPassword), findsNothing, reason: 'Password validation should disappear');
    },
    // Named arguments AFTER the callback
    tags: const ['integration'],
  );

  patrolTest(
    'App UI elements render correctly on Login Screen',
    // Standard signature: description, callback, {timeout, tags}
    (PatrolIntegrationTester $) async {
      app.main();
      await $.pumpAndSettle();

      // App launched automatically.
      // Initial wait.

      expect($('Memverse Login'), findsOneWidget);

      expect($(AppBar), findsOneWidget);
      expect($(Image), findsOneWidget);
      expect($(TextField), findsNWidgets(2), reason: 'Should find 2 TextFields (user/pass)');
      expect(
        $(IconButton).containing(const Icon(Icons.visibility_off)),
        findsOneWidget,
        reason: 'Should find visibility_off icon button',
      );
      expect(
        $(ElevatedButton).containing(const Text('Login')),
        findsOneWidget,
        reason: 'Should find Login button',
      );

      expect($('Welcome to Memverse'), findsOneWidget);
      expect($('Sign in to continue'), findsOneWidget);

      final image = $.tester.widget<Image>($(Image).first);
      expect(image.image, isA<NetworkImage>());
    },
    // Named arguments AFTER the callback
    tags: const ['integration'],
  );
}
