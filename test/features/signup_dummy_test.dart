// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import './step/the_app_is_running_with_fake_user_repository.dart';
import './step/i_am_on_the_login_screen.dart';
import './step/i_tap_sign_up.dart';
import './step/i_should_see_the_signup_form.dart';
import './step/i_enter_dummynewuserdummycom_in_the_email_field.dart';
import './step/i_enter_dummyuser_in_the_username_field.dart';
import './step/i_enter_test123_in_the_password_field.dart';
import './step/i_tap_create_account.dart';
import './step/i_should_see_welcome_to_memverse.dart';
import './step/i_should_see_account_created_successfully.dart';
import './step/i_should_see_dummynewuserdummycom.dart';
import './step/i_enter_invalidtestcom_in_the_email_field.dart';
import './step/i_enter_testuser_in_the_username_field.dart';
import './step/i_should_see_user_creation_failed.dart';

void main() {
  group('''Dummy User Signup''', () {
    Future<void> bddSetUp(WidgetTester tester) async {
      await theAppIsRunningWithFakeUserRepository(tester);
    }

    testWidgets('''Successful dummy signup''', (tester) async {
      await bddSetUp(tester);
      await iAmOnTheLoginScreen(tester);
      await iTapSignUp(tester);
      await iShouldSeeTheSignupForm(tester);
      await iEnterDummynewuserdummycomInTheEmailField(tester);
      await iEnterDummyuserInTheUsernameField(tester);
      await iEnterTest123InThePasswordField(tester);
      await iTapCreateAccount(tester);
      await iShouldSeeWelcomeToMemverse(tester);
      await iShouldSeeAccountCreatedSuccessfully(tester);
      await iShouldSeeDummynewuserdummycom(tester);
    });
    testWidgets('''Invalid email signup''', (tester) async {
      await bddSetUp(tester);
      await iAmOnTheLoginScreen(tester);
      await iTapSignUp(tester);
      await iShouldSeeTheSignupForm(tester);
      await iEnterInvalidtestcomInTheEmailField(tester);
      await iEnterTestuserInTheUsernameField(tester);
      await iEnterTest123InThePasswordField(tester);
      await iTapCreateAccount(tester);
      await iShouldSeeUserCreationFailed(tester);
    });
  });
}
