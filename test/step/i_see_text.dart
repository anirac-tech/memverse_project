import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// Usage: I see text "Hello"
Future<void> iSeeText(WidgetTester tester, String text) async {
  await tester.pumpAndSettle(const Duration(milliseconds: 300));

  // Sometimes findText might match multiple widgets or none, handle this specially
  final foundWidgets = find.text(text);
  if (foundWidgets.evaluate().isEmpty) {
    // Dump the widget tree to help debugging
    debugDumpApp();
    expect(
      foundWidgets,
      findsOneWidget,
      reason: 'Expected to find "$text" in the widget tree but found none',
    );
  } else if (foundWidgets.evaluate().length > 1) {
    expect(
      foundWidgets,
      findsOneWidget,
      reason: 'Expected to find exactly one "$text" but found ${foundWidgets.evaluate().length}',
    );
  }

  // This assertion will pass if exactly one widget is found
  expect(foundWidgets, findsOneWidget, reason: 'Expected to find "$text" in the widget tree');
}
