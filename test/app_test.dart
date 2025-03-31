// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_import, directives_ordering

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import './step/the_app_is_running.dart';
import './step/i_see_text.dart';
import './step/i_tap_text.dart';
import './step/i_enter_into_input_field.dart';
import './step/i_wait_seconds.dart';
import './step/i_dont_see_text.dart';

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
    testWidgets('''Verse reference test progress tracking''', (tester) async {
      await theAppIsRunning(tester);
      await tester.pumpAndSettle();
      expect(find.text('0%'), findsOneWidget);
      await iEnterIntoInputField(tester, 'Genesis 1:1', 0);
      await iTapText(tester, 'Submit');
      await iWaitSeconds(tester, 2);
      expect(find.text('100%'), findsOneWidget);
      expect(find.text('1/1'), findsOneWidget);
      await iEnterIntoInputField(tester, 'John 3:17', 0);
      await iTapText(tester, 'Submit');
      await iWaitSeconds(tester, 2);
      expect(find.text('50%'), findsOneWidget);
      expect(find.text('1/2'), findsOneWidget);
    });
  });
}