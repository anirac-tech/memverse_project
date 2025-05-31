// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_import, directives_ordering

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import './step/the_app_is_running.dart';
import './step/i_am_logged_in_as_test_user.dart';
import 'package:bdd_widget_test/step/i_see_text.dart';
import 'package:bdd_widget_test/step/i_see_icon.dart';
import 'package:bdd_widget_test/step/i_tap_icon.dart';
import './step/i_see_feedback_interface.dart';
import './step/the_app_is_starting_up.dart';
import './step/i_see_loading_indicator.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('''App UI and Navigation BDD Tests''', () {
    Future<void> bddSetUp(WidgetTester tester) async {
      await theAppIsRunning(tester);
      await iAmLoggedInAsTestUser(tester);
    }

    testWidgets('''Main app bar elements are present''', (tester) async {
      await bddSetUp(tester);
      await iSeeText(tester, 'Memverse Reference Test');
      await iSeeIcon(tester, Icons.feedback_outlined);
      await iSeeIcon(tester, Icons.logout);
    });
    testWidgets('''Feedback button functionality''', (tester) async {
      await bddSetUp(tester);
      await iTapIcon(tester, Icons.feedback_outlined);
      await iSeeFeedbackInterface(tester);
    });
    testWidgets('''Loading states display correctly''', (tester) async {
      await bddSetUp(tester);
      await theAppIsStartingUp(tester);
      await iSeeLoadingIndicator(tester);
    });
    testWidgets('''UI text elements are visible''', (tester) async {
      await bddSetUp(tester);
      await iSeeText(tester, 'Reference:');
      await iSeeText(tester, 'Submit');
      await iSeeText(tester, 'He is before all things');
    });
  });
}
