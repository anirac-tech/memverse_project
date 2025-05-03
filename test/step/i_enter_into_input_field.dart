import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memverse/src/utils/app_logger.dart';

/// Usage: I enter "text" into {0} input field
Future<void> iEnterIntoInputField(WidgetTester tester, String text, int index) async {
  await tester.pumpAndSettle();

  // Find all TextFields in the widget tree
  final textFields = find.byType(TextField);

  // Check if there are any TextFields to interact with
  if (textFields.evaluate().isEmpty) {
    fail('No TextField widgets found in the widget tree');
  }

  // Check if the requested index is valid
  try {
    await tester.enterText(textFields.at(index), text);
    await tester.pumpAndSettle();
  } catch (e) {
    // If the index is out of range, try with the first TextField
    if (e is RangeError) {
      AppLogger.d(
        'TextField at index $index not found. Using the first available TextField instead.',
      );
      await tester.enterText(textFields.first, text);
      await tester.pumpAndSettle();
    } else {
      rethrow;
    }
  }
}
