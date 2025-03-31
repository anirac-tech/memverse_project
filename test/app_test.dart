// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_import, directives_ordering

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import './step/the_app_is_running.dart';
import 'package:bdd_widget_test/step/i_see_text.dart';
import 'package:bdd_widget_test/step/i_tap_text.dart';
import 'package:bdd_widget_test/step/i_enter_into_input_field.dart';
import './step/i_wait_seconds.dart';
import 'package:bdd_widget_test/step/i_dont_see_text.dart';

void main() {
  group('''App''', () {
    testWidgets('''Initial app launch''', (tester) async {
      await theAppIsRunning(tester);
      await iSeeText(tester, 'Reference Test');
    });
    testWidgets('''Empty answer''', (tester) async {
      await theAppIsRunning(tester);
      await iTapText(tester, 'Submit');
      await iSeeText(tester, 'Reference cannot be empty');
      await iSeeText(tester, '5');
    });
    testWidgets('''Invalid Reference (is never correct)''', (tester) async {
      await theAppIsRunning(tester);
      await iEnterIntoInputField(tester, 'Revelation 9:99', 0);
      await iTapText(tester, 'Submit');
      await iWaitSeconds(tester, 3);
      await iDontSeeText(tester, 'Reference cannot be empty');
    });
  });
}
