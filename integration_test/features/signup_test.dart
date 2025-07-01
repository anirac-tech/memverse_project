// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import './step/i_am_on_the_signup_page.dart';
import './step/i_enter_dummynewuserdummycom_as_email.dart';
import './step/i_enter_test_user_as_name.dart';
import './step/i_enter_password123_as_password.dart';
import './step/i_tap_the_create_account_button.dart';
import './step/i_should_see_the_welcome_message.dart';
import './step/i_should_see_my_email_displayed.dart';
import './step/i_should_be_redirected_to_the_main_app.dart';
import './step/i_should_see_please_enter_your_email_error.dart';
import './step/i_should_see_please_enter_your_name_error.dart';
import './step/i_should_see_please_enter_a_password_error.dart';
import './step/i_enter_invalidemail_as_email.dart';
import './step/i_should_see_please_enter_a_valid_email_error.dart';
import './step/i_enter_short_as_password.dart';
import './step/i_should_see_password_must_be_at_least6_characters_error.dart';
import './step/i_enter_realexamplecom_as_email.dart';
import './step/i_should_see_an_orange_error_message.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('''User Signup''', () {
    Future<void> bddSetUp(WidgetTester tester) async {
      await iAmOnTheSignupPage(tester);
    }

    testWidgets('''Successful signup with dummy credentials''', (tester) async {
      await bddSetUp(tester);
      await iEnterDummynewuserdummycomAsEmail(tester);
      await iEnterTestUserAsName(tester);
      await iEnterPassword123AsPassword(tester);
      await iTapTheCreateAccountButton(tester);
      await iShouldSeeTheWelcomeMessage(tester);
      await iShouldSeeMyEmailDisplayed(tester);
      await iShouldBeRedirectedToTheMainApp(tester);
    }, tags: ['happy-path']);
    testWidgets('''Form validation for empty fields''', (tester) async {
      await bddSetUp(tester);
      await iTapTheCreateAccountButton(tester);
      await iShouldSeePleaseEnterYourEmailError(tester);
      await iShouldSeePleaseEnterYourNameError(tester);
      await iShouldSeePleaseEnterAPasswordError(tester);
    }, tags: ['validation']);
    testWidgets('''Form validation for invalid email''', (tester) async {
      await bddSetUp(tester);
      await iEnterInvalidemailAsEmail(tester);
      await iTapTheCreateAccountButton(tester);
      await iShouldSeePleaseEnterAValidEmailError(tester);
    }, tags: ['validation']);
    testWidgets('''Form validation for short password''', (tester) async {
      await bddSetUp(tester);
      await iEnterDummynewuserdummycomAsEmail(tester);
      await iEnterTestUserAsName(tester);
      await iEnterShortAsPassword(tester);
      await iTapTheCreateAccountButton(tester);
      await iShouldSeePasswordMustBeAtLeast6CharactersError(tester);
    }, tags: ['validation']);
    testWidgets('''Error message for non-dummy email''', (tester) async {
      await bddSetUp(tester);
      await iEnterRealexamplecomAsEmail(tester);
      await iEnterTestUserAsName(tester);
      await iEnterPassword123AsPassword(tester);
      await iTapTheCreateAccountButton(tester);
      await iShouldSeeAnOrangeErrorMessage(tester);
    }, tags: ['error-case']);
  });
}
