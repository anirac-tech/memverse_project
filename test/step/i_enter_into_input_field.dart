import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Usage: I enter "text" into {0} input field
Future<void> iEnterIntoInputField(WidgetTester tester, String text, int index) async {
  await tester.pumpAndSettle();
  await tester.enterText(find.byType(TextField).at(index), text);
  await tester.pumpAndSettle();
}
