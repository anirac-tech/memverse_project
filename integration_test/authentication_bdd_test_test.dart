// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import './step/the_app_is_running.dart';
import './step/i_enter_test_credentials_into_login_fields.dart';
import './step/i_tap_login_button.dart';
import './step/i_see_text.dart';
import './step/i_enter_into_login_password_field.dart';
import 'package:bdd_widget_test/step/i_see_icon.dart';
import 'package:bdd_widget_test/step/i_tap_icon.dart';
import './step/i_am_logged_in_as_test_user.dart';
import './step/i_see_login_page.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('''User Authentication BDD Tests''', () {
    testWidgets('''Successful login with valid credentials''', (tester) async {
      await theAppIsRunning(tester);
      await iEnterTestCredentialsIntoLoginFields(tester);
      await iTapLoginButton(tester);
      await iSeeText(tester, 'Memverse Reference Test');
    });
    testWidgets('''Login validation with empty fields''', (tester) async {
      await theAppIsRunning(tester);
      await iTapLoginButton(tester);
      await iSeeText(tester, 'Please enter your username');
      await iSeeText(tester, 'Please enter your password');
    });
    testWidgets('''Password visibility toggle functionality''', (tester) async {
      await theAppIsRunning(tester);
      await iEnterIntoLoginPasswordField(tester, 'testpassword');
      await iSeeIcon(tester, Icons.visibility_off);
      await iTapIcon(tester, Icons.visibility_off);
      await iSeeIcon(tester, Icons.visibility);
      await iTapIcon(tester, Icons.visibility);
      await iSeeIcon(tester, Icons.visibility_off);
    });
    testWidgets('''Logout functionality''', (tester) async {
      await theAppIsRunning(tester);
      await iAmLoggedInAsTestUser(tester);
      await iTapIcon(tester, Icons.logout);
      await iSeeLoginPage(tester);
    });
  });
}
