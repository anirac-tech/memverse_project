// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_import, directives_ordering

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import './step/the_app_is_running.dart';
import './step/i_see_text.dart';
import './step/the_app_is_running_with_verses_error.dart';
import './step/i_see_text_containing.dart';
import './step/i_tap_text.dart';
import './step/i_enter_into_input_field.dart';
import './step/i_wait_seconds.dart';
import './step/i_dont_see_text_containing.dart';
import './step/i_dont_see_text.dart';

void main() {
  group('''App''', () {
    testWidgets('''Initial app launch''', (tester) async {
      await theAppIsRunning(tester);
      await iSeeText(tester, 'Reference Test');
    });
    testWidgets('''Verse list error such as server issue.''', (tester) async {
      await theAppIsRunningWithVersesError(tester);
      await iSeeTextContaining(tester, 'Error loading verses');
    });
    testWidgets('''Empty answer''', (tester) async {
      await theAppIsRunning(tester);
      await iTapText(tester, 'Submit');
      await iSeeText(tester, 'Reference cannot be empty');
      await iSeeText(tester, '5');
    });
    testWidgets('''Invalid Reference Format''', (tester) async {
      await theAppIsRunning(tester);
      await iEnterIntoInputField(tester, 'lafjl', 0);
      await iTapText(tester, 'Submit');
      await iWaitSeconds(tester, 3);
      await iDontSeeTextContaining(tester, 'Genesis 1:1-');
    });
    testWidgets('''Invalid Reference (is never correct)''', (tester) async {
      await theAppIsRunning(tester);
      await iEnterIntoInputField(tester, 'Revelation 9:99', 0);
      await iTapText(tester, 'Submit');
      await iWaitSeconds(tester, 3);
      await iDontSeeText(tester, 'Reference cannot be empty');
    });
    testWidgets('''Correct Reference''', (tester) async {
      await theAppIsRunning(tester);
      await iEnterIntoInputField(tester, 'Genesis 1:1', 0);
      await iTapText(tester, 'Submit');
      await iWaitSeconds(tester, 3);
      await iSeeText(tester, 'Genesis 1:1-[Genesis 1:1] Correct!');
    });
    testWidgets('''Verse reference test progress tracking''', (tester) async {
      await theAppIsRunning(tester);
      await iSeeText(tester, '0%');
      await iEnterIntoInputField(tester, 'Genesis 1:1', 0);
      await iTapText(tester, 'Submit');
      await iWaitSeconds(tester, 2);
      await iSeeText(tester, '100%');
      await iSeeText(tester, '1/1');
      await iEnterIntoInputField(tester, 'John 3:17', 0);
      await iTapText(tester, 'Submit');
      await iWaitSeconds(tester, 2);
      await iSeeText(tester, '50%');
      await iSeeText(tester, '1/2');
    });
  });
}
