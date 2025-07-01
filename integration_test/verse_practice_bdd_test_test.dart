// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import './step/the_app_is_running.dart';
import './step/i_am_logged_in_as_test_user.dart';
import './step/i_see_verse_text.dart';
import './step/i_enter_into_reference_input_field.dart';
import './step/i_tap_submit_button.dart';
import './step/i_should_see_input_field_color.dart';
import './step/i_see_text.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('''Verse Reference Practice BDD Tests''', () {
    Future<void> bddSetUp(WidgetTester tester) async {
      await theAppIsRunning(tester);
      await iAmLoggedInAsTestUser(tester);
    }

    testWidgets('''Correct verse reference provides feedback''', (tester) async {
      await bddSetUp(tester);
      await iSeeVerseText(tester);
      await iEnterIntoReferenceInputField(tester, 'Col 1:17');
      await iTapSubmitButton(tester);
      await iShouldSeeInputFieldColor(tester, Colors.green);
      await iSeeText(tester, 'Correct!');
    });
    testWidgets('''Almost correct verse reference provides feedback''', (tester) async {
      await bddSetUp(tester);
      await iSeeVerseText(tester);
      await iEnterIntoReferenceInputField(tester, 'Gal 5:2');
      await iTapSubmitButton(tester);
      await iShouldSeeInputFieldColor(tester, Colors.orange);
      await iSeeText(tester, 'Not quite right');
    });
    testWidgets('''Empty reference validation''', (tester) async {
      await bddSetUp(tester);
      await iTapSubmitButton(tester);
      await iSeeText(tester, 'Reference cannot be empty');
    });
    testWidgets('''Invalid reference format validation''', (tester) async {
      await bddSetUp(tester);
      await iEnterIntoReferenceInputField(tester, 'invalid format');
      await iTapSubmitButton(tester);
      await iSeeText(tester, 'Invalid reference format');
    });
    testWidgets('''Answer history tracking''', (tester) async {
      await bddSetUp(tester);
      await iEnterIntoReferenceInputField(tester, 'Col 1:17');
      await iTapSubmitButton(tester);
      await iEnterIntoReferenceInputField(tester, 'Gal 5:2');
      await iTapSubmitButton(tester);
      await iSeeText(tester, 'Prior Questions');
    });
  });
}
