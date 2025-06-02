// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_import, directives_ordering

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import './step/the_app_is_running.dart';
import 'package:bdd_widget_test/step/i_see_text.dart';
import 'package:bdd_widget_test/step/i_tap_icon.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('''Hello World BDD Test''', () {
    testWidgets('''Basic app launch''', (tester) async {
      await theAppIsRunning(tester);
      await iSeeText(tester, 'Hello');
    });
    testWidgets('''Counter functionality''', (tester) async {
      await theAppIsRunning(tester);
      await iTapIcon(tester, Icons.add);
      await iSeeText(tester, '1');
    });
  });
}
