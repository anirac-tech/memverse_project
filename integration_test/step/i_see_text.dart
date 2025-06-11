import 'package:flutter_test/flutter_test.dart';

/// Usage: I see text "some text"
Future<void> iSeeText(WidgetTester tester, String text) async {
  await tester.pumpAndSettle();

  // Find text widget containing the specified text
  final textFinder = find.text(text);
  expect(textFinder, findsOneWidget, reason: 'Expected to find text: "$text"');
}

/// Usage: I should see text "some text"
Future<void> iShouldSeeText(WidgetTester tester, String text) async {
  await iSeeText(tester, text);
}
