import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memverse/main_development.dart' as app;
import 'package:patrol/patrol.dart';

// To run this test:
// 1. Ensure you have a running emulator/device.
// 2. Set environment variables: MEMVERSE_CLIENT_ID, MEMVERSE_USERNAME, MEMVERSE_PASSWORD
// 3. Run command: patrol test integration_test/feedback_test.dart --flavor development --dart-define=CLIENT_ID=$MEMVERSE_CLIENT_ID --dart-define=USERNAME=$MEMVERSE_USERNAME --dart-define=PASSWORD=$MEMVERSE_PASSWORD --target lib/main_development.dart --dart-define=PATROL_TEST=true
// Note: Requires Gmail installed and possibly logged in. Manual interaction might be needed if selectors fail.

// Keys added to the main app widgets
const _usernameFieldKey = ValueKey('login_username_field');
const _passwordFieldKey = ValueKey('login_password_field');
const _loginButtonKey = ValueKey('login_button');
const _memversePageScaffoldKey = ValueKey('memverse_page_scaffold');
const _feedbackButtonKey = ValueKey('feedback_button');

void main() {
  patrolTest('Submit feedback with screenshot and text via Gmail', ($) async {
    app.main();
    await $.pumpAndSettle();

    // --- Login ---
    await $('Welcome to Memverse').waitUntilVisible();
    await $(find.byKey(_usernameFieldKey)).enterText(const String.fromEnvironment('USERNAME'));
    await $(find.byKey(_passwordFieldKey)).enterText(const String.fromEnvironment('PASSWORD'));
    await $(find.byKey(_loginButtonKey)).tap();
    await $.pumpAndSettle();

    // --- Open Feedback ---
    await $(find.byKey(_memversePageScaffoldKey)).waitUntilVisible();
    expect($(find.byKey(_feedbackButtonKey)), findsOneWidget);
    await $(find.byKey(_feedbackButtonKey)).tap();
    await $.pumpAndSettle();

    // --- Interact with Feedback UI ---
    final textFieldFinder = find.byType(TextField);
    await $.tester.ensureVisible(textFieldFinder);
    await $.pumpAndSettle();
    await $(textFieldFinder).enterText('Patrol test feedback: All good!');
    await $.pumpAndSettle();

    final sendButtonFinder = find.widgetWithText(ElevatedButton, 'Send');
    await $.tester.ensureVisible(sendButtonFinder);
    await $.pumpAndSettle();
    await $(sendButtonFinder).tap(); // This triggers the share sheet

    // --- Interact with Native Share Sheet (Android specific) ---
    // Wait for the share sheet to become visible (using a common element)
    await $.native.waitUntilVisible(Selector(textContains: 'Share'));

    // Tap on the Gmail app in the share sheet
    dev.log('Tapping Gmail in share sheet...');
    await $.native.tap(Selector(text: 'Gmail'));

    // Wait for Gmail compose screen to potentially load
    await $.pump(const Duration(seconds: 5));
    await $.pumpAndSettle();

    // --- Native Interaction with Gmail (Best Effort) ---
    // Attempt to tap the Send button using its content description
    dev.log('Tapping Send button in Gmail...');
    // Corrected Selector: Use contentDescription instead of description
    await $.native.tap(Selector(contentDescription: 'Send'));

    // Wait briefly after initiating the send
    await $.pump(const Duration(seconds: 3));
    await $.pumpAndSettle();

    // --- Final Verification ---
    // Focus on verifying no errors occurred *within the Flutter app*
    dev.log('Checking for error Snackbars in Flutter app...');
    expect(
      $(find.byType(SnackBar)).containing(find.text('Sharing screenshot failed')),
      findsNothing,
      reason: 'Snackbar reporting screenshot sharing failure should not be present',
    );
    expect(
      $(find.byType(SnackBar)).containing(find.text('Failed to share feedback')),
      findsNothing,
      reason: 'Snackbar reporting general feedback failure should not be present',
    );

    dev.log('Feedback test completed attempt to share via Gmail.');

    // Optionally, add a slight delay if needed for CI environments
    // await Future<void>.delayed(const Duration(seconds: 1));
  });
}
